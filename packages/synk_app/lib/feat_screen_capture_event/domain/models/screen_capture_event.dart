import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

part 'screen_capture_event.freezed.dart';

@freezed
sealed class ScreenCaptureEvent with _$ScreenCaptureEvent {
  const factory ScreenCaptureEvent.png({
    required Uint8List bytes,
    required String filepath,
    required DeviceScreenSize screenSize,
    required DeviceId deviceId,
    required String modelName,
  }) = _Png;

  const factory ScreenCaptureEvent.video({
    required Uint8List? posterBytes,
    required String filepath,
    required DeviceScreenSize screenSize,
    required DeviceId deviceId,
    required String modelName,
  }) = _Video;
}
