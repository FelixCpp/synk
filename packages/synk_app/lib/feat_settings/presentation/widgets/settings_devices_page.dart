import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_layout.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String _frameRateLabel(MirrorFrameRate frameRate) => switch (frameRate) {
  MirrorFrameRate.fps30 => '30 fps',
  MirrorFrameRate.fps60 => '60 fps',
};

String _qualityLabel(MirrorQuality quality) => switch (quality) {
  MirrorQuality.low => 'Niedrig',
  MirrorQuality.medium => 'Mittel',
  MirrorQuality.high => 'Hoch',
};

class const SettingsDevicesPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final colors = context.synkUi.colors;
        final bloc = context.read<SettingsBloc>();

        return SettingsPage(
          title: 'Geräte',
          children: [
            SettingsSection(
              title: 'Spiegeln',
              children: [
                SettingsRow(
                  label: const SettingsRowLabel(
                    title: 'Bildrate',
                    subtitle: 'Wirkt ab der nächsten Verbindung.',
                  ),
                  trailing: SynkUiSegmentedControl<MirrorFrameRate>(
                    value: state.frameRate,
                    segments: [
                      for (final frameRate in MirrorFrameRate.values)
                        SynkUiSegment(
                          value: frameRate,
                          label: _frameRateLabel(frameRate),
                        ),
                    ],
                    onChanged: (frameRate) => bloc.add(
                      .onSetFrameRate(frameRate),
                    ),
                  ),
                ),
                SettingsRow(
                  label: const SettingsRowLabel(
                    title: 'Bildqualität',
                    subtitle:
                        'Höher braucht mehr Bandbreite, vor allem über WLAN.',
                  ),
                  trailing: SynkUiSegmentedControl<MirrorQuality>(
                    value: state.quality,
                    segments: [
                      for (final quality in MirrorQuality.values)
                        SynkUiSegment(
                          value: quality,
                          label: _qualityLabel(quality),
                        ),
                    ],
                    onChanged: (quality) => bloc.add(.onSetQuality(quality)),
                  ),
                ),
                SettingsRow(
                  label: SettingsRowLabel(
                    title: 'Display am Gerät ausschalten',
                    subtitle: 'Wirkt ab der nächsten Verbindung.',
                    badge: SynkUiTag(label: 'Android', color: colors.accent),
                  ),
                  trailing: SynkUiToggle(
                    value: state.turnDeviceScreenOff,
                    onChanged: (value) => bloc.add(
                      .onSetTurnDeviceScreenOff(value),
                    ),
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: 'Beim Verbinden',
              children: [
                SettingsRow(
                  label: const SettingsRowLabel(title: 'Ton stummschalten'),
                  trailing: SynkUiToggle(
                    value: state.muteOnConnect,
                    onChanged: (value) => bloc.add(
                      .onSetMuteOnConnect(value),
                    ),
                  ),
                ),
                SettingsRow(
                  label: const SettingsRowLabel(
                    title: 'Zwischenablage synchronisieren',
                    subtitle:
                        '⌘C und ⌘V im Gerätefenster kopieren zwischen Mac '
                        'und Gerät.',
                  ),
                  trailing: SynkUiToggle(
                    value: state.syncClipboard,
                    onChanged: (value) => bloc.add(
                      .onSetSyncClipboard(value),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
