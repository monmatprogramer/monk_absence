import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannedBarcodeLabel extends StatelessWidget {
  final Stream<BarcodeCapture> barcodes;
  const ScannedBarcodeLabel({super.key, required this.barcodes});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        return Text("Stream builder");
      },
    );
  }
}
