import 'dart:async';

import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class const NotificationToast({
  super.key,
  required final String message,
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
    return Positioned(
      right: DeviceViewerTheme.horizontalPagePadding,
      bottom: DeviceViewerTheme.verticalPagePadding,
      child: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Container(
            padding: DeviceViewerTheme.cardPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                DeviceViewerTheme.cornerRadius,
              ),
              color: MacosDynamicColor.resolve(
                MacosColors.controlBackgroundColor,
                context,
              ),
              boxShadow: [
                BoxShadow(
                  color: MacosColors.black.withAlpha(60),
                  blurRadius: 12.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              spacing: DeviceViewerTheme.horizontalComponentSpacingMedium,
              mainAxisSize: MainAxisSize.min,
              children: [
                MacosIcon(
                  CupertinoIcons.exclamationmark_circle,
                  color: MacosDynamicColor.resolve(
                    MacosColors.systemRedColor,
                    context,
                  ),
                ),
                Flexible(
                  child: Text(widget.message, style: context.typo.body),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
