import 'dart:async';

import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/application/device_platform.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:rxdart/rxdart.dart';

class DeviceConnectionsRepositoryImpl({
  required final List<DevicePlatform> platforms,
}) implements DeviceConnectionsRepository {
  final agentsById = <DeviceId, DeviceAgent>{};
  final connectionStates = BehaviorSubject.seeded(
    <DeviceId, DeviceConnectionState>{},
  );
  final screenSizes = BehaviorSubject.seeded(<DeviceId, DeviceScreenSize>{});
  final screenSizeSubscriptions =
      <DeviceId, StreamSubscription<DeviceScreenSize>>{};

  var _platformsByDeviceId = <DeviceId, DevicePlatform>{};
  late final StreamSubscription<List<List<PluggedDevice>>>
  pluggedDeviceSubscription;

  this {
    pluggedDeviceSubscription = _observeDevicesPerPlatform().listen((
      devicesPerPlatform,
    ) {
      _platformsByDeviceId = {
        for (final (index, devices) in devicesPerPlatform.indexed)
          for (final device in devices) device.id: platforms[index],
      };

      _forgetStatesOfAbsentDevices(_platformsByDeviceId.keys.toSet());
    });
  }

  @override
  Future<void> dispose() async {
    await pluggedDeviceSubscription.cancel();
    for (final subscription in screenSizeSubscriptions.values) {
      await subscription.cancel();
    }
    screenSizeSubscriptions.clear();
    await screenSizes.close();
    await connectionStates.close();

    for (final agent in agentsById.values) {
      await agent.dispose();
    }
    agentsById.clear();

    for (final platform in platforms) {
      await platform.dispose();
    }
  }

  @override
  Future<void> toggleConnection(PluggedDevice device) async {
    await (isConnected(device.id) ? _disconnect(device) : _connect(device));
  }

  @override
  bool isConnected(DeviceId id) {
    return agentsById.containsKey(id);
  }

  @override
  DeviceAgent? getAgent(DeviceId id) {
    return agentsById[id];
  }

  @override
  Stream<List<PluggedDevice>> observePluggedDevices() {
    return _observeDevicesPerPlatform().map((devicesPerPlatform) {
      return [for (final devices in devicesPerPlatform) ...devices];
    });
  }

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return Rx.combineLatest2(
      observePluggedDevices(),
      connectionStates,
      (devices, states) => {
        for (final device in devices)
          device.id: states[device.id] ?? const .disconnected(),
      },
    );
  }

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() {
    return Rx.combineLatest3(
      observePluggedDevices(),
      connectionStates,
      screenSizes,
      (devices, states, sizes) => [
        for (final device in devices)
          if (states[device.id] is ConnectionStateConnected)
            ?_buildConnection(device, sizes),
      ],
    );
  }

  /// One list per entry of [platforms], in the same order.
  Stream<List<List<PluggedDevice>>> _observeDevicesPerPlatform() {
    if (platforms.isEmpty) {
      return Stream.value(const []);
    }

    return Rx.combineLatestList([
      for (final platform in platforms) platform.observeDevices(),
    ]);
  }

  DeviceConnection? _buildConnection(
    PluggedDevice device,
    Map<DeviceId, DeviceScreenSize> sizes,
  ) {
    final agent = agentsById[device.id];
    if (agent == null) {
      return null;
    }

    return DeviceConnection(
      device: device,
      textureId: agent.textureId,
      screenSize: sizes[device.id] ?? agent.screenSize,
      supportsInteraction: agent.interaction != null,
      supportsDeviceActions: agent.fileTransfer != null,
      supportsAudio: agent.audio != null,
    );
  }

  Future<void> _connect(PluggedDevice device) async {
    final platform = _platformsByDeviceId[device.id];
    if (platform == null) {
      throw DeviceNotPluggedException(deviceId: device.id);
    }

    _ensureIdle(device.id);
    _setState(device.id, const DeviceConnectionState.connecting());

    try {
      final agent = await platform.connect(device.id);
      agentsById[device.id] = agent;
      _watchScreenSize(device.id, agent);
      _setState(device.id, const DeviceConnectionState.connected());
    } catch (_) {
      _setState(
        device.id,
        const DeviceConnectionState.failed(failure: .unknown),
      );
      rethrow;
    }
  }

  Future<void> _disconnect(PluggedDevice device) async {
    await agentsById.remove(device.id)?.dispose();
    await screenSizeSubscriptions.remove(device.id)?.cancel();
    _forgetScreenSize(device.id);
    _setState(device.id, const DeviceConnectionState.disconnected());
  }

  void _ensureIdle(DeviceId id) {
    if (isConnected(id) ||
        connectionStates.value[id] is ConnectionStateConnecting) {
      throw DeviceAlreadyConnectingException(deviceId: id);
    }
  }

  void _setState(DeviceId id, DeviceConnectionState state) {
    connectionStates.add({...connectionStates.value, id: state});
  }

  void _forgetStatesOfAbsentDevices(Set<DeviceId> pluggedIds) {
    final states = connectionStates.value;
    final staleIds = {
      for (final entry in states.entries)
        if (!pluggedIds.contains(entry.key) && _isIdle(entry.value)) entry.key,
    };

    if (staleIds.isEmpty) {
      return;
    }

    connectionStates.add({
      for (final entry in states.entries)
        if (!staleIds.contains(entry.key)) entry.key: entry.value,
    });
  }

  bool _isIdle(DeviceConnectionState state) => switch (state) {
    ConnectionStateDisconnected() => true,
    ConnectionStateFailed() => true,
    ConnectionStateConnecting() => false,
    ConnectionStateConnected() => false,
  };

  void _watchScreenSize(DeviceId deviceId, DeviceAgent agent) {
    screenSizeSubscriptions[deviceId] = agent.screenSizeChanges.listen(
      (size) => screenSizes.add({...screenSizes.value, deviceId: size}),
    );
  }

  void _forgetScreenSize(DeviceId deviceId) {
    screenSizes.add({...screenSizes.value}..remove(deviceId));
  }
}
