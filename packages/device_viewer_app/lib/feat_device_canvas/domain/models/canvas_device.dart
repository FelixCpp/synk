import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'canvas_device.freezed.dart';

@freezed
sealed class CanvasDevice with _$CanvasDevice {
  const factory CanvasDevice({
    required AndroidDevice device,
    required bool isConnected,
  }) = _CanvasDevice;
}
