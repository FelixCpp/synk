import 'dart:async';

import 'package:device_viewer/feat_theme_mode/domain/models/theme_mode.dart';
import 'package:device_viewer/feat_theme_mode/domain/repositories/theme_mode_repository.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeRepositoryImpl implements ThemeModeRepository {
  static const _preferenceKey = 'theme_mode';

  final _controller = BehaviorSubject<ThemeMode>.seeded(.light);

  @override
  Future<void> close() {
    return _controller.close();
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    final themeMode =
        _themeModeFromPreference(preferences.getString(_preferenceKey)) ??
        _controller.value;

    _controller.add(themeMode);
    return themeMode;
  }

  @override
  Stream<ThemeMode> observeThemeMode() {
    return _controller.stream;
  }

  @override
  Future<void> toggleThemeMode() async {
    final themeMode = _controller.value.inverted();
    _controller.add(themeMode);

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferenceKey, _preferenceFor(themeMode));
  }

  ThemeMode? _themeModeFromPreference(String? value) {
    return switch (value) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => null,
    };
  }

  String _preferenceFor(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark ? 'dark' : 'light';
  }
}
