import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presence_app/auth_service.dart';
import 'package:presence_app/conponent/profile_avartar.dart';
import 'package:presence_app/container_scanner.dart';
import 'package:presence_app/controllers/home_page_scan_controller.dart';
import 'package:presence_app/controllers/profile_controller.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

class HomePageScan extends StatelessWidget {
  HomePageScan({super.key});

  final HomePageScanController controller = Get.put(HomePageScanController());

  final authService = Get.find<AuthService>();
  final profileController = Get.find<ProfileController>();

  final int userId = Get.arguments[0];
  final String userRole = Get.arguments[1] ?? "user";

  // /uploads/1754482866709-365741922.jpg

  Future<void> pickQrFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      // If the user does not pick up any image
      if (pickedFile == null) {
        Get.snackbar(
          "Warnig message",
          "Image not selected",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
          duration: const Duration(seconds: 3),
        );
      }

      if (pickedFile != null) {
        // Select QR Code from image
        final String? qrData = await QrCodeToolsPlugin.decodeFrom(
          pickedFile.path,
        );

        // Make sure the QR Code is not empty
        if (qrData != null && qrData.isNotEmpty) {
          Get.dialog(
            AlertDialog(
              title: Text("QR Code Found"),
              content: Text('This is not QR found form'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } else {
          Get.defaultDialog(
            title: "Error message",
            middleText: "Something has errors in pick up image!",
            textCancel: "No",
            textConfirm: "Yes",
            onConfirm: () => Get.back(),
          );
          // not work
          debugPrint("😭 Something has errors in pick up image!");
        }
      }
    } catch (e) {
      Get.defaultDialog(
        title: "Error message",
        middleText: "Please choose QR code image!",
        textCancel: "No",
        textConfirm: "Yes",
        cancelTextColor: Colors.grey[600],
        confirmTextColor: Colors.blue[600],
        onConfirm: () => Get.back(),
      );
      debugPrint("😭 Something has errors in pick up image! $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "Scan QR Code",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(width: 50),
            SizedBox(
              height: 50,
              width: 50,
              child: Obx(
                () => InkWell(
                  onTap: () => Get.toNamed('/userProfile'),
                  child: ProfileAvartar(
                    localImageFile: profileController.image.value,
                    networkImagUrl: profileController.imageUrl.value,
                    dfaultAssetPath: profileController.imagePath.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Container(
        margin: const EdgeInsets.all(10),

        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Camera
                Expanded(
                  flex: 1,
                  child: ContainerScanner(
                    image: 'camera.png',
                    isPressed: controller.isPressedCam.value,
                    label: "Camera ",
                    onTapFun: () {
                      controller.updateCam();
                      //call camera
                      Get.toNamed('camera', arguments: [userId, userRole]);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ContainerScanner(
                    image: 'picture.png',
                    isPressed: controller.isPressedGal.value,
                    label: "Gallary",
                    onTapFun: () {
                      pickQrFromGallery();
                      controller.updateGal();
                      debugPrint("Gallary");
                    },
                  ),
                ),
                userRole.trim() != "admin" && userRole.trim() != "owner"
                    ? SizedBox.shrink()
                    : Expanded(
                        flex: 1,
                        child: ContainerScanner(
                          image: "qr_code_admin.png",
                          onTapFun: () {
                            controller.updateQR();
                            Get.toNamed('/qr');
                            // debugPrint('👉 role: ${role == 'owner'}');
                          },
                          isPressed: controller.isPressedQR.value,
                          label: "QR Code",
                        ),
                      ),
                ContainerScanner(
                  image: "morning.png",
                  onTapFun: () {},
                  isPressed: false,
                  label: "Morning",
                ),

                //Image
              ],
            ),
           
          ],
        ),
      ),
    );
  }
}
