import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:file/file.dart';
import 'package:path/path.dart' as path;
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_kind.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';

class const ScreenCaptureStore({
  required final DeviceId deviceId,
  required final String modelName,
  required final SettingsRepository settingsRepository,
  required final ScreenCaptureEventChannel events,
  required final FileSystem fileSystem,
  required final Clock clock,
}) {
  Future<String> reservePath(ScreenCaptureKind kind) async {
    final settings = await settingsRepository.read();
    final directory = settings.screenCaptureSavePath;

    await fileSystem.directory(directory).create(recursive: true);

    return path.join(
      directory,
      kind.filenameFor(modelName, clock.now()),
    );
  }

  Future<void> writeScreenshot(String filepath, Uint8List pngBytes) {
    return fileSystem.file(filepath).writeAsBytes(pngBytes);
  }

  void announceScreenshot({
    required String filepath,
    required Uint8List pngBytes,
    required DeviceScreenSize screenSize,
  }) {
    events.submit(
      .png(
        bytes: pngBytes,
        filepath: filepath,
        screenSize: screenSize,
        deviceId: deviceId,
        modelName: modelName,
      ),
    );
  }

  void announceRecording({
    required String filepath,
    required Uint8List? posterBytes,
    required DeviceScreenSize screenSize,
  }) {
    events.submit(
      .video(
        posterBytes: posterBytes,
        filepath: filepath,
        screenSize: screenSize,
        deviceId: deviceId,
        modelName: modelName,
      ),
    );
  }
}
