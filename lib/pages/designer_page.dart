import 'package:flutter/material.dart';
import 'package:presence_app/pages/morning_list_page.dart';
import 'package:presence_app/pages/segmented_controll_app.dart';
import 'package:presence_app/pages/tap_bar_app.dart';

class DesignerPage extends StatelessWidget {
  const DesignerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SegmentedControllApp();
  }
}
