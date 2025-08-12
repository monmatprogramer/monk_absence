import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccessRestrictedPage extends StatelessWidget {
  const AccessRestrictedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shadowColor: Colors.blueAccent.withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Get.toNamed('/home'),
                child: Text("🏠 Goto Home Page"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
