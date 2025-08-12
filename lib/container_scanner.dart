import 'package:flutter/material.dart';

class ContainerScanner extends StatelessWidget {
  final String image;
  final VoidCallback onTapFun;
  final String label;
  final double w = 100;
  final double h = 100;
  final bool isPressed;

  const ContainerScanner({
    super.key,
    required this.image,
    required this.onTapFun,
    required this.isPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Image
        SizedBox(
          width: w,
          height: h,
          child: Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: onTapFun,
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.blueGrey;
                }
                return null;
              }),
              child: AnimatedScale(
                scale: isPressed ? 0.9 : 1.0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                child: Image.asset('images/$image'),
              ),
            ),
          ),
        ),
        Text(label),

        //Text
      ],
    );
  }
}
