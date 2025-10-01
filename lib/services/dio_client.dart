
import 'package:dio/dio.dart';
import 'package:presence_app/db_config.dart';

class DioClient{
    // Private constructor
    DioClient._();
    static final DioClient instance = DioClient._();

    final Dio dio = Dio(BaseOptions(
            baseUrl: "${DbConfig.apiUrl}/api",
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 20),

        ),
    )..interceptors.add(
        LogInterceptor(
            request: true,
            requestBody: true,
            responseBody: true,
            error: true,
        ),
    );
}



