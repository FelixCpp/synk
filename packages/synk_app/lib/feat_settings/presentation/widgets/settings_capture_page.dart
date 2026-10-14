import 'package:file_selector/file_selector.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_layout.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mirrors the name `DeviceFrameRepository` builds for a capture.
const _namePattern = 'Screenshot <Gerät> JJJJ-MM-TT at HH.MM.SS.png';

class const SettingsCapturePage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final theme = context.synkUi;
        final colors = theme.colors;
        final bloc = context.read<SettingsBloc>();

        return SettingsPage(
          title: 'Aufnahmen',
          children: [
            SettingsSection(
              title: 'Speicherort',
              children: [
                SettingsRow(
                  spacing: SynkUiSpace.s12,
                  leading: Icon(
                    CupertinoIcons.folder,
                    size: 18.0,
                    color: colors.accent,
                  ),
                  label: SettingsRowLabel(
                    title: state.screenCaptureSavePath ?? 'Wird geladen …',
                    titleStyle: theme.typography.mono.copyWith(
                      fontSize: 12.0,
                      color: colors.text,
                    ),
                    subtitle: _namePattern,
                  ),
                  trailing: Row(
                    spacing: SynkUiSpace.s8,
                    children: [
                      SynkUiButton(
                        label: 'Im Finder zeigen',
                        variant: SynkUiButtonVariant.secondary,
                        onPressed: () => bloc.add(
                          const .onRevealScreenCaptureSavePath(),
                        ),
                      ),
                      SynkUiButton(
                        label: 'Ändern …',
                        onPressed: () => _pickSavePath(
                          bloc,
                          state.screenCaptureSavePath,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: 'Nach der Aufnahme',
              children: [
                SettingsRow(
                  label: const SettingsRowLabel(
                    title: 'Vorschau einblenden',
                    subtitle:
                        'Kleines Vorschaubild unten rechts, wie bei macOS.',
                  ),
                  trailing: SynkUiToggle(
                    value: state.showCapturePreview,
                    onChanged: (value) => bloc.add(
                      .onSetShowCapturePreview(value),
                    ),
                  ),
                ),
                // Both of these need native code that does not exist yet, so
                // they are shown as unavailable rather than as dead switches.
                const SettingsRow(
                  label: SettingsRowLabel(
                    title: 'Screenshot in die Zwischenablage kopieren',
                    subtitle: 'Noch nicht verfügbar.',
                  ),
                  trailing: SynkUiToggle(value: false, onChanged: null),
                ),
                const SettingsRow(
                  label: SettingsRowLabel(
                    title: 'Ton in Videos aufnehmen',
                    subtitle:
                        'Noch nicht verfügbar – Aufnahmen sind derzeit stumm.',
                  ),
                  trailing: SynkUiToggle(value: false, onChanged: null),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickSavePath(SettingsBloc bloc, String? current) async {
    final directory = await getDirectoryPath(
      initialDirectory: current,
      confirmButtonText: 'Auswählen',
    );

    if (directory == null) {
      return;
    }

    bloc.add(.onSetScreenCaptureSavePath(directory));
  }
}
