import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../services/destination_service.dart';
import 'destination_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DestinationService _service = DestinationService();
  List<Destination> destinations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    try {
      final data = await _service.fetchDestinations();

      // 🔎 DEBUG (remove later)
      debugPrint("DESTINATIONS LOADED: ${data.length}");
      for (var d in data) {
        debugPrint("${d.name} → ${d.description}");
      }

      setState(() {
        destinations = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR FETCHING DESTINATIONS: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 20),
            _categories(),
            const SizedBox(height: 20),
            _featuredBoxes(context),
            const SizedBox(height: 30),
            _sectionTitle("Top Destinations"),
            const SizedBox(height: 12),
            _topDestinationBoxes(context),
          ],
        ),
      ),
    );
  }

  // 🔹 Header
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Discover",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.search, size: 26),
      ],
    );
  }

  // 🔹 Categories (static for now)
  Widget _categories() {
    final categories = ["Mountain", "Jungle", "Water", "Beach"];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          return Text(
            categories[index],
            style: TextStyle(
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
              color: index == 0 ? Colors.black : Colors.grey,
            ),
          );
        },
      ),
    );
  }

  // 🔹 Featured (Top 2 destinations)
  Widget _featuredBoxes(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final featured = destinations.take(2).toList();

    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: featured.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final dest = featured[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DestinationDetailsScreen(
                    title: dest.name,
                  ),
                ),
              );
            },
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    dest.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔹 Section title
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // 🔹 Top destinations list (NAME + DESCRIPTION FIXED)
  Widget _topDestinationBoxes(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (destinations.isEmpty) {
      return const Text("No destinations available");
    }

    // ❌ Categories to exclude
    final excludedCategories = [
      'restaurant',
      'food',
      'accomodations',
    ];

    // ✅ Filter + sort
    final topDestinations = destinations
        .where((dest) =>
            !excludedCategories.contains(dest.category.toLowerCase()))
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));

    if (topDestinations.isEmpty) {
      return const Text("No top destinations available");
    }

    return Column(
      children: topDestinations.take(5).map((dest) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DestinationDetailsScreen(
                  title: dest.name,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),

                // 📌 Name + description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dest.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dest.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                Text("⭐ ${dest.rating}"),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

}
