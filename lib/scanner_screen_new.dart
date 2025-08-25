import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:http/http.dart' as _httpClient;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:presence_app/auth_service.dart';
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

class _ScannerScreenNewState extends State<ScannerScreenNew>
    with WidgetsBindingObserver {
  final authService = Get.find<AuthService>();
  // Setup camera controller
  MobileScannerController? cameraController = MobileScannerController();
  bool isFlashOn = false;
  bool isFlashAvailable = false;
  bool _isProcessing = false;
  Timer? _debounceTimer;
  var logger = Logger(printer: PrettyPrinter());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameraController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: false,
      );

      //check flash
      await cameraController!.start();

      setState(() {
        isFlashAvailable = true;
      });
    } catch (e) {
      debugPrint('🔥 Camera initialization failed: $e');
      setState(() {
        isFlashAvailable = false;
      });
      _showMessage('📷 Camera initialization failed. Please restart the app.');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //check make sure camera is available before starting
    if (cameraController == null) {
      return;
    }

    switch (state) {
      case AppLifecycleState.paused: //App run in background
        cameraController!.stop();
        break;
      case AppLifecycleState.resumed:
        // allow camera to start
        if (!widget.scanCameraController.isScannedCompleted.value) {
          cameraController!.start();
        }
        break;
      case AppLifecycleState.detached:
        //Clean up camera resources
        _cleanup();
        break;
      default:
        break;
    }
  }

  //Handle clean up resources
  Future<void> _cleanup() async {
    try {
      _debounceTimer?.cancel(); //
      _debounceTimer = null;

      // Stop and dispose camera controller
      if (cameraController != null) {
        await cameraController!.stop();
        cameraController!.dispose();
        cameraController = null;
      }

      //close registration
      WidgetsBinding.instance.removeObserver(this);
    } catch (e) {
      // Handle cleanup errors
      debugPrint('🔥 Cleanup failed: $e');
    }
  }

  void _toggleFlash() {
    try {
      cameraController!.toggleTorch();
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

  // Future<void> _cameraHandling() async {
  //   if (widget.scanCameraController.isScannedCompleted.value == true) {
  //     await cameraController!.stop();
  //   } else {
  //     await cameraController!.start();
  //   }
  // }

  Future<void> _sendToServer(int userId, String qrContent) async {
    _showMessage('🔃 Processing QR code...');
    try {
      final String baseUri = '${DbConfig.apiUrl}/api/qrcode/scan-qr';
      final String tokenKey = await authService.getToken();
      final response = await _httpClient
          .post(
            Uri.parse(baseUri),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $tokenKey',
              'Accept': 'application/json',
              'Connection': 'Keep-Alive',
            },
            body: jsonEncode({
              'id': userId,
              'sessionId': 19,
              'qrCode': qrContent,
            }),
          )
          .timeout(
            //duration
            const Duration(seconds: 15),
            //At the appoinnted minut
            onTimeout: () {
              throw TimeoutException(
                'Connection timeout - please check your internet connection',
                const Duration(seconds: 15),
              );
            },
          );

      await _handleServerResponse(response, authService.userId.value);
    } on TimeoutException catch (e) {
      await _handleNetworkError(
        'Connection timeout',
        e.message ?? "Request timed out",
      );
    } on http.ClientException catch (e) {
      await _handleNetworkError(
        "Network error",
        "Connection failed: ${e.message}",
      );
    } on FormatException catch (e) {
      await _handleNetworkError(
        "Invalid QR code format",
        "The QR code you scanned does not contain valid data.",
      );
    } catch (e) {
      debugPrint('🔥 Error scanning QR code: $e');
    }
  }

  Future<bool> _onWillPop() async {
    if (_isProcessing) {
      _showMessage('⌛ Please wait for current scan to complete.');
      return false;
    }
    await _cleanup();
    return true;
  }

  void _onPopInvoked(bool didPop, dynamic result) {
    if (didPop) {
      _cleanup();
      return;
    }
    if (_isProcessing) {
      _showMessage('⌛ Please wait for current scan to complete.');
    }
  }

  // Handle server response
  Future<void> _handleServerResponse(
    _httpClient.Response response,
    int userId,
  ) async {
    try {
      final Map<String, dynamic> responseData = jsonDecode(
        response.body,
      ); //respose body has data from server
      switch (response.statusCode) {
        case 200:
        case 201:
          await _handleSuccessfulScan(responseData, userId);
          break;
        case 400:
          await _handleBadRequest(responseData);
          break;
        case 401:
          await _handleUnauthorized();
          break;
        case 404:
          await _handleNotFound(responseData);
          break;
        case 409:
          await _handleConflict(responseData);
          break;
        case 500:
        case 502:
        case 503:
          await _handleSeverError(responseData);
        default:
          await _handleUnknownError(response.statusCode, responseData);
      }
    } catch (e) {
      await _handleNetworkError(
        'Response parsing error',
        ' Failed to parse server response',
      );
    }
  }

  //Handle network error
  Future<void> _handleNetworkError(String title, String details) async {
    await _resetScanStateAndShowError('🌐 $title: $details');
  }

  //Handle unknow error
  Future<void> _handleUnknownError(
    int statusCode,
    Map<String, dynamic> data,
  ) async {
    final String message = data['message'] ?? "Unknown error occurred";
    await _resetScanStateAndShowError("❓ Error $statusCode: $message.");
  }

  //Handle Sever Error
  Future<void> _handleSeverError(Map<String, dynamic> data) async {
    await _resetScanStateAndShowError(
      '🛅 Server maintenance in progress. Please try again later.',
    );
  }

  //Handle conflict
  Future<void> _handleConflict(Map<String, dynamic> data) async {
    final String message =
        data['message'] ?? "Conflict occurred while scanning QR code";
    Get.dialog(
      AlertDialog(
        title: const Text('Attendance Status'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _resetScanState();
            },
            child: const Text('Scan Again'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offNamed(
                '/home',
                arguments: [widget.userId, widget.userRole],
              );
            },
            child: const Text('Go to Home'),
          ),
        ],
      ),
    );
  }

  //reset scan state
  void _resetScanState() async {
    widget.scanCameraController.updateIsScannedCompleted(false);
    //await _cameraHandling();
  }

  //Handle not found
  Future<void> _handleNotFound(Map<String, dynamic> data) async {
    final String message = data['message'] ?? "QR code not found";
    await _resetScanStateAndShowError('🔎 $message');
  }

  //Handle unauthorized
  Future<void> _handleUnauthorized() async {
    await _resetScanStateAndShowError('🔒 Session expired. Please login again');
    // Get.toNamed('/login');
  }

  //Handle bad request
  Future<void> _handleBadRequest(Map<String, dynamic> data) async {
    final String message = data['message'] ?? "Invalid QR code or request";
    await _resetScanStateAndShowError('❌ $message');
  }

  //reset and show error message
  Future<void> _resetScanStateAndShowError(String message) async {
    widget.scanCameraController.updateIsScannedCompleted(false);
    // await _cameraHandling();
    _showMessage(message);
  }

  //Stted date
  String formatDate(String isoDate) {
    try {
      final DateTime dateTime = DateTime.parse(isoDate);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return isoDate;
    }
  }

  Future<void> _handleSuccessfulScan(
    Map<String, dynamic> data,
    int userId,
  ) async {
    //set message to user
    final String message =
        data['message'] ?? "Attendance captured successfully";
    //create object data that retrieve from server
    final Map<String, dynamic>? attendanceData = data['data'] ?? {};

    String detailMessage = message;
    if (attendanceData != null) {
      final String? statusCode = attendanceData['status'] ?? "";
      final String? slot = attendanceData['slot'] ?? "";
      final String? attendanceDate = attendanceData['attendanceDate'] ?? "";

      if (statusCode != null && slot != null) {
        switch (statusCode.toUpperCase()) {
          case "LATE":
            detailMessage = 'Late arrrival recorded for $slot session';
            break;
          case "PRESENT":
            detailMessage = 'Present at $slot session on $attendanceDate';
            break;
          case "ABSENT":
            detailMessage = 'Absent from $slot session on $attendanceDate';
            break;
          case "EXCUSED":
            detailMessage = 'Excused from $slot session on $attendanceDate';
            break;
        }
        if (attendanceDate != null) {
          detailMessage = '\nDate: ${formatDate(attendanceDate)}';
        }
      }
    }

    _showMessage("✅ $detailMessage");

    widget.scanCameraController.updateIsScannedCompleted(true);

    await Future.delayed(const Duration(milliseconds: 1500));

    Get.toNamed('/home', arguments: [userId, widget.userRole]);
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
    _cleanup();
    super.dispose();
  }

  // This method is called when a QR code is detected
  Future<void> _onDetect(BarcodeCapture capture) async {
    //First of all is it false means can scan QR code
    if (_isProcessing || widget.scanCameraController.isScannedCompleted.value) {
      return;
    }

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) {
      _showMessage("💥 The QR Code does not has anything!");
      return;
    }
    // Get the scanned text from the first barcode
    // It can be null so you can get empty text also
    final String? rawValue = barcodes.first.rawValue; // QR019-AM-X5D
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
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _processQRCodewithValidation(rawValue);
    });
  }

  //helper method to validate QR code format
  bool _isValidQRCodeFormat(String qrContent) {
    //QR019-AM-X5D
    const List<String> slots = ['AM', "PM"];
    for (String slot in slots) {
      if (!qrContent.contains(slot)) {
        return false;
      }
      return true;
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

  Future<void> _processQRCodewithValidation(String qrContent) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });
    try {
      if (!_isValidQRCodeFormat(qrContent)) {
        _showMessage('💥 Invalid QR code format!');
        return;
      }
      widget.scanCameraController.updateIsScannedCompleted(true);
      // await _cameraHandling();
      await _pauseCamera();
      await _sendToServer(authService.userId.value, qrContent);
    } catch (e) {
      widget.scanCameraController.updateIsScannedCompleted(false);
      _showMessage('💥 Error processing QR code: ${e.toString()}');
      debugPrint('🔥 in _processValidQRCode: $e');
    }
  }

  Future<void> _pauseCamera() async {
    try {
      if (cameraController != null) {
        await cameraController!.stop();
      }
    } catch (e) {
      debugPrint('🔥 Error pausing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isProcessing,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            if (cameraController != null)
              MobileScanner(controller: cameraController, onDetect: _onDetect)
            else
              Center(child: CircularProgressIndicator(color: Colors.white)),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String token = await authService.getToken();
            _showMessageDialog(authService.userId.value.toString());
          },
          child: const Icon(Icons.computer),
        ),
      ),
    );
  }
}

void _showMessageDialog(String token) {
  Get.dialog(
    AlertDialog(
      title: const Text("Find token key"),
      content: Text("This scanner_screen_new token key: $token"),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Close")),
      ],
    ),
  );
}
