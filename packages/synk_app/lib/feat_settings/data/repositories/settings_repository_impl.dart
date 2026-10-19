import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl({
  required final RxSharedPreferences preferences,
  required final Settings defaults,
}) implements SettingsRepository {
  @override
  Future<Settings> read() async {
    return _decode(await preferences.readAll());
  }

  @override
  Stream<Settings> observe() {
    return preferences.observeAll().map(_decode).distinct();
  }

  @override
  Future<void> save(Settings settings) async {
    final stored = _encode(_decode(await preferences.readAll()));
    final wanted = _encode(settings);

    await Future.wait([
      for (final entry in wanted.entries)
        if (stored[entry.key] != entry.value) _write(entry.key, entry.value),
    ]);
  }

  /// The counterpart of [_decode]: one entry per stored key.
  Map<String, Object?> _encode(Settings settings) {
    return {
      _Key.themeMode: settings.themeMode.name,
      _Key.screenCaptureSavePath: settings.screenCaptureSavePath,
      _Key.showCapturePreview: settings.showCapturePreview,
      _Key.copyScreenshotToClipboard: settings.copyScreenshotToClipboard,
      _Key.recordAudio: settings.recordAudio,
      _Key.frameRate: settings.frameRate.name,
      _Key.quality: settings.quality.name,
      _Key.turnDeviceScreenOff: settings.turnDeviceScreenOff,
      _Key.muteOnConnect: settings.muteOnConnect,
      _Key.syncClipboard: settings.syncClipboard,
      _Key.customAdbPath: settings.customAdbPath,
    };
  }

  Future<void> _write(String key, Object? value) {
    if (value is bool) {
      return preferences.setBool(key, value);
    }

    return preferences.setString(key, value as String?);
  }

  Settings _decode(Map<String, Object?> stored) {
    T readOrFallBack<T extends Object>(String key, T fallback) {
      final value = stored[key];
      return value is T ? value : fallback;
    }

    E readEnum<E extends Enum>(String key, List<E> values, E fallback) {
      final name = stored[key];

      for (final value in values) {
        if (value.name == name) return value;
      }

      return fallback;
    }

    return Settings(
      themeMode: readEnum(
        _Key.themeMode,
        ThemeMode.values,
        defaults.themeMode,
      ),
      screenCaptureSavePath: readOrFallBack(
        _Key.screenCaptureSavePath,
        defaults.screenCaptureSavePath,
      ),
      showCapturePreview: readOrFallBack(
        _Key.showCapturePreview,
        defaults.showCapturePreview,
      ),
      copyScreenshotToClipboard: readOrFallBack(
        _Key.copyScreenshotToClipboard,
        defaults.copyScreenshotToClipboard,
      ),
      recordAudio: readOrFallBack(_Key.recordAudio, defaults.recordAudio),
      frameRate: readEnum(
        _Key.frameRate,
        MirrorFrameRate.values,
        defaults.frameRate,
      ),
      quality: readEnum(_Key.quality, MirrorQuality.values, defaults.quality),
      turnDeviceScreenOff: readOrFallBack(
        _Key.turnDeviceScreenOff,
        defaults.turnDeviceScreenOff,
      ),
      muteOnConnect: readOrFallBack(_Key.muteOnConnect, defaults.muteOnConnect),
      syncClipboard: readOrFallBack(_Key.syncClipboard, defaults.syncClipboard),
      customAdbPath: stored[_Key.customAdbPath] as String?,
    );
  }
}

abstract final class _Key {
  static const themeMode = 'theme_mode';
  static const screenCaptureSavePath = 'screen_capture_save_path';
  static const showCapturePreview = 'show_capture_preview';
  static const copyScreenshotToClipboard = 'copy_screenshot_to_clipboard';
  static const recordAudio = 'record_audio';
  static const frameRate = 'mirror_frame_rate';
  static const quality = 'mirror_quality';
  static const turnDeviceScreenOff = 'turn_device_screen_off';
  static const muteOnConnect = 'mute_on_connect';
  static const syncClipboard = 'sync_clipboard';
  static const customAdbPath = 'adb_path';
}
