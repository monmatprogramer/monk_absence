import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/services/auth_service.dart';
import 'package:presence_app/controllers/profile_controller.dart';
import 'package:presence_app/db_config.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({super.key});
  var logger = Logger(printer: PrettyPrinter());
  final authservice = Get.find<AuthService>();
  final profileController = Get.find<ProfileController>();

  Future<void> checkLoginStatus() async {
    try {
      await authservice.handleIsLoggedIn();
      if (authservice.isLoggedIn.value == true) {
        RxMap<dynamic, dynamic> rxMap = RxMap();
        await authservice.getProfile();

        rxMap['role'] = authservice.wholeData['role'];
        rxMap['id'] = authservice.wholeData['id'];
        rxMap['profileImage'] =
            '${DbConfig.apiUrl}${authservice.wholeData['profileImage']}';
        profileController.updateImageUrl(
          '${DbConfig.apiUrl}${authservice.wholeData['profileImage']}',
        );

        Get.toNamed(
          "/home",
          arguments: [
            authservice.userId.value,
            rxMap['role'],
            rxMap['profileImage'],
          ],
        );
      } else {
        Get.toNamed("/login");
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    checkLoginStatus();
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
