import 'destination_model.dart';

enum TripStatus { planned, ongoing, past }

class Trip {
  final String destination;
  final TripStatus status;

  // 🔹 NEW FIELDS (optional for backward compatibility)
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<Mood>? moods;
  final double? budget;

  Trip({
    required this.destination,
    this.status = TripStatus.planned,
    this.fromDate,
    this.toDate,
    this.moods,
    this.budget,
  });

  // ---------------- SERIALIZATION ----------------

  Map<String, dynamic> toJson() {
    return {
      'destination': destination,
      'status': status.index,
      'fromDate': fromDate?.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
      'moods': moods?.map((m) => m.index).toList(),
      'budget': budget,
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      destination: json['destination'],
      status: TripStatus.values[json['status']],
      fromDate:
          json['fromDate'] != null ? DateTime.parse(json['fromDate']) : null,
      toDate:
          json['toDate'] != null ? DateTime.parse(json['toDate']) : null,
      moods: json['moods'] != null
          ? (json['moods'] as List)
              .map((i) => Mood.values[i])
              .toList()
          : null,
      budget: json['budget']?.toDouble(),
    );
  }
}
