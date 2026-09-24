import 'dart:async';

import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';
import 'package:rxdart/rxdart.dart';

class DeviceConnectionsRepositoryImpl(
  final AdbDevicesRepository devicesRepository,
) implements DeviceConnectionsRepository {
  final _connectedDeviceIds = BehaviorSubject<List<AndroidDeviceId>>.seeded(
    const [],
  );

  @override
  Future<void> dispose() {
    return _connectedDeviceIds.close();
  }

  @override
  Future<void> connect(AndroidDeviceId id) async {
    _connectedDeviceIds.add([..._connectedDeviceIds.value, id]);
  }

  @override
  Future<bool> isConnected(AndroidDeviceId id) {
    return _connectedDeviceIds.contains(id);
  }
}
