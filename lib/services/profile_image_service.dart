import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:presence_app/db_config.dart';

class ProfileImageService {
    final Dio dio = Dio(BaseOptions(
        baseUrl:  "${DbConfig.apiUrl}/api",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
    ));

    Future<void> uploadProfileImage(String token,List<int> bytes, String filename) async{
     try {
        final formData = FormData.fromMap({
            "image": MultipartFile.fromBytes(
                bytes,
                filename: filename,
                contentType: DioMediaType("Image","jpeg")
            ),
        });

        final response = await dio.post(
            '/upload/upload-file',
            data: formData,
            options: Options(
                headers: {"Authorization":"Bearer $token"},
            ),
            onSendProgress: (sent, total){
                debugPrint("🔄 Upload progress: ${(sent / total * 100).toStringAsFixed(0)}%");
            },
            onReceiveProgress: (received, total){
                if(total != -1){
                    final percentage = (received /total * 100);
                    debugPrint("Download progress: ${percentage.toStringAsFixed(1)}% ($received/$total byte)");
                    if(percentage >= 0 && percentage < 25){
                       debugPrint("🔄 Response receiving started...");
                    }else if(percentage >= 25 && percentage < 75){
                        debugPrint("⚡ Response almost complete...");
                    }else if(percentage >= 75 && percentage < 100){
                        debugPrint("✅ Response nearly finished...");
                    }else if(percentage == 100){
                        debugPrint("🎉 Response fully received!");
                    }
                }else{
                    debugPrint("📥 Receiving response: $received bytes (total size unknown)");
                }
            }
        );

        debugPrint("✅ Upload complete successfully!");
        debugPrint("Response status: ${response.statusCode}");
        if(response.statusCode == 200){
            debugPrint("Respnse data: ${response.data}");
            //TODO: update image profile

        }else{
            debugPrint("⚠️ Upload failed: ${response.statusCode}");
        }
    }on DioException catch(e){
        debugPrint("⛓️‍💥 Server error: ${e.response?.data}");
    }
    catch (e) {
        debugPrint("❌ Upload failed: $e");
        rethrow;

    }
    }
}
