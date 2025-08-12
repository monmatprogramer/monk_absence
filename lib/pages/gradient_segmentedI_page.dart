import 'package:flutter/material.dart';
import 'package:presence_app/gradient_segmented.dart';

class GradientSegmentediPage extends StatelessWidget {
  const GradientSegmentediPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientSegmentedI(
          segments: [
            GradientSegmented(
              value: 0,
              label: "A1",
              icon: Icons.dashboard_customize,
            ),
            GradientSegmented(value: 0, label: "A1", icon: Icons.settings),
          ],
          selected: {1},
          onChanged: (value) {
            print(value);
          },
        ),
      ),
    );
  }
}
