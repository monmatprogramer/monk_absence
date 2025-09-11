import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/pages/loading_states.dart';
import 'package:presence_app/services/auth_service.dart';
import 'package:presence_app/conponent/show_status_dialog.dart';
import 'package:presence_app/controllers/profile_controller.dart';
import 'package:presence_app/pages/profile_page_body_con.dart';
import 'package:presence_app/pages/profile_page_header_con.dart';

enum Status { loading }

class ProfilePageCon extends StatelessWidget {
  ProfilePageCon({super.key});

  var logger = Logger(printer: PrettyPrinter());
  final profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Profile")),
      body: Obx(() {
        switch (profileController.profileResponse.value.states) {
          case LoadingStates.loading:
            return const Center(child: CircularProgressIndicator());
          case LoadingStates.initial:
            return Center(child: CircularProgressIndicator());
          case LoadingStates.success:
            return const SingleChildScrollView(
              child: Column(
                children: [ProfilePageHeaderCon(), ProfilePageBodyCon()],
              ),
            );
          case LoadingStates.error:
            final errorMessage =
                profileController.profileResponse.value.errorMessage ??
                "An unknown error occurred";
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
        }
      }),
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
