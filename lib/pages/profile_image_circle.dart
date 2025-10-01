import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/pages/loading_states.dart';
import 'package:presence_app/services/auth_service.dart';
import 'package:presence_app/conponent/profile_avartar.dart';
import 'package:presence_app/controllers/profile_controller.dart';
import 'package:presence_app/services/profile_image_service.dart';

class ProfileImageCircle extends StatelessWidget {
  ProfileImageCircle({super.key});

  final profileController = Get.find<ProfileController>();
  final authService = Get.find<AuthService>();
  final userId = Get.arguments;
  final profileImageService = ProfileImageService();
  final logger = Logger(printer: PrettyPrinter());

  Future<void> pickImage() async {
    try{
      final picker = ImagePicker();
      final pickerFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if(pickerFile == null){
        debugPrint('❌ User cancelled picker');
        return;
      }
      if(kIsWeb){
        // Web: read as bytes
        Uint8List bytes = await pickerFile.readAsBytes();
        //get token
        final String token = await authService.getToken();
        await profileImageService.uploadProfileImage(token, bytes, pickerFile.name);
      }else{
        // Mobile / Desktop : use file
        File file = File(pickerFile.path);
        logger.d('🗃️ file: $file');
        //TODO: Implement here
      }
    }catch(e){
      logger.e("❌ Error picking image: $e ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: <Widget>[
          profileController.profileResponse.value.states == LoadingStates.loading
              ? CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey.shade200,
                  child: CircularProgressIndicator(),
                )
              : ProfileAvartar(
                  size: 140,
                  localImageFile: profileController.image.value,
                  networkImagUrl: profileController.imageUrl,
                  dfaultAssetPath: 'images/profile.png',
                ),
          Positioned(
            right: 114,
            bottom: 10,
            child: GestureDetector(
              onTap: () async => await pickImage(),

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
