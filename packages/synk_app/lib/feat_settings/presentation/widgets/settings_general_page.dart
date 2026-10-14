import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_layout.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const SettingsGeneralPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final bloc = context.read<SettingsBloc>();

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
                  trailing: SynkUiSegmentedControl<ThemeMode>(
                    value: state.themeMode,
                    segments: const [
                      SynkUiSegment(value: ThemeMode.light, label: 'Hell'),
                      SynkUiSegment(value: ThemeMode.dark, label: 'Dunkel'),
                      SynkUiSegment(value: ThemeMode.system, label: 'System'),
                    ],
                    onChanged: (mode) => bloc.add(.onSetThemeMode(mode)),
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: 'Fenster',
              children: [
                SettingsRow(
                  label: const SettingsRowLabel(
                    title: 'Seitenleiste beim Start anzeigen',
                  ),
                  trailing: SynkUiToggle(
                    value: state.showSidebarOnStart,
                    onChanged: (value) => bloc.add(
                      .onSetShowSidebarOnStart(value),
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
