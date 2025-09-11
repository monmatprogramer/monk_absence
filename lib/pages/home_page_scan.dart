import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presence_app/conponent/profile_avartar.dart';
import 'package:presence_app/container_scanner.dart';
import 'package:presence_app/controllers/home_page_scan_controller.dart';
import 'package:presence_app/controllers/profile_controller.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

class HomePageScan extends StatefulWidget {
  const HomePageScan({super.key});

  @override
  State<HomePageScan> createState() => _HomePageScanState();
}

class _HomePageScanState extends State<HomePageScan> {
  // 1. Initialize Controllers
  final HomePageScanController controller = Get.find<HomePageScanController>();
  final ProfileController profileController = Get.find<ProfileController>();

  // 2. Define variables for route arguments
  late String userId;
  late String userRole;

  @override
  void initState() {
    super.initState();
    // 3. Retrieve arguments
    final arguments = Get.arguments as List;
    userId = arguments[0] as String;
    userRole = arguments[1] as String;
  }

  // 4. Implement the missing function
  Future<void> pickQrFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final String? qrData = await QrCodeToolsPlugin.decodeFrom(image.path);
      if (qrData != null) {
        // Handle the scanned QR data
        Get.snackbar('QR Scanned', 'Data: $qrData');
      } else {
        Get.snackbar('Error', 'No QR code found in the image.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan QR Code",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Obx(
                () => InkWell(
                  onTap: () => Get.toNamed('/profile'),
                  child: ProfileAvartar(
                    localImageFile: profileController.image.value,
                    //networkImagUrl: profileController.imageUrl.value,
                    dfaultAssetPath: profileController.imagePath.value,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
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
                label: "Gallery",
                onTapFun: () {
                  pickQrFromGallery();
                  controller.updateGal();
                  debugPrint("Gallery");
                },
              ),
            ),
            if (userRole.trim() == "admin" || userRole.trim() == "owner")
              Expanded(
                flex: 1,
                child: ContainerScanner(
                  image: "qr_code_admin.png",
                  onTapFun: () {
                    controller.updateQR();
                    Get.toNamed('/qr');
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
          ],
        ),
      ),
    );
  }
}