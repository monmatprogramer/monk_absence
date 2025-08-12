import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/controllers/profile_controller.dart';
import 'package:presence_app/controllers/segment_controller.dart';

class SegmentedControllApp extends StatelessWidget {
  SegmentedControllApp({super.key});
  final controller = Get.find<SegmentController>();
  var logger = Logger(printer: PrettyPrinter());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Screen A'), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 0,
              color: cs.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: cs.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Column(
                  children: [
                    Text(
                      'Switch View',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final selected = {controller.segmentIndex.value};
                      return SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(
                            value: 0,
                            label: Text('A1'),
                            icon: Icon(Icons.dashboard_customize_outlined),
                          ),
                          ButtonSegment(
                            value: 1,
                            label: Text('A2'),
                            icon: Icon(Icons.list_alt_outlined),
                          ),
                        ],
                        selected: selected,
                        showSelectedIcon: false,
                        
                        onSelectionChanged: (newSel) =>
                            controller.updateSegment(newSel.first),
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(999),
                            ),
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                          side: WidgetStateProperty.resolveWith((states) {
                            final c = Theme.of(context).colorScheme;
                            final isSelected = states.contains(
                              WidgetState.selected,
                            );
                            final isFocusHover =
                                states.contains(WidgetState.focused) ||
                                states.contains(WidgetState.hovered);
                            final baseColor = isSelected
                                ? c.primary
                                : c.outlineVariant;
                            final width = isFocusHover
                                ? (isSelected ? 2.6 : 2.0)
                                : (isSelected ? 1.8 : 1.0);
                            final theme = Theme.of(context).colorScheme;
                            final color = isFocusHover
                                ? baseColor.withValues(alpha:0.85)
                                : baseColor;
                            return BorderSide(
                             color: color, width: width
                            );
                          }),
                          visualDensity: VisualDensity.comfortable,
                          backgroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            final c = Theme.of(context).colorScheme;
                            if (states.contains(WidgetState.disabled)) {
                              return c.surface.withValues(alpha: 0.60);
                            }
                            if (states.contains(WidgetState.selected)) {
                              return c.primaryContainer;
                            }
                            return c.surfaceContainerHighest;
                          }),
                          foregroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            final c = Theme.of(context).colorScheme;
                            if (states.contains(WidgetState.disabled)) {
                              return c.onSurface.withValues(alpha: .38);
                            }
                            if (states.contains(WidgetState.selected)) {
                              return c.onPrimaryContainer;
                            }
                            return c.onSurfaceVariant;
                          }),
                          overlayColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            final c = Theme.of(context).colorScheme;
                            if (states.contains(WidgetState.pressed)) {
                              return c.primary.withValues(alpha: 0.18);
                            }
                            return null;
                          }),
                          animationDuration: const Duration(milliseconds: 180),
                          elevation: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.disabled))
                              return 0.0;
                            if (states.contains(WidgetState.pressed))
                              return 3.0;
                            if (states.contains(WidgetState.selected))
                              return 2.0;
                            if (states.contains(WidgetState.hovered) ||
                                states.contains(WidgetState.focused))
                              return 1.0;
                            return 0.0;
                          }),
                          shadowColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            final c = Theme.of(context).colorScheme;
                            final base = c.shadow;
                            return base.withValues(
                              alpha: states.contains(WidgetState.pressed)
                                  ? 0.40
                                  : 0.22,
                            );
                          }),
                          surfaceTintColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            final c = Theme.of(context).colorScheme;
                            return states.contains(WidgetState.selected)
                                ? c.primary
                                : c.surfaceTint;
                          }),
                          textStyle: WidgetStateProperty.resolveWith((states) {
                            final base = Theme.of(
                              context,
                            ).textTheme.labelLarge!;
                            final isSel = states.contains(WidgetState.selected);
                            return base.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                              fontSize:
                                  (base.fontSize ?? 14) + (isSel ? 0.5 : 0),
                            );
                          }),
                          iconSize: WidgetStateProperty.resolveWith((states) {
                            return states.contains(WidgetState.selected)
                                ? 20.0
                                : 18.0;
                          }),
                          splashFactory: InkSparkle.splashFactory,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => IndexedStack(
                  index: controller.segmentIndex.value,
                  children: [Text("A1"), Text("A2")],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
