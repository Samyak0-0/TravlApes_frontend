import 'destination_model.dart';

enum TripStatus { planned, ongoing, past }

class Trip {
  final String id;
  final List<Destination> destinations;
  final TripStatus status;

  final DateTime? fromDate;
  final DateTime? toDate;
  final List<Mood>? moods;
  final double? budget;

  Trip({
    String? id,
    required this.destinations,
    this.status = TripStatus.planned,
    this.fromDate,
    this.toDate,
    this.moods,
    this.budget,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  /// ✅ BACKWARD COMPATIBILITY (VERY IMPORTANT)
  String get destination =>
      destinations.isNotEmpty ? destinations.first.name : '';

  // ---------------- SERIALIZATION ----------------

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destinations': destinations.map((d) => d.toJson()).toList(),
      'status': status.index,
      'fromDate': fromDate?.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
      'moods': moods?.map((m) => m.index).toList(),
      'budget': budget,
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    List<Destination> parsedDestinations = [];

    if (json['destinations'] is List) {
      parsedDestinations = (json['destinations'] as List)
          .map((e) => Destination.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (json['destination'] != null) {
      final name = json['destination'].toString();
      parsedDestinations = [
        Destination(
          id: '',
          name: name,
          description: '',
          location: name,
          category: Category.other,
          avg_price: 0,
          rating: 0,
          open_hours: '',
          latitude: 0,
          longitude: 0,
          suitable_season: const [],
          suitable_weather: const [],
          compatable_moods: const [],
        ),
      ];
    }

    return Trip(
      id: json['id'],
      destinations: parsedDestinations,
      status: TripStatus.values[json['status'] ?? 0],
      fromDate:
          json['fromDate'] != null ? DateTime.parse(json['fromDate']) : null,
      toDate:
          json['toDate'] != null ? DateTime.parse(json['toDate']) : null,
      moods: json['moods'] != null
          ? (json['moods'] as List).map((i) => Mood.values[i]).toList()
          : null,
      budget: json['budget']?.toDouble(),
    );
  }
}
