import 'dart:convert';
import 'package:http/http.dart' as http;

class RoutingService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<List<double>>> getRoute({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
    String profile = 'car',
  }) async {
    final uri = Uri.parse(
      '$baseUrl/route'
      '?profile=$profile'
      '&start_lat=$startLat'
      '&start_lon=$startLon'
      '&end_lat=$endLat'
      '&end_lon=$endLon',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Backend error ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    return List<List<double>>.from(
      data['geometry']['coordinates'],
    );
  }
}
