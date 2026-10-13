import 'dart:async';

import 'package:synk/feat_device_connections/data/repositories/device_connections_repository_impl.dart';
import 'package:synk/feat_device_connections/domain/models/connection_failure.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_platform/application/agents/interaction_device_agent.dart';
import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device_connection.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device_state.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_device_agent.dart';
import '../support/fake_device_platform.dart';

void main() {
  late FakePlatform android;
  late FakePlatform ios;
  late DeviceConnectionsRepositoryImpl repository;

  setUp(() {
    android = FakePlatform();
    ios = FakePlatform();
    repository = DeviceConnectionsRepositoryImpl(platforms: [android, ios]);
  });

  tearDown(() async {
    await repository.dispose();
  });

  Future<PluggedDevice> plugInto(FakePlatform platform, String id) async {
    final device = _buildDevice(id);
    platform.plug([device]);
    await pumpEventQueue();

    return device;
  }

  group('DeviceConnectionsRepositoryImpl.observePluggedDevices', () {
    test('lists the devices of every platform', () async {
      final pixel = await plugInto(android, 'android-1');
      final iphone = await plugInto(ios, 'ios-1');

      expect(await repository.observePluggedDevices().first, [pixel, iphone]);
    });

    test('lists nothing without any platform', () async {
      final empty = DeviceConnectionsRepositoryImpl(platforms: const []);
      addTearDown(empty.dispose);

      expect(await empty.observePluggedDevices().first, isEmpty);
    });
  });

  group('DeviceConnectionsRepositoryImpl.toggleConnection', () {
    test('connects a device through the platform that reported it', () async {
      final pixel = await plugInto(android, 'android-1');
      final iphone = await plugInto(ios, 'ios-1');

      await repository.toggleConnection(iphone);

      expect(ios.connectCalls, [iphone.id]);
      expect(android.connectCalls, isEmpty);

      await repository.toggleConnection(pixel);

      expect(android.connectCalls, [pixel.id]);
    });

    test('refuses a device no platform has reported', () async {
      await expectLater(
        () => repository.toggleConnection(_buildDevice('unknown-1')),
        throwsA(isA<DeviceNotPluggedException>()),
      );
    });

    test('refuses a second attempt while one is in flight', () async {
      final connecting = Completer<DeviceAgent>();
      android.onConnect = (_) => connecting.future;
      final device = await plugInto(android, 'android-1');

      final attempt = repository.toggleConnection(device);
      await pumpEventQueue();

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<DeviceAlreadyConnectingException>()),
      );

      connecting.complete(FakeDeviceAgent());
      await attempt;
    });

    test('disconnects a connected device by disposing its agent', () async {
      final agent = FakeDeviceAgent();
      android.onConnect = (_) async => agent;
      final device = await plugInto(android, 'android-1');

      await repository.toggleConnection(device);
      expect(repository.isConnected(device.id), isTrue);
      expect(repository.getAgent(device.id), agent);

      await repository.toggleConnection(device);

      expect(agent.isDisposed, isTrue);
      expect(repository.isConnected(device.id), isFalse);
      expect(repository.getAgent(device.id), isNull);
      expect(
        repository.connectionStates.value[device.id],
        const DeviceConnectionState.disconnected(),
      );
    });
  });

  group('DeviceConnectionsRepositoryImpl.observeDeviceConnections', () {
    test('offers what the agent of a connection can do', () async {
      android.onConnect = (_) async => FakeDeviceAgent(
        interaction: _NoInteraction(),
      );
      final device = await plugInto(android, 'android-1');

      await repository.toggleConnection(device);
      final connection =
          (await repository.observeDeviceConnections().first).single;

      expect(connection.device, device);
      expect(connection.supportsInteraction, isTrue);
      expect(connection.supportsAudio, isFalse);
      expect(connection.supportsDeviceActions, isFalse);
    });

    test('follows the screen size of a connected device', () async {
      final agent = FakeDeviceAgent(
        screenSize: const DeviceScreenSize(width: 1080, height: 2400),
      );
      android.onConnect = (_) async => agent;
      final device = await plugInto(android, 'android-1');
      await repository.toggleConnection(device);

      agent.screenSizes.add(const DeviceScreenSize(width: 2400, height: 1080));
      await pumpEventQueue();

      final connection =
          (await repository.observeDeviceConnections().first).single;

      expect(
        connection.screenSize,
        const DeviceScreenSize(width: 2400, height: 1080),
      );
    });
  });

  group('DeviceConnectionsRepositoryImpl.observeConnectionStates', () {
    test(
      'reports a plugged device without an attempt as disconnected',
      () async {
        final device = await plugInto(android, 'android-states-1');

        await expectLater(
          repository.observeConnectionStates(),
          emits({device.id: const DeviceConnectionState.disconnected()}),
        );
      },
    );

    test(
      'marks a device as connecting while the attempt is in flight',
      () async {
        final connecting = Completer<DeviceAgent>();
        android.onConnect = (_) => connecting.future;
        final device = await plugInto(android, 'android-states-2');

        final attempt = repository.toggleConnection(device);
        await pumpEventQueue();

        expect(
          repository.connectionStates.value[device.id],
          const DeviceConnectionState.connecting(),
        );

        connecting.completeError(_MarkerException());
        await expectLater(attempt, throwsA(isA<_MarkerException>()));
      },
    );

    test('marks a failed attempt and passes the error on', () async {
      android.onConnect = (_) async => throw _MarkerException();
      final device = await plugInto(android, 'android-states-4');

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<_MarkerException>()),
      );

      expect(
        repository.connectionStates.value[device.id],
        const DeviceConnectionState.failed(
          failure: ConnectionFailure.unknown,
        ),
      );
      expect(repository.isConnected(device.id), isFalse);
    });

    test('forgets a failed attempt once the device is unplugged', () async {
      android.onConnect = (_) async => throw _MarkerException();
      final device = await plugInto(android, 'android-states-5');

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<_MarkerException>()),
      );
      expect(repository.connectionStates.value, contains(device.id));

      android.plug([]);
      await pumpEventQueue();

      expect(repository.connectionStates.value, isEmpty);
    });

    test(
      'keeps a connecting device that vanishes from the device list',
      () async {
        final connecting = Completer<DeviceAgent>();
        android.onConnect = (_) => connecting.future;
        final device = await plugInto(android, 'android-states-6');

        final attempt = repository.toggleConnection(device);
        await pumpEventQueue();

        android.plug([]);
        await pumpEventQueue();

        expect(
          repository.connectionStates.value[device.id],
          const DeviceConnectionState.connecting(),
        );

        connecting.completeError(_MarkerException());
        await expectLater(attempt, throwsA(isA<_MarkerException>()));
      },
    );
  });

  group('DeviceConnectionsRepositoryImpl.dispose', () {
    test('disposes the connected agents and the platforms', () async {
      final agent = FakeDeviceAgent();
      final platform = FakePlatform(onConnect: (_) async => agent);
      final repository = DeviceConnectionsRepositoryImpl(
        platforms: [platform],
      );
      final device = _buildDevice('android-1');
      platform.plug([device]);
      await pumpEventQueue();
      await repository.toggleConnection(device);

      await repository.dispose();

      expect(agent.isDisposed, isTrue);
      expect(platform.isDisposed, isTrue);
    });
  });
}

AndroidDevice _buildDevice(String id) {
  return AndroidDevice(
    id: DeviceId(id),
    modelName: 'Pixel',
    state: AndroidDeviceState.device,
    connection: AndroidDeviceConnection.usb,
  );
}

class _MarkerException implements Exception {}

class _NoInteraction implements InteractionDeviceAgent {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
