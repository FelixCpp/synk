import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/presentation/bloc/notification_bloc.dart';
import 'package:synk/feat_notifications/presentation/widgets/notification_toast.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const AppNotificationListener({
  super.key,
  required final NotificationService notifications,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<AppNotificationListener> createState() =>
      _AppNotificationListenerState();
}

class _AppNotificationListenerState extends State<AppNotificationListener> {
  final _toasts = <({int id, AppNotification notification})>[];
  var _nextToastId = 0;
  OverlayEntry? _toastEntry;

  @override
  void dispose() {
    _toastEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (context) => NotificationBloc(widget.notifications),
      child: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          final notification = state.notification;
          if (notification == null) return;

          switch (notification.severity) {
            case NotificationSeverity.critical:
              _showDialog(context, notification);
            case NotificationSeverity.error:
            case NotificationSeverity.success:
              _showToast(context, notification);
          }
        },
        child: widget.child,
      ),
    );
  }

  void _showToast(BuildContext context, AppNotification notification) {
    _toasts.add((id: _nextToastId++, notification: notification));

    final entry = _toastEntry;
    if (entry != null) {
      entry.markNeedsBuild();
      return;
    }

    final newEntry = OverlayEntry(builder: _buildToasts);
    _toastEntry = newEntry;
    Overlay.of(context).insert(newEntry);
  }

  void _dismissToast(int id) {
    _toasts.removeWhere((toast) => toast.id == id);

    if (_toasts.isEmpty) {
      _toastEntry?.remove();
      _toastEntry = null;
    } else {
      _toastEntry?.markNeedsBuild();
    }
  }

  Widget _buildToasts(BuildContext context) {
    return Positioned(
      right: SynkUiSpace.s16,
      bottom: SynkUiSpace.s16,
      child: SafeArea(
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .end,
          spacing: SynkUiSpace.s8,
          children: [
            for (final toast in _toasts)
              NotificationToast(
                key: ValueKey(toast.id),
                message: toast.notification.message,
                severity: toast.notification.severity,
                onDismissed: () => _dismissToast(toast.id),
              ),
          ],
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context, AppNotification notification) {
  showSynkUiDialog<void>(
    context: context,
    builder: (context) {
      return SynkUiDialog(
        icon: CupertinoIcons.exclamationmark_triangle,
        title: 'Fehler',
        message: notification.message,
        actions: [
          SynkUiButton(
            label: 'OK',
            onPressed: Navigator.of(context).pop,
          ),
        ],
      );
    },
  );
}
