import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationService {
  static const baseurl = 'https://api.mapbox.com';

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan Lokasi (GPS) dimatikan.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak oleh pengguna.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Izin lokasi ditolak permanen. Ubah di pengaturan perangkat.',
      );
    }

    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  Future<LatLng> fetchVenueCoordinates(String venueName) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$venueName&format=json&limit=1',
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'tugas_akhir/1.0.0+1'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        } else {
          throw Exception('Lokasi tidak ditemukan');
        }
      } else {
        throw Exception('Gagal request Geocoding API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Geocoding: $e');
    }
  }

  Future<List<LatLng>> getRoute(LatLng origin, LatLng destination) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${origin.longitude},${origin.latitude};'
      '${destination.longitude},${destination.latitude}'
      '?overview=full&geometries=geojson',
    );
    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        // Gagal HTTP, kembalikan garis lurus
        return [origin, destination];
      }

      final data = jsonDecode(response.body);

      if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
        // Rute SUKSES ditemukan
        final routeCoords = data['routes'][0]['geometry']['coordinates'];

        final routePoints = routeCoords
            .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
            .toList();

        print(routePoints);
        return routePoints;
      } else {
        // OSRM tidak menemukan rute ('NoRoute' dll), kembalikan garis lurus
        return [origin, destination];
      }
    } catch (e) {
      // Error lain (parsing JSON, network, dll), kembalikan garis lurus
      return [origin, destination];
    }
  }
}
