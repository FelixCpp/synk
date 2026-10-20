import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/settings_feature.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const ThemeModeProvider({
  super.key,
  required final Settings defaults,
  required final BlocWidgetBuilder<ThemeMode> builder,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(
        defaults: defaults,
        feature: RepositoryProvider.of<SettingsFeature>(context),
        notifications: RepositoryProvider.of<NotificationService>(context),
      ),
      child: BlocSelector<SettingsBloc, Settings, ThemeMode>(
        selector: (settings) => settings.themeMode,
        builder: builder,
      ),
    );
  }
}
