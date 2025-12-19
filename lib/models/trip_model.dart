enum TripStatus { planned, ongoing, past }

class Trip {
  final String destination;
  final TripStatus status;

  Trip({
    required this.destination,
    this.status = TripStatus.planned,
  });

  Map<String, dynamic> toJson() {
    return {
      'destination': destination,
      'status': status.index,
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      destination: json['destination'],
      status: TripStatus.values[json['status']],
    );
  }
}
