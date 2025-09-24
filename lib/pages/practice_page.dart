import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/controllers/practice_controller.dart';
import 'package:presence_app/pages/loading_states.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Register dependencies
    final PracticeController controller = Get.put(PracticeController());

    return Scaffold(
      appBar: AppBar(title: const Text('Pratice Page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                switch (controller.practiceData.value.states) {
                  case LoadingStates.loading:
                    return const CircularProgressIndicator();
                  case LoadingStates.success:
                    return Text("Success");
                  case LoadingStates.error:
                    return Text(controller.practiceData.value.errorMessage ?? "Error");
                  default:
                    return Text("Choose button bellow");
                }
              }),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => controller.fetchDataSuccessfully(),
                child: const Text('Fetch Data(Success)'),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => controller.fetchDataFailure(),
                child: const Text('Fetch Data (Failure)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
