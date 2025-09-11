import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
import 'package:presence_app/services/auth_service.dart';
import 'package:presence_app/conponent/profile_avartar.dart';
import 'package:presence_app/container_scanner.dart';
import 'package:presence_app/controllers/home_page_scan_controller.dart';
import 'package:presence_app/controllers/profile_controller.dart';
import 'package:presence_app/controllers/scan_camera_controller.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

class MenuPage extends StatefulWidget {
  MenuPage({super.key});
  final profileController = Get.find<ProfileController>();

  final int userId = Get.arguments[0];
  final String userRole = Get.arguments[1] ?? "user";

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final PageController _pageController = PageController();
  final HomePageScanController controller = Get.put(HomePageScanController());
  final scanCameraController = Get.put(ScanCameraController());
  final autherService = Get.find<AuthService>();
  var logger = Logger(printer: PrettyPrinter());
  int _currentPage = 0;
  static const List<String> _bannerImages = [
    'https://cdn.pixabay.com/photo/2025/06/14/21/46/plane-9660343_1280.jpg',
    'https://d1y8sb8igg2f8e.cloudfront.net/images/32517113524_1f8c2d8459_o.width-800.jpg',
    'https://m.media-amazon.com/images/S/pv-target-images/8a989db986eaa37c5eb2f88d8badcaa57f001ba13410f3329fcda3a1483cc3bd._SX1080_FMjpg_.jpg',
    'https://news.cgtn.com/news/2021-10-02/Live-Airshow-China-2021-wraps-up-with-stunning-aerobatic-display-142g0D9peZq/img/32eded0a8ec64953a0d8414399ba20c9/32eded0a8ec64953a0d8414399ba20c9.jpeg',
    'https://jet.mt/wp-content/uploads/2019/01/bfe66c353d80cead6829d0aeecbe014b.jpg',
  ];

  List<ContainerScanner> _menuItemValue = [];
  //Lazy initializer
  List<ContainerScanner> get _menuItem => _menuItemValue;
  @override
  void initState() {
    super.initState();
    _menuItemValue = [
      ContainerScanner(
        image: 'camera.png',
        isPressed: controller.isPressedCam.value,
        label: "Camera ",
        onTapFun: () {
          // controller.updateCam();
          scanCameraController.updateIsScannedCompleted(false);
          //call camera
          Get.toNamed(
            '/camera',
            arguments: [autherService.userId.value, widget.userRole],
          );
        },
      ),
      ContainerScanner(
        image: 'picture.png',
        isPressed: controller.isPressedGal.value,
        label: "Gallary",
        onTapFun: () {
          pickQrFromGallery();
          controller.updateGal();
          debugPrint("Gallary");
        },
      ),
      ContainerScanner(
        image: "qr_code_admin.png",
        onTapFun: () {
          controller.updateQR();
          Get.toNamed('/qr', arguments: autherService.wholeData['role']);
          // debugPrint('👉 role: ${role == 'owner'}');
        },
        isPressed: controller.isPressedQR.value,
        label: "QR Code",
      ),
      ContainerScanner(
        image: "morning.png",
        onTapFun: () => Get.toNamed('/morning-session'),
        isPressed: false,
        label: "Morning",
      ),
      ContainerScanner(
        image: "night.png",
        onTapFun: () => Get.toNamed('/evening-session'),
        isPressed: false,
        label: "Evening",
      ),
      ContainerScanner(
        image: "list_presence.png",
        onTapFun: () {},
        isPressed: false,
        label: "List",
      ),
      ContainerScanner(
        image: "timer.png",
        onTapFun: () => Get.toNamed('/session'),
        isPressed: false,
        label: "Sessions",
      ),
    ];
  }

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
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _bannerImages.length,
                      onPageChanged: (value) {
                        setState(() {
                          _currentPage = value;
                        });
                      },
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _bannerImages[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) {
                              return ColoredBox(color: Colors.grey[300]!);
                            },
                          ),
                        );
                      },
                    ),
                    //Track slide show processing
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _bannerImages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 12 : 8,
                            height: _currentPage == index ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //Profile
                    Positioned(
                      top: 0,
                      right: 2,
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Obx(
                          () => InkWell(
                            onTap: () => Get.toNamed('/userProfile'),
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: ProfileAvartar(
                                localImageFile:
                                    widget.profileController.image.value,
                                networkImagUrl:
                                    // widget.profileController.imageUrl.value,
                                // dfaultAssetPath:
                                    widget.profileController.imagePath.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(indent: 10, endIndent: 10, thickness: 1.5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: GridView.builder(
                  itemCount: _menuItem.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.5,
                  ),
                  itemBuilder: (context, index) {
                    final item = _menuItem[index];
                    return item;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
