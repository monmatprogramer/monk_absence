import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:presence_app/controllers/scan_camera_controller.dart';
import 'package:presence_app/db_config.dart';

class ScannerScreenNew extends StatefulWidget {
  final int userId;
  final String userRole;
  final scanCameraController = Get.find<ScanCameraController>();
  ScannerScreenNew({super.key, required this.userId, required this.userRole});

  @override
  State<ScannerScreenNew> createState() => _ScannerScreenNewState();
}

class _ScannerScreenNewState extends State<ScannerScreenNew> {
  // Setup camera controller
  MobileScannerController cameraController = MobileScannerController();
  bool isFlashOn = false;
  bool isFlashAvailable = false;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
    isFlashAvailable = true;
  }

  void _toggleFlash() {
    try {
      cameraController.toggleTorch();
      setState(() {
        isFlashOn = !isFlashOn;
      });
    } catch (e) {
      // Handle case where torch is not available
      if (mounted) {
        setState(() {
          isFlashAvailable = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flash not available on this device')),
        );
      }
    }
  }

  Future<void> _cameraHandling() async {
    if (widget.scanCameraController.isScannedCompleted.value == true) {
      await cameraController.stop();
    } else {
      await cameraController.start();
    }
  }

  Future<void> _sendToServer(int userId, String encodedCode) async {
    try {
      final baseUri = '${DbConfig.apiUrl}/api/qrcode/log-attendance';
      final response = await http.post(
        Uri.parse(baseUri),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'code': encodedCode}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showTestMessage("Scanning...");
        await Future.delayed(const Duration(seconds: 3));
        _showTestMessage("Success to scan QR code");
        widget.scanCameraController.updateIsScannedCompleted(true);
        Get.toNamed('/home', arguments: [userId, widget.userRole]);
      } else {
        await _cameraHandling();
        Get.dialog<String>(
          AlertDialog(
            title: const Text("Confirm action"),
            content: Text("${data['message']}"),
            actions: [
              ElevatedButton(
                onPressed: () =>
                    Get.offNamed('/home', arguments: [userId, widget.userRole]),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('🔥 Error scanning QR code: $e');
    }
  }

  // For testing message
  void _showTestMessage(String message) {
    Get.snackbar(
      "Scan status",
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.black87,
      backgroundColor: Colors.grey[100],
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.info_outline, color: Colors.blue),
      duration: Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('OK', style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  void closeScan() {
    widget.scanCameraController.updateIsScannedCompleted(true);
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  // This method is called when a QR code is detected
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!widget.scanCameraController.isScannedCompleted.value) {
      final List<Barcode> barcodes = capture.barcodes;
      if (barcodes.isNotEmpty) {
        // Get the scanned text from the first barcode
        // It can be null so you can get empty text also
        final String? rawValue = barcodes.first.rawValue;
        if (rawValue == null ||
            widget.scanCameraController.isScannedCompleted.value == true) {
          _showTestMessage(
            "💥The QR Code does not has anything or you have scanned!",
          );
          return;
        }
        String encodedCode = base64.encode(utf8.encode(rawValue));
        widget.scanCameraController.updateIsScannedCompleted(true);
        // await cameraController.stop();
        await _cameraHandling();
        await _sendToServer(widget.userId, encodedCode);
      } else {
        _showTestMessage("💥The QR Code does not has anything!");
        widget.scanCameraController.updateIsScannedCompleted(false);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: cameraController, onDetect: _onDetect),

          Positioned(
            top: 2,
            right: 2,
            child: isFlashAvailable
                ? CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 153, 138, 138),
                    child: IconButton(
                      onPressed: _toggleFlash,
                      icon: Icon(
                        isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      ),
                      tooltip: isFlashOn ? 'Flash Off' : 'Flash On',
                    ),
                  )
                : CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
