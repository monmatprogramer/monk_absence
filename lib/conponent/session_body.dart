import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/controllers/session_controller.dart';
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
    //Get the controller instance
    final SessionController controller = Get.find<SessionController>();
    //list view builder
    return Obx(() {
      // Shows loading when request data from API
      if (controller.isLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading sessions...'),
            ],
          ),
        );
      }
      // Show error message
      if (controller.hasError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              Text(
                controller.errorMessage.value,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: controller.refreshSessions,
                icon: Icon(Icons.refresh),
                label: Text("Try again"),
              ),
            ],
          ),
        );
      }
      if (controller.sessions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_note, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "No session found",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              Text(
                'Pull down to refresh',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: controller.refreshSessions,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.sessions.length,
          itemBuilder: (context, index) {
            final session = controller.sessions[index];
            return _SessionListItem(session: session);
          },
        ),
      );
    });
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

class _SessionListItemState extends State<_SessionListItem> with SingleTickerProviderStateMixin {

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
    final theme = Theme.of(context);
    final txtTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final activateColor = widget.session.isActive ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.session.isActive
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.session.isActive
                    ? Icons.play_circle_filled
                    : Icons.pause_circle_filled,
                color: widget.session.isActive ? Colors.green : Colors.grey,
                size: 28,
              ),
            ),
            title: Text(
              widget.session.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Code ${widget.session.sessionCode}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(_formatTimeRange(), style: theme.textTheme.bodySmall),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.session.isActive
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.session.isActive ? 'Active' : 'Inactive',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: widget.session.isActive
                          ? Colors.green
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Session ID',
                    widget.session.id.toString(),
                    Icons.tag,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Start Time',
                    _formatDateTime(widget.session.startAt),
                    Icons.play_arrow,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'End Time',
                    _formatDateTime(widget.session.endAt),
                    Icons.stop,
                  ),
                  _buildDetailRow(
                    'Created',
                    _formatDateTime(widget.session.createdAt),
                    Icons.calendar_today,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showSessionDetails();
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text(
                            'View Details',
                            style: TextStyle(fontSize: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.session.isActive
                              ? () {
                                  _joinSession();
                                }
                              : null,
                          icon: const Icon(Icons.login),
                          label: const Text(
                            'Join Session',
                            style: TextStyle(fontSize: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }

  void _showSessionDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.session.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session Code: ${widget.session.sessionCode}'),
            const SizedBox(height: 8),
            Text('Status: ${widget.session.isActive ? 'Active' : 'Inactive'}'),
            const SizedBox(height: 8),
            Text('Start: ${_formatDateTime(widget.session.startAt)}'),
            const SizedBox(height: 8),
            Text('End: ${_formatDateTime(widget.session.endAt)}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _joinSession() {
    Get.snackbar(
      'Session',
      'Joining session ${widget.session.sessionCode}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTimeString)}';
    } catch (e) {
      return dateTimeString;
    }
  }

  String _formatTimeRange() {
    final startTime = _formatTime(widget.session.startAt);
    final endTime = _formatTime(widget.session.endAt);
    return '$startTime - $endTime';
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return dateTimeString;
    }
  }
}
