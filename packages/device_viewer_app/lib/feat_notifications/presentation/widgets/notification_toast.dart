import 'dart:async';

import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_notifications/domain/models/app_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

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
    final icon = isSuccess
        ? CupertinoIcons.checkmark_circle
        : CupertinoIcons.exclamationmark_circle;
    final color = isSuccess ? context.colors.success : context.colors.error;

    return Positioned(
      right: DeviceViewerTheme.horizontalPagePadding,
      bottom: DeviceViewerTheme.verticalPagePadding,
      child: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                DeviceViewerTheme.cornerRadius,
              ),
              color: context.colors.card,
              border: Border.all(
                color: context.colors.divider,
                width: DeviceViewerTheme.hairlineThickness,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colors.shadow,
                  blurRadius: 12.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: DeviceViewerTheme.cardPadding,
              child: Row(
                spacing: DeviceViewerTheme.horizontalComponentSpacingMedium,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MacosIcon(icon, color: color),
                  Flexible(
                    child: Text(widget.message, style: context.typo.body),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
