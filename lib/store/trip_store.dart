import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trip_model.dart';
import '../models/destination_model.dart';

class TripStore {
  static final TripStore _instance = TripStore._internal();
  factory TripStore() => _instance;
  TripStore._internal();

  static const String _storageKey = "trips_storage";

  /// 🔔 Reactive trips list
  final ValueNotifier<List<Trip>> tripsNotifier =
      ValueNotifier<List<Trip>>([]);

  List<Trip> get trips => tripsNotifier.value;

  // --------------------------------------------------
  // 🔹 LOAD FROM STORAGE
  // --------------------------------------------------
  Future<void> loadTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);

    if (data != null) {
      final List decoded = jsonDecode(data);
      tripsNotifier.value =
          decoded.map((e) => Trip.fromJson(e)).toList();
    }
  }

  // --------------------------------------------------
  // 🔹 SAVE TO STORAGE
  // --------------------------------------------------
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      tripsNotifier.value.map((t) => t.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encoded);
  }

  // --------------------------------------------------
  // ✅ ADD PLANNED TRIP (FULL DATA)
  // --------------------------------------------------
  Future<void> addPlannedTrip({
    required String destination,
    required DateTime fromDate,
    required DateTime toDate,
    required List<Mood> moods,
    required double budget,
  }) async {
    tripsNotifier.value = [
      ...tripsNotifier.value,
      Trip(
        destination: destination,
        status: TripStatus.planned,
        fromDate: fromDate,
        toDate: toDate,
        moods: moods,
        budget: budget,
      ),
    ];

    await _save();
  }

  // --------------------------------------------------
  // 🔹 PLANNED → ONGOING
  // --------------------------------------------------
  Future<void> startTrip(String destination) async {
    tripsNotifier.value = tripsNotifier.value.map((trip) {
      if (trip.destination == destination &&
          trip.status == TripStatus.planned) {
        return Trip(
          destination: trip.destination,
          status: TripStatus.ongoing,
          fromDate: trip.fromDate,
          toDate: trip.toDate,
          moods: trip.moods,
          budget: trip.budget,
        );
      }
      return trip;
    }).toList();

    await _save();
  }

  // --------------------------------------------------
  // 🔹 ONGOING → PAST
  // --------------------------------------------------
  Future<void> completeTrip(String destination) async {
    tripsNotifier.value = tripsNotifier.value.map((trip) {
      if (trip.destination == destination &&
          trip.status == TripStatus.ongoing) {
        return Trip(
          destination: trip.destination,
          status: TripStatus.past,
          fromDate: trip.fromDate,
          toDate: trip.toDate,
          moods: trip.moods,
          budget: trip.budget,
        );
      }
      return trip;
    }).toList();

    await _save();
  }

  // --------------------------------------------------
  // 🔹 CANCEL TRIP
  // --------------------------------------------------
  Future<void> cancelTrip(String destination) async {
    tripsNotifier.value = tripsNotifier.value
        .where((t) => t.destination != destination)
        .toList();

    await _save();
  }

  // --------------------------------------------------
  // 🔹 GETTERS
  // --------------------------------------------------
  List<Trip> get plannedTrips =>
      trips.where((t) => t.status == TripStatus.planned).toList();

  List<Trip> get ongoingTrips =>
      trips.where((t) => t.status == TripStatus.ongoing).toList();

  List<Trip> get pastTrips =>
      trips.where((t) => t.status == TripStatus.past).toList();
}
