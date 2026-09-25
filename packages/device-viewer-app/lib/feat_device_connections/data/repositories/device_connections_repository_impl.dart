import 'dart:async';

import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';

class DeviceConnectionsRepositoryImpl({
  required final AdbApi api,
}) implements DeviceConnectionsRepository {
  @override
  Future<void> dispose() async {}

  @override
  Future<void> toggleConnection(AndroidDevice device) async {
    if (await isConnected(device.id)) {
      await disconnect(device);
    } else {
      await connect(device);
    }
  }

  @override
  Future<bool> isConnected(AndroidDeviceId id) async {
    return false;
  }

  @override
  Stream<Set<AndroidDeviceId>> observeConnectedDeviceIds() {
    return Stream.value(const {});
  }

  Future<void> connect(AndroidDevice device) async {
    final adbConnection = api.connect(device);
    final session = adbSessionBootstrapper.createSession(adbConnection);
  }

  Future<void> disconnect(AndroidDevice device) async {}
}
