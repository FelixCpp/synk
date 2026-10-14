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
    return preferences.observeAll().map(_decode);
  }

  @override
  Future<void> save(Settings settings) async {
    await Future.wait([
      preferences.setString(_Key.themeMode, settings.themeMode.name),
      preferences.setString(
        _Key.screenCaptureSavePath,
        settings.screenCaptureSavePath,
      ),
      preferences.setBool(
        _Key.showCapturePreview,
        settings.showCapturePreview,
      ),
      preferences.setBool(
        _Key.copyScreenshotToClipboard,
        settings.copyScreenshotToClipboard,
      ),
      preferences.setBool(_Key.recordAudio, settings.recordAudio),
      preferences.setString(_Key.frameRate, settings.frameRate.name),
      preferences.setString(_Key.quality, settings.quality.name),
      preferences.setBool(
        _Key.turnDeviceScreenOff,
        settings.turnDeviceScreenOff,
      ),
      preferences.setBool(_Key.muteOnConnect, settings.muteOnConnect),
      preferences.setBool(_Key.syncClipboard, settings.syncClipboard),
      preferences.setString(_Key.customAdbPath, settings.customAdbPath),
    ]);
  }

  Settings _decode(Map<String, Object?> stored) {
    T read<T extends Object>(String key, T fallback) {
      return stored[key] as T? ?? fallback;
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
      screenCaptureSavePath: read(
        _Key.screenCaptureSavePath,
        defaults.screenCaptureSavePath,
      ),
      showCapturePreview: read(
        _Key.showCapturePreview,
        defaults.showCapturePreview,
      ),
      copyScreenshotToClipboard: read(
        _Key.copyScreenshotToClipboard,
        defaults.copyScreenshotToClipboard,
      ),
      recordAudio: read(_Key.recordAudio, defaults.recordAudio),
      frameRate: readEnum(
        _Key.frameRate,
        MirrorFrameRate.values,
        defaults.frameRate,
      ),
      quality: readEnum(_Key.quality, MirrorQuality.values, defaults.quality),
      turnDeviceScreenOff: read(
        _Key.turnDeviceScreenOff,
        defaults.turnDeviceScreenOff,
      ),
      muteOnConnect: read(_Key.muteOnConnect, defaults.muteOnConnect),
      syncClipboard: read(_Key.syncClipboard, defaults.syncClipboard),
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
