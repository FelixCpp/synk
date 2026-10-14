import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';

abstract interface class SettingsRepository {
  Future<String> getScreenCaptureSavePath();
  Future<void> setScreenCaptureSavePath(String path);
  Future<void> setThemeMode(ThemeMode mode);

  Stream<SettingsState> observeState();
}
