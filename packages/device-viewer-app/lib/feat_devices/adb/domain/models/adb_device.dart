import 'package:device_viewer/feat_devices/adb/domain/models/adb_device_connection_state.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/adb_device_identity.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/adb_transport.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_device.freezed.dart';

@freezed
sealed class AdbDevice with _$AdbDevice {
  const factory AdbDevice({
    required AdbDeviceIdentity identity,
    required AdbDeviceConnectionState state,
    required AdbTransport transport,
  }) = _AdbDevice;
}
