import 'package:clock/clock.dart';
import 'package:file_selector/file_selector.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_kind.dart';
import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_layout.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const SettingsCapturePage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, Settings>(
      builder: (context, settings) {
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
                    title: settings.screenCaptureSavePath,
                    titleStyle: theme.typography.mono.copyWith(
                      fontSize: 12.0,
                      color: colors.text,
                    ),
                    subtitle: ScreenCaptureKind.screenshot.filenameFor(
                      '<Gerät>',
                      RepositoryProvider.of<Clock>(context).now(),
                    ),
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
                        onPressed: () => _pickSavePath(bloc, settings),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: 'Verhalten',
              children: [
                SettingsRow(
                  label: const SettingsRowLabel(
                    title: 'Vorschau nach Aufnahme',
                    subtitle:
                        'Kleines Vorschaubild unten rechts, wie bei macOS.',
                  ),
                  trailing: SynkUiToggle(
                    value: settings.showCapturePreview,
                    onChanged: (value) => bloc.add(
                      .onSave(settings.copyWith(showCapturePreview: value)),
                    ),
                  ),
                ),
                SettingsRow(
                  label: const SettingsRowLabel(
                    title: 'Screenshot in die Zwischenablage kopieren',
                    subtitle: 'Zusätzlich zur Datei im Speicherort.',
                  ),
                  trailing: SynkUiToggle(
                    value: settings.copyScreenshotToClipboard,
                    onChanged: (value) => bloc.add(
                      .onSave(
                        settings.copyWith(copyScreenshotToClipboard: value),
                      ),
                    ),
                  ),
                ),
                SettingsRow(
                  label: SettingsRowLabel(
                    title: 'Ton in Videos aufnehmen',
                    subtitle:
                        'Unabhängig davon, ob der Ton am Mac zu hören ist.',
                    badge: SynkUiTag(label: 'Android', color: colors.accent),
                  ),
                  trailing: SynkUiToggle(
                    value: settings.recordAudio,
                    onChanged: (value) => bloc.add(
                      .onSave(settings.copyWith(recordAudio: value)),
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

  Future<void> _pickSavePath(SettingsBloc bloc, Settings settings) async {
    final directory = await getDirectoryPath(
      initialDirectory: settings.screenCaptureSavePath,
      confirmButtonText: 'Auswählen',
    );

    if (directory == null) {
      return;
    }

    bloc.add(.onSave(settings.copyWith(screenCaptureSavePath: directory)));
  }
}
