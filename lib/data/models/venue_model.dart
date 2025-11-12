import 'package:latlong2/latlong.dart';

class VenueModel {
  final LatLng origin;
  final LatLng destination;
  final List<LatLng> routePoints;

  VenueModel({required this.origin, required this.destination, required this.routePoints});
}