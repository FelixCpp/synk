import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const ThemeModeProvider({
  super.key,
  required final ThemeMode initialThemeMode,
  required final BlocWidgetBuilder<ThemeMode> builder,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(
        themeMode: initialThemeMode,
        repository: RepositoryProvider.of(context),
        notifications: RepositoryProvider.of(context),
      ),
      child: BlocSelector<SettingsBloc, SettingsState, ThemeMode>(
        selector: (state) => state.themeMode,
        builder: builder,
      ),
    );
  }
}
