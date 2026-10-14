import 'dart:async';

import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/application/device_platform.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:rxdart/rxdart.dart';

class DeviceConnectionsRepositoryImpl({
  required final List<DevicePlatform> platforms,
  required final SettingsRepository settingsRepository,
}) implements DeviceConnectionsRepository {
  final sessionsById = <DeviceId, DeviceSession>{};
  final connectionStates = BehaviorSubject.seeded(
    <DeviceId, DeviceConnectionState>{},
  );

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
    await connectionStates.close();

    for (final session in sessionsById.values) {
      await session.dispose();
    }
    sessionsById.clear();

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
    return sessionsById.containsKey(id);
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
    return Rx.combineLatest2(
      observePluggedDevices(),
      connectionStates,
      (devices, states) => [
        for (final device in devices)
          if (sessionsById[device.id] case final session?)
            _observeConnection(device, session),
      ],
    ).switchMap((connections) {
      if (connections.isEmpty) {
        return Stream.value(const []);
      }

      return Rx.combineLatestList(connections);
    });
  }

  Stream<DeviceConnection> _observeConnection(
    PluggedDevice device,
    DeviceSession session,
  ) {
    return session.screenSizeChanges.map((screenSize) {
      return DeviceConnection(
        device: device,
        session: session,
        screenSize: screenSize,
      );
    });
  }

  Stream<List<List<PluggedDevice>>> _observeDevicesPerPlatform() {
    if (platforms.isEmpty) {
      return Stream.value(const []);
    }

    return Rx.combineLatestList([
      for (final platform in platforms) platform.observeDevices(),
    ]);
  }

  Future<void> _connect(PluggedDevice device) async {
    final platform = _platformsByDeviceId[device.id];
    if (platform == null) {
      throw DeviceNotPluggedException(deviceId: device.id);
    }

    _ensureIdle(device.id);
    _setState(device.id, const DeviceConnectionState.connecting());

    try {
      final settings = await settingsRepository.read();
      final session = await platform.connect(device.id, settings.mirrorOptions);
      await session.audio?.setAudioMuted(settings.muteOnConnect);

      sessionsById[device.id] = session;
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
    await sessionsById.remove(device.id)?.dispose();
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

  bool _isIdle(DeviceConnectionState state) {
    return state.map(
      disconnected: (_) => true,
      connecting: (_) => false,
      connected: (_) => false,
      failed: (_) => true,
    );
  }
}
