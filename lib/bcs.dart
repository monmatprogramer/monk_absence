import 'package:flutter/material.dart';
import 'package:presence_app/conponent/fsr.dart';

class Bcs extends StatelessWidget {
  final Image? qrImageUrl;
  const Bcs({super.key, required this.qrImageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Fsr(), //Frame of scanner
        Positioned(
          top: 25,
          left: 25,
          child: SizedBox(width: 200, height: 200, child: qrImageUrl),
        ),
      ],
    );
  }
}
