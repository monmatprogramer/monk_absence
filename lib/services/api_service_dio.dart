
import 'package:dio/dio.dart';
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
        } catch (e) {
            logger.d("ApiServerDio error : $e");
        }
    }
}
