import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device.dart';
import 'package:synk/feat_maximized_device/presentation/maximized_device_watch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

import '../support/fake_device_session.dart';

void main() {
  group('MaximizedDeviceWatch.observeDevice', () {
    late _FakeConnections connections;
    late MaximizedDeviceWatch repository;

    setUp(() {
      connections = _FakeConnections();
      repository = MaximizedDeviceWatch(
        connectionsRepository: connections,
      );
    });

    tearDown(() async {
      await connections.dispose();
    });

    test('follows the connection of the maximized device', () async {
      final iphone = _connection('ios-1');
      connections.emit([_connection('ios-2'), iphone]);

      expect(await repository.observe(iphone.device.id).first, iphone);
    });

    test('reports the device as gone once it is disconnected', () async {
      final iphone = _connection('ios-1');
      final other = _connection('ios-2');
      connections.emit([iphone, other]);

      final seen = <DeviceConnection?>[];
      final subscription = repository
          .observe(iphone.device.id)
          .listen(seen.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      connections.emit([other]);
      await pumpEventQueue();

      expect(seen, [iphone, null]);
    });

    test('stays quiet while only other devices change', () async {
      final iphone = _connection('ios-1');
      connections.emit([iphone]);

      final seen = <DeviceConnection?>[];
      final subscription = repository
          .observe(iphone.device.id)
          .listen(seen.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      connections.emit([iphone, _connection('ios-2')]);
      await pumpEventQueue();

      expect(seen, [iphone]);
    });
  });
}

DeviceConnection _connection(String id) {
  return DeviceConnection(
    device: IosDevice(id: DeviceId(id), modelName: 'iPhone'),
    session: FakeDeviceSession(),
    screenSize: const DeviceScreenSize(width: 1179, height: 2556),
  );
}

class _FakeConnections implements DeviceConnectionsRepository {
  final _connections = BehaviorSubject.seeded(<DeviceConnection>[]);

  void emit(List<DeviceConnection> connections) {
    _connections.add(connections);
  }

  @override
  Future<void> dispose() => _connections.close();

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() => _connections;

  @override
  Stream<List<PluggedDevice>> observePluggedDevices() {
    return Stream.value(const []);
  }

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return Stream.value(const {});
  }

  @override
  Future<void> connect(PluggedDevice device) async {}

  @override
  Future<void> disconnect(PluggedDevice device) async {}

  @override
  bool isConnected(DeviceId id) => false;
}
