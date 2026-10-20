import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/domain/models/notification_entry.dart';
import 'package:synk/feat_notifications/domain/notification_policy.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';

class const NotificationCard({
  super.key,
  required final NotificationEntry entry,
  required final bool isLeaving,
  required final VoidCallback onDismissed,
  required final VoidCallback onLeft,
}) extends StatefulWidget {
  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: SynkUiMotion.move,
    reverseDuration: SynkUiMotion.state,
  );

  late final _reveal = CurvedAnimation(
    parent: _controller,
    curve: SynkUiMotion.emphasized,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void didUpdateWidget(NotificationCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLeaving == oldWidget.isLeaving) {
      return;
    }

    if (widget.isLeaving) {
      _controller.reverse().then((_) {
        if (mounted && widget.isLeaving) {
          widget.onLeft();
        }
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _reveal.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _reveal,
      alignment: Alignment.topRight,
      child: FadeTransition(
        opacity: _reveal,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(_reveal),
          child: Padding(
            padding: const EdgeInsets.only(bottom: SynkUiSpace.s8),
            child: _Toast(entry: widget.entry, onDismiss: widget.onDismissed),
          ),
        ),
      ),
    );
  }
}

class const _Toast({
  required final NotificationEntry entry,
  required final VoidCallback onDismiss,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timeLeft = entry.timeLeft;

    if (timeLeft == null) {
      return _toastWith(context, null);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(end: timeLeft),
      duration: NotificationPolicy.tick,
      curve: Curves.linear,
      builder: (context, value, _) => _toastWith(context, value),
    );
  }

  Widget _toastWith(BuildContext context, double? progress) {
    final colors = context.synkUi.colors;
    final severity = entry.notification.severity;

    return SynkUiToast(
      icon: _iconFor(severity),
      message: entry.notification.message,
      accent: _accentFor(severity, colors),
      count: entry.count,
      progress: progress,
      dismissIcon: CupertinoIcons.clear,
      onDismiss: onDismiss,
    );
  }
}

IconData _iconFor(NotificationSeverity severity) {
  return switch (severity) {
    .success => CupertinoIcons.checkmark_circle,
    .warning => CupertinoIcons.exclamationmark_triangle,
    .error => CupertinoIcons.exclamationmark_circle,
  };
}

Color _accentFor(NotificationSeverity severity, SynkUiColors colors) {
  return switch (severity) {
    .success => colors.live,
    .warning => colors.warn,
    .error => colors.error,
  };
}
