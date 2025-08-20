import 'package:flutter/material.dart';
import 'package:presence_app/conponent/app_containts.dart';

class Btn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Color? bgColor;
  final Color txtColor;
  const Btn({
    super.key,
    required this.onPressed,
    required this.title,
    required this.bgColor,
    this.txtColor = Colors.black,
  });
  double findScreenWidth(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    double y = 0.0;
    y = x + 110;
    return y - x;
  }

  double findScreenHeight(BuildContext context) {
    double x = MediaQuery.of(context).size.height;
    double y = 0.0;
    y = x + 50;
    return y - x;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: findScreenWidth(context),
      height: findScreenHeight(context),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: AppContaints.getScreenSize(context).isSmallScreen
                ? 14
                : 20,
            color: txtColor,
          ),
        ),
      ),
    );
  }
}
