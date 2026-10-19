import 'dart:async';
import 'dart:typed_data';

import 'package:app_logger/app_logger.dart';
import 'package:dartz/dartz.dart';
import 'package:synk/feat_device_frame/domain/models/device_frame_exception.dart';
import 'package:synk/feat_device_frame/domain/models/running_recording.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_frame/domain/repositories/screen_captures.dart';
import 'package:use_in_case/use_in_case.dart';

class const StopRecordingInteractor({
  required final DeviceFrameRepository repository,
  required final ScreenCaptures captures,
  required final RunningRecording running,
}) implements Interactor {
  @override
  FutureOr<void> getOrThrow(Unit input) async {
    final filepath = running.take();
    final heldFrames = await repository.stopRecording();

    if (!heldFrames) {
      throw const DeviceFrameException(
        'Die Aufnahme enthielt kein Bild und wurde nicht gespeichert.',
      );
    }

    if (filepath == null) {
      return;
    }

    captures.announceRecording(
      filepath: filepath,
      posterBytes: await _posterFrame(),
      screenSize: repository.screenSize,
    );
  }

  Future<Uint8List?> _posterFrame() async {
    try {
      return await repository.captureScreenshot();
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'The recording is saved but has no poster frame',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }
}
