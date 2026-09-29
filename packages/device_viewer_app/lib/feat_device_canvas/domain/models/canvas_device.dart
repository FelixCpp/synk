import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_native_texture/native_texture.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'canvas_device.freezed.dart';

@freezed
sealed class CanvasDevice with _$CanvasDevice {
  const factory CanvasDevice.android({
    required AndroidDevice device,
    required bool isConnected,
    required NativeTextureId textureId,
    required DeviceScreenSize screenSize,
  }) = _AndroidCanvasDevice;

  const factory CanvasDevice.connecting({required AndroidDevice device}) =
      _ConnectingCanvasDevice;
}
