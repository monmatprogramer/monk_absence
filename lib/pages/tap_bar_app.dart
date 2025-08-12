import 'package:flutter/material.dart';

class TapBarApp extends StatelessWidget {
  const TapBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Screen A'),
          bottom: const TabBar(tabs: [
            Tab(text: 'Tab A'),
            Tab(text: 'Tab B'),
          ]),
        ),
        body: const TabBarView(children: [
          Center(child: Text('Content for Tab A')),
          Center(child: Text('Content for Tab B')),
        ]),
      ),
    );
  }
}