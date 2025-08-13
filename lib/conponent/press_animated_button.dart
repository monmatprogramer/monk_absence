import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PressAnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool enabled;
  final bool glow;
  const PressAnimatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.enabled = true,
    this.glow = true,
  });

  @override
  State<PressAnimatedButton> createState() => _PressAnimatedButtonState();
}

class _PressAnimatedButtonState extends State<PressAnimatedButton> {
  bool _pressed = false;
  bool _hovering = false;
  var logger = Logger(printer: PrettyPrinter());
  bool get _isEnabled => widget.enabled;
  void _setPressed(bool v) {
    if (!_isEnabled) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final targetScale = !_isEnabled
        ? 1.0
        : _pressed
        ? 0.96
        : (_hovering ? 1.03 : 1.0);
    final glowOpacity = (!_isEnabled || !widget.glow)
        ? 0.0
        : _hovering
        ? 0.35
        : (_pressed ? 0.20 : 0.0);
    final glowBlur = glowOpacity == 0
        ? 0.0
        : _hovering
        ? 24.0
        : (_pressed ? 12.0 : 0.0);
    final child = widget.icon == null
        ? Text(widget.label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18),
              const SizedBox(width: 8),
              Text(widget.label),
            ],
          );
    final button = ElevatedButton(
      onPressed: _isEnabled ? widget.onPressed : null,
      child: child,
    );
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Listener(
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: targetScale),
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (widget.glow)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,

                  width: null,
                  height: null,
                  decoration: glowBlur == 0
                      ? const BoxDecoration()
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: glowBlur,
                              spreadRadius: 1,
                              color: scheme.primary.withValues(
                                alpha: glowOpacity,
                              ),
                            ),
                          ],
                        ),
                ),
              button,
            ],
          ),
        ),
      ),
    );
  }
}
