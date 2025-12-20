class Destination {
  final int id;
  final String name;        // PLACE NAME
  final String description; // PLACE DESCRIPTION
  final String location;
  final String category;
  final double rating;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.rating,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 0.0,
    );
  }
}
