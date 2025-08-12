
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _index = 0;

  late final AnimationController _indicator = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );

  @override
  void dispose() {
    _indicator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final spacing = 12.0;

    // App scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Segmented Control', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'More',
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a view',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Text(
              'Modern segmented control with smooth transitions, proper contrast, and semantic labels for accessibility.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8)),
            ),
            const SizedBox(height: 16),
            _SegmentedControl(
              index: _index,
              onChanged: (v) {
                setState(() => _index = v);
                _indicator.forward(from: 0);
                // Haptic feedback hint (subtle)
                Feedback.forTap(context);
              },
              items: const [
                _SegmentItem(icon: Icons.dashboard_outlined, label: 'Overview'),
                _SegmentItem(icon: Icons.list_alt_outlined, label: 'Tasks'),
                _SegmentItem(icon: Icons.insights_outlined, label: 'Reports'),
              ],
            ),
            const SizedBox(height: 16),

            // Content area with animated switch & elevation surface
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cs.surfaceVariant.withOpacity(0.35),
                        cs.surface.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      // Subtle combined fade + slide
                      final slide = Tween<Offset>(
                        begin: const Offset(0.03, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(position: slide, child: child),
                      );
                    },
                    child: _buildTabBody(_index, key: ValueKey(_index)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Primary action row (example micro-interactions)
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Primary Action'),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    label: const Text('Secondary'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBody(int index, {Key? key}) {
    switch (index) {
      case 0:
        return _OverviewPanel(key: key);
      case 1:
        return _TasksPanel(key: key);
      case 2:
        return _ReportsPanel(key: key);
      default:
        return SizedBox(key: key);
    }
  }
}

class _SegmentItem {
  final IconData icon;
  final String label;
  const _SegmentItem({required this.icon, required this.label});
}

/// A custom, accessible segmented control with an animated thumb and proper states.
class _SegmentedControl extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<_SegmentItem> items;

  const _SegmentedControl({
    required this.index,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: 'Segmented control',
      hint: 'Swipe or tap to change section',
      toggled: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final itemWidth = (width / items.length).clamp(80.0, 240.0);

          return Container(
            decoration: ShapeDecoration(
              color: isDark ? cs.surfaceVariant.withOpacity(0.3) : cs.surfaceVariant.withOpacity(0.6),
              shape: StadiumBorder(side: BorderSide(color: cs.outlineVariant)),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Animated thumb / indicator
                AnimatedAlign(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment(-1.0 + (2.0 * index / (items.length - 1)), 0),
                  child: Container(
                    width: itemWidth,
                    height: 46,
                    margin: const EdgeInsets.all(4),
                    decoration: ShapeDecoration(
                      color: cs.primaryContainer,
                      shape: const StadiumBorder(),
                      shadows: [
                        BoxShadow(
                          color: cs.primary.withOpacity(0.24),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),

                // Segments
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      Expanded(
                        child: _SegmentButton(
                          item: items[i],
                          selected: index == i,
                          onTap: () => onChanged(i),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final _SegmentItem item;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelLarge!;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      onTapHint: 'Select ${item.label}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 54,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              style: labelStyle.copyWith(
                color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: selected ? 20 : 19,
                    color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(item.label),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Example Tab Bodies -------------------------------------------------------

class _OverviewPanel extends StatelessWidget {
  const _OverviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'High-level metrics and recent activity. Use cards to group information and guide attention.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.85)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.only(bottom: 8),
              crossAxisCount: MediaQuery.of(context).size.width > 720 ? 3 : 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _MetricCard(
                  title: 'Active Users',
                  value: '1,248',
                  trendLabel: '+4.2%',
                  icon: Icons.people_alt_outlined,
                  color: cs.primary,
                ),
                _MetricCard(
                  title: 'Conversions',
                  value: '312',
                  trendLabel: '+2.1%',
                  icon: Icons.shopping_cart_outlined,
                  color: cs.tertiary,
                ),
                _MetricCard(
                  title: 'Bounce Rate',
                  value: '38%',
                  trendLabel: '-1.3%',
                  icon: Icons.trending_down,
                  color: cs.error,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TasksPanel extends StatelessWidget {
  const _TasksPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      key: const PageStorageKey('tasks'),
      padding: const EdgeInsets.all(16),
      children: [
        Text('Tasks', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Keep forms clean, use clear affordances, and provide inline validation.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Task title',
                    helperText: 'Keep it short and actionable',
                    prefixIcon: const Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  minLines: 2,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    helperText: 'Optional details to clarify the task',
                    prefixIcon: const Icon(Icons.notes),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          prefixIcon: Icon(Icons.flag_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'low', child: Text('Low')),
                          DropdownMenuItem(value: 'medium', child: Text('Medium')),
                          DropdownMenuItem(value: 'high', child: Text('High')),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Assignee',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'you', child: Text('You')),
                          DropdownMenuItem(value: 'team', child: Text('Team')),
                          DropdownMenuItem(value: 'auto', child: Text('Auto assign')),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_task),
                    label: const Text('Create Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Recently Added', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...List.generate(6, (i) => _TaskTile(index: i + 1, color: cs.primary)),
      ],
    );
  }
}

class _ReportsPanel extends StatelessWidget {
  const _ReportsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reports', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Charts and summaries belong here. Use clear legends and meaningful axis labels.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 720),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.area_chart, size: 48, color: cs.primary),
                    const SizedBox(height: 12),
                    Text(
                      'Integrate your chart library of choice (e.g., charts_flutter) here.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tip: Keep your charts accessible with color-safe palettes and text alternatives.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Small components ---------------------------------------------------------

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String trendLabel;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.trendLabel,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 20, color: color),
                  ),
                  const Spacer(),
                  Text(
                    trendLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: cs.secondary),
                  ),
                ],
              ),
              const Spacer(),
              Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8))),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final int index;
  final Color color;
  const _TaskTile({required this.index, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.checklist, color: color),
        ),
        title: Text('Task #$index'),
        subtitle: const Text('Tap to view details or edit'),
        trailing: Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
