import 'package:synk/design/build_context.dart';
import 'package:synk/design/theme/synk_theme.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';

class const DeviceFrameToolBar({
  super.key,
  required final DeviceConnection connection,
  required final bool isMaximized,
  required final bool isRecording,
  required final bool isAudioMuted,
  required final double audioVolume,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleRecording,
  required final VoidCallback onToggleAudioMute,
  required final ValueChanged<double> onAudioVolumeChanged,
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
                  const _StatusDot(),
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
                  if (connection.interactionUnavailableReason
                      case final reason?)
                    _ViewOnlyTag(reason: reason),
                ],
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: .scaleDown,
                child: _Actions(
                  connection: connection,
                  isMaximized: isMaximized,
                  isRecording: isRecording,
                  isAudioMuted: isAudioMuted,
                  audioVolume: audioVolume,
                  onCaptureScreenshot: onCaptureScreenshot,
                  onToggleRecording: onToggleRecording,
                  onToggleAudioMute: onToggleAudioMute,
                  onAudioVolumeChanged: onAudioVolumeChanged,
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
  required final double audioVolume,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleRecording,
  required final VoidCallback onToggleAudioMute,
  required final ValueChanged<double> onAudioVolumeChanged,
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
        if (connection.hasMenuActions)
          _OverflowButton(
            connection: connection,
            isAudioMuted: isAudioMuted,
            audioVolume: audioVolume,
            onToggleAudioMute: onToggleAudioMute,
            onAudioVolumeChanged: onAudioVolumeChanged,
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
  required final double audioVolume,
  required final VoidCallback onToggleAudioMute,
  required final ValueChanged<double> onAudioVolumeChanged,
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
          _AudioControls(
            isAudioMuted: isAudioMuted,
            audioVolume: audioVolume,
            onToggleAudioMute: onToggleAudioMute,
            onAudioVolumeChanged: onAudioVolumeChanged,
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

class const _AudioControls({
  required final bool isAudioMuted,
  required final double audioVolume,
  required final VoidCallback onToggleAudioMute,
  required final ValueChanged<double> onAudioVolumeChanged,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final icon = switch (audioVolume) {
      _ when isAudioMuted || audioVolume == 0.0 =>
        CupertinoIcons.speaker_slash_fill,
      < 0.5 => CupertinoIcons.speaker_1_fill,
      _ => CupertinoIcons.speaker_2_fill,
    };

    return Padding(
      padding: const EdgeInsets.only(right: SynkUiSpace.s8),
      child: Row(
        spacing: SynkUiSpace.s4,
        children: [
          SynkUiTooltip(
            message: isAudioMuted ? 'Ton ein' : 'Ton aus',
            child: SynkUiIconButton(
              icon: icon,
              onPressed: onToggleAudioMute,
            ),
          ),
          Expanded(
            child: SynkUiTooltip(
              message: 'Lautstärke',
              child: Opacity(
                opacity: isAudioMuted ? 0.5 : 1.0,
                child: SynkUiSlider(
                  value: audioVolume,
                  onChanged: onAudioVolumeChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class const _ViewOnlyTag({required final InteractionUnavailableReason reason})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SynkUiTooltip(
      message: switch (reason) {
        .coreDeviceUnavailable =>
          'Bedienung braucht Xcode auf einem Mac mit Apple Silicon und '
              'macOS 14 oder neuer. Details unter Einstellungen › Tools.',
        .deviceNotPaired =>
          'Das Gerät ist Xcode nicht bekannt. Gerät entsperren, '
              '„Diesem Computer vertrauen“ bestätigen und neu verbinden.',
        .developerModeDisabled =>
          'Der Entwicklermodus ist aus. Auf dem Gerät unter Einstellungen › '
              'Datenschutz & Sicherheit › Entwicklermodus einschalten und neu '
              'verbinden.',
        .unknown =>
          'Die Bedienung ließ sich nicht vorbereiten. Gerät entsperren und '
              'neu verbinden.',
      },
      child: SynkUiTag(
        label: 'Nur Ansicht',
        color: context.synkUiTheme.colors.warn,
      ),
    );
  }
}

class const _StatusDot() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = context.colors.deviceConnected;

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

extension on DeviceConnection {
  bool get hasMenuActions =>
      supportsFileTransfer || supportsAudio || supportsInteraction;
}
