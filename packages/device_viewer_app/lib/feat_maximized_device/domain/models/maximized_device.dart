import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_native_texture/native_texture.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'maximized_device.freezed.dart';

@freezed
sealed class MaximizedDevice with _$MaximizedDevice {
  const factory MaximizedDevice({
    required DeviceId deviceId,
    required String modelName,
    required bool isLive,
    required NativeTextureId? textureId,
    required DeviceScreenSize? screenSize,
    required bool supportsInteraction,
  }) = _MaximizedDevice;
}
