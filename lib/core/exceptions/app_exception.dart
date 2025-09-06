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
