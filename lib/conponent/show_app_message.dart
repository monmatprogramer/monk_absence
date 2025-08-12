import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MessageType { success, error, info, warning }

void showAppMessage({
  required MessageType messageType,
  required String? buttonLabel,
  required String message,
}) {
  Color bgColor;
  IconData icon;
  switch (messageType) {
    case MessageType.success:
      bgColor = Colors.green.shade600;
      icon = Icons.check_circle_outline;
      break;
    case MessageType.error:
      bgColor = Colors.red.shade700;
      icon = Icons.error_outline;
      break;
    case MessageType.info:
      bgColor = Colors.blue.shade600;
      icon = Icons.info_outline;
      break;
    case MessageType.warning:
      bgColor = Colors.yellow.shade600;
      icon = Icons.warning_amber_outlined;
      break;
  }
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.TOP,
    backgroundColor: bgColor,
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    borderRadius: 12,
    animationDuration: const Duration(milliseconds: 400),
    forwardAnimationCurve: Curves.easeOutBack,
    duration: const Duration(seconds: 4),
    overlayBlur: 0,
    titleText: Row(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "Title",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (true)
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              buttonLabel!,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
      ],
    ),
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    ),
    backgroundGradient: LinearGradient(
      colors: [bgColor.withValues(alpha: 1), bgColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
