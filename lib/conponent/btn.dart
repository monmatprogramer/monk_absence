import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Color? bgColor;
  final Color txtColor ;
  const Btn({
    super.key,
    required this.onPressed,
    required this.title,
    required this.bgColor,
    this.txtColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 40,
      child: ElevatedButton(
        
        style: ElevatedButton.styleFrom(
          
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(title, style: TextStyle(color: txtColor)),
      ),
    );
  }
}
