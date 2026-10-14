import 'dart:async';

import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:use_in_case/use_in_case.dart';

class const SetThemeModeInteractor(final SettingsRepository repository)
    implements ParameterizedInteractor<ThemeMode> {
  @override
  FutureOr<void> getOrThrow(ThemeMode input) {
    return repository.setThemeMode(input);
  }
}
