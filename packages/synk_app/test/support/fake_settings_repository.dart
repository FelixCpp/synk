import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';

/// Settings that keep whatever they are handed in memory.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({
    this.screenCaptureSavePath = '/tmp/synk-test-captures',
    this.themeMode = ThemeMode.light,
  });

  String screenCaptureSavePath;
  ThemeMode themeMode;

  @override
  Future<String> getScreenCaptureSavePath() async => screenCaptureSavePath;

  @override
  Future<void> setScreenCaptureSavePath(String path) async {
    screenCaptureSavePath = path;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
  }

  @override
  Stream<SettingsState> observeState() {
    return Stream.value(
      SettingsState(
        themeMode: themeMode,
        screenCaptureSavePath: screenCaptureSavePath,
      ),
    );
  }
}
