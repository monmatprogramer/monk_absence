import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PressAnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  const PressAnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<PressAnimatedButton> createState() => _PressAnimatedButtonState();
}

class _PressAnimatedButtonState extends State<PressAnimatedButton> {
  bool _pressed = false;
  bool _hovering = false;
  var logger = Logger(printer: PrettyPrinter());
  void _setPressed(bool v) {
    if (widget.onPressed == null) return;
    setState(() {
      _pressed = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final targetScale = _pressed ? 0.96 : (_hovering ? 1.03 : 1.0);
    return MouseRegion(
      onEnter: (_) => setState(()=>  _hovering=true),
      onExit: (_) => setState(() => _hovering=false),
      child: Listener(
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: targetScale),
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: ElevatedButton(
            onPressed: () {
              widget.onPressed!();
              _setPressed(true);
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
