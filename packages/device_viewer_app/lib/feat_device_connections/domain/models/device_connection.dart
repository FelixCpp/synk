import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_device_connections/domain/models/android_device_info.dart';
import 'package:device_viewer/feat_native_texture/native_texture.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_connection.freezed.dart';

@freezed
sealed class DeviceConnection with _$DeviceConnection {
  const factory DeviceConnection.android({
    required AndroidDevice device,
    required AndroidDeviceInfo info,
    required NativeTextureId textureId,
    required DeviceScreenSize screenSize,
  }) = _AndroidDeviceConnection;
}
