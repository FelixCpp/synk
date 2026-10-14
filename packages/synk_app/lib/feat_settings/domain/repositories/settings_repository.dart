import 'package:synk/feat_device_platform/domain/models/mirror_options.dart';
import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';

abstract interface class SettingsRepository {
  Future<String> getScreenCaptureSavePath();

  /// `null` means the copy of adb that ships inside Synk.
  Future<String?> getAdbPath();

  /// Read once per connect by the connections repository.
  Future<MirrorOptions> getMirrorOptions();

  /// Read once per session by the device frame.
  Future<bool> getMuteOnConnect();

  /// Read on every ⌘C/⌘V inside a device frame.
  Future<bool> getSyncClipboard();

  Future<void> setThemeMode(ThemeMode mode);
  Future<void> setScreenCaptureSavePath(String path);
  Future<void> setShowCapturePreview(bool value);
  Future<void> setFrameRate(MirrorFrameRate frameRate);
  Future<void> setQuality(MirrorQuality quality);
  Future<void> setTurnDeviceScreenOff(bool value);
  Future<void> setMuteOnConnect(bool value);
  Future<void> setSyncClipboard(bool value);

  /// Pass `null` to go back to the copy of adb that ships inside Synk.
  Future<void> setAdbPath(String? path);

  Stream<SettingsState> observeState();
}
