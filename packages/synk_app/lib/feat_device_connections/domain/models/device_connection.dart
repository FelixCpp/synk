import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_connections/domain/models/android_device_info.dart';
import 'package:synk/feat_native_texture/native_texture.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_connection.freezed.dart';

@freezed
sealed class DeviceConnection with _$DeviceConnection {
  const factory DeviceConnection.android({
    required PluggedDevice device,
    required AndroidDeviceInfo info,
    required NativeTextureId textureId,
    required DeviceScreenSize screenSize,
  }) = _AndroidDeviceConnection;

  const factory DeviceConnection.ios({
    required PluggedDevice device,
    required NativeTextureId textureId,
    required DeviceScreenSize screenSize,
  }) = _IosDeviceConnection;
}
