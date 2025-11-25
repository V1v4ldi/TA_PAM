import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/core/session.dart';
import 'package:tugas_akhir/modelviews/venue_view_models.dart';

class VenuePage extends StatelessWidget {
  final String venueName;
  const VenuePage({super.key, required this.venueName});

  @override
  Widget build(BuildContext context) {
    void checkSession() async {
      final hasSession = await Provider.of<SessionCheck>(
        context,
        listen: false,
      ).sessionCheck();

      if (hasSession) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<VenueViewModels>().loadMaps(venueName);
        });
      }
    }
    checkSession();
    return Scaffold(
      appBar: AppBar(title: Text('Rute ke $venueName')),
      body: Consumer<VenueViewModels>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null) {
            return Center(child: Text(vm.errorMessage!));
          }

          if (vm.mapModel == null) {
            return const Center(child: Text('Masukkan nama venue yang valid.'));
          }

          final data = vm.mapModel!;
          final isFallback = data.routePoints.length <= 2;

          return FlutterMap(
            options: MapOptions(initialCenter: data.origin, initialZoom: 4.5),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'tugas_akhir/1.0.0+1',
              ),

              // Polyline (rute atau garis lurus)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: data.routePoints,
                    color: isFallback ? Colors.orange : Colors.blue,
                    strokeWidth: 4,
                  ),
                ],
              ),

              // Marker lokasi pengguna dan venue
              MarkerLayer(
                markers: [
                  Marker(
                    point: data.origin,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 35,
                    ),
                  ),
                  Marker(
                    point: data.destination,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
