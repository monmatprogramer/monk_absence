import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:presence_app/services/auth_service.dart';
import 'package:presence_app/conponent/profile_avartar.dart';
import 'package:presence_app/conponent/show_app_message.dart';
import 'package:presence_app/constains/response_message.dart';
import 'package:presence_app/controllers/profile_controller.dart';
import 'package:presence_app/db_config.dart';

class ProfileImageCircle extends StatelessWidget {
  ProfileImageCircle({super.key});
  final profileController = Get.find<ProfileController>();
  final authService = Get.find<AuthService>();
  final userId = Get.arguments;

  var logger = Logger(printer: PrettyPrinter());

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickerFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickerFile != null) {
      // profileController.updateImage(PickedFile.path);
      // profileController.handleSelectedImage(File(pickerFile.path));

      await uploadImage(File(pickerFile.path));
    }
  }

  Future<void> uploadImage(File imageFile) async {
    ///data/user/0/com.example.presence_app/cache/scaled_1000003693.jpg
    try {
      final token = await authService.getToken();

      final mimeTypeData = lookupMimeType(
        imageFile.path,
      )?.split('/'); //[image,jpeg]
      final uri = Uri.parse('${DbConfig.apiUrl}/api/upload/upload-file');
      final file = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      );
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(file);

      final response = await request.send();
      final resp = await http.Response.fromStream(response);
      var resMessage = ResponseMessage();
      final tempMessage = jsonDecode(resp.body);
      resMessage.message = tempMessage['message'];
      if (response.statusCode == 200) {
        final path =
            resp.body.contains(
              'filePath',
            ) // /uploads/1754390592902-392971489.png
            ? RegExp(r'\"filePath\":\"(.*?)\"').firstMatch(resp.body)?.group(1)
            : null;
        if (path != null) {
          profileController.updateImageUrl(DbConfig.apiUrl + path);
        }
        showAppMessage(
          messageType: MessageType.success,
          buttonLabel: "Update successful",
          message: resMessage.message,
        );
      } else {
        debugPrint("Upload failed with status ${response.statusCode}");
        debugPrint("Error message: ${response.reasonPhrase}");
        showAppMessage(
          messageType: MessageType.error,
          buttonLabel: "Update error",
          message: resMessage.message,
        );
      }
    } catch (e) {
      debugPrint("Error uploading image: $e");
      showAppMessage(
        messageType: MessageType.error,
        buttonLabel: "Update error",
        message: "Error $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: <Widget>[
          profileController.isLoading.value
              ? CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey.shade200,
                  child: CircularProgressIndicator(),
                )
              : ProfileAvartar(
                  size: 140,
                  localImageFile: profileController.image.value,
                  // networkImagUrl: profileController.imageUrl.value,
                  dfaultAssetPath: 'images/profile.png',
                ),

          // CircleAvatar(
          //   radius: 70,
          //   backgroundColor: Colors.grey.shade200,
          //   backgroundImage: profileController.imageUrl.value.isNotEmpty
          //       ? NetworkImage(profileController.imageUrl.value)
          //       : NetworkImage(
          //           DbConfig.apiUrl + authService.wholeData['profileImage'],
          //         ),
          //   onBackgroundImageError: (_, _) =>
          //       const Icon(Icons.person, size: 70),
          // ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.28,
            bottom: 10,
            child: GestureDetector(
              onTap: () => pickImage(),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
