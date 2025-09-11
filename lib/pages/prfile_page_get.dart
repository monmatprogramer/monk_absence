import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/controllers/profile_controller.dart';

class PrfilePageGet extends StatelessWidget {
  const PrfilePageGet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Page GetX")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Text(
              "Name: ${controller.name}",
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            // onPressed: () => controller.updateName("Mon Mat"),
            onPressed: () {},
            child: const Text("change name"),
          ),
        ],
      ),
    );
  }
}
