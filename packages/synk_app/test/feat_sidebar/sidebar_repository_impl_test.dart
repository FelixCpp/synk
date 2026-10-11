import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/domain/models/audio_agent.dart';
import 'package:synk/feat_device_agent/domain/models/clipboard_agent.dart';
import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_device_connections/domain/models/connection_failure.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_connection.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_state.dart';
import 'package:synk/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:synk/feat_plugged_devices/ios/domain/repositories/plugged_ios_devices_repository.dart';
import 'package:synk/feat_sidebar/data/repositories/sidebar_repository_impl.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('SidebarRepositoryImpl', () {
    late _FakeAdbDevices adbDevices;
    late _FakeIosDevices iosDevices;
    late _FakeConnections connections;
    late SidebarRepositoryImpl repository;

    setUp(() {
      adbDevices = _FakeAdbDevices();
      iosDevices = _FakeIosDevices();
      connections = _FakeConnections();
      repository = SidebarRepositoryImpl(connections, adbDevices, iosDevices);
    });

    tearDown(() async {
      await adbDevices.dispose();
      await iosDevices.dispose();
      await connections.dispose();
    });

    Future<SidebarDeviceState> stateOf(PluggedDevice device) async {
      final devices = await repository.observeDevices().first;
      return devices.singleWhere((entry) => entry.device == device).state;
    }

    test(
      'reports an authorized device without a connection as disconnected',
      () async {
        final device = _buildAndroidDevice('serial-1');
        adbDevices.emit([device]);

        expect(await stateOf(device), const SidebarDeviceState.disconnected());
      },
    );

    test('mirrors a running connection attempt', () async {
      final device = _buildAndroidDevice('serial-2');
      adbDevices.emit([device]);
      connections.emit({device.id: const DeviceConnectionState.connecting()});

      expect(await stateOf(device), const SidebarDeviceState.connecting());
    });

    test('mirrors an established connection', () async {
      final device = _buildAndroidDevice('serial-3');
      adbDevices.emit([device]);
      connections.emit({device.id: const DeviceConnectionState.connected()});

      expect(await stateOf(device), const SidebarDeviceState.connected());
    });

    test('carries the failure of a failed attempt', () async {
      final device = _buildAndroidDevice('serial-4');
      adbDevices.emit([device]);
      connections.emit({
        device.id: const DeviceConnectionState.failed(
          failure: ConnectionFailure.connectionRefused,
        ),
      });

      expect(
        await stateOf(device),
        const SidebarDeviceState.failedToConnect(
          failure: ConnectionFailure.connectionRefused,
        ),
      );
    });

    test('reports an unauthorized device as unable to connect', () async {
      final device = _buildAndroidDevice(
        'serial-5',
        state: AndroidDeviceState.unauthorized,
      );
      adbDevices.emit([device]);

      expect(await stateOf(device), const SidebarDeviceState.unableToConnect());
    });

    test(
      'keeps an unauthorized device unable to connect despite a stale state',
      () async {
        final device = _buildAndroidDevice(
          'serial-6',
          state: AndroidDeviceState.unauthorized,
        );
        adbDevices.emit([device]);
        connections.emit({device.id: const DeviceConnectionState.connected()});

        expect(
          await stateOf(device),
          const SidebarDeviceState.unableToConnect(),
        );
      },
    );

    test('lists Android and iOS devices together', () async {
      final androidDevice = _buildAndroidDevice('serial-7');
      final iosDevice = IosDevice(id: DeviceId('ios-1'), modelName: 'iPhone');
      adbDevices.emit([androidDevice]);
      iosDevices.emit([iosDevice]);
      connections.emit({
        iosDevice.id: const DeviceConnectionState.connecting(),
      });

      final devices = await repository.observeDevices().first;

      expect(devices, [
        SidebarDevice(
          device: androidDevice,
          state: const SidebarDeviceState.disconnected(),
        ),
        SidebarDevice(
          device: iosDevice,
          state: const SidebarDeviceState.connecting(),
        ),
      ]);
    });
  });
}

AndroidDevice _buildAndroidDevice(
  String id, {
  AndroidDeviceState state = AndroidDeviceState.device,
}) {
  return AndroidDevice(
    id: DeviceId(id),
    modelName: 'Pixel',
    state: state,
    connection: AndroidDeviceConnection.usb,
  );
}

class _FakeAdbDevices implements PluggedAdbDevicesRepository {
  final _devices = BehaviorSubject.seeded(<AndroidDevice>[]);

  void emit(List<AndroidDevice> devices) => _devices.add(devices);

  Future<void> dispose() => _devices.close();

  @override
  Stream<List<AndroidDevice>> observeAdbDevices() => _devices;
}

class _FakeIosDevices implements PluggedIosDevicesRepository {
  final _devices = BehaviorSubject.seeded(<IosDevice>[]);

  void emit(List<IosDevice> devices) => _devices.add(devices);

  Future<void> dispose() => _devices.close();

  @override
  Stream<List<IosDevice>> observeIosDevices() => _devices;
}

class _FakeConnections implements DeviceConnectionsRepository {
  final _states = BehaviorSubject.seeded(<DeviceId, DeviceConnectionState>{});

  void emit(Map<DeviceId, DeviceConnectionState> states) => _states.add(states);

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return _states;
  }

  @override
  Future<void> dispose() => _states.close();

  @override
  Future<void> toggleConnection(PluggedDevice device) async {}

  @override
  bool isConnected(DeviceId id) => false;

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() {
    return const Stream.empty();
  }

  @override
  AndroidDeviceAgent? getAndroidDeviceAgent(DeviceId id) => null;

  @override
  ScreenCaptureAgent? getScreenCaptureAgent(DeviceId id) => null;

  @override
  ClipboardAgent? getClipboardAgent(DeviceId id) => null;

  @override
  AudioAgent? getAudioAgent(DeviceId id) => null;

  @override
  InteractionAgent? getInteractionAgent(DeviceId id) => null;
}
