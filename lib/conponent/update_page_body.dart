import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/services/auth_service.dart';
import 'package:presence_app/conponent/app_containts.dart';
import 'package:presence_app/conponent/update_page_body_form.dart';
import 'package:presence_app/controllers/update_pwd_controller.dart';

class UpdatePageBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final FocusNode currentPasswordFocusNode;
  UpdatePageBody({
    super.key,
    required this.formKey,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.currentPasswordFocusNode,
  });
  final authService = Get.find<AuthService>();
  final controller = Get.put(UpdatePwdController());

  @override
  Widget build(BuildContext context) {
    final screenSizeInfo = AppContaints.getScreenSize(context);
    final screenWidth = screenSizeInfo.width;
    bool isSamllScreen = screenSizeInfo.isSmallScreen;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04, //24
        vertical: screenSizeInfo.isSmallScreen ? 16 : 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Form
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isSamllScreen ? double.infinity : 400,
            ),
            child: UpdatePageBodyForm(
              formKey: formKey,
              currentPasswordController: currentPasswordController,
              newPasswordController: newPasswordController,
              confirmPasswordController: confirmPasswordController,
              currentPasswordFocusNode: currentPasswordFocusNode,
            ),
          ),
          SizedBox(height: isSamllScreen ? 20 : 32),
          // Update Button
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isSamllScreen ? double.infinity : 400,
            ),
            child: SizedBox(
              width: double.infinity,
              height: _getButtonHeight(context),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isSamllScreen ? 8 : 12),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // String oldPwd = controller.oldPwd.value;
                    // String newPwd = controller.newPwd.value;
                    String oldPwd = currentPasswordController.text.trim();
                    String newPwd = newPasswordController.text.trim();

                    await authService.updatePassword(oldPwd, newPwd);
                    currentPasswordFocusNode.requestFocus();
                    controller.clearPassword();
                    _showTestMessage('${authService.messageUpdatePassword}');
                    formKey.currentState?.reset();
                    currentPasswordController.clear();
                    newPasswordController.clear();
                    confirmPasswordController.clear();
                    if (authService.isSuccessfullUpdatePassword.value == true) {
                      authService.logout();
                      Get.toNamed("/login");
                    }
                  }
                },
                child: Obx(() {
                  final txtStyle = TextStyle(
                    fontSize: isSamllScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                  );
                  if (authService.isLoading.value == true) {
                    return Text("Updating...", style: txtStyle);
                  }
                  return Text("Update", style: txtStyle);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getButtonHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 600) return 48;
    if (screenHeight < 800) return 56;
    return 64;
  }

  // For testing message
  void _showTestMessage(String message) {
    Get.snackbar(
      "Update status",
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.black87,
      backgroundColor: Colors.grey[100],
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.info_outline, color: Colors.blue),
      duration: Duration(seconds: 3),
      mainButton: TextButton(
        onPressed: () {
          authService.isSuccessfullUpdatePassword.value = false;
          Get.back();
        },
        child: const Text('OK', style: TextStyle(color: Colors.blue)),
      ),
    );
  }
}
