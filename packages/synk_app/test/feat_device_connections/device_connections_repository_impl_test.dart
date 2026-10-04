import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/application/ios_device_agent.dart';
import 'package:synk/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:synk/feat_device_agent/domain/repositories/ios_device_agent_repository.dart';
import 'package:synk/feat_device_connections/data/repositories/device_connections_repository_impl.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_connection.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_state.dart';
import 'package:synk/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/ios/domain/models/ios_device.dart';
import 'package:synk/feat_plugged_devices/ios/domain/repositories/plugged_ios_devices_repository.dart';
import 'package:flutter_test/flutter_test.dart';

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
