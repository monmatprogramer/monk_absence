import 'package:flutter/material.dart';
import 'package:presence_app/conponent/app_containts.dart';
import 'package:presence_app/conponent/text_f.dart';
import 'package:get/get.dart';
import 'package:presence_app/controllers/update_pwd_controller.dart';

class UpdatePageBodyForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final FocusNode currentPasswordFocusNode;
  const UpdatePageBodyForm({
    super.key,
    required this.formKey,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.currentPasswordFocusNode,
  });

  @override
  State<UpdatePageBodyForm> createState() => _UpdatePageBodyFormState();
}

class _UpdatePageBodyFormState extends State<UpdatePageBodyForm> {
  final controller = Get.put(UpdatePwdController());
  final _newPwdFocusNode = FocusNode();
  final _confirmPwdFocusNode = FocusNode();
  //Fix
  late final ScreenSizeInfo screenSizeInfo;
  late final bool isSamllScreen;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.currentPasswordFocusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSizeInfo = AppContaints.getScreenSize(context);
    isSamllScreen = screenSizeInfo.isSmallScreen;
  }

  @override
  void dispose() {
    clearForm();
    _newPwdFocusNode.dispose();
    super.dispose();
  }

  void clearForm() {
    widget.confirmPasswordController.clear();
    widget.newPasswordController.clear();
    widget.currentPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    // final screenWidth = screenSize.width;
    // final screenHeight = screenSize.height;
    // bool isSamllScreen = screenWidth < 600;
    // bool isMediumScreen = screenWidth >= 600 && screenWidth < 1200;
    // bool isLargeScreen = screenWidth >= 1200;
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextF(
            controller: widget.currentPasswordController,
            hintText: "Current Password",
            isSee: !_isCurrentPasswordVisible,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            suffixIcon: _isCurrentPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            seePassBtn: () {
              setState(() {
                _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
              });
            },
            icon: Icons.lock,
            isSamllScreen: isSamllScreen,
            // onChanged: (String? value) {
            //   if (value == null) {
            //     controller.updateOldPwd('');
            //   } else {
            //     controller.updateOldPwd(value);
            //   }
            //   return value = null;
            // },
            focusNode: widget.currentPasswordFocusNode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your current password';
              }
              // clearFeilds();
              // if (controller.oldPwd.value.isEmpty)
              //   return 'Please enter your current password';
              // controller.updateOldPwd(_currentPasswordController.text);
              return null;
            },
          ),

          const SizedBox(height: 16),
          TextF(
            controller: widget.newPasswordController,
            hintText: "New Password",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            isSamllScreen: isSamllScreen,
            icon: Icons.lock,
            suffixIcon: _isNewPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            isSee: !_isNewPasswordVisible,
            seePassBtn: () {
              setState(() {
                _isNewPasswordVisible = !_isNewPasswordVisible;
              });
            },
            // onChanged: (String? value) {
            //   if (value == null) {
            //     controller.updateNewPwd('');
            //   } else {
            //     controller.updateNewPwd(value);
            //   }
            // },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a new password';
              }
              if (value.length < 2) {
                return 'Password must be at least 6 characters';
              }
              // if (controller.newPwd.value.isEmpty)
              //   return 'Please enter a new password';
              // controller.updateNewPwd(_newPasswordController.text);

              return null;
            },
          ),
          const SizedBox(height: 16),
          TextF(
            controller: widget.confirmPasswordController,
            hintText: "Confirm New Password",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            isSamllScreen: isSamllScreen,
            focusNode: _confirmPwdFocusNode,
            icon: Icons.lock,
            suffixIcon: _isConfirmPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            isSee: !_isConfirmPasswordVisible,
            seePassBtn: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your new password';
              }
              if (value != widget.newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
