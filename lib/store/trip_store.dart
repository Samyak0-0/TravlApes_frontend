import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trip_model.dart';

class TripStore {
  static final TripStore _instance = TripStore._internal();
  factory TripStore() => _instance;
  TripStore._internal();

  static const String _storageKey = "trips_storage";

  final List<Trip> _trips = [];

  /// Load trips from storage (call on app start)
  Future<void> loadTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);

    if (data != null) {
      final List decoded = jsonDecode(data);
      _trips
        ..clear()
        ..addAll(decoded.map((e) => Trip.fromJson(e)));
    }
  }

  /// Save trips to storage
  Future<void> _saveTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_trips.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> addPlannedTrip(String destination) async {
    _trips.add(Trip(destination: destination));
    await _saveTrips();
  }

  List<Trip> get plannedTrips =>
      _trips.where((t) => t.status == TripStatus.planned).toList();

  List<Trip> get ongoingTrips =>
      _trips.where((t) => t.status == TripStatus.ongoing).toList();

  List<Trip> get pastTrips =>
      _trips.where((t) => t.status == TripStatus.past).toList();
}
