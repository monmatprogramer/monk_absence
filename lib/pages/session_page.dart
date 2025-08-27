import 'package:flutter/material.dart';
import 'package:presence_app/conponent/session_header.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(child: Column(children: [SessionHeader()])),
    );
  }
}
