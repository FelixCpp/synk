import 'package:device_viewer/feat_notifications/application/notification_service.dart';
import 'package:device_viewer/feat_notifications/domain/models/app_notification.dart';
import 'package:device_viewer/feat_notifications/presentation/bloc/notification_bloc.dart';
import 'package:device_viewer/feat_notifications/presentation/widgets/notification_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

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
              _showToast(context, notification);
          }
        },
        child: child,
      ),
    );
  }
}

void _showDialog(BuildContext context, AppNotification notification) {
  showMacosAlertDialog(
    context: context,
    builder: (context) {
      return MacosAlertDialog(
        appIcon: MacosIcon(
          CupertinoIcons.exclamationmark_triangle,
          size: 56,
          color: MacosDynamicColor.resolve(
            MacosColors.systemRedColor,
            context,
          ),
        ),
        title: const Text('Fehler'),
        message: Text(notification.message),
        primaryButton: PushButton(
          controlSize: .large,
          onPressed: Navigator.of(context).pop,
          child: const Text('OK'),
        ),
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
        onDismissed: () => entry.remove(),
      );
    },
  );

  overlay.insert(entry);
}
