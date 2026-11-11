import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_device_platform/domain/models/mirror_options.dart';
import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_settings/domain/models/settings_category.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';

part 'settings.freezed.dart';

@freezed
sealed class Settings with _$Settings {
  const Settings._();

  const factory Settings({
    required ThemeMode themeMode,
    required String screenCaptureSavePath,
    required bool showCapturePreview,
    required bool copyScreenshotToClipboard,
    required bool recordAudio,
    required MirrorFrameRate frameRate,
    required MirrorQuality quality,
    required bool turnDeviceScreenOff,
    required bool muteOnConnect,
    required bool syncClipboard,
    required String? customAdbPath,
    required SettingsCategory settingsCategory,
  }) = _Settings;

  factory Settings.defaults({required String screenCaptureSavePath}) {
    return Settings(
      themeMode: .light,
      screenCaptureSavePath: screenCaptureSavePath,
      showCapturePreview: true,
      copyScreenshotToClipboard: false,
      recordAudio: true,
      frameRate: .fps60,
      quality: .medium,
      turnDeviceScreenOff: false,
      muteOnConnect: true,
      syncClipboard: true,
      customAdbPath: null,
      settingsCategory: .general,
    );
  }

  MirrorOptions get mirrorOptions {
    return MirrorOptions(
      maxFps: frameRate.maxFps,
      videoBitRate: quality.videoBitRate,
      turnDeviceScreenOff: turnDeviceScreenOff,
    );
  }
}
