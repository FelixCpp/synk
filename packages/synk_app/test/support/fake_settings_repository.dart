import 'package:synk/feat_device_platform/domain/models/mirror_options.dart';
import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_settings/domain/models/settings_defaults.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';

/// Settings that keep whatever they are handed in memory.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({
    this.screenCaptureSavePath = '/tmp/synk-test-captures',
    this.themeMode = ThemeMode.light,
    this.showSidebarOnStart = SettingsDefaults.showSidebarOnStart,
    this.showCapturePreview = SettingsDefaults.showCapturePreview,
    this.frameRate = SettingsDefaults.frameRate,
    this.quality = SettingsDefaults.quality,
    this.turnDeviceScreenOff = SettingsDefaults.turnDeviceScreenOff,
    this.muteOnConnect = SettingsDefaults.muteOnConnect,
    this.syncClipboard = SettingsDefaults.syncClipboard,
    this.adbPath,
  });

  String screenCaptureSavePath;
  ThemeMode themeMode;
  bool showSidebarOnStart;
  bool showCapturePreview;
  MirrorFrameRate frameRate;
  MirrorQuality quality;
  bool turnDeviceScreenOff;
  bool muteOnConnect;
  bool syncClipboard;
  String? adbPath;

  @override
  Future<String> getScreenCaptureSavePath() async => screenCaptureSavePath;

  @override
  Future<String?> getAdbPath() async => adbPath;

  @override
  Future<MirrorOptions> getMirrorOptions() async {
    return MirrorOptions(
      maxFps: frameRate.maxFps,
      videoBitRate: quality.videoBitRate,
      turnDeviceScreenOff: turnDeviceScreenOff,
    );
  }

  @override
  Future<bool> getMuteOnConnect() async => muteOnConnect;

  @override
  Future<bool> getSyncClipboard() async => syncClipboard;

  @override
  Future<void> setScreenCaptureSavePath(String path) async {
    screenCaptureSavePath = path;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
  }

  @override
  Future<void> setShowSidebarOnStart(bool value) async {
    showSidebarOnStart = value;
  }

  @override
  Future<void> setShowCapturePreview(bool value) async {
    showCapturePreview = value;
  }

  @override
  Future<void> setFrameRate(MirrorFrameRate value) async {
    frameRate = value;
  }

  @override
  Future<void> setQuality(MirrorQuality value) async {
    quality = value;
  }

  @override
  Future<void> setTurnDeviceScreenOff(bool value) async {
    turnDeviceScreenOff = value;
  }

  @override
  Future<void> setMuteOnConnect(bool value) async {
    muteOnConnect = value;
  }

  @override
  Future<void> setSyncClipboard(bool value) async {
    syncClipboard = value;
  }

  @override
  Future<void> setAdbPath(String? path) async {
    adbPath = path;
  }

  @override
  Stream<SettingsState> observeState() {
    return Stream.value(
      SettingsState(
        themeMode: themeMode,
        screenCaptureSavePath: screenCaptureSavePath,
        showSidebarOnStart: showSidebarOnStart,
        showCapturePreview: showCapturePreview,
        frameRate: frameRate,
        quality: quality,
        turnDeviceScreenOff: turnDeviceScreenOff,
        muteOnConnect: muteOnConnect,
        syncClipboard: syncClipboard,
        adbPath: adbPath,
      ),
    );
  }
}
