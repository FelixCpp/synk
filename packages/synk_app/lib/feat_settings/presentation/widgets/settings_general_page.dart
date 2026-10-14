import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_layout.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const SettingsGeneralPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Allgemein',
      children: [
        SettingsSection(
          title: 'Erscheinungsbild',
          children: [
            SettingsRow(
              label: const SettingsRowLabel(
                title: 'Design',
                subtitle: '„System“ folgt der macOS-Einstellung.',
              ),
              trailing: BlocSelector<SettingsBloc, SettingsState, ThemeMode>(
                selector: (state) => state.themeMode,
                builder: (context, themeMode) {
                  return SynkUiSegmentedControl<ThemeMode>(
                    value: themeMode,
                    segments: const [
                      SynkUiSegment(value: ThemeMode.light, label: 'Hell'),
                      SynkUiSegment(value: ThemeMode.dark, label: 'Dunkel'),
                      SynkUiSegment(value: ThemeMode.system, label: 'System'),
                    ],
                    onChanged: (mode) => context.read<SettingsBloc>().add(
                      .onSetThemeMode(mode),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
