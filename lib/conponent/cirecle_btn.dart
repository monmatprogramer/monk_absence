import 'package:flutter/material.dart';

class CirecleBtn extends StatefulWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const CirecleBtn({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<CirecleBtn> createState() => _CirecleBtnState();
}

class _CirecleBtnState extends State<CirecleBtn> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      // margin: const EdgeInsets.only(left: 50),
      child: Column(
        children: <Widget>[
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            onTap: () {
              widget.onTap();
              setState(() {
                isPressed = !isPressed;
              });
              debugPrint("👉 Click: ${widget.label}");
            },
            child: AnimatedScale(
              scale: isPressed ? .9 : .9,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Center(
                  child: Image.asset(
                    widget.icon,
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(),
          Text(widget.label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
