import 'dart:async';
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

  Future<void> _sendToServer(int userId, String qrContent) async {
    try {
      final baseUri = '${DbConfig.apiUrl}/api/qrcode/scan-qr';
      final response = await http
          .post(
            Uri.parse(baseUri),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'userId': userId, 'code': qrContent}),
          )
          .timeout(
            //duration
            const Duration(seconds: 10),
            //At the appoinnted minut
            onTimeout: () {
              throw TimeoutException(
                'Connection timeout - please check your internet connection',
                const Duration(seconds: 10),
              );
            },
          );

      await _handleServerResponse(response, userId);

      if (response.statusCode == 201) {
        _showMessage("Scanning...");
        await Future.delayed(const Duration(seconds: 3));
        _showMessage("Success to scan QR code");
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

  // Handle server response
  Future<void> _handleServerResponse(http.Response response, int userId) async {
    try {
      final Map<String, dynamic> responseData = jsonDecode(
        response.body,
      ); //respose body has data from server
      switch (response.statusCode) {
        case 200:
        case 201:
          await _handleSuccessfulScan(responseData, userId);
          break;
      }
    } catch (e) {}
  }

  Future<void> _handleSuccessfulScan(
    Map<String, dynamic> data,
    int userId,
  ) async {
    //set message to user
    final String message = data['message'] ?? "Attendance captured successfully"; 
    //close camera
    widget.scanCameraController.isScannedCompleted(true);
    //send to sverver
    try {
      await _sendToServer(userId, data);
    } catch (e) {}
  }

  // For testing message
  void _showMessage(String message) {
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
    if (widget.scanCameraController.isScannedCompleted.value) {
      return;
    }

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) {
      _showMessage("💥 The QR Code does not has anything!");
      return;
    }
    // Get the scanned text from the first barcode
    // It can be null so you can get empty text also
    final String? rawValue = barcodes.first.rawValue;
    if (rawValue == null) {
      _showMessage("💥QR code is empty or corrupted!");
      return;
    }

    if (rawValue.trim().isEmpty) {
      _showMessage('💥 QR code contains only whitespace!');
      return;
    }
    if (!_isValidQRCodeFormat(rawValue)) {
      _showMessage('💥 Invalid QR code format!');
      return;
    }

    await processValidQRCode(rawValue);
  }

  //helper method to validate QR code format
  bool _isValidQRCodeFormat(String qrContent) {
    const List<String> slots = ['AM', "PM"];
    for (String slot in slots) {
      if (!qrContent.contains(slot)) {
        return false;
      }
    }

    if (qrContent.length < 3 || qrContent.length > 500) {
      return false;
    }
    final List<String> suspiciousPatterns = ['<script', 'javascript:', 'data:'];
    for (String pattern in suspiciousPatterns) {
      if (qrContent.toLowerCase().contains(pattern)) {
        return false;
      }
    }
    return true;
  }

  Future<void> processValidQRCode(String qrContent) async {
    try {
      widget.scanCameraController.updateIsScannedCompleted(true);
      await _cameraHandling();
      await _sendToServer(widget.userId, qrContent);
    } catch (e) {
      widget.scanCameraController.updateIsScannedCompleted(false);
      _showMessage('💥 Error processing QR code: ${e.toString()}');
      debugPrint('🔥 in _processValidQRCode: $e');
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
