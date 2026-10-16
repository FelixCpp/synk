import 'dart:async';

import 'package:synk/feat_device_platform/domain/models/camera_access_denied_exception.dart';
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
  final _sessionsById = <DeviceId, DeviceSession>{};
  final connectionStates = BehaviorSubject.seeded(
    <DeviceId, DeviceConnectionState>{},
  );

  var _platformsByDeviceId = <DeviceId, DevicePlatform>{};
  late final StreamSubscription<void> _discoverySubscription;

  this {
    _discoverySubscription = _observeDiscoveries().listen((discoveries) {
      _platformsByDeviceId = {
        for (final (:device, :platform) in discoveries) device.id: platform,
      };

      _forgetStatesOfAbsentDevices(_platformsByDeviceId.keys.toSet());
    });
  }

  @override
  Future<void> dispose() async {
    await _discoverySubscription.cancel();
    await connectionStates.close();

    for (final session in _sessionsById.values) {
      await session.dispose();
    }
    _sessionsById.clear();

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
    return _sessionsById.containsKey(id);
  }

  @override
  Stream<List<PluggedDevice>> observePluggedDevices() {
    return _observeDiscoveries().map(
      (discoveries) => [
        for (final discovery in discoveries) discovery.device,
      ],
    );
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
          if (_sessionsById[device.id] case final session?)
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

  Stream<List<_DeviceDiscovery>> _observeDiscoveries() {
    if (platforms.isEmpty) {
      return Stream.value(const []);
    }

    return Rx.combineLatestList([
      for (final platform in platforms) _observeDiscoveriesOf(platform),
    ]).map((perPlatform) => [for (final devices in perPlatform) ...devices]);
  }

  Stream<List<_DeviceDiscovery>> _observeDiscoveriesOf(
    DevicePlatform platform,
  ) {
    return platform.observeDevices().map(
      (devices) => [
        for (final device in devices) (device: device, platform: platform),
      ],
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
      final settings = await settingsRepository.read();
      final session = await platform.connect(device.id, settings.mirrorOptions);
      await session.audio?.setAudioMuted(settings.muteOnConnect);

      _sessionsById[device.id] = session;
      _setState(device.id, const DeviceConnectionState.connected());
    } on CameraAccessDeniedException {
      _setState(
        device.id,
        const DeviceConnectionState.failed(failure: .cameraAccessDenied),
      );
      rethrow;
    } catch (_) {
      _setState(
        device.id,
        const DeviceConnectionState.failed(failure: .unknown),
      );
      rethrow;
    }
  }

  Future<void> _disconnect(PluggedDevice device) async {
    await _sessionsById.remove(device.id)?.dispose();
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

typedef _DeviceDiscovery = ({
  PluggedDevice device,
  DevicePlatform platform,
});
