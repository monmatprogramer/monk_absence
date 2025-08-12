import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:presence_app/conponent/btn.dart';
import 'package:presence_app/conponent/show_app_message.dart';
import 'package:presence_app/conponent/show_status_dialog.dart';
import 'package:presence_app/conponent/text_f.dart';
import 'package:presence_app/auth_service.dart';

class SubLoginUserPage extends StatefulWidget {
  const SubLoginUserPage({super.key});

  @override
  State<SubLoginUserPage> createState() => _SubLoginUserPageState();
}

class _SubLoginUserPageState extends State<SubLoginUserPage> {
  bool isSee = false;
  late final String token, role;
  final authServer = Get.find<AuthService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withAlpha(90),
            blurRadius: 10,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          //Center here
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextF(
              controller: _usernameController,
              hintText: "Username",
              icon: Icons.person,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                //validation

                if (value == null || value.isEmpty) {
                  return "Username is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextF(
              controller: _passwordController,
              hintText: "Password",
              icon: Icons.lock,
              suffixIcon: Icons.remove_red_eye_outlined,
              isSee: isSee,
              seePassBtn: () {
                setState(() {
                  isSee = !isSee;
                });
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            //Row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Btn(
                  title: "Close",
                  onPressed: () {
                    showSatusDialog(
                      context: context,
                      title: "Close Login Form",
                      message: "Do you want to close this form?",
                      icon: Icons.close,
                      iconColor: Colors.white,
                      onPressed: () {
                        SystemChannels.platform.invokeMethod(
                          'SystemNavigator.pop',
                        );
                      },
                    );
                  },

                  bgColor: Colors.red[200],
                ),
                const SizedBox(width: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : Btn(
                        title: "Login",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await authServer.login(
                              _usernameController.text,
                              _passwordController.text,
                            );
                            if (authServer.userData['success'] == true) {
                              Get.offAllNamed(
                                "/home",
                                arguments: [
                                  authServer.userId.value,
                                  authServer.userData['role'],
                                ],
                              );
                            } else {
                              showAppMessage(
                                messageType: MessageType.error,
                                buttonLabel: "Close",
                                message: authServer.userData['message'],
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        bgColor: Colors.blue,
                        txtColor: Colors.white,
                      ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
