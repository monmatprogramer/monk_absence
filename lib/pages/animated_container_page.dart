import 'package:flutter/material.dart';

class AnimatedContainerPage extends StatefulWidget {
  const AnimatedContainerPage({super.key});
  @override
  State<AnimatedContainerPage> createState() => _AnimatedContainerPage();
}

class _AnimatedContainerPage extends State<AnimatedContainerPage> {
  bool _isOn = false;
  bool big = false;
  bool start = false;
  bool rounded = false;
  bool expand = false;
  bool disable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedContainerPage: Color DEMO')),
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isOn = !_isOn;
                big = !big;
                start = !start;
                rounded = !rounded;
                expand = !expand;
                disable = !disable;
              });
            },
            child: AnimatedContainer(
              width: big ? 240 : 120,
              height: 160,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              constraints: BoxConstraints(
                minWidth: 80,
                minHeight: 60,
                maxWidth: expand ? 240 : 120,
                maxHeight: 120,
              ),
              transform: Matrix4.identity()
                ..scale(big ? 1.2 : 0.9)
                ..rotateZ(big ? 0.1 : -0.1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                color: _isOn ? Colors.teal : Colors.orange,
                borderRadius: BorderRadius.circular(rounded ? 28 : 6),
              ),
              clipBehavior: Clip.antiAlias,
              foregroundDecoration: BoxDecoration(
                color: disable
                    ? Colors.white.withValues(alpha: 0.6)
                    : Colors.transparent,
              ),
              alignment: start ? Alignment.topLeft : Alignment.bottomRight,
              child: Text(
                _isOn ? 'ON' : 'OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
