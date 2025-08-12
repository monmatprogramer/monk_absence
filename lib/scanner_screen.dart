import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _cameraController;
  late BarcodeScanner _barcodeScanner;
  bool _isBusy = false;
  @override
  void initState() {
    _initialilzeCamera();
    _barcodeScanner = BarcodeScanner();
    super.initState();
  }

  //initialize camera
  Future<void> _initialilzeCamera() async {
    //1. find available camera
    final cameras = await availableCameras();
    //2. pick the back camera
    final back = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
    );
    //3. create a camera controller
    _cameraController = CameraController(
      back,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController!.initialize();

    //4. start image stream
    await _cameraController!.startImageStream(_processCameraImage);
    setState(() {});
  }

  //Called on every frame
  Future<void> _processCameraImage(CameraImage image) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      // Convert to ML Kit's InputImage
      final WriteBuffer allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(
          plane.bytes,
        ); // Put the bytes from the plane into the buffer.
      }
      final bytes = allBytes.done().buffer.asUint8List();
      final Size imageSize = Size(
        image.width.toDouble(),
        image.height.toDouble(),
      );
      final InputImageRotation rotation =
          _cameraController!.description.sensorOrientation == 90
          ? InputImageRotation.rotation90deg
          : _cameraController!.description.sensorOrientation == 270
          ? InputImageRotation.rotation270deg
          : InputImageRotation.rotation0deg;
      final InputImageFormat format = InputImageFormat.nv21;
      // final planeData = image.planes.map((plane) => InputImagePlaneMetadata());
      final bytesPerRow = image.planes[0].bytesPerRow;
      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: imageSize,
          rotation: rotation,
          format: format,
          bytesPerRow: bytesPerRow,
        ),
      );
      // run the detector
      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        final Barcode barcode = barcodes.first;
        if (barcode.type == BarcodeType.url) {
          final url = Uri.tryParse(barcode.rawValue!);
          if (url != null && await canLaunchUrl(url)) {
            debugPrint("➡️ url: $url");
            await launchUrl(url);
            await _cameraController?.startImageStream(_processCameraImage);
          }
        }
        debugPrint("➡️ barcodes: $barcode");
      }
    } catch (e) {
      debugPrint('💥 ML Kit error: $e');
    }
    _isBusy = false;
  }

  @override
  void dispose() {
    //1. Stop the cemera stream
    _cameraController?.stopImageStream();
    //2. Dispose the camera controller
    _cameraController?.dispose();
    //3. Close the ML Kit client to kill its background threads
    _barcodeScanner.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_cameraController!);
  }
}
