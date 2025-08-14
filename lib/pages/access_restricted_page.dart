import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:presence_app/conponent/press_animated_button.dart';

class AccessRestrictedPage extends StatelessWidget {
  AccessRestrictedPage({super.key});
  var logger = Logger(printer: PrettyPrinter());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  child: Image.asset(
                    'images/access_restricted.png',
                    height: 400,
                    width: 400,
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Acess Restricted",
                  style: TextStyle(fontSize: 24, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                const Text(
                  "This is for admin only",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                //Create custom elevated Button style
                PressAnimatedButton(
                  label: "Goto HomePage",
                  onPressed: () {
                    Get.toNamed('/home');
                    logger.d("Preseed");
                  },
                  icon: Icons.home,
                  glow: false,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
