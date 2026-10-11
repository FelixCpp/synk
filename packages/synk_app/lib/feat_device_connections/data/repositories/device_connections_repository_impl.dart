import 'dart:async';

import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/application/ios_device_agent.dart';
import 'package:synk/feat_device_agent/domain/models/audio_agent.dart';
import 'package:synk/feat_device_agent/domain/models/clipboard_agent.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:synk/feat_device_agent/domain/repositories/ios_device_agent_repository.dart';
import 'package:synk/feat_device_connections/domain/models/android_device_info.dart';
import 'package:synk/feat_device_connections/domain/models/connection_failure.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
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
  final connectionStates = BehaviorSubject.seeded(
    <DeviceId, DeviceConnectionState>{},
  );
  final screenSizes = BehaviorSubject.seeded(<DeviceId, DeviceScreenSize>{});
  final screenSizeSubscriptions =
      <DeviceId, StreamSubscription<DeviceScreenSize>>{};
  late final StreamSubscription<Set<DeviceId>> pluggedDeviceSubscription;

  this {
    pluggedDeviceSubscription = _observePluggedDeviceIds().listen(
      _forgetStatesOfAbsentDevices,
    );
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
    await agentRepository.dispose();
    await iosAgentRepository.dispose();
  }

  @override
  Future<void> toggleConnection(PluggedDevice device) async {
    final isDeviceConnected = isConnected(device.id);

    switch (device) {
      case AndroidDevice():
        await (isDeviceConnected
            ? _disconnectAndroid(device)
            : _connectAndroid(device));
      case IosDevice():
        await (isDeviceConnected
            ? _disconnectIos(device)
            : _connectIos(device));
    }
  }

  @override
  bool isConnected(DeviceId id) {
    if (androidDeviceAgentsById.containsKey(id)) {
      return true;
    }

    if (iosDeviceAgentsById.containsKey(id)) {
      return true;
    }

    return false;
  }

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return Rx.combineLatest3(
      pluggedAdbDevicesRepository.observeAdbDevices(),
      pluggedIosDevicesRepository.observeIosDevices(),
      connectionStates,
      (androidDevices, iosDevices, states) => {
        for (final device in _pluggedDevices(androidDevices, iosDevices))
          device.id: states[device.id] ?? const .disconnected(),
      },
    );
  }

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() {
    return Rx.combineLatest4(
      pluggedAdbDevicesRepository.observeAdbDevices(),
      pluggedIosDevicesRepository.observeIosDevices(),
      connectionStates,
      screenSizes,
      (androidDevices, iosDevices, states, sizes) => [
        for (final device in _pluggedDevices(androidDevices, iosDevices))
          if (states[device.id] is ConnectionStateConnected)
            ?_buildConnection(device, sizes),
      ],
    );
  }

  Stream<Set<DeviceId>> _observePluggedDeviceIds() {
    return Rx.combineLatest2(
      pluggedAdbDevicesRepository.observeAdbDevices(),
      pluggedIosDevicesRepository.observeIosDevices(),
      (androidDevices, iosDevices) => {
        for (final device in _pluggedDevices(androidDevices, iosDevices))
          device.id,
      },
    );
  }

  List<PluggedDevice> _pluggedDevices(
    List<AndroidDevice> androidDevices,
    List<IosDevice> iosDevices,
  ) {
    return [...androidDevices, ...iosDevices];
  }

  DeviceConnection? _buildConnection(
    PluggedDevice device,
    Map<DeviceId, DeviceScreenSize> sizes,
  ) {
    if (androidDeviceAgentsById[device.id] case final agent?) {
      return DeviceConnection.android(
        device: device,
        info: androidDeviceInfos[device.id]!,
        textureId: agent.textureId,
        screenSize: sizes[device.id] ?? agent.screenSize,
        supportsInteraction: true,
        supportsAudio: true,
      );
    }

    if (iosDeviceAgentsById[device.id] case final agent?) {
      return DeviceConnection.ios(
        device: device,
        textureId: agent.textureId,
        screenSize: sizes[device.id] ?? agent.screenSize,
        supportsInteraction: agent.supportsInteraction,
        supportsAudio: agent.supportsAudio,
      );
    }

    return null;
  }

  Future<void> _connectAndroid(AndroidDevice device) async {
    _ensureIdle(device.id);
    _setState(device.id, const DeviceConnectionState.connecting());

    try {
      final agent = await agentRepository.establishConnection(device.id);
      try {
        final info = await agent.fetchAndroidDeviceInfo();
        androidDeviceAgentsById[device.id] = agent;
        androidDeviceInfos[device.id] = info;
        _watchScreenSize(device.id, agent);
        _setState(device.id, const DeviceConnectionState.connected());
      } catch (_) {
        await agentRepository.cutConnection(device.id);
        rethrow;
      }
    } catch (error) {
      _setState(
        device.id,
        DeviceConnectionState.failed(failure: _failureOf(error)),
      );
      rethrow;
    }
  }

  Future<void> _disconnectAndroid(AndroidDevice device) async {
    await agentRepository.cutConnection(device.id);
    androidDeviceAgentsById.remove(device.id);
    androidDeviceInfos.remove(device.id);
    await screenSizeSubscriptions.remove(device.id)?.cancel();
    _forgetScreenSize(device.id);
    _setState(device.id, const DeviceConnectionState.disconnected());
  }

  Future<void> _connectIos(IosDevice device) async {
    _ensureIdle(device.id);
    _setState(device.id, const DeviceConnectionState.connecting());

    try {
      final agent = await iosAgentRepository.establishConnection(device.id);
      try {
        iosDeviceAgentsById[device.id] = agent;
        _watchScreenSize(device.id, agent);
        _setState(device.id, const DeviceConnectionState.connected());
      } catch (_) {
        await iosAgentRepository.cutConnection(device.id);
        rethrow;
      }
    } catch (error) {
      _setState(
        device.id,
        DeviceConnectionState.failed(failure: _failureOf(error)),
      );
      rethrow;
    }
  }

  Future<void> _disconnectIos(IosDevice device) async {
    await iosAgentRepository.cutConnection(device.id);
    iosDeviceAgentsById.remove(device.id);
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

  ConnectionFailure _failureOf(Object error) => switch (error) {
    DeviceAgentAlreadyConnectedException() =>
      ConnectionFailure.connectionRefused,
    DeviceAgentNotConnectedException() => ConnectionFailure.connectionRefused,
    _ => ConnectionFailure.unknown,
  };

  void _watchScreenSize(DeviceId deviceId, ScreenCaptureAgent agent) {
    screenSizeSubscriptions[deviceId] = agent.screenSizeChanges.listen(
      (size) => screenSizes.add({...screenSizes.value, deviceId: size}),
    );
  }

  void _forgetScreenSize(DeviceId deviceId) {
    screenSizes.add({...screenSizes.value}..remove(deviceId));
  }

  @override
  AndroidDeviceAgent? getAndroidDeviceAgent(DeviceId id) {
    return androidDeviceAgentsById[id];
  }

  @override
  ScreenCaptureAgent? getScreenCaptureAgent(DeviceId id) {
    return androidDeviceAgentsById[id] ?? iosDeviceAgentsById[id];
  }

  @override
  ClipboardAgent? getClipboardAgent(DeviceId id) {
    return androidDeviceAgentsById[id] ?? iosDeviceAgentsById[id];
  }

  @override
  AudioAgent? getAudioAgent(DeviceId id) {
    if (androidDeviceAgentsById[id] case final agent?) {
      return agent;
    }

    // A mirrored iOS device only carries audio over the CoreDevice media
    // stream; the capture-session fallback has nothing to mute.
    final agent = iosDeviceAgentsById[id];
    if (agent == null || !agent.supportsAudio) {
      return null;
    }

    return agent;
  }

  @override
  InteractionAgent? getInteractionAgent(DeviceId id) {
    if (androidDeviceAgentsById[id] case final agent?) {
      return agent;
    }

    final agent = iosDeviceAgentsById[id];
    if (agent == null || !agent.supportsInteraction) {
      return null;
    }

    return agent;
  }
}
