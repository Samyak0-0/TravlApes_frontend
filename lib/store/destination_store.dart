import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../services/api_service.dart';

class DestinationStore extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Destination> destinations = [];
  bool isLoading = false;

  Future<void> fetchDestinations() async {
    isLoading = true;
    notifyListeners();

    destinations = await _api.getAllDestinations();

    isLoading = false;
    notifyListeners();
  }

  Future<void> filterDestinations(List<String> moods) async {
    isLoading = true;
    notifyListeners();

    destinations = await _api.searchDestinations(moods: moods);

    isLoading = false;
    notifyListeners();
  }
}
