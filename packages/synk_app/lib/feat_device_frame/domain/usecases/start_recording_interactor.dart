import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_device_frame/domain/models/running_recording.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_frame/domain/repositories/screen_captures.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_kind.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const StartRecordingInteractor({
  required final DeviceFrameRepository repository,
  required final ScreenCaptures captures,
  required final SettingsRepository settingsRepository,
  required final RunningRecording running,
}) implements Interactor {
  @override
  FutureOr<void> getOrThrow(Unit input) async {
    final settings = await settingsRepository.read();
    final filepath = await captures.reservePath(ScreenCaptureKind.recording);

    await repository.startRecording(
      filepath,
      withAudio: settings.recordAudio,
    );

    running.started(filepath);
  }
}
