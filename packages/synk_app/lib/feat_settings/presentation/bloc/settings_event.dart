part of 'settings_bloc.dart';

@freezed
sealed class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.onSetup() = _OnSetup;
  const factory SettingsEvent.onSetThemeMode(ThemeMode themeMode) =
      _OnSetThemeMode;
  const factory SettingsEvent.onSetScreenCaptureSavePath(String path) =
      _OnSetScreenCaptureSavePath;
  const factory SettingsEvent.onRevealScreenCaptureSavePath() =
      _OnRevealScreenCaptureSavePath;
  const factory SettingsEvent.onSetShowCapturePreview(bool value) =
      _OnSetShowCapturePreview;
  const factory SettingsEvent.onSetFrameRate(MirrorFrameRate frameRate) =
      _OnSetFrameRate;
  const factory SettingsEvent.onSetQuality(MirrorQuality quality) =
      _OnSetQuality;
  const factory SettingsEvent.onSetTurnDeviceScreenOff(bool value) =
      _OnSetTurnDeviceScreenOff;
  const factory SettingsEvent.onSetMuteOnConnect(bool value) =
      _OnSetMuteOnConnect;
  const factory SettingsEvent.onSetSyncClipboard(bool value) =
      _OnSetSyncClipboard;
  const factory SettingsEvent.onSetAdbPath(String? path) = _OnSetAdbPath;
}
