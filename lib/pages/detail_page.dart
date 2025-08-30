import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/services/auth_service_get.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authServiceGet = Get.find<AuthServiceGet>();
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text('Received ${authServiceGet.isLoggedIn}')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Go back home"),
            ),
          ],
        ),
      ),
    );
  }
}
