import 'package:flutter/material.dart';
import 'package:presence_app/conponent/app_containts.dart';

class SessionHeader extends StatelessWidget {
  const SessionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: AppContaints.getScreenSize(context).isSmallScreen ? 150 : 300,
        decoration: BoxDecoration(
          color: Color(0XFF6A2FF2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 2, color: Colors.white),
            ),
            child: Row(
              children: [
                //image
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'images/spv.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Wat Sampove meas",
                        style: AppContaints.getScreenSize(context).isSmallScreen
                            ? textTheme.headlineSmall?.copyWith(fontSize: 18)
                            : textTheme.headlineSmall?.copyWith(fontSize: 24),
                      ),
                      SizedBox(height: 5),
                      Text("Session manangement", style: textTheme.bodySmall),
                    ],
                  ),
                ),
                //title
              ],
            ),
          ),
        ),
      ),
    );
  }
}
