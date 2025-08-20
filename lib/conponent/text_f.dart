import 'package:flutter/material.dart';

class TextF extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final IconData? suffixIcon;
  final bool isSee;
  final VoidCallback? seePassBtn;
  final TextEditingController? controller;
  final bool isSamllScreen;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;

  const TextF({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.isSamllScreen = false,
    this.suffixIcon,
    this.isSee = false,
    this.seePassBtn,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isSee,
        style: TextStyle(
          color: Colors.black87,
          fontSize: isSamllScreen ? 12 : 16,
        ),
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: isSamllScreen ? 12 : 16,
          ),
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon == null
              ? null
              : IconButton(
                  onPressed: seePassBtn,
                  icon: Icon(
                    isSee
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          focusColor: Colors.black,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: isSamllScreen ? 12 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        autofocus: focusNode == null ? false : true,
        onTap: () {},
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
