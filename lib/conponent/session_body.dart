import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/models/sessions_model.dart';

var logger = Logger(printer: PrettyPrinter());

final List<Session> sessions = [
  const Session(
    id: 1,
    title: "Title",
    sessionCode: 'cs0001',
    startAt: '2023-10-01 10:00:00.000',
    endAt: '2023-10-01 11:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: true,
  ),
  const Session(
    id: 2,
    title: "Title 2",
    sessionCode: 'cs0002',
    startAt: '2023-10-01 12:00:00.000',
    endAt: '2023-10-01 13:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: false,
  ),
  const Session(
    id: 3,
    title: "Title 3",
    sessionCode: 'cs0003',
    startAt: '2023-10-01 14:00:00.000',
    endAt: '2023-10-01 15:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: true,
  ),
  const Session(
    id: 4,
    title: "Title 4",
    sessionCode: 'cs0004',
    startAt: '2023-10-01 16:00:00.000',
    endAt: '2023-10-01 17:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: false,
  ),
  const Session(
    id: 5,
    title: "Title 5",
    sessionCode: 'cs0005',
    startAt: '2023-10-01 18:00:00.000',
    endAt: '2023-10-01 19:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: true,
  ),
  const Session(
    id: 6,
    title: "Title 6",
    sessionCode: 'cs0006',
    startAt: '2023-10-01 20:00:00.000',
    endAt: '2023-10-01 21:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: false,
  ),
  const Session(
    id: 7,
    title: "Title 7",
    sessionCode: 'cs0007',
    startAt: '2023-10-01 22:00:00.000',
    endAt: '2023-10-01 23:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: true,
  ),
  //insert 100 lists
  const Session(
    id: 8,
    title: "Title 8",
    sessionCode: 'cs0008',
    startAt: '2023-10-02 10:00:00.000',
    endAt: '2023-10-02 11:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: false,
  ),
  const Session(
    id: 9,
    title: "Title 9",
    sessionCode: 'cs0009',
    startAt: '2023-10-02 12:00:00.000',
    endAt: '2023-10-02 13:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: true,
  ),
  const Session(
    id: 10,
    title: "Title 10",
    sessionCode: 'cs0010',
    startAt: '2023-10-02 14:00:00.000',
    endAt: '2023-10-02 15:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: false,
  ),
  const Session(
    id: 11,
    title: "Title 11",
    sessionCode: 'cs0011',
    startAt: '2023-10-02 16:00:00.000',
    endAt: '2023-10-02 17:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: true,
  ),
  const Session(
    id: 12,
    title: "Title 12",
    sessionCode: 'cs0012',
    startAt: '2023-10-02 18:00:00.000',
    endAt: '2023-10-02 19:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: false,
  ),
  const Session(
    id: 13,
    title: "Title 13",
    sessionCode: 'cs0013',
    startAt: '2023-10-02 20:00:00.000',
    endAt: '2023-10-02 21:30:00.000',
    createdAt: '2023-09-30 10:00:00.000',
    isActive: true,
  ),
];

class SessionBody extends StatelessWidget {
  const SessionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    //list view builder
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final isActive = session.isActive == true;
        return _SessionListItemCus(session: session);
      },
    );
  }
}

//Session explainded widget using custom widget
class _SessionListItemCus extends StatefulWidget {
  final Session session;
  const _SessionListItemCus({required this.session});
  @override
  _SessionListItemCusState createState() => _SessionListItemCusState();
}

class _SessionListItemCusState extends State<_SessionListItemCus>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _iconTurns;
  late final Animation<double> _heightFactor;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _iconTurns = Tween<double>(
      begin: 0.0,
      end: 0.125,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final bgColor = Theme.of(context).colorScheme.surface;
    final subBgColor = Theme.of(context).colorScheme.onSurface;
    final activateColor = widget.session.isActive ? Colors.green : Colors.red;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      child: Column(
        children: [
          ListTile(
            onTap: _handleTap,
            title: Text(
              widget.session.title,
              style: txtTheme.headlineSmall?.copyWith(
                fontSize: 14,
                color: subBgColor,
              ),
            ),
            subtitle: Text(
              widget.session.sessionCode,
              style: txtTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: subBgColor.withOpacity(0.5),
              ),
            ),
            trailing: RotationTransition(
              turns: _iconTurns,
              child: Icon(Icons.add_circle, color: activateColor),
            ),
          ),
          ClipRect(
            child: SizeTransition(
              sizeFactor: _heightFactor,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(
                      left: 32,
                      right: 16,
                      bottom: 8,
                    ),
                    title: Text(
                      widget.session.sessionCode,
                      style: txtTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'Starts: ${widget.session.startAt}\nEnds: ${widget.session.endAt}',
                      style: txtTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Session Expanded widget using ExpansionTile
class _SessionListItem extends StatefulWidget {
  final Session session;
  const _SessionListItem({required this.session});

  @override
  State<_SessionListItem> createState() => _SessionListItemState();
}

class _SessionListItemState extends State<_SessionListItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    //Animate from 0 (0 degree) to 0.125(45 degree)
    _animation = Tween<double>(
      begin: 0.0,
      end: 0.125,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final activateColor = widget.session.isActive ? Colors.green : Colors.red;
    return ExpansionTile(
      shape: const Border(), //remove border around the expansion tile
      collapsedShape: const Border(), //remove border around the expansion tile
      backgroundColor: colorScheme.primary.withOpacity(0.05),
      collapsedBackgroundColor: Colors.transparent,
      leading: Icon(Icons.circle, color: activateColor),
      title: Text(
        widget.session.title,
        style: txtTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: RotationTransition(
        turns: _animation,
        child: Icon(Icons.add_circle, color: activateColor),
      ),
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });
        if (expanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      children: <Widget>[
        ListTile(
          contentPadding: const EdgeInsets.only(left: 32, right: 16, bottom: 8),
          title: Text(
            widget.session.sessionCode,
            style: txtTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Starts: ${widget.session.startAt}\nEnds: ${widget.session.endAt}',
            style: txtTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
