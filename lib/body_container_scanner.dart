import 'package:flutter/material.dart';
import 'package:presence_app/bcs.dart';

class BodyContainerScanner extends StatefulWidget {
  final Image? qrImageUrl;
  final String title;
  final String date;
  const BodyContainerScanner({
    super.key,
    required this.qrImageUrl,
    required this.title,
    required this.date,
  });

  @override
  State<BodyContainerScanner> createState() => _BodyContainerScannerState();
}

class _BodyContainerScannerState extends State<BodyContainerScanner> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Text
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text.rich(
                TextSpan(
                  text: 'This is',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: ' ${widget.title}',
                      style: TextStyle(color: Colors.amber),
                    ),
                    TextSpan(
                      text: ' scann code',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Text('Date: ${widget.date}'),
            const SizedBox(height: 30),
            Bcs(qrImageUrl: widget.qrImageUrl),
          ],
        ),
      ),
    );
  }
}
