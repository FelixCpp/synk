import 'package:synk/design/theme/device_status_colors.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_frame/presentation/bloc/device_frame_bloc.dart';
import 'package:synk/feat_device_frame/presentation/device_frame_metrics.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The strip above a mirrored screen.
///
/// Everything the bloc can carry out is dispatched by the control that offers
/// it, so only what lives outside the frame — maximizing, closing, and the
/// screenshot flash the view owns — arrives as a callback.
class const DeviceFrameToolBar({
  super.key,
  required final DeviceConnection connection,
  required final bool isMaximized,
  required final bool isRecording,
  required final bool isAudioMuted,
  required final double audioVolume,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onClose,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DeviceFrameMetrics.toolBarHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.synkUi.colors.surface,
          border: .symmetric(
            horizontal: BorderSide(
              color: context.synkUi.colors.line,
              width: SynkUiSize.hairline,
            ),
          ),
        ),
        child: Padding(
          padding: DeviceFrameMetrics.toolBarPadding,
          child: Row(
            mainAxisAlignment: .spaceBetween,
            spacing: SynkUiSpace.s4,
            children: [
              Expanded(child: _DeviceName(connection: connection)),
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
                    onToggleMaximize: onToggleMaximize,
                    onClose: onClose,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _DeviceName({
  required final DeviceConnection connection,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: SynkUiSpace.s4,
      children: [
        const _StatusDot(),
        Flexible(
          child: SynkUiTooltip(
            message: connection.device.id,
            child: Text(
              connection.device.modelName,
              style: context.synkUi.typography.label,
              overflow: .ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        if (connection.interactionUnavailableReason case final reason?)
          _ViewOnlyTag(reason: reason),
      ],
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
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onClose,
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
            color: isRecording ? context.synkUi.colors.error : null,
            onPressed: () => context.read<DeviceFrameBloc>().add(
              const .onToggleRecording(),
            ),
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
                context.read<DeviceFrameBloc>().add(const .onInstallApk());
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
                context.read<DeviceFrameBloc>().add(const .onShareFile());
              },
            ),
          ),
        ],
        if (connection.supportsAudio)
          _AudioControls(
            isAudioMuted: isAudioMuted,
            audioVolume: audioVolume,
          ),
        if (connection.supportsInteraction)
          SynkUiTooltip(
            message: 'Gerät An-/Ausschalten',
            child: SynkUiMenuItem(
              icon: CupertinoIcons.power,
              label: 'Standby',
              onPressed: () {
                controller.close();
                context.read<DeviceFrameBloc>().add(
                  const .onPowerButtonPressed(),
                );
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
            // The menu stays open on purpose, so the sound can be toggled
            // back and the volume adjusted without reopening it.
            child: SynkUiIconButton(
              icon: icon,
              onPressed: () => context.read<DeviceFrameBloc>().add(
                const .onToggleAudioMute(),
              ),
            ),
          ),
          Expanded(
            child: SynkUiTooltip(
              message: 'Lautstärke',
              child: Opacity(
                opacity: isAudioMuted ? 0.5 : 1.0,
                child: SynkUiSlider(
                  value: audioVolume,
                  onChanged: (volume) => context
                      .read<DeviceFrameBloc>()
                      .add(.onAudioVolumeChanged(volume)),
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
        .developerDiskImageUnavailable =>
          'Das Gerät ist nicht für die Entwicklung vorbereitet. Gerät per '
              'Kabel anschließen, in Xcode unter Window › Devices and '
              'Simulators die Vorbereitung abwarten und neu verbinden.',
        .unknown =>
          'Die Bedienung ließ sich nicht vorbereiten. Gerät entsperren und '
              'neu verbinden.',
      },
      child: SynkUiTag(
        label: 'Nur Ansicht',
        color: context.synkUi.colors.warn,
      ),
    );
  }
}

class const _StatusDot() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: SynkUiSpace.s2),
      child: SynkUiStatusDot(
        color: context.synkUi.colors.deviceConnected,
        glow: true,
      ),
    );
  }
}

extension on DeviceConnection {
  bool get hasMenuActions =>
      supportsFileTransfer || supportsAudio || supportsInteraction;
}
