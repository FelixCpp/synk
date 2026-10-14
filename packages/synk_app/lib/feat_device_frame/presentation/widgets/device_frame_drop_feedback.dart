import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';

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
            duration: SynkUiMotion.reveal,
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
    final theme = context.synkUi;

    return ColoredBox(
      color: theme.colors.soft(theme.colors.accent),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          spacing: SynkUiSpace.s8,
          children: [
            Icon(
              CupertinoIcons.tray_arrow_down_fill,
              size: 32.0,
              color: theme.colors.accent,
            ),
            Text(
              'Datei hier ablegen',
              style: theme.typography.label.copyWith(
                color: theme.colors.accent,
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
    const foreground = Color(0xFFFFFFFF);

    return ColoredBox(
      color: const Color(0x99000000),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          spacing: SynkUiSpace.s8,
          children: [
            const SynkUiSpinner(size: 18.0, color: foreground),
            Text(
              'Wird übertragen…',
              style: context.synkUi.typography.label.copyWith(
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
