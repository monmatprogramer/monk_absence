import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/models/sessions_model.dart';
import 'package:presence_app/repositories/session_repository.dart';

class SessionController extends GetxController {
  // Dependencies
  final SessionRepository _repository;
  final _logger = Logger();

  //Constructor initialization
  SessionController({SessionRepository? repository})
    : _repository = repository ?? SessionRepository();

  // Observable state variable
  final RxList<Session> sessions = <Session>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  // Called when constroller is initialized
  @override
  void onInit() {
    super.onInit();
    fetchSessions(); // Loading sessions when controller starts
  }

  // Fetch all sessions from repository
  Future<void> fetchSessions() async {
    try {
      // Set laodig state
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Fetch sessions from repository
      final List<Session> fetchedSessions = await _repository.getAllSessions();

      sessions.value = fetchedSessions;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to laod sessions,  please try again';
    } finally {
      // Always stop loading indicator
      isLoading.value = false;
    }
  }

  // Refresh sessions (pull-to-refresh functonality)
  Future<void> refreshSessions() async {
    await fetchSessions();
  }

  List<Session> get activeSessions {
    return sessions.where((session) => session.isActive).toList();
  }

  // Search session by title
  List<Session>? searchSession(String query) {
    if (query.isEmpty) return sessions; // return whole sessions
    final List<Session> sessionResult = sessions
        .where(
          (session) =>
              session.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    if (sessionResult.isNotEmpty) {
      return sessionResult;
    }
    return null;
  }
}
