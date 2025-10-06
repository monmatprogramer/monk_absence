import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:presence_app/models/upload_result.dart';
import 'package:presence_app/services/dio_client.dart';

class ProfileImageService {
  final Dio _dio;
  ProfileImageService({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  static const String _endpoint = "/upload/upload-file";

  Future<UploadResult> uploadProfileImageMobile({
    required String token,
    required XFile imageFile, //image_picker
    void Function(int send, int total)? onProgress,
    CancelToken? cancelToken, //dio
  }) async {
    try {
      final String filePath = imageFile
          .path; //'/storage/emulated/0/DCIM/Camera/IMG_20231215_123456.jpg'
      final String fileName =
          filePath.split(Platform.pathSeparator).last.isEmpty
          ? "profile_${DateTime.now().millisecondsSinceEpoch}.jpg"
          : filePath.split(Platform.pathSeparator).last;
      final String mimeType = lookupMimeType(filePath) ?? 'image/jpeg';
      final parts = mimeType.split('/');
      final DioMediaType mediaType = DioMediaType(parts.first, parts.last);
      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: mediaType,
        ),
      });
      final response = await _dio.post(
        _endpoint,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
        onSendProgress: onProgress,
        cancelToken: cancelToken,
      );

      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final dynamic body = response.data;
        final String? url = body is Map
            ? (body['data']?['url'] ?? body['url'] ?? body['result']?['url'])
            : null;

        return UploadResult(
          success: true,
          statusCode: code,
          url: url,
          message: "upload successfull",
        );
      }

      return UploadResult(
        success: false,
        statusCode: code,
        message: "Upload failed with status $code",
      );
    } on DioException catch (e) {
      final int code = e.response?.statusCode ?? -1;
      final String serverMsg = "${e.response?.data}";
      return UploadResult(
        success: false,
        statusCode: code,
        message: "DioException: ${e.message}. Server: $serverMsg",
      );
    } catch (e) {
      return UploadResult(
        success: false,
        statusCode: -1,
        message: "Unexpected error: $e",
      );
    }
  }
}
