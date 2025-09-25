
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/db_config.dart';

class ApiServerDio{
    final logger = Logger(printer: PrettyPrinter());
    final Dio dio = Dio(BaseOptions(
        baseUrl: "${DbConfig.apiUrl}/api",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {"Content-Type": "application/json"},
    ));

    // Upload image from Web app
    Future<void> uploadImage(String token, List<int> bytes, String filename)async{
        try {
             final formData = FormData.fromMap({
                "image": MultipartFile.fromBytes(
                    bytes,
                    filename: filename,
                    contentType: DioMediaType("image","jpeg"),
                ),
            });

            final response = await dio.post(
                "/upload",
                data: formData,
                options: Options(headers: {"Authorization": "Bearer $token"}),
                onSendProgress: (sent, total){
                    debugPrint('🔄 Upload progress: ${(sent/total * 100).toStringAsFixed(0)}%');
                },
            );

            if(response.statusCode == 200){
                debugPrint("✅ Upload success: ${response.data}");
            }else{
                debugPrint("💥 Failed: ${response.statusCode}");
            }

        }on DioException catch(e){
            debugPrint("💥 Upload failed: ${e.message}");
            if(e.response != null){
                debugPrint("Sever response: ${e.response?.data}");
            }
        }
        catch (e) {
            logger.d("ApiServerDio error : $e");
        }
    }
}
