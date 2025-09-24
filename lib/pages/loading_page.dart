import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/services/auth_service.dart';
import 'package:presence_app/controllers/profile_controller.dart';
import 'package:presence_app/db_config.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final logger = Logger(printer: PrettyPrinter());
  final authservice = Get.find<AuthService>();
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      await authservice.handleIsLoggedIn().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw 'Connection timeout. Please try again later';
        },
      );

      if (authservice.isLoggedIn.value == true) {
        await authservice.getProfile();

        final userData = authservice.wholeData;
        if(userData == null || userData.isEmpty){
          throw 'Failed to load user profile';
        }

        final profileImage = '${DbConfig.apiUrl}${userData['profileImage']}';
        profileController.updateImageUrl(profileImage);


        Get.offAllNamed(
          "/home",
          arguments: [
            authservice.userId.value,
            userData['role'],
            profileImage,
          ],
        );
      } else {
        Get.offAllNamed("/login");
      }
    } catch (e) {
      logger.e('An error occurred in checkLoginStatus: $e');
      Get.snackbar(
        'Error',
        'Failed to connect to the server. Please check your internet connection and try again',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [CircularProgressIndicator(), Text("Loading...")],
        ),
      ),
    );
  }
}
