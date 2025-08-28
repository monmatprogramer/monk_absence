import 'package:flutter/material.dart';
import 'package:presence_app/conponent/session_body.dart';
import 'package:presence_app/conponent/session_header.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SafeArea(
        child: Column(
          children: [
            SessionHeader(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: const Divider(),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SessionBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
