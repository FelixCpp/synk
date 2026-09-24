import 'package:device_viewer/feat_devices/adb/domain/models/adb_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_device_connection.freezed.dart';

@freezed
sealed class AdbDeviceConnection with _$AdbDeviceConnection {
  const factory AdbDeviceConnection({
    required List<AdbDevice> connectedDevices,
  }) = _AdbDeviceConnection;
}
