import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'canvas_device.freezed.dart';

@freezed
sealed class CanvasDevice with _$CanvasDevice {
  const factory CanvasDevice.connected({
    required PluggedDevice device,
    required bool isConnected,
    required NativeTextureId textureId,
    required DeviceScreenSize screenSize,
    required bool supportsInteraction,
    required bool supportsDeviceActions,
  }) = _ConnectedCanvasDevice;

  const factory CanvasDevice.connecting({
    required PluggedDevice device,
    required bool supportsInteraction,
    required bool supportsDeviceActions,
  }) = _ConnectingCanvasDevice;
}

extension CanvasDeviceMirror on CanvasDevice {
  bool get isConnected => switch (this) {
    _ConnectedCanvasDevice(:final isConnected) => isConnected,
    _ConnectingCanvasDevice() => false,
  };

  NativeTextureId? get textureId => switch (this) {
    _ConnectedCanvasDevice(:final textureId) => textureId,
    _ConnectingCanvasDevice() => null,
  };

  DeviceScreenSize? get screenSize => switch (this) {
    _ConnectedCanvasDevice(:final screenSize) => screenSize,
    _ConnectingCanvasDevice() => null,
  };
}
