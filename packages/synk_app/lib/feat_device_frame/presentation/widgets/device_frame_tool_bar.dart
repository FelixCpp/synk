import 'package:synk/design/build_context.dart';
import 'package:synk/design/theme/synk_theme.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';

class const DeviceFrameToolBar({
  super.key,
  required final DeviceId deviceId,
  required final String modelName,
  required final bool isLive,
  required final bool isMaximized,
  required final bool isRecording,
  required final bool supportsInteraction,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleRecording,
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onInstallApk,
  required final VoidCallback onShareFile,
  required final VoidCallback onClose,
  required final VoidCallback onStandby,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.card,
        border: .symmetric(
          horizontal: BorderSide(
            color: context.colors.divider,
            width: SynkTheme.hairlineThickness,
          ),
        ),
      ),
      child: Padding(
        padding: SynkTheme.deviceFrameToolBarPadding,
        child: Row(
          spacing: SynkTheme.horizontalComponentSpacingSmall,
          children: [
            _StatusDot(isLive: isLive),
            Expanded(
              child: BenchTooltip(
                message: deviceId,
                child: Align(
                  alignment: .centerLeft,
                  child: Text(
                    modelName,
                    style: context.typo.headline,
                    overflow: .ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            _Actions(
              isMaximized: isMaximized,
              isRecording: isRecording,
              supportsInteraction: supportsInteraction,
              onCaptureScreenshot: onCaptureScreenshot,
              onToggleRecording: onToggleRecording,
              onToggleMaximize: onToggleMaximize,
              onClose: onClose,
              onInstallApk: onInstallApk,
              onShareFile: onShareFile,
              onStandby: onStandby,
            ),
          ],
        ),
      ),
    );
  }
}

class const _Actions({
  required final bool isMaximized,
  required final bool isRecording,
  required final bool supportsInteraction,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleRecording,
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onClose,
  required final VoidCallback onInstallApk,
  required final VoidCallback onShareFile,
  required final VoidCallback onStandby,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BenchTooltip(
          message: isRecording ? 'Aufnahme beenden' : 'Aufnahme starten',
          child: BenchIconButton(
            icon: isRecording
                ? CupertinoIcons.stop_fill
                : CupertinoIcons.video_camera,
            color: isRecording ? context.colors.error : null,
            onPressed: onToggleRecording,
          ),
        ),
        BenchTooltip(
          message: 'Screenshot aufnehmen',
          child: BenchIconButton(
            icon: CupertinoIcons.camera,
            onPressed: onCaptureScreenshot,
          ),
        ),
        BenchTooltip(
          message: isMaximized ? 'Vollbild verlassen' : 'Gerät maximieren',
          child: BenchIconButton(
            icon: isMaximized
                ? CupertinoIcons.arrow_down_right_arrow_up_left
                : CupertinoIcons.arrow_up_left_arrow_down_right,
            onPressed: onToggleMaximize,
          ),
        ),
        if (supportsInteraction)
          _OverflowButton(
            onInstallApk: onInstallApk,
            onShareFile: onShareFile,
            onStandby: onStandby,
          ),
        BenchTooltip(
          message: 'Spiegelung beenden',
          child: BenchIconButton(
            icon: CupertinoIcons.clear,
            onPressed: onClose,
          ),
        ),
      ],
    );
  }
}

class const _OverflowButton({
  required final VoidCallback onInstallApk,
  required final VoidCallback onShareFile,
  required final VoidCallback onStandby,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BenchMenu(
      width: 190.0,
      itemsBuilder: (context, controller) => [
        BenchTooltip(
          message: 'APK auf dem Gerät installieren',
          child: BenchMenuItem(
            icon: CupertinoIcons.arrow_down_to_line,
            label: 'APK Installieren',
            onPressed: () {
              controller.close();
              onInstallApk();
            },
          ),
        ),
        BenchTooltip(
          message: 'Datei auf das Gerät übertragen',
          child: BenchMenuItem(
            icon: CupertinoIcons.share,
            label: 'Datei senden',
            onPressed: () {
              controller.close();
              onShareFile();
            },
          ),
        ),
        BenchTooltip(
          message: 'Gerät An-/Ausschalten',
          child: BenchMenuItem(
            icon: CupertinoIcons.power,
            label: 'Standby',
            onPressed: () {
              controller.close();
              onStandby();
            },
          ),
        ),
      ],
      triggerBuilder: (context, controller) => BenchTooltip(
        message: 'Mehr',
        child: BenchIconButton(
          icon: CupertinoIcons.ellipsis_vertical,
          onPressed: () =>
              controller.isOpen ? controller.close() : controller.open(),
        ),
      ),
    );
  }
}

class const _StatusDot({required final bool isLive}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = isLive
        ? context.colors.deviceConnected
        : context.colors.deviceDisconnected;

    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: .circle,
          color: color,
          boxShadow: [
            BoxShadow(color: color.withAlpha(90), blurRadius: 6.0),
          ],
        ),
        child: const SizedBox.square(dimension: 7.0),
      ),
    );
  }
}
