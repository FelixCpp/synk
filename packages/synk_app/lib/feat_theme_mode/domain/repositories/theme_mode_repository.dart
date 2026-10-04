import 'package:synk/feat_theme_mode/domain/models/theme_mode.dart';

abstract interface class ThemeModeRepository {
  Future<void> close();
  Future<void> toggleThemeMode();
  Future<ThemeMode> getThemeMode();
  Stream<ThemeMode> observeThemeMode();
}
