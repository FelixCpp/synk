import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'canvas_device.freezed.dart';

@freezed
sealed class CanvasDevice with _$CanvasDevice {
  const factory CanvasDevice({
    required PluggedDevice device,
    required NativeTextureId textureId,
    required DeviceScreenSize screenSize,
    required bool supportsInteraction,
    required bool supportsDeviceActions,
    required bool supportsAudio,
  }) = _ConnectedCanvasDevice;
}
