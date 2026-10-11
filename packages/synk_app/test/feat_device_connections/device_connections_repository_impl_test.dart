import 'dart:async';

import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/application/ios_device_agent.dart';
import 'package:synk/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:synk/feat_device_agent/domain/repositories/ios_device_agent_repository.dart';
import 'package:synk/feat_device_connections/data/repositories/device_connections_repository_impl.dart';
import 'package:synk/feat_device_connections/domain/models/connection_failure.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_connection.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_state.dart';
import 'package:synk/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:synk/feat_plugged_devices/ios/domain/repositories/plugged_ios_devices_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('DeviceConnectionsRepositoryImpl.toggleConnection', () {
    late _FakeAndroidAgentRepository androidAgentRepository;
    late _FakeIosAgentRepository iosAgentRepository;
    late DeviceConnectionsRepositoryImpl repository;

    setUp(() {
      androidAgentRepository = _FakeAndroidAgentRepository();
      iosAgentRepository = _FakeIosAgentRepository();
      repository = DeviceConnectionsRepositoryImpl(
        pluggedAdbDevicesRepository: const _FakeAdbDevices(),
        agentRepository: androidAgentRepository,
        pluggedIosDevicesRepository: const _FakeIosDevices(),
        iosAgentRepository: iosAgentRepository,
      );
    });

    test('dispatches an AndroidDevice to the Android agent repository', () async {
      final device = AndroidDevice(
        id: DeviceId('android-1'),
        modelName: 'Pixel',
        state: AndroidDeviceState.device,
        connection: AndroidDeviceConnection.usb,
      );

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<_AndroidMarkerException>()),
      );

      expect(androidAgentRepository.establishConnectionCalls, [device.id]);
      expect(iosAgentRepository.establishConnectionCalls, isEmpty);
    });

    test('dispatches an IosDevice to the iOS agent repository', () async {
      final device = IosDevice(id: DeviceId('ios-1'), modelName: 'iPhone');

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<_IosMarkerException>()),
      );

      expect(iosAgentRepository.establishConnectionCalls, [device.id]);
      expect(androidAgentRepository.establishConnectionCalls, isEmpty);
    });
  });
  group('DeviceConnectionsRepositoryImpl.observeConnectionStates', () {
    late _ControllablePluggedDevices devices;

    setUp(() {
      devices = _ControllablePluggedDevices();
    });

    tearDown(() async {
      await devices.dispose();
    });

    DeviceConnectionsRepositoryImpl buildRepository({
      DeviceAgentRepository? agentRepository,
    }) {
      return DeviceConnectionsRepositoryImpl(
        pluggedAdbDevicesRepository: _ControllableAdbDevices(devices),
        agentRepository: agentRepository ?? _FakeAndroidAgentRepository(),
        pluggedIosDevicesRepository: _ControllableIosDevices(devices),
        iosAgentRepository: _FakeIosAgentRepository(),
      );
    }

    test('reports a plugged device without an attempt as disconnected', () async {
      final repository = buildRepository();
      final device = _buildAndroidDevice('android-states-1');
      devices.androidDevices.add([device]);

      await expectLater(
        repository.observeConnectionStates(),
        emits({device.id: const DeviceConnectionState.disconnected()}),
      );

      await repository.dispose();
    });

    test('marks a device as connecting while the attempt is in flight', () async {
      final agentRepository = _HangingAgentRepository();
      final repository = buildRepository(agentRepository: agentRepository);
      final device = _buildAndroidDevice('android-states-2');
      devices.androidDevices.add([device]);

      final attempt = repository.toggleConnection(device);
      await pumpEventQueue();

      expect(
        repository.connectionStates.value[device.id],
        const DeviceConnectionState.connecting(),
      );

      agentRepository.establishConnectionCompleter.completeError(
        _AndroidMarkerException(),
      );
      await expectLater(attempt, throwsA(isA<_AndroidMarkerException>()));
      await repository.dispose();
    });

    test('classifies a refused agent connection', () async {
      final repository = buildRepository(
        agentRepository: _RefusingAgentRepository(),
      );
      final device = _buildAndroidDevice('android-states-3');
      devices.androidDevices.add([device]);

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<DeviceAgentAlreadyConnectedException>()),
      );

      expect(
        repository.connectionStates.value[device.id],
        const DeviceConnectionState.failed(
          failure: ConnectionFailure.connectionRefused,
        ),
      );

      await repository.dispose();
    });

    test('classifies an unexpected error as an unknown failure', () async {
      final repository = buildRepository();
      final device = _buildAndroidDevice('android-states-4');
      devices.androidDevices.add([device]);

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<_AndroidMarkerException>()),
      );

      expect(
        repository.connectionStates.value[device.id],
        const DeviceConnectionState.failed(
          failure: ConnectionFailure.unknown,
        ),
      );

      await repository.dispose();
    });

    test('forgets a failed attempt once the device is unplugged', () async {
      final repository = buildRepository();
      final device = _buildAndroidDevice('android-states-5');
      devices.androidDevices.add([device]);

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<_AndroidMarkerException>()),
      );
      expect(repository.connectionStates.value, contains(device.id));

      devices.androidDevices.add([]);
      await pumpEventQueue();

      expect(repository.connectionStates.value, isEmpty);

      await repository.dispose();
    });

    test('keeps a connecting device that vanishes from the device list', () async {
      final agentRepository = _HangingAgentRepository();
      final repository = buildRepository(agentRepository: agentRepository);
      final device = _buildAndroidDevice('android-states-6');
      devices.androidDevices.add([device]);

      final attempt = repository.toggleConnection(device);
      await pumpEventQueue();

      devices.androidDevices.add([]);
      await pumpEventQueue();

      expect(
        repository.connectionStates.value[device.id],
        const DeviceConnectionState.connecting(),
      );

      agentRepository.establishConnectionCompleter.completeError(
        _AndroidMarkerException(),
      );
      await expectLater(attempt, throwsA(isA<_AndroidMarkerException>()));
      await repository.dispose();
    });
  });
}

