import 'dart:ui';

import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';

class SettingsRepositoryImpl({
  required final RxSharedPreferences preferences,
  required final String fallbackScreenCaptureSavePath,
  required final ThemeMode fallbackThemeMode,
}) implements SettingsRepository {
  static const screenCaptureSavePath = 'screen_capture_save_path';
  static const themeMode = 'theme_mode';

  @override
  Future<String> getScreenCaptureSavePath() async {
    return await preferences.getString(screenCaptureSavePath) ??
        fallbackScreenCaptureSavePath;
  }

  @override
  Future<void> setScreenCaptureSavePath(String path) async {
    await preferences.setString(screenCaptureSavePath, path);
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await preferences.setString(themeMode, switch (mode) {
      Brightness.dark => 'dark',
      Brightness.light => 'light',
    });
  }

  @override
  Stream<SettingsState> observeState() {
    return Rx.combineLatest2(
      preferences
          .getStringStream(screenCaptureSavePath)
          .map((value) => value ?? fallbackScreenCaptureSavePath),
      preferences
          .getStringStream(themeMode)
          .map((value) => _themeModeFromPreference(value) ?? fallbackThemeMode),
      (screenCaptureSavePath, themeMode) {
        return SettingsState(
          themeMode: themeMode,
          screenCaptureSavePath: screenCaptureSavePath,
        );
      },
    );
  }
}

ThemeMode? _themeModeFromPreference(String? value) {
  return switch (value) {
    'dark' => ThemeMode.dark,
    'light' => ThemeMode.light,
    _ => null,
  };
}
