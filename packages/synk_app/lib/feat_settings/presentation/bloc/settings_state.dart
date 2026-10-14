part of 'settings_bloc.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    required ThemeMode themeMode,
    required String? screenCaptureSavePath,
    required bool showCapturePreview,
    required MirrorFrameRate frameRate,
    required MirrorQuality quality,
    required bool turnDeviceScreenOff,
    required bool muteOnConnect,
    required bool syncClipboard,

    /// `null` means the copy of adb that ships inside Synk.
    required String? adbPath,
  }) = _SettingsState;

  factory SettingsState.initial(ThemeMode mode) {
    return .new(
      themeMode: mode,
      screenCaptureSavePath: null,
      showCapturePreview: SettingsDefaults.showCapturePreview,
      frameRate: SettingsDefaults.frameRate,
      quality: SettingsDefaults.quality,
      turnDeviceScreenOff: SettingsDefaults.turnDeviceScreenOff,
      muteOnConnect: SettingsDefaults.muteOnConnect,
      syncClipboard: SettingsDefaults.syncClipboard,
      adbPath: null,
    );
  }
}
