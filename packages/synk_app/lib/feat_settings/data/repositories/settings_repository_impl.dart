import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/domain/models/mirror_options.dart';
import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_settings/domain/models/settings_defaults.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';

class SettingsRepositoryImpl({
  required final RxSharedPreferences preferences,
  required final String fallbackScreenCaptureSavePath,
  required final ThemeMode fallbackThemeMode,
}) implements SettingsRepository {
  static const screenCaptureSavePath = 'screen_capture_save_path';
  static const themeMode = 'theme_mode';
  static const showSidebarOnStart = 'show_sidebar_on_start';
  static const showCapturePreview = 'show_capture_preview';
  static const frameRate = 'mirror_frame_rate';
  static const quality = 'mirror_quality';
  static const turnDeviceScreenOff = 'turn_device_screen_off';
  static const muteOnConnect = 'mute_on_connect';
  static const syncClipboard = 'sync_clipboard';
  static const adbPath = 'adb_path';

  @override
  Future<String> getScreenCaptureSavePath() async {
    return await preferences.getString(screenCaptureSavePath) ??
        fallbackScreenCaptureSavePath;
  }

  @override
  Future<String?> getAdbPath() {
    return preferences.getString(adbPath);
  }

  @override
  Future<MirrorOptions> getMirrorOptions() async {
    final frameRate = _frameRateFromPreference(
      await preferences.getString(SettingsRepositoryImpl.frameRate),
    );
    final quality = _qualityFromPreference(
      await preferences.getString(SettingsRepositoryImpl.quality),
    );

    return MirrorOptions(
      maxFps: frameRate.maxFps,
      videoBitRate: quality.videoBitRate,
      turnDeviceScreenOff:
          await preferences.getBool(turnDeviceScreenOff) ??
          SettingsDefaults.turnDeviceScreenOff,
    );
  }

  @override
  Future<bool> getMuteOnConnect() async {
    return await preferences.getBool(muteOnConnect) ??
        SettingsDefaults.muteOnConnect;
  }

  @override
  Future<bool> getSyncClipboard() async {
    return await preferences.getBool(syncClipboard) ??
        SettingsDefaults.syncClipboard;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await preferences.setString(themeMode, mode.name);
  }

  @override
  Future<void> setScreenCaptureSavePath(String path) async {
    await preferences.setString(screenCaptureSavePath, path);
  }

  @override
  Future<void> setShowSidebarOnStart(bool value) async {
    await preferences.setBool(showSidebarOnStart, value);
  }

  @override
  Future<void> setShowCapturePreview(bool value) async {
    await preferences.setBool(showCapturePreview, value);
  }

  @override
  Future<void> setFrameRate(MirrorFrameRate value) async {
    await preferences.setString(frameRate, value.name);
  }

  @override
  Future<void> setQuality(MirrorQuality value) async {
    await preferences.setString(quality, value.name);
  }

  @override
  Future<void> setTurnDeviceScreenOff(bool value) async {
    await preferences.setBool(turnDeviceScreenOff, value);
  }

  @override
  Future<void> setMuteOnConnect(bool value) async {
    await preferences.setBool(muteOnConnect, value);
  }

  @override
  Future<void> setSyncClipboard(bool value) async {
    await preferences.setBool(syncClipboard, value);
  }

  @override
  Future<void> setAdbPath(String? path) async {
    // A null value removes the key, which is what "use the bundled adb" is.
    await preferences.setString(adbPath, path);
  }

  @override
  Stream<SettingsState> observeState() {
    return Rx.combineLatest2(
      _observeAppearance(),
      _observeMirroring(),
      (appearance, mirroring) {
        return SettingsState(
          themeMode: appearance.themeMode,
          screenCaptureSavePath: appearance.screenCaptureSavePath,
          showSidebarOnStart: appearance.showSidebarOnStart,
          showCapturePreview: appearance.showCapturePreview,
          adbPath: appearance.adbPath,
          frameRate: mirroring.frameRate,
          quality: mirroring.quality,
          turnDeviceScreenOff: mirroring.turnDeviceScreenOff,
          muteOnConnect: mirroring.muteOnConnect,
          syncClipboard: mirroring.syncClipboard,
        );
      },
    );
  }

  Stream<
    ({
      ThemeMode themeMode,
      String screenCaptureSavePath,
      bool showSidebarOnStart,
      bool showCapturePreview,
      String? adbPath,
    })
  >
  _observeAppearance() {
    return Rx.combineLatest5(
      preferences
          .getStringStream(themeMode)
          .map((value) => _themeModeFromPreference(value) ?? fallbackThemeMode),
      preferences
          .getStringStream(screenCaptureSavePath)
          .map((value) => value ?? fallbackScreenCaptureSavePath),
      _boolStream(showSidebarOnStart, SettingsDefaults.showSidebarOnStart),
      _boolStream(showCapturePreview, SettingsDefaults.showCapturePreview),
      preferences.getStringStream(adbPath),
      (themeMode, savePath, sidebar, preview, adb) => (
        themeMode: themeMode,
        screenCaptureSavePath: savePath,
        showSidebarOnStart: sidebar,
        showCapturePreview: preview,
        adbPath: adb,
      ),
    );
  }

  Stream<
    ({
      MirrorFrameRate frameRate,
      MirrorQuality quality,
      bool turnDeviceScreenOff,
      bool muteOnConnect,
      bool syncClipboard,
    })
  >
  _observeMirroring() {
    return Rx.combineLatest5(
      preferences
          .getStringStream(frameRate)
          .map(_frameRateFromPreference),
      preferences.getStringStream(quality).map(_qualityFromPreference),
      _boolStream(turnDeviceScreenOff, SettingsDefaults.turnDeviceScreenOff),
      _boolStream(muteOnConnect, SettingsDefaults.muteOnConnect),
      _boolStream(syncClipboard, SettingsDefaults.syncClipboard),
      (frameRate, quality, screenOff, mute, clipboard) => (
        frameRate: frameRate,
        quality: quality,
        turnDeviceScreenOff: screenOff,
        muteOnConnect: mute,
        syncClipboard: clipboard,
      ),
    );
  }

  Stream<bool> _boolStream(String key, bool fallback) {
    return preferences.getBoolStream(key).map((value) => value ?? fallback);
  }
}

/// Values written before `system` existed were already `dark`/`light`, so
/// matching on the enum name needs no migration.
ThemeMode? _themeModeFromPreference(String? value) {
  for (final mode in ThemeMode.values) {
    if (mode.name == value) return mode;
  }

  return null;
}

MirrorFrameRate _frameRateFromPreference(String? value) {
  return MirrorFrameRate.values.firstWhere(
    (frameRate) => frameRate.name == value,
    orElse: () => SettingsDefaults.frameRate,
  );
}

MirrorQuality _qualityFromPreference(String? value) {
  return MirrorQuality.values.firstWhere(
    (quality) => quality.name == value,
    orElse: () => SettingsDefaults.quality,
  );
}
