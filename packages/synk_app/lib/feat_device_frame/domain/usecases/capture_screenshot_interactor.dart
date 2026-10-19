import 'dart:async';
import 'dart:typed_data';

import 'package:app_logger/app_logger.dart';
import 'package:dartz/dartz.dart';
import 'package:synk/feat_clipboard/application/host_clipboard.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_frame/domain/repositories/screen_captures.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_kind.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const CaptureScreenshotInteractor({
  required final DeviceFrameRepository repository,
  required final ScreenCaptures captures,
  required final HostClipboard hostClipboard,
  required final SettingsRepository settingsRepository,
}) implements Interactor {
  @override
  FutureOr<void> getOrThrow(Unit input) async {
    final pngBytes = await repository.captureScreenshot();
    final filepath = await captures.reservePath(ScreenCaptureKind.screenshot);
    await captures.writeScreenshot(filepath, pngBytes);

    final settings = await settingsRepository.read();
    if (settings.copyScreenshotToClipboard) {
      await _putOnHostClipboard(pngBytes);
    }

    captures.announceScreenshot(
      filepath: filepath,
      pngBytes: pngBytes,
      screenSize: repository.screenSize,
    );
  }

  Future<void> _putOnHostClipboard(Uint8List pngBytes) async {
    try {
      await hostClipboard.writeImage(pngBytes);
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'The screenshot is saved but did not make it onto the clipboard',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
