import 'package:flutter/material.dart';
import 'package:presence_app/conponent/app_containts.dart';

class UpdatePassHeader extends StatelessWidget {
  const UpdatePassHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenInfo = AppContaints.getScreenSize(context);

    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'images/change_pass.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 48,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenInfo.isSmallScreen ? double.infinity : AppContaints.maxTextWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppContaints.defaultPadding,
            ),
            child: const Text(
              "Change your password to keep your account secure. This is especially important for first-time users.",
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
