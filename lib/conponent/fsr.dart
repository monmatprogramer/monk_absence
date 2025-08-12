import 'package:flutter/material.dart';

//Fsr = Frame of scanner
class Fsr extends StatelessWidget {
  const Fsr({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          //250
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blue, width: 4),
          ),
        ),
        Positioned(
          top: 25,
          child: Container(
            width: 260,
            height: 200,
            decoration: BoxDecoration(color: Colors.white),
          ),
        ),
        Positioned(
          right: 25,
          child: Container(
            width: 200,
            height: 260,
            decoration: BoxDecoration(color: Colors.white),
          ),
        ),
      ],
    );
    
  }
}
