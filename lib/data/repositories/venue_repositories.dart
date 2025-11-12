import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tugas_akhir/data/models/venue_model.dart';
import 'package:tugas_akhir/data/services/locator_service.dart';

class VenueRepositories {
  final LocationService _locationService;

  VenueRepositories(this._locationService);

  Future<LatLng> getVenueCoordinates(String venueName) async {
    return await _locationService.fetchVenueCoordinates(venueName);
  }

  Future<Position> getUserCoordinates() async {
    return await _locationService.getCurrentLocation();
  }

  Future<VenueModel> getRouteToVenue(String venueName) async {
    try {
      final userLoc = await getUserCoordinates();
      final origin = LatLng(userLoc.latitude, userLoc.longitude);

      final destination = await getVenueCoordinates(venueName);

      final route = await _locationService.getRoute(origin, destination);

      return VenueModel(
        origin: origin,
        destination: destination,
        routePoints: route,
      );
    } catch (e) {
      throw Exception("Gagal Mendapatkan Rute: $e");
    }
  }
}
