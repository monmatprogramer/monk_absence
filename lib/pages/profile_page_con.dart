import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/auth_service.dart';
import 'package:presence_app/conponent/app_containts.dart';
import 'package:presence_app/conponent/show_status_dialog.dart';
import 'package:presence_app/controllers/profile_controller.dart';
import 'package:presence_app/pages/profile_page_body_con.dart';
import 'package:presence_app/pages/profile_page_header_con.dart';

class ProfilePageCon extends StatelessWidget {
  ProfilePageCon({super.key});

  var logger = Logger(printer: PrettyPrinter());
  final profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    logger.d("ProfilePageCon👉 ${profileController.imageUrl.value}");
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(centerTitle: true, title: const Text("Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: AppContaints.maxTextWidth - 90,
              height: AppContaints.maxTextWidth - 130, //200
              child: ProfilePageHeaderCon(
               
              ),
            ),
            //const SizedBox(height: 80, child: Placeholder()),
            ProfilePageBodyCon(),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: () => _handleLogout(context),
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showSatusDialog(
      context: context,
      title: "Logout",
      message: "Do you want to logout?",
      icon: Icons.logout,
      iconColor: Colors.white,
      onPressed: () {
        AuthService().logout();
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}
