import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationService {
  static const String baseUrl = "http://10.10.254.254:8000";

  Future<Map<String, dynamic>> recommendPlaces({
    required String location,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/places/recommend"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "location": location,
        "from_date": "2025-01-01",
        "to_date": "2025-01-05",
        "moods": ["cultural", "peaceful"],
        "budget": 5000,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch recommendations");
    }

    return jsonDecode(response.body);
  }
}
