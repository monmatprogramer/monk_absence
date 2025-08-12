import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/conponent/fsr.dart';
import 'package:presence_app/controllers/scan_camera_controller.dart';
import 'package:presence_app/scanner_screen_new.dart';

/// Sqrcc = scanner qr code container
/// - Container for qr code scanner
/// - It includes a placeholder of camera to scann the qr code
class ScanCodeContainer extends StatelessWidget {
  ScanCodeContainer({super.key});
  final scanCameraController = Get.find<ScanCameraController>();
  final int userId = Get.arguments[0];
  final String userRole = Get.arguments[1];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
                // Title
                Container(
                  width: 300,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Title
                          Text(
                            "Scan QR Code",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          //SubTitle
                          Text(
                            " simply dummy text of the printing and typesetting industry.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                // Camera scan
                Stack(
                  children: <Widget>[
                    Fsr(), //Frame of scanner
                    Positioned(
                      top: 25,
                      left: 25,
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: ScannerScreenNew(
                          userId: userId,
                          userRole: userRole,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                //Button for scanning press
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      scanCameraController.updateIsScannedCompleted(false);
                    },
                    child: const Text(
                      "Scann",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
