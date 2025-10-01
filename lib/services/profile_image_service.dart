import 'package:dio/dio.dart';
import 'package:presence_app/services/dio_client.dart';

class ProfileImageService {
    final Dio _dio;
    ProfileImageService({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;
}
