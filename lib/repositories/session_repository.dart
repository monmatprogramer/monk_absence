import 'package:logger/logger.dart';
import 'package:presence_app/models/sessions_model.dart';
import 'package:presence_app/services/api_service.dart';

class SessionRepository {
  // Dependencies
  final ApiService _apiService;
  final _logger = Logger(printer: PrettyPrinter());
  SessionRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  // Fetch all sessions and convert them to Session objects
  Future<List<Session>> getAllSessions() async {
    try {
      final List<Map<String, dynamic>> sessionsJson = await _apiService
          .getAllSessions();

      final List<Session> sessions = sessionsJson
          .map((json) => Session.fromJson(json))
          .toList();
      return sessions;
    } catch (e) {
      rethrow;
    }
  }

  // Get active session only
  Future<List<Session>> getActiveSessions() async {
    try {
      final List<Session> allSessions = await getAllSessions();
      _logger.d(
        'activeSession: ${allSessions.where((a) => a.isActive == true)}',
      );
      final List<Session> activeSession = allSessions
          .where((a) => a.isActive == true)
          .toList();
      return activeSession;
    } catch (e) {
      rethrow;
    }
  }

  // Get session by session id
  Future<Session?> getSessionById(int sessionId) async {
    try {
      //Check session id validation
      //Negative
      if (sessionId < 0) {
        throw Exception("Session's ID must be positive: $sessionId");
      }
      //session id require
      if (sessionId == 0) {
        throw Exception("Session's ID is required.");
      }
      // Get list of all Session
      final List<Session> allSession = await getAllSessions();
      //Check Session existing by using Session's ID input
      return allSession.firstWhere(
        (session) => session.id == sessionId,
        orElse: () => throw Exception('Session not found'),
      );
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _apiService.dispose();
  }
}
