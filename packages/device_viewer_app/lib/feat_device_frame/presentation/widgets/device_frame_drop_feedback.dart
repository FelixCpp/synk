import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class const DeviceFrameDropFeedback({
  super.key,
  required final bool isDragHovered,
  required final bool isProcessing,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        child,
        IgnorePointer(
          child: AnimatedSwitcher(
            duration: DeviceViewerTheme.actionRevealDuration,
            child: switch ((isProcessing, isDragHovered)) {
              (true, _) => const _BusyOverlay(key: ValueKey('busy')),
              (false, true) => const _DragOverlay(key: ValueKey('drag')),
              (false, false) => const SizedBox.shrink(key: ValueKey('none')),
            },
          ),
        ),
      ],
    );
  }
}

class const _DragOverlay({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: context.colors.focusRing.withAlpha(36)),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          spacing: DeviceViewerTheme.verticalComponentSpacingMedium,
          children: [
            MacosIcon(
              CupertinoIcons.tray_arrow_down_fill,
              size: 32.0,
              color: context.colors.focusRing,
            ),
            Text(
              'Datei hier ablegen',
              style: context.typo.caption1.copyWith(
                color: context.colors.focusRing,
                fontWeight: .w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _BusyOverlay({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: MacosColors.black.withAlpha(150)),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          spacing: DeviceViewerTheme.verticalComponentSpacingMedium,
          children: [
            const ProgressCircle(radius: 9.0),
            Text(
              'Wird übertragen…',
              style: context.typo.caption1.copyWith(
                color: MacosColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
