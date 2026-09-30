import 'dart:async';

import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/feat_notifications/domain/models/app_notification.dart';
import 'package:bench_ui/bench_ui.dart';
import 'package:flutter/cupertino.dart';

class const NotificationToast({
  super.key,
  required final String message,
  required final NotificationSeverity severity,
  required final VoidCallback onDismissed,
}) extends StatefulWidget {
  @override
  State<NotificationToast> createState() => _NotificationToastState();
}

class _NotificationToastState extends State<NotificationToast> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 4), widget.onDismissed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.severity == NotificationSeverity.success;
    final colors = context.benchTheme.colors;

    return Positioned(
      right: BenchSpace.s16,
      bottom: BenchSpace.s16,
      child: SafeArea(
        child: BenchToast(
          icon: isSuccess
              ? CupertinoIcons.checkmark_circle
              : CupertinoIcons.exclamationmark_circle,
          message: widget.message,
          accent: isSuccess ? colors.live : colors.error,
          dismissIcon: CupertinoIcons.clear,
          onDismiss: widget.onDismissed,
        ),
      ),
    );
  }
}
