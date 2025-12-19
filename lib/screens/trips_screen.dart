import 'package:flutter/material.dart';
import '../store/trip_store.dart';
import '../models/trip_model.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = TripStore();

    return Scaffold(
      appBar: AppBar(title: const Text("My Trips")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section("Planned Trips", store.plannedTrips),
          _section("Ongoing Trips", store.ongoingTrips),
          _section("Past Trips", store.pastTrips),
        ],
      ),
    );
  }

  Widget _section(String title, List<Trip> trips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        if (trips.isEmpty)
          const Text("No trips", style: TextStyle(color: Colors.grey))
        else
          Column(
            children: trips.map((trip) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(trip.destination),
                ),
              );
            }).toList(),
          ),

        const SizedBox(height: 24),
      ],
    );
  }
}
