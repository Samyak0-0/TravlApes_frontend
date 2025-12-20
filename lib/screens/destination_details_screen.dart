import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../store/favourite_store.dart';
import 'plan_trip_screen.dart';

class DestinationDetailsScreen extends StatelessWidget {
  final Destination destination;

  const DestinationDetailsScreen({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final isFavourite =
        FavouriteStore().isFavourite(destination.name);

    return Scaffold(
      body: Column(
        children: [
          _topSection(context),
          Expanded(child: _detailsSection(context, isFavourite)),
        ],
      ),
    );
  }

  Widget _topSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.green.shade300,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: destination.imageUrl.isNotEmpty
              ? Image.network(
                  destination.imageUrl,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        Positioned(
          top: 40,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                destination.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                destination.location,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailsSection(BuildContext context, bool isFavourite) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoBoxes(),
          const SizedBox(height: 20),

          const Text(
            "Description",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            destination.description,
            style: const TextStyle(color: Colors.grey),
          ),

          const Spacer(),
          _bottomButtons(context, isFavourite),
        ],
      ),
    );
  }

  Widget _infoBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _InfoBox(title: "Location", value: destination.location),
        _InfoBox(title: "Rating", value: "⭐ ${destination.rating}"),
        _InfoBox(title: "Category", value: destination.category.toString().split('.').last),
      ],
    );
  }

  Widget _bottomButtons(BuildContext context, bool isFavourite) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              if (!isFavourite) {
                await FavouriteStore()
                    .addFavourite(destination.name);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "${destination.name} added to favourites"),
                  ),
                );
              }
            },
            icon: Icon(
              isFavourite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: isFavourite ? Colors.red : null,
            ),
            label: const Text("Favourite"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PlanTripScreen(destination: destination.name),
                ),
              );
            },
            icon: const Icon(Icons.navigation),
            label: const Text("Plan Trip"),
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
