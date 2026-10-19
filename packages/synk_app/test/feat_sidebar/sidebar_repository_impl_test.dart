import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_sidebar/data/repositories/sidebar_repository.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device_state.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('SidebarRepository', () {
    late _FakeConnections connections;
    late SidebarRepository repository;

    setUp(() {
      connections = _FakeConnections();
      repository = SidebarRepository(connections);
    });

    tearDown(() async {
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
        connections.plug([device]);

        expect(await stateOf(device), const SidebarDeviceState.disconnected());
      },
    );

    test('mirrors a running connection attempt', () async {
      final device = _buildAndroidDevice('serial-2');
      connections.plug([device]);
      connections.emit({device.id: const DeviceConnectionState.connecting()});

      expect(await stateOf(device), const SidebarDeviceState.connecting());
    });

    test('mirrors an established connection', () async {
      final device = _buildAndroidDevice('serial-3');
      connections.plug([device]);
      connections.emit({device.id: const DeviceConnectionState.connected()});

      expect(await stateOf(device), const SidebarDeviceState.connected());
    });

    test('carries the failure of a failed attempt', () async {
      final device = _buildAndroidDevice('serial-4');
      connections.plug([device]);
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
      connections.plug([device]);

      expect(await stateOf(device), const SidebarDeviceState.unableToConnect());
    });

    test(
      'keeps an unauthorized device unable to connect despite a stale state',
      () async {
        final device = _buildAndroidDevice(
          'serial-6',
          state: AndroidDeviceState.unauthorized,
        );
        connections.plug([device]);
        connections.emit({device.id: const DeviceConnectionState.connected()});

        expect(
          await stateOf(device),
          const SidebarDeviceState.unableToConnect(),
        );
      },
    );

    test('lists every plugged device with its own state', () async {
      final androidDevice = _buildAndroidDevice('serial-7');
      final iosDevice = IosDevice(id: DeviceId('ios-1'), modelName: 'iPhone');
      connections.plug([androidDevice, iosDevice]);
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

class _FakeConnections implements DeviceConnectionsRepository {
  @override
  Stream<List<PluggedDevice>> observePluggedDevices() {
    return _devices;
  }

  final _states = BehaviorSubject.seeded(<DeviceId, DeviceConnectionState>{});
  final _devices = BehaviorSubject.seeded(<PluggedDevice>[]);

  void plug(List<PluggedDevice> devices) => _devices.add(devices);

  void emit(Map<DeviceId, DeviceConnectionState> states) => _states.add(states);

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return _states;
  }

  @override
  Future<void> dispose() async {
    await _states.close();
    await _devices.close();
  }

  @override
  Future<void> connect(PluggedDevice device) async {}

  @override
  Future<void> disconnect(PluggedDevice device) async {}

  @override
  bool isConnected(DeviceId id) => false;

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() {
    return const Stream.empty();
  }
}
