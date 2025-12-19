import '../models/trip_model.dart';

class TripStore {
  static final TripStore _instance = TripStore._internal();
  factory TripStore() => _instance;
  TripStore._internal();

  final List<Trip> _trips = [];

  void addPlannedTrip(String destination) {
    _trips.add(Trip(destination: destination));
  }

  List<Trip> get plannedTrips =>
      _trips.where((t) => t.status == TripStatus.planned).toList();

  List<Trip> get ongoingTrips =>
      _trips.where((t) => t.status == TripStatus.ongoing).toList();

  List<Trip> get pastTrips =>
      _trips.where((t) => t.status == TripStatus.past).toList();
}
