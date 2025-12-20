import 'package:flutter/material.dart';

class RecommendationResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const RecommendationResultScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final primary = data['primary']['data'] as List;
    final secondary = data['secondary']['data'] as List;
    final food = data['food']['data'] as List;
    final accomodations = data['accomodations']['data'] as List;

    return Scaffold(
      appBar: AppBar(title: const Text("Recommended Places")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section("Primary Attractions", primary),
          _section("Secondary Attractions", secondary),
          _section("Food Places", food),
          _section("Accommodations", accomodations),
        ],
      ),
    );
  }

  Widget _section(String title, List items) {
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Card(
            child: ListTile(
              title: Text(item['name']),
              subtitle: Text(item['description']),
              trailing: Text("⭐ ${item['rating']}"),
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}
