import 'package:synk/feat_device_platform/domain/models/device_navigation.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/native_texture_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_connection.freezed.dart';

@freezed
sealed class DeviceConnection with _$DeviceConnection {
  const factory DeviceConnection({
    required PluggedDevice device,
    required NativeTextureId textureId,
    required DeviceScreenSize screenSize,
    required bool supportsInteraction,
    required Set<DeviceNavigation> navigations,
    required bool supportsFileTransfer,
    required bool supportsAudio,
  }) = _DeviceConnection;
}
