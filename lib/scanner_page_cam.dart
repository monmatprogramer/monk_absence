import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';
import 'package:presence_app/scanned_barcode_label.dart';

class ScannerPageCam extends StatefulWidget {
  const ScannerPageCam({super.key});

  @override
  State<ScannerPageCam> createState() => _ScannerPageCamState();
}

class _ScannerPageCamState extends State<ScannerPageCam> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController? controller;
  //Camera
  bool useScanWindow = !kIsWeb;
  //Resultion of camera
  Size desiredCameraResolution = const Size(1920, 1080);
  // Detection
  DetectionSpeed detectionSpeed =
      DetectionSpeed.normal; //change from unrestricted to normal
  // Duration of dection
  int detectionTimeoutMs = 250; //100 -> 250
  //Image
  bool returnImage = true; //false -> true
  //Invert image
  bool invertImage = false;
  //Auto zoom
  bool autoZoom = false;
  //Format
  List<BarcodeFormat> selectedFormats = [];
  //hide rebuild
  bool hideMobileScannerWidget = false;
  //Box
  BoxFit boxFit = BoxFit.contain;
  //barcode overlay
  bool useBarcodeOverlay = true;
  //Captured image
  Uint8List? _barcodeImage;
  //to prevent multiple scan
  bool _isScanComplete = false;
  //Initial mobile controller
  MobileScannerController initController() => MobileScannerController(
    autoStart: false,
    cameraResolution: desiredCameraResolution,
    detectionSpeed: detectionSpeed,
    detectionTimeoutMs: detectionTimeoutMs,
    formats: selectedFormats,
    returnImage: returnImage,
    invertImage: invertImage,
    autoZoom: autoZoom,
  );

  @override
  void initState() {
    super.initState();
    //Init mobile controller
    controller = initController();
    unawaited(controller!.start());
  }

  Future<void> _handleBarcode(String code) async {
    //it return "future"
    await controller?.stop(); //Stop scanning
    //Launch URL
    final Uri? uri = Uri.tryParse(code);
    //canLaunchUrl is mean that the uri is valid
    if (uri != null && await canLaunchUrl(uri)) {
      try {
        await launchUrl(uri); //Open URL
        if (mounted) {
          //mounted is mean that the widget is still alive
          Navigator.of(
            context,
          ).pop(); //after open uri page, it will close scanner page
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    } else {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Scan Result'),
            content: SelectableText(code),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
      //restart to scan
      _restartScanner();
    }
  }

  void _restartScanner() {
    if (mounted) {
      setState(() {
        _isScanComplete = false;
      });
      unawaited(controller?.start());
    }
  }

  @override
  Widget build(BuildContext context) {
    //custom rect
    late final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -100)),
      width: 300,
      height: 200,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Advanced Mobile Scanner',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: Colors.black,
      // body: controller == null || hideMobileScannerWidget
      //     ? const Placeholder()
      //     : const Placeholder(),
      body: Stack(
        children: [
          //Scanner controller
          MobileScanner(
            //draw rectangle region for focusing scanning
            scanWindow: useScanWindow ? scanWindow : null,
            controller: controller,
            onDetect: (capture) async {
              //if scanned complete, it will do not scanning again
              if (_isScanComplete) return;
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                //Get value from QR code
                final String? code = barcodes.first.rawValue;
                //code = www.google.com
                if (code != null) {
                  setState(() {
                    _isScanComplete = true;
                  });
                  await _handleBarcode(code);
                }
              }
              //return image of QR code on the screen
              if (returnImage &&
                  capture.image != null &&
                  capture.barcodes.isNotEmpty) {
                final fullImage = img.decodeImage(capture.image!);
                if (fullImage == null) {
                  return;
                }
                final barcode = capture.barcodes.first;
                final corners = barcode.corners;
                if (corners.isEmpty) return;

                // Calculate bounding box from corners
                final minX = corners
                    .map((c) => c.dx)
                    .reduce((a, b) => a < b ? a : b);
                final maxX = corners
                    .map((c) => c.dx)
                    .reduce((a, b) => a > b ? a : b);
                final minY = corners
                    .map((c) => c.dy)
                    .reduce((a, b) => a < b ? a : b);
                final maxY = corners
                    .map((c) => c.dy)
                    .reduce((a, b) => a > b ? a : b);

                final croppedImage = img.copyCrop(
                  fullImage,
                  x: minX.toInt(),
                  y: minY.toInt(),
                  width: (maxX - minX).toInt(),
                  height: (maxY - minY).toInt(),
                );
                final croppedBytes = img.encodePng(croppedImage);

                setState(() {
                  _barcodeImage = Uint8List.fromList(croppedBytes);
                });
              }
            },
            errorBuilder: (context, error) {
              return Center(child: Text("🔥Error:${error.toString()}"));
            },
            fit: boxFit,
          ),
          //Overlay
          if (useBarcodeOverlay)
            BarcodeOverlay(boxFit: boxFit, controller: controller!),
          //detect barcode
          if (useScanWindow)
            ScanWindowOverlay(controller: controller!, scanWindow: scanWindow),

          if (returnImage && _barcodeImage != null)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.memory(_barcodeImage!, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 200,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ScannedBarcodeLabel(barcodes: controller!.barcodes),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
