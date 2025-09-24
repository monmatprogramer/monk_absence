import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/services/auth_service.dart';
import 'package:presence_app/controllers/profile_controller.dart';

class ProfileHeaderBody extends StatelessWidget {
  ProfileHeaderBody({super.key});
  final GlobalKey widgetKey = GlobalKey();
  final authServer = Get.find<AuthService>();
  final proController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {

    if (widgetKey.currentContext == null) {
      Get.delete<ProfileController>();
    }

    return authServer.wholeData.isEmpty
        ? const Center(child: Text('Failed to fetch user data'))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Name",
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18),
                    ),
                    TextSpan(
                      text: " : ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    TextSpan(
                      text: authServer.wholeData['username'],
                      style: TextStyle(
                        color: const Color.fromARGB(255, 4, 89, 201),
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Email",
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                    ),
                    TextSpan(
                      text: " : ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    TextSpan(
                      text: authServer.wholeData['email'] ?? "None",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 4, 89, 201),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Role",
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                    ),
                    TextSpan(
                      text: " : ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    TextSpan(
                      text: authServer.wholeData['role'] ?? "user",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 201, 4, 102),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
