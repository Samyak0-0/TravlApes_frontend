import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RouteMapScreen extends StatelessWidget {
  final List<List<double>> coordinates;

  const RouteMapScreen({
    super.key,
    required this.coordinates,
  });

  @override
  Widget build(BuildContext context) {
    if (coordinates.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No route found')),
      );
    }

    // Convert GeoJSON [lon, lat] → LatLng
    final points = coordinates
        .map((c) => LatLng(c[1], c[0]))
        .toList();

    final bounds = LatLngBounds.fromPoints(points);

    return Scaffold(
      appBar: AppBar(title: const Text('Route')),
      body: FlutterMap(
        options: MapOptions(
          initialCameraFit: CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(32),
          ),
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.paryatan_mantralaya_f',
          ),

          // Start marker
          MarkerLayer(
            markers: [
              Marker(
                point: points.first,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 40,
                ),
              ),

              // End marker
              Marker(
                point: points.last,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.flag,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),

          // Route polyline
          PolylineLayer(
            polylines: [
              Polyline(
                points: points,
                strokeWidth: 4,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
