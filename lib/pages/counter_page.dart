import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/controllers/conter_controller.dart';

class CounterPage extends StatelessWidget {
  // Inject the controller
  final CounterController controller = Get.put(CounterController());
  CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reactive Counter")),
      body: Center(
        child: Obx(() {
          return Text(
            'Counter: ${controller.count}',
            style: const TextStyle(fontSize: 20),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
