import 'dart:async';

import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk_ui/synk_ui.dart';
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

  bool get _isSuccess => widget.severity == NotificationSeverity.success;

  @override
  void initState() {
    super.initState();
    if (_isSuccess) {
      _timer = Timer(const Duration(seconds: 4), widget.onDismissed);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;

    return SynkUiToast(
      icon: _isSuccess
          ? CupertinoIcons.checkmark_circle
          : CupertinoIcons.exclamationmark_circle,
      message: widget.message,
      accent: _isSuccess ? colors.live : colors.error,
      dismissIcon: CupertinoIcons.clear,
      onDismiss: widget.onDismissed,
    );
  }
}
