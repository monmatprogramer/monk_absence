import 'package:flutter/material.dart';

Future<void> showSatusDialog({
  required BuildContext context,
  required String title,
  required String message,
  required IconData icon,
  required Color iconColor,
  VoidCallback? onPressed,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(message, textAlign: TextAlign.left),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: title.contains('Successful')
                  ? Colors.lightGreen
                  : Colors.red,
              child: Icon(icon, color: iconColor, size: 30),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                color: title.contains('Successful')
                    ? Colors.lightGreen
                    : Colors.red,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed ?? () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
