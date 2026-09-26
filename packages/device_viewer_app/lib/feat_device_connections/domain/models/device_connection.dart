import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_connections/domain/models/android_device_info.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_connection.freezed.dart';

@freezed
sealed class DeviceConnection with _$DeviceConnection {
  const factory DeviceConnection.android({
    required AndroidDevice device,
    required AndroidDeviceInfo info,
    required NativeTextureId textureId,
  }) = _AndroidDeviceConnection;
}
