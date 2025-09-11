import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/conponent/show_app_message.dart';
import 'package:presence_app/core/exceptions/app_exception.dart';

class ExceptionHandler {
  static final Logger _logger = Logger();

  // Handle exceptions globally
  static void handleException(
    dynamic exception, {
    StackTrace? stackTrace,
    bool showToUser = true,
    String? context,
  }) {
    _logger.e(
      'Exception handled in context: ${context ?? 'Unknown'}',
      error: exception,
      stackTrace: stackTrace,
    );
    if (exception is AppException) {
      _handleAppException(exception, showToUser: showToUser);
    } else {
      _handleGenericException(exception, stackTrace, showToUser: showToUser);
    }

    if (kDebugMode) {
      _printDebugInfo(exception, stackTrace, context);
    }
  }

  // Handle App Exception
  static void _handleAppException(
    AppException exception, {
    bool showToUser = true,
  }) {
    if (showToUser) {
      MessageType messageType;
      switch (exception.runtimeType) {
        case NetworkException:
          messageType = MessageType.error;
          break;
        case AuthException:
          messageType = MessageType.warning;
          break;
        case ValidationException:
          messageType = MessageType.info;
          break;
        case ApiException:
          messageType = MessageType.error;
          break;
        default:
          messageType = MessageType.error;
          break;
      }
      _logger.d("👉${exception.getDisplayMessage()}");
      showAppMessage(
        messageType: messageType,
        buttonLabel: "OK",
        message: exception.getDisplayMessage(),
      );
    }
  }

  // Handle generic exception
  static void _handleGenericException(
    dynamic exception,
    StackTrace? stackTrace, {
    bool showToUser = true,
  }) {
    final AppException appException = AppException(
      'An unexpected error occurred',
      details: exception.toString(),
      stackTrace: stackTrace,
      debugInfo: {'orginalException': exception.runtimeType.toString()},
    );

    // show to user or not
    if (showToUser) {
      showAppMessage(
        messageType: MessageType.error,
        buttonLabel: "OK",
        message: "Something went wrong. please try again",
      );
    }
  }

  // Print debug info
  static void _printDebugInfo(
    dynamic exception,
    StackTrace? stackTrace,
    String? context,
  ) {
    debugPrint("======== EXCEPTION DEBUG INFO =======");
    debugPrint('Context: ${context ?? 'Unknown'}');
    debugPrint('Exception Type: ${exception.runtimeType}');
    debugPrint('Exception: $exception');

    if (exception is AppException) {
      debugPrint("Debug info: ${exception.getDebugInfo()}");
    }

    if (stackTrace != null) {
      debugPrint("Stack Trace");
      debugPrint(stackTrace.toString());
    }
    debugPrint('======== END DEBUG INFO ==============');
  }
}
