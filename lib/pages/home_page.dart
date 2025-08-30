import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/services/auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  String profileImage = Get.arguments[2];

  ///uploads/1754482866709-365741922.jpg

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Get.to(DetailPage());
                authService.login("mat", "temp_password");
              },
              child: Obx(
                () => Text("Test Login (result{${authService.userData}})"),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Go to profile page",
                  middleText: "Preparing to open the profile for testing",
                  textCancel: "No",
                  textConfirm: "Yes",
                  onConfirm: () {
                    Navigator.of(context).pop();
                    Get.toNamed("/profile", arguments: profileImage);
                  },
                );
              },
              child: const Text("Go to Prfile Page"),
            ),
          ],
        ),
      ),
    );
  }
}
