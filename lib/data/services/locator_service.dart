import 'package:geolocator/geolocator.dart';

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
      // Minta izin ke pengguna
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak oleh pengguna.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi ditolak permanen. Ubah di pengaturan perangkat.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
  }
}