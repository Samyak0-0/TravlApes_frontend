enum TripStatus { planned, ongoing, past }

class Trip {
  final String destination;
  final TripStatus status;

  Trip({
    required this.destination,
    this.status = TripStatus.planned,
  });
}
