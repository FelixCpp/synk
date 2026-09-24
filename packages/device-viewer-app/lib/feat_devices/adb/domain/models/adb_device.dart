import 'package:device_viewer/feat_devices/adb/domain/models/android_device_connection.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device_info.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_device.freezed.dart';

extension type const AndroidDeviceId(String value) implements String {}

@freezed
sealed class AdbDevice with _$AdbDevice {
  const factory AdbDevice({
    required AndroidDeviceId id,
    required AndroidDeviceState state,
    required AndroidDeviceConnection connection,
    required AndroidDeviceInfo info,
  }) = _AdbDevice;
}
