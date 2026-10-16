import 'dart:async';

import 'package:synk/feat_device_platform/domain/models/camera_access_denied_exception.dart';
import 'package:synk/feat_device_platform/domain/models/device_setup_exception.dart';
import 'package:synk/feat_device_connections/data/repositories/device_connections_repository_impl.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_device_session.dart';
import '../support/fake_device_platform.dart';
import '../support/fake_settings_repository.dart';

void main() {
  late FakePlatform android;
  late FakePlatform ios;
  late FakeSettingsRepository settings;
  late DeviceConnectionsRepositoryImpl repository;

  setUp(() {
    android = FakePlatform();
    ios = FakePlatform();
    settings = FakeSettingsRepository();
    repository = DeviceConnectionsRepositoryImpl(
      platforms: [android, ios],
      settingsRepository: settings,
    );
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
      final empty = DeviceConnectionsRepositoryImpl(
        platforms: const [],
        settingsRepository: FakeSettingsRepository(),
      );
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
      final connecting = Completer<DeviceSession>();
      android.onConnect = (_) => connecting.future;
      final device = await plugInto(android, 'android-1');

      final attempt = repository.toggleConnection(device);
      await pumpEventQueue();

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<DeviceAlreadyConnectingException>()),
      );

      connecting.complete(FakeDeviceSession());
      await attempt;
    });

    test('disconnects a connected device by disposing its session', () async {
      final session = FakeDeviceSession();
      android.onConnect = (_) async => session;
      final device = await plugInto(android, 'android-1');

      await repository.toggleConnection(device);
      expect(repository.isConnected(device.id), isTrue);

      await repository.toggleConnection(device);

      expect(session.isDisposed, isTrue);
      expect(repository.isConnected(device.id), isFalse);
      expect(
        repository.connectionStates.value[device.id],
        const DeviceConnectionState.disconnected(),
      );
    });
  });

  group('DeviceConnectionsRepositoryImpl.observeDeviceConnections', () {
    test('offers what the session of a connection can do', () async {
      final session = FakeDeviceSession(interaction: _HomeOnlyInteraction());
      android.onConnect = (_) async => session;
      final device = await plugInto(android, 'android-1');

      await repository.toggleConnection(device);
      final connection =
          (await repository.observeDeviceConnections().first).single;

      expect(connection.device, device);
      expect(connection.session, session);
      expect(connection.supportsInteraction, isTrue);
      expect(connection.supportsAudio, isFalse);
      expect(connection.navigations, {DeviceNavigation.home});
      expect(connection.supportsFileTransfer, isFalse);
    });

    test('follows the screen size of a connected device', () async {
      final session = FakeDeviceSession(
        screenSize: const DeviceScreenSize(width: 1080, height: 2400),
      );
      android.onConnect = (_) async => session;
      final device = await plugInto(android, 'android-1');
      await repository.toggleConnection(device);

      session.screenSizes.add(
        const DeviceScreenSize(width: 2400, height: 1080),
      );
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
        final connecting = Completer<DeviceSession>();
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

    test('marks a denied camera access as such', () async {
      android.onConnect = (_) async =>
          throw const CameraAccessDeniedException();
      final device = await plugInto(android, 'android-states-5');

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<CameraAccessDeniedException>()),
      );

      expect(
        repository.connectionStates.value[device.id],
        const DeviceConnectionState.failed(
          failure: ConnectionFailure.cameraAccessDenied,
        ),
      );
    });

    test('marks a device that is not set up as such', () async {
      android.onConnect = (_) async => throw const DeviceSetupException(
        problem: .developerModeDisabled,
      );
      final device = await plugInto(android, 'android-states-setup');

      await expectLater(
        () => repository.toggleConnection(device),
        throwsA(isA<DeviceSetupException>()),
      );

      expect(
        repository.connectionStates.value[device.id],
        const DeviceConnectionState.failed(
          failure: ConnectionFailure.developerModeDisabled,
        ),
      );
    });

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
        final connecting = Completer<DeviceSession>();
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

  group('DeviceConnectionsRepositoryImpl mirror options', () {
    test('hands the stored options to the platform it connects', () async {
      settings.update(
        (it) => it.copyWith(
          frameRate: MirrorFrameRate.fps30,
          quality: MirrorQuality.high,
          turnDeviceScreenOff: true,
        ),
      );
      final pixel = await plugInto(android, 'android-1');

      await repository.toggleConnection(pixel);

      final options = android.connectOptions.single;
      expect(options.maxFps, 30);
      expect(options.videoBitRate, MirrorQuality.high.videoBitRate);
      expect(options.turnDeviceScreenOff, isTrue);
    });

    test('re-reads them for every connect', () async {
      final pixel = await plugInto(android, 'android-1');

      settings.update((it) => it.copyWith(frameRate: MirrorFrameRate.fps30));
      await repository.toggleConnection(pixel);
      await repository.toggleConnection(pixel);

      settings.update((it) => it.copyWith(frameRate: MirrorFrameRate.fps60));
      await repository.toggleConnection(pixel);

      expect(
        android.connectOptions.map((options) => options.maxFps),
        [30, 60],
      );
    });
  });

  group('DeviceConnectionsRepositoryImpl connect-time audio', () {
    Future<FakeAudio> connectWith({required bool muteOnConnect}) async {
      final audio = FakeAudio()..isAudioMuted = false;
      android.onConnect = (_) async => FakeDeviceSession(audio: audio);
      settings.update((it) => it.copyWith(muteOnConnect: muteOnConnect));
      final pixel = await plugInto(android, 'android-1');

      await repository.toggleConnection(pixel);

      return audio;
    }

    test('mutes a fresh session when the preference asks for it', () async {
      expect((await connectWith(muteOnConnect: true)).isAudioMuted, isTrue);
    });

    test('leaves it audible when it does not', () async {
      expect((await connectWith(muteOnConnect: false)).isAudioMuted, isFalse);
    });
  });

  group('DeviceConnectionsRepositoryImpl.dispose', () {
    test('disposes the connected sessions and the platforms', () async {
      final session = FakeDeviceSession();
      final platform = FakePlatform(onConnect: (_) async => session);
      final repository = DeviceConnectionsRepositoryImpl(
        platforms: [platform],
        settingsRepository: FakeSettingsRepository(),
      );
      final device = _buildDevice('android-1');
      platform.plug([device]);
      await pumpEventQueue();
      await repository.toggleConnection(device);

      await repository.dispose();

      expect(session.isDisposed, isTrue);
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

class _HomeOnlyInteraction implements DeviceInteraction {
  @override
  Set<DeviceNavigation> get supportedNavigations => const {.home};

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
