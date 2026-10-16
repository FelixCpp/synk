import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_layout.dart';
import 'package:synk/feat_version/domain/models/newer_app_version.dart';
import 'package:synk/feat_version/presentation/bloc/app_version_bloc.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const SettingsGeneralPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, Settings>(
      builder: (context, settings) {
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
                    value: settings.themeMode,
                    segments: const [
                      SynkUiSegment(value: .light, label: 'Hell'),
                      SynkUiSegment(value: .dark, label: 'Dunkel'),
                      SynkUiSegment(value: .system, label: 'System'),
                    ],
                    onChanged: (themeMode) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        .onSave(settings.copyWith(themeMode: themeMode)),
                      );
                    },
                  ),
                ),
              ],
            ),
            const _VersionSection(),
          ],
        );
      },
    );
  }
}

typedef _AppVersionViewData = ({
  String subtitle,
  Widget? action,
});

class const _VersionSection() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppVersionBloc, AppVersionState>(
      builder: (context, state) {
        final data = _getViewData(
          BlocProvider.of<AppVersionBloc>(context),
          state,
          state.newerAppVersion,
        );

        return SettingsSection(
          title: 'Version',
          children: [
            SettingsRow(
              label: const SettingsRowLabel(title: 'Installierte Version'),
              trailing: Text(state.currentAppVersion.version),
            ),
            SettingsRow(
              label: SettingsRowLabel(
                title: 'Updates',
                subtitle: data.subtitle,
              ),
              trailing: data.action ?? const SynkUiSpinner(),
            ),
          ],
        );
      },
    );
  }

  _AppVersionViewData _getViewData(
    AppVersionBloc bloc,
    AppVersionState state,
    NewerAppVersion? newerAppVersion,
  ) {
    if (newerAppVersion == null) {
      return (subtitle: 'Wird geprüft...', action: null);
    }

    return newerAppVersion.when(
      upToDate: () {
        return (
          subtitle: 'Synk ist auf dem neuesten Stand.',
          action: SynkUiButton(
            label: 'Erneut prüfen',
            variant: SynkUiButtonVariant.secondary,
            onPressed: () => bloc.add(const .onCheckForUpdates()),
          ),
        );
      },
      updateAvailable: (version) {
        return (
          subtitle: 'Version $version ist verfügbar.',
          action: SynkUiButton(
            label: switch ((state.isUpdating, state.downloadProgress)) {
              (false, _) => 'Herunterladen',
              (true, null) => 'Wird geladen …',
              (true, final progress?) =>
                'Wird geladen … ${(progress * 100).round()} %',
            },
            onPressed: state.isUpdating
                ? null
                : () => bloc.add(const .onUpdate()),
          ),
        );
      },
      failedToFetch: () {
        return (
          subtitle: 'Suche nach Updates fehlgeschlagen.',
          action: SynkUiButton(
            label: 'Erneut prüfen',
            variant: SynkUiButtonVariant.secondary,
            onPressed: () => bloc.add(const .onCheckForUpdates()),
          ),
        );
      },
    );
  }
}
