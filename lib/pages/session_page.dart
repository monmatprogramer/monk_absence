import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/conponent/session_body.dart';
import 'package:presence_app/conponent/session_header.dart';
import 'package:presence_app/controllers/session_controller.dart';

class SessionPage extends StatelessWidget {
  SessionPage({super.key});
  final SessionController sessionController = Get.find<SessionController>();
  @override
  Widget build(BuildContext context) {
    final SessionController controller = Get.find<SessionController>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('Session'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchDialog(context, controller);
            },
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              _handleFilterSelection(value, controller);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Sessions')),
              const PopupMenuItem(value: 'active', child: Text('Active only')),
              const PopupMenuItem(
                value: 'inactive',
                child: Text('Inactive only'),
              ),
            ],
            child: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: controller.refreshSessions,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SessionBody(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/scanner');
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }

  void _handleFilterSelection(String filter, SessionController controller) {
    switch (filter) {
      case 'active':
        Get.snackbar(
          'Filter',
          'Showing active session only',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 'inactive':
        Get.snackbar(
          'Filter',
          "Showing inactive sessions only",
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 'all':
      default:
        Get.snackbar(
          "Filter",
          'Showing all sessions',
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }

  void _showSearchDialog(BuildContext context, SessionController controller) {
    showDialog(
      context: context,
      builder: (builder) => AlertDialog(
        title: const Text('Search Sessions'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter session title or code...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (query) {
            final result = controller.searchSession(query);
          },
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(onPressed: () => Get.back(), child: const Text('Search')),
        ],
      ),
    );
  }
}
