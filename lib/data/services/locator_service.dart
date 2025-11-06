import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

class LocationService {
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
}

class GeoCodingService {
  final _GeoCodeAPI = dotenv.env['GOOGLE_MAPS_KEY_API'];

  Future<LatLng> fetchCoordinates(String venueName) async {
    final address = "$venueName, USA";

    final url = Uri.encodeFull(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$_GeoCodeAPI',
    );

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        } else {
          throw Exception('Geocoding Gagal: ${data['status']}');
        }
      } else {
        throw Exception(
          'Gagal request Geocoding API. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

class DirectionService {
  final _apiKey = dotenv.env['GOOGLE_MAPS_KEY_API']!;

  Future<List<LatLng>> getRoute(LatLng origin, LatLng destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final decodedPoints = PolylinePoints.decodePolyline(points);
          return decodedPoints
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList();
        } else {
          throw Exception('Directions gagal: ${data['status']}');
        }
      } else {
        throw Exception(
          'Request Directions gagal. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}