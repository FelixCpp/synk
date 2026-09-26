import 'dart:async';

import 'package:device_viewer/feat_device_agent/application/android_device_agent.dart';
import 'package:device_viewer/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/models/android_device_info.dart';
import 'package:device_viewer/feat_device_connections/domain/models/device_connection.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';
import 'package:rxdart/rxdart.dart';

class DeviceConnectionsRepositoryImpl({
  required final PluggedAdbDevicesRepository pluggedAdbDevicesRepository,
  required final DeviceAgentRepository agentRepository,
}) implements DeviceConnectionsRepository {
  final androidDeviceAgentsById = <DeviceId, AndroidDeviceAgent>{};
  final androidDeviceInfos = <DeviceId, AndroidDeviceInfo>{};
  final connectedIds = BehaviorSubject.seeded(<DeviceId>{});

  @override
  Future<void> dispose() async {
    await agentRepository.dispose();
  }

  @override
  Future<void> toggleConnection(AndroidDevice device) async {
    if (await isConnected(device.id)) {
      await disconnect(device);
    } else {
      await connect(device);
    }
  }

  @override
  Future<bool> isConnected(DeviceId id) async {
    return androidDeviceAgentsById.containsKey(id);
  }

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() {
    return Rx.combineLatest2(
      pluggedAdbDevicesRepository.observeAdbDevices(),
      connectedIds,
      (devices, ids) => (devices, ids),
    ).map((pair) {
      final (devices, ids) = pair;
      final devicesById = {for (final device in devices) device.id: device};

      return [
        for (final id in ids)
          if (devicesById[id] case final device?)
            if (androidDeviceAgentsById[id] case final agent?)
              DeviceConnection.android(
                device: device,
                info: androidDeviceInfos[id]!,
                textureId: agent.textureId,
              ),
      ];
    });
  }

  Future<void> connect(AndroidDevice device) async {
    if (androidDeviceAgentsById.containsKey(device.id)) {
      // TODO(Felix): Throw own exception type
      throw Exception('Device connection has already been established.');
    }

    final agent = await agentRepository.establishConnection(device.id);
    androidDeviceAgentsById[device.id] = agent;
    androidDeviceInfos[device.id] = await agent.fetchDeviceInfo();
    connectedIds.add(androidDeviceAgentsById.keys.toSet());
  }

  Future<void> disconnect(AndroidDevice device) async {
    await agentRepository.cutConnection(device.id);
    androidDeviceAgentsById.remove(device.id);
    androidDeviceInfos.remove(device.id);
    connectedIds.add(androidDeviceAgentsById.keys.toSet());
  }

  @override
  AndroidDeviceAgent? getAgent(DeviceId id) {
    return androidDeviceAgentsById[id];
  }
}
