import 'dart:async';

import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/application/ios_device_agent.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:synk/feat_device_agent/domain/repositories/ios_device_agent_repository.dart';
import 'package:synk/feat_device_connections/domain/models/android_device_info.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:synk/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:synk/feat_plugged_devices/ios/domain/models/ios_device.dart';
import 'package:synk/feat_plugged_devices/ios/domain/repositories/plugged_ios_devices_repository.dart';
import 'package:rxdart/rxdart.dart';

class DeviceConnectionsRepositoryImpl({
  required final PluggedAdbDevicesRepository pluggedAdbDevicesRepository,
  required final DeviceAgentRepository agentRepository,
  required final PluggedIosDevicesRepository pluggedIosDevicesRepository,
  required final IosDeviceAgentRepository iosAgentRepository,
}) implements DeviceConnectionsRepository {
  final androidDeviceAgentsById = <DeviceId, AndroidDeviceAgent>{};
  final androidDeviceInfos = <DeviceId, AndroidDeviceInfo>{};
  final iosDeviceAgentsById = <DeviceId, IosDeviceAgent>{};
  final connectedIds = BehaviorSubject.seeded(<DeviceId>{});
  final connectingIds = BehaviorSubject.seeded(<DeviceId>{});
  final screenSizes = BehaviorSubject.seeded(<DeviceId, DeviceScreenSize>{});
  final screenSizeSubscriptions =
      <DeviceId, StreamSubscription<DeviceScreenSize>>{};

  @override
  Future<void> dispose() async {
    for (final subscription in screenSizeSubscriptions.values) {
      await subscription.cancel();
    }
    screenSizeSubscriptions.clear();
    await screenSizes.close();
    await agentRepository.dispose();
    await iosAgentRepository.dispose();
  }

  @override
  Future<void> toggleConnection(PluggedDevice device) async {
    final isDeviceConnected = await isConnected(device.id);

    switch (device) {
      case AndroidDevice():
        await (isDeviceConnected ? _disconnectAndroid(device) : _connectAndroid(device));
      case IosDevice():
        await (isDeviceConnected ? _disconnectIos(device) : _connectIos(device));
      default:
        throw UnsupportedError('Unknown device type: $device');
    }
  }

  @override
  Future<bool> isConnected(DeviceId id) async {
    return androidDeviceAgentsById.containsKey(id) ||
        iosDeviceAgentsById.containsKey(id);
  }

  @override
  Stream<List<PluggedDevice>> observeConnectingDevices() {
    return Rx.combineLatest3(
      pluggedAdbDevicesRepository.observeAdbDevices(),
      pluggedIosDevicesRepository.observeIosDevices(),
      connectingIds,
      (androidDevices, iosDevices, ids) => (androidDevices, iosDevices, ids),
    ).map((tuple) {
      final (androidDevices, iosDevices, ids) = tuple;
      final devicesById = <DeviceId, PluggedDevice>{
        for (final device in androidDevices) device.id: device,
        for (final device in iosDevices) device.id: device,
      };

      return [
        for (final id in ids) ?devicesById[id],
      ];
    });
  }

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() {
    return Rx.combineLatest4(
      pluggedAdbDevicesRepository.observeAdbDevices(),
      pluggedIosDevicesRepository.observeIosDevices(),
      connectedIds,
      screenSizes,
      (androidDevices, iosDevices, ids, sizes) =>
          (androidDevices, iosDevices, ids, sizes),
    ).map((tuple) {
      final (androidDevices, iosDevices, ids, sizes) = tuple;
      final androidDevicesById = {
        for (final device in androidDevices) device.id: device,
      };
      final iosDevicesById = {
        for (final device in iosDevices) device.id: device,
      };

      return [
        for (final id in ids)
          ?_buildConnection(id, androidDevicesById, iosDevicesById, sizes),
      ];
    });
  }

  DeviceConnection? _buildConnection(
    DeviceId id,
    Map<DeviceId, AndroidDevice> androidDevicesById,
    Map<DeviceId, IosDevice> iosDevicesById,
    Map<DeviceId, DeviceScreenSize> sizes,
  ) {
    if (androidDevicesById[id] case final device?) {
      if (androidDeviceAgentsById[id] case final agent?) {
        return DeviceConnection.android(
          device: device,
          info: androidDeviceInfos[id]!,
          textureId: agent.textureId,
          screenSize: sizes[id] ?? agent.screenSize,
        );
      }
      return null;
    }

    if (iosDevicesById[id] case final device?) {
      if (iosDeviceAgentsById[id] case final agent?) {
        return DeviceConnection.ios(
          device: device,
          textureId: agent.textureId,
          screenSize: agent.screenSize,
        );
      }
    }

    return null;
  }

  Future<void> _connectAndroid(AndroidDevice device) async {
    if (androidDeviceAgentsById.containsKey(device.id) ||
        connectingIds.value.contains(device.id)) {
      throw DeviceAlreadyConnectingException(deviceId: device.id);
    }

    connectingIds.add({...connectingIds.value, device.id});
    try {
      final agent = await agentRepository.establishConnection(device.id);
      try {
        final info = await agent.fetchDeviceInfo();
        androidDeviceAgentsById[device.id] = agent;
        androidDeviceInfos[device.id] = info;
        _watchScreenSize(device.id, agent);
        _recomputeConnectedIds();
      } catch (_) {
        await agentRepository.cutConnection(device.id);
        rethrow;
      }
    } finally {
      connectingIds.add({...connectingIds.value}..remove(device.id));
    }
  }

  Future<void> _disconnectAndroid(AndroidDevice device) async {
    await agentRepository.cutConnection(device.id);
    androidDeviceAgentsById.remove(device.id);
    androidDeviceInfos.remove(device.id);
    await screenSizeSubscriptions.remove(device.id)?.cancel();
    _forgetScreenSize(device.id);
    _recomputeConnectedIds();
  }

  Future<void> _connectIos(IosDevice device) async {
    if (iosDeviceAgentsById.containsKey(device.id) ||
        connectingIds.value.contains(device.id)) {
      throw DeviceAlreadyConnectingException(deviceId: device.id);
    }

    connectingIds.add({...connectingIds.value, device.id});
    try {
      final agent = await iosAgentRepository.establishConnection(device.id);
      try {
        iosDeviceAgentsById[device.id] = agent;
        _recomputeConnectedIds();
      } catch (_) {
        await iosAgentRepository.cutConnection(device.id);
        rethrow;
      }
    } finally {
      connectingIds.add({...connectingIds.value}..remove(device.id));
    }
  }

  Future<void> _disconnectIos(IosDevice device) async {
    await iosAgentRepository.cutConnection(device.id);
    iosDeviceAgentsById.remove(device.id);
    _recomputeConnectedIds();
  }

  void _watchScreenSize(DeviceId deviceId, AndroidDeviceAgent agent) {
    screenSizeSubscriptions[deviceId] = agent.screenSizeChanges.listen(
      (size) => screenSizes.add({...screenSizes.value, deviceId: size}),
    );
  }

  void _forgetScreenSize(DeviceId deviceId) {
    screenSizes.add({...screenSizes.value}..remove(deviceId));
  }

  void _recomputeConnectedIds() {
    connectedIds.add({
      ...androidDeviceAgentsById.keys,
      ...iosDeviceAgentsById.keys,
    });
  }

  @override
  AndroidDeviceAgent? getAndroidDeviceAgent(DeviceId id) {
    return androidDeviceAgentsById[id];
  }

  @override
  IosDeviceAgent? getIosDeviceAgent(DeviceId id) {
    return iosDeviceAgentsById[id];
  }

  @override
  ScreenCaptureAgent? getScreenCaptureAgent(DeviceId id) {
    return androidDeviceAgentsById[id] ?? iosDeviceAgentsById[id];
  }
}
