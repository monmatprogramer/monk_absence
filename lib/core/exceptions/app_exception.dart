import 'package:logger/logger.dart';

class AppException implements Exception {
  final String message;
  final String? details;
  final String? errorCode;
  final DateTime timestamp;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? debugInfo;

  AppException(
    this.message, {
    this.details,
    this.errorCode,
    this.stackTrace,
    this.debugInfo,
  }) : timestamp = DateTime.now() {
    _logException();
  }
  void _logException() {
    final logger = Logger();
    logger.e(
      'AppException occurred',
      error: this,
      stackTrace: stackTrace,
      time: timestamp,
    );
  }

  Map<String, dynamic> getDebugInfo() {
    return {
      'message': message,
      'details': details,
      'errorCode': errorCode,
      'timestamp': timestamp.toIso8601String(),
      'stackTrace': stackTrace?.toString(),
      'debugInfo': debugInfo,
      'runtimeType': runtimeType.toString(),
    };
  }

  String getDisplayMessage() {
    return details != null ? '$message: $details' : message;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('$runtimeType: $message');

    if (errorCode != null) {
      buffer.write(' (Code: $errorCode)');
    }

    if (details != null) {
      buffer.write('\nDetails: $details');
    }

    buffer.write('\nTimestamp: ${timestamp.toIso8601String()}');

    return buffer.toString();
  }
}

// Network exception
class NetworkException extends AppException {
  final int? statusCode;
  final String? endpoint;
  NetworkException({
    String? message,
    this.statusCode,
    this.endpoint,
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message ?? 'Network connection failed',
         details: details,
         errorCode: 'NETWORK_ERROR_${statusCode ?? 'UNKHNOWN'}',
         stackTrace: stackTrace,
         debugInfo: {
           'statusCode': statusCode,
           'endpoint': endpoint,
           'networkType': 'HTTP',
         },
       );

  @override
  String getDisplayMessage() {
    if (statusCode != null) {
      return 'Network error ($statusCode): $message';
    }
    return super.getDisplayMessage();
  }
}

//Auth
class AuthException extends AppException {
  final String? userId;
  final String? authMethod;
  AuthException({
    String? message,
    this.userId,
    this.authMethod,
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message ?? "Authentiacion failed",
         details: details ?? "Authentication details failed",
         errorCode: "AUTH_ERROR",
         stackTrace: stackTrace,
         debugInfo: {'userId': userId, 'authMethod': authMethod},
       );
}

// Validation exception
class ValidationException extends AppException {
  final String? fieldName;
  final dynamic invalidValue;
  ValidationException({
    String? message,
    this.fieldName,
    this.invalidValue,
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message ?? "Validation failed",
         details: details,
         errorCode: "VALIDATION_ERROR",
         stackTrace: stackTrace,
         debugInfo: {'fieldName': fieldName, 'invalidValue': invalidValue},
       );
}

// API-related exception
class ApiException extends AppException {
  final String? endpoint;
  final String? method;
  final int? statusCode;
  final Map<String, dynamic>? responseData;
  ApiException({
    String? message,
    this.endpoint,
    this.method,
    this.statusCode,
    this.responseData,
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message ?? "API request failed",
         details: details,
         errorCode:
             "API_ERROR_${statusCode ?? "UNKNOWN"}", //API_ERROR_300 or API_ERROR_UNKNOWN
         stackTrace: stackTrace,
         debugInfo: {
           'endPoint': endpoint,
           'method': method,
           'statusCode': statusCode,
           'responseData': responseData,
         },
       );
}
