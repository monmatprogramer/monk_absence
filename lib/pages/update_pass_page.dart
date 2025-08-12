import 'package:flutter/material.dart';
import 'package:presence_app/conponent/app_containts.dart';
import 'package:presence_app/conponent/update_page_body.dart';
import 'package:presence_app/conponent/update_pass_header.dart';

class UpdatePassPage extends StatelessWidget {
  UpdatePassPage({super.key});
  // Create a global key here for pass it to its child
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode currentPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Password"), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppContaints.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const UpdatePassHeader(),
              const SizedBox(height: 20),
              UpdatePageBody(
                formKey: _formKey,
                currentPasswordController: currentPasswordController,
                newPasswordController: newPasswordController,
                confirmPasswordController: confirmPasswordController,
                currentPasswordFocusNode: currentPasswordFocusNode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
