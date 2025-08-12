import 'package:flutter/material.dart';

class AccessRestrictedPage extends StatelessWidget {
  const AccessRestrictedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(child: Placeholder()),
    );
  }
}