AndroidDevice _buildAndroidDevice(String id) {
  return AndroidDevice(
    id: DeviceId(id),
    modelName: 'Pixel',
    state: AndroidDeviceState.device,
    connection: AndroidDeviceConnection.usb,
  );
}
class _AndroidMarkerException implements Exception {}

class _IosMarkerException implements Exception {}

class _FakeAdbDevices implements PluggedAdbDevicesRepository {
  const _FakeAdbDevices();

  @override
  Stream<List<AndroidDevice>> observeAdbDevices() => const Stream.empty();
}

class _FakeIosDevices implements PluggedIosDevicesRepository {
  const _FakeIosDevices();

  @override
  Stream<List<IosDevice>> observeIosDevices() => const Stream.empty();
}

class _FakeAndroidAgentRepository implements DeviceAgentRepository {
  final establishConnectionCalls = <DeviceId>[];

  @override
  Future<void> dispose() async {}

  @override
  Future<AndroidDeviceAgent> establishConnection(DeviceId deviceId) async {
    establishConnectionCalls.add(deviceId);
    throw _AndroidMarkerException();
  }

  @override
  Future<void> cutConnection(DeviceId deviceId) async {}
}

class _FakeIosAgentRepository implements IosDeviceAgentRepository {
  final establishConnectionCalls = <DeviceId>[];

  @override
  Future<void> dispose() async {}

  @override
  Future<IosDeviceAgent> establishConnection(DeviceId deviceId) async {
    establishConnectionCalls.add(deviceId);
    throw _IosMarkerException();
  }

  @override
  Future<void> cutConnection(DeviceId deviceId) async {}
}

class _ControllablePluggedDevices {
  final androidDevices = BehaviorSubject.seeded(<AndroidDevice>[]);
  final iosDevices = BehaviorSubject.seeded(<IosDevice>[]);

  Future<void> dispose() async {
    await androidDevices.close();
    await iosDevices.close();
  }
}

class _ControllableAdbDevices(
  final _ControllablePluggedDevices devices,
) implements PluggedAdbDevicesRepository {
  @override
  Stream<List<AndroidDevice>> observeAdbDevices() => devices.androidDevices;
}

class _ControllableIosDevices(
  final _ControllablePluggedDevices devices,
) implements PluggedIosDevicesRepository {
  @override
  Stream<List<IosDevice>> observeIosDevices() => devices.iosDevices;
}

class _HangingAgentRepository implements DeviceAgentRepository {
  final establishConnectionCompleter = Completer<AndroidDeviceAgent>();

  @override
  Future<void> dispose() async {}

  @override
  Future<AndroidDeviceAgent> establishConnection(DeviceId deviceId) {
    return establishConnectionCompleter.future;
  }

  @override
  Future<void> cutConnection(DeviceId deviceId) async {}
}

class _RefusingAgentRepository implements DeviceAgentRepository {
  @override
  Future<void> dispose() async {}

  @override
  Future<AndroidDeviceAgent> establishConnection(DeviceId deviceId) async {
    throw DeviceAgentAlreadyConnectedException(deviceId: deviceId);
  }

  @override
  Future<void> cutConnection(DeviceId deviceId) async {}
}
