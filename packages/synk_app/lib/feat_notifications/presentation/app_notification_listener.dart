import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/presentation/bloc/notification_bloc.dart';
import 'package:synk/feat_notifications/presentation/widgets/notification_toast.dart';
import 'package:bench_ui/bench_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const AppNotificationListener({
  super.key,
  required final NotificationService notifications,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (context) => NotificationBloc(notifications),
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
        child: child,
      ),
    );
  }
}

void _showDialog(BuildContext context, AppNotification notification) {
  showBenchDialog<void>(
    context: context,
    builder: (context) {
      return BenchDialog(
        icon: CupertinoIcons.exclamationmark_triangle,
        title: 'Fehler',
        message: notification.message,
        actions: [
          BenchButton(
            label: 'OK',
            onPressed: Navigator.of(context).pop,
          ),
        ],
      );
    },
  );
}

void _showToast(BuildContext context, AppNotification notification) {
  final overlay = Overlay.of(context);
  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return NotificationToast(
        message: notification.message,
        severity: notification.severity,
        onDismissed: () => entry.remove(),
      );
    },
  );

  overlay.insert(entry);
}
