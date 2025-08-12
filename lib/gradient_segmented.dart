import 'package:flutter/material.dart';

class GradientSegmented<T> {
  final T value;
  final String label;
  final IconData? icon;

  const GradientSegmented({
    required this.value,
    required this.label,
    this.icon,
  });
}

class GradientSegmentedI<T> extends StatelessWidget {
  final List<GradientSegmented<T>> segments;
  final Set<T> selected;
  final ValueChanged<T> onChanged;
  final EdgeInsetsGeometry padding;
  final double height;
  final double gap;
  const GradientSegmentedI({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.height = 44,
    this.gap = 8,
    this.padding = const EdgeInsets.all(6),
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(999);
    return Material(
      color: c.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: c.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < segments.length; i++) ...[
              _SegmentChipt(
                segment: segments[i],
                isSelected: selected.contains(segments[i].value),
                onTap: () => onChanged(segments[i].value),
                height: height,
              ),
              if (i != segments.length - 1) SizedBox(width: gap),
            ],
          ],
        ),
      ),
    );
  }
}

class _SegmentChipt<T> extends StatelessWidget {
  final GradientSegmented<T> segment;
  final bool isSelected;
  final VoidCallback onTap;
  final double height;
  const _SegmentChipt({
    required this.segment,
    required this.isSelected,
    required this.onTap,
    required this.height,
  });
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final fgSelected = c.surface;
    final fgUnSelected = c.onSurfaceVariant;
    final radius = BorderRadius.circular(999);
    final selectedGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
        colors:[
          c.primaryContainer,
          Color.alphaBlend(c.primary.withValues(alpha: 0.16), c.primaryContainer),
        ] 
      );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: isSelected ? selectedGradient : null,
        border: Border.all(
          color: isSelected ? c.primary : c.outlineVariant,
          width: isSelected ? 1.6 : 1.0,
        ),
        boxShadow: isSelected?[
          BoxShadow(
            color: c.shadow.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ]:null,
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: radius),
        onTap: onTap,
        splashFactory: InkSparkle.splashFactory,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (segment.icon != null) ...[
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  segment.icon,
                  size: isSelected ? 20 : 18,
                  color: isSelected ? fgSelected : fgUnSelected,
                ),
              ),
              const SizedBox(width: 8),
            ],
            AnimatedDefaultTextStyle(
              child: Text(segment.label),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
                color: isSelected ? fgSelected : fgUnSelected,
                fontSize:
                    (Theme.of(context).textTheme.labelLarge!.fontSize ?? 14) +
                    (isSelected ? 0.5 : 0),
              ),
              duration: const Duration(milliseconds: 180),
            ),
          ],
        ),
      ),
    );
  }
}
