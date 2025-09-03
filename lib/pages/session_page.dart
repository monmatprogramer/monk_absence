import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/conponent/session_body.dart';
import 'package:presence_app/conponent/session_header.dart';
import 'package:presence_app/controllers/session_controller.dart';
import 'package:presence_app/repositories/session_repository.dart';
import 'package:presence_app/services/api_service.dart';

class SessionPage extends StatelessWidget {
  SessionPage({super.key});
  final SessionController sessionController = Get.find<SessionController>();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await sessionController.refreshSessions();
            final result = sessionController.searchSession("sdfgfg");
            Get.snackbar(
              'success',
              'Got ${result != null ? result.length : "not found"} sessions',
            );
            // apiService.dispose();
          } catch (e) {
            Get.snackbar('Error', "Failed to get sessions: $e");
          }
        },
        child: Icon(Icons.settings),
      ),
    );
  }
}
