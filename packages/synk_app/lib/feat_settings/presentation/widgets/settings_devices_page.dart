import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_layout.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String _frameRateLabel(MirrorFrameRate frameRate) => switch (frameRate) {
  .fps30 => '30 fps',
  .fps60 => '60 fps',
};

String _qualityLabel(MirrorQuality quality) => switch (quality) {
  .low => 'Niedrig',
  .medium => 'Mittel',
  .high => 'Hoch',
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
              title: 'Für neue Verbindungen',
              note:
                  'Eine Verbindung behält, womit sie gestartet wurde. '
                  'Änderungen greifen beim nächsten Verbinden.',
              children: [
                SettingsRow(
                  label: const SettingsRowLabel(title: 'Bildrate'),
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
                    subtitle:
                        'Das Gerät bleibt dunkel, während du es am Mac '
                        'bedienst.',
                    badge: SynkUiTag(label: 'Android', color: colors.accent),
                  ),
                  trailing: SynkUiToggle(
                    value: state.turnDeviceScreenOff,
                    onChanged: (value) => bloc.add(
                      .onSetTurnDeviceScreenOff(value),
                    ),
                  ),
                ),
                SettingsRow(
                  label: const SettingsRowLabel(
                    title: 'Ton zu Beginn stummschalten',
                    subtitle:
                        'Der Ton wird trotzdem übertragen und lässt sich im '
                        'Gerätefenster jederzeit einschalten.',
                  ),
                  trailing: SynkUiToggle(
                    value: state.muteOnConnect,
                    onChanged: (value) => bloc.add(
                      .onSetMuteOnConnect(value),
                    ),
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: 'Im Gerätefenster',
              children: [
                SettingsRow(
                  label: const SettingsRowLabel(
                    title: 'Zwischenablage synchronisieren',
                    subtitle:
                        '⌘C und ⌘V kopieren zwischen Mac und Gerät. Ist das '
                        'aus, gehen die Tastenkürzel an das Gerät selbst.',
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
