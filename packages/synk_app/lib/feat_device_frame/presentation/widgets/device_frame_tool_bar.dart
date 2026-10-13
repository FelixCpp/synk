import 'package:synk/design/build_context.dart';
import 'package:synk/design/theme/synk_theme.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';

class const DeviceFrameToolBar({
  super.key,
  required final DeviceConnection connection,
  required final bool isMaximized,
  required final bool isRecording,
  required final bool isAudioMuted,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleRecording,
  required final VoidCallback onToggleAudioMute,
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
          mainAxisAlignment: .spaceBetween,
          spacing: SynkTheme.horizontalComponentSpacingSmall,
          children: [
            Expanded(
              child: Row(
                spacing: SynkTheme.horizontalComponentSpacingSmall,
                children: [
                  _StatusDot(isLive: true), // TODO(Felix): Maybe remove this?
                  Flexible(
                    child: SynkUiTooltip(
                      message: connection.device.id,
                      child: Text(
                        connection.device.modelName,
                        style: context.typo.headline,
                        overflow: .ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Scales the actions down in a narrow frame instead of overflowing.
            Flexible(
              child: FittedBox(
                fit: .scaleDown,
                child: _Actions(
                  connection: connection,
                  isMaximized: isMaximized,
                  isRecording: isRecording,
                  isAudioMuted: isAudioMuted,
                  onCaptureScreenshot: onCaptureScreenshot,
                  onToggleRecording: onToggleRecording,
                  onToggleAudioMute: onToggleAudioMute,
                  onToggleMaximize: onToggleMaximize,
                  onClose: onClose,
                  onInstallApk: onInstallApk,
                  onShareFile: onShareFile,
                  onStandby: onStandby,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _Actions({
  required final DeviceConnection connection,
  required final bool isMaximized,
  required final bool isRecording,
  required final bool isAudioMuted,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleRecording,
  required final VoidCallback onToggleAudioMute,
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
        SynkUiTooltip(
          message: isRecording ? 'Aufnahme beenden' : 'Aufnahme starten',
          child: SynkUiIconButton(
            icon: isRecording
                ? CupertinoIcons.stop_fill
                : CupertinoIcons.video_camera,
            color: isRecording ? context.colors.error : null,
            onPressed: onToggleRecording,
          ),
        ),
        SynkUiTooltip(
          message: 'Screenshot aufnehmen',
          child: SynkUiIconButton(
            icon: CupertinoIcons.camera,
            onPressed: onCaptureScreenshot,
          ),
        ),
        SynkUiTooltip(
          message: isMaximized ? 'Vollbild verlassen' : 'Gerät maximieren',
          child: SynkUiIconButton(
            icon: isMaximized
                ? CupertinoIcons.arrow_down_right_arrow_up_left
                : CupertinoIcons.arrow_up_left_arrow_down_right,
            onPressed: onToggleMaximize,
          ),
        ),
        if (connection.supportsInteraction ||
            connection.supportsFileTransfer ||
            isAudioMuted)
          _OverflowButton(
            connection: connection,
            isAudioMuted: isAudioMuted,
            onToggleAudioMute: onToggleAudioMute,
            onInstallApk: onInstallApk,
            onShareFile: onShareFile,
            onStandby: onStandby,
          ),
        SynkUiTooltip(
          message: 'Spiegelung beenden',
          child: SynkUiIconButton(
            icon: CupertinoIcons.clear,
            onPressed: onClose,
          ),
        ),
      ],
    );
  }
}

class const _OverflowButton({
  required final DeviceConnection connection,
  required final bool isAudioMuted,
  required final VoidCallback onToggleAudioMute,
  required final VoidCallback onInstallApk,
  required final VoidCallback onShareFile,
  required final VoidCallback onStandby,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SynkUiMenu(
      width: 190.0,
      itemsBuilder: (context, controller) => [
        if (connection.supportsFileTransfer) ...[
          SynkUiTooltip(
            message: 'APK auf dem Gerät installieren',
            child: SynkUiMenuItem(
              icon: CupertinoIcons.arrow_down_to_line,
              label: 'APK Installieren',
              onPressed: () {
                controller.close();
                onInstallApk();
              },
            ),
          ),
          SynkUiTooltip(
            message: 'Datei auf das Gerät übertragen',
            child: SynkUiMenuItem(
              icon: CupertinoIcons.share,
              label: 'Datei senden',
              onPressed: () {
                controller.close();
                onShareFile();
              },
            ),
          ),
        ],
        if (connection.supportsAudio)
          SynkUiTooltip(
            message: isAudioMuted ? 'Ton ein' : 'Ton aus',
            child: SynkUiMenuItem(
              icon: isAudioMuted
                  ? CupertinoIcons.speaker_slash_fill
                  : CupertinoIcons.speaker_2_fill,
              label: isAudioMuted ? 'Ton ein' : 'Ton aus',
              onPressed: onToggleAudioMute,
            ),
          ),
        if (connection.supportsInteraction)
          SynkUiTooltip(
            message: 'Gerät An-/Ausschalten',
            child: SynkUiMenuItem(
              icon: CupertinoIcons.power,
              label: 'Standby',
              onPressed: () {
                controller.close();
                onStandby();
              },
            ),
          ),
      ],
      triggerBuilder: (context, controller) => SynkUiTooltip(
        message: 'Mehr',
        child: SynkUiIconButton(
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
