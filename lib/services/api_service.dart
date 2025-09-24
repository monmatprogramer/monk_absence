import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:presence_app/db_config.dart';
import 'package:presence_app/services/auth_service.dart';

class ApiService {
  static final String baseUrl = '${DbConfig.apiUrl}/api';
  final http.Client _client = http.Client();
  final authService = Get.find<AuthService>();
  final _logger = Logger(printer: PrettyPrinter());
  // Get all sessions from the API
  Future<List<Map<String, dynamic>>> getAllSessions() async {
    try {
      final String token = await authService.getToken();
      // Make HTTP GET requrest to the API

      final response = await _client.get(
        Uri.parse('$baseUrl/session/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      // Check if the request was successful
      if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(
          response.body,
        ); //response.body = [{"id": 1, "name": "Session 1"}, {"id": 2, "name": "Session 2"}];
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        _logger.e('Failed to get sessions from API: ${response.statusCode}');
        throw Exception(
          'Failed to get sessions from API: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      _logger.e('Error getting sessions from API: $e');
      throw Exception('Error getting sessions from API: $e');
    }
  }

  // Clean up resources when done
  void dispose() {
    _client.close();
  }
}
