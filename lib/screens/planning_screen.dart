import 'package:flutter/material.dart';
import 'route_map_screen.dart';

class PlanningScreen extends StatelessWidget {
  final String destination;

  const PlanningScreen({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Planning")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              destination,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _infoCard("Status", "Planned"),
            _infoCard("Dates", "Not set"),
            _infoCard("Trip Type", "Not specified"),
            _infoCard("Transport", "Car"),
            _infoCard("Budget", "Not specified"),

            const Spacer(),

            /// 🧪 TEST MAP BUTTON (NO BACKEND)
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: const Text("Test Map (Hardcoded Route)"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RouteMapScreen(
                      coordinates: const [
                        [85.3240, 27.7172], // Start (Kathmandu)
                        [85.3250, 27.6736], // End
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
