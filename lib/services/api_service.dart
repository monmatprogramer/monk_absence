import 'package:http/http.dart' as http;
import 'package:presence_app/conponent/app_containts.dart';
import 'package:presence_app/db_config.dart';

class ApiService {
  static final String baseUrl = '${DbConfig.apiUrl}/api';
  final http.Client _client = http.Client();

  // Get all sessions from the API
  Future<List<Map<String, dynamic>>> getAllSessions() async {
    try {
      // Make HTTP GET requrest to the API
      final response = await _client.get(
        Uri.parse('$baseUrl/sessions/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppContaints.token}',
          'Accept': 'application/json'
        }
      );
    } catch (e) {}
  }
}
