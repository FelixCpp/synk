import 'dart:async';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device_discovery_channel.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_network_device_discovery.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device_dto.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hid_channel.dart';
import 'package:synk/feat_device_platform_ios/ios_device_platform.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_media_stream_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_channel.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file/memory.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_setup_exception.dart';
import 'package:synk/feat_device_platform/domain/models/mirror_options.dart';

import '../support/fake_process_manager.dart';

void main() {
  group('IosDevicePlatform.observeDevices', () {
    test(
      'hands a late listener the devices that are already plugged in',
      () async {
        final frames = StreamController<List<IosDeviceDto>>();
        addTearDown(frames.close);

        final platform = IosDevicePlatform(
          discoveryChannel: _FakeIosDeviceDiscoveryChannel(frames.stream),
          networkDiscovery: _FakeNetworkDiscovery(Stream.value(const [])),
          channel: IosMirrorChannel(),
          mediaStreamChannel: IosMediaStreamChannel(),
          hidChannel: IosHidChannel(),
          devicectl: DevicectlApi(),
          fileSystem: MemoryFileSystem(),
        );

        final seenByFirst = <List<PluggedDevice>>[];
        final first = platform.observeDevices().listen(seenByFirst.add);
        addTearDown(first.cancel);

        frames.add(const [_pluggedDevice]);
        await pumpEventQueue();

        expect(seenByFirst, hasLength(1));

        final seenByLate = await platform.observeDevices().first.timeout(
          const Duration(seconds: 1),
        );

        expect(seenByLate.single, isA<IosDevice>());
        expect(seenByLate.single.id, _pluggedDevice.serialNumber);
      },
    );
  });

  group('IosDevicePlatform over the network', () {
    const wireless = IosDevice(
      id: DeviceId('000081200009555001C2601E'),
      modelName: 'iPhone von Felix',
      isWireless: true,
    );

    IosDevicePlatform platformWith({
      List<IosDeviceDto> plugged = const [],
      List<IosDevice> reachable = const [],
    }) {
      return IosDevicePlatform(
        discoveryChannel: _FakeIosDeviceDiscoveryChannel(Stream.value(plugged)),
        networkDiscovery: _FakeNetworkDiscovery(Stream.value(reachable)),
        channel: IosMirrorChannel(),
        mediaStreamChannel: IosMediaStreamChannel(),
        hidChannel: IosHidChannel(),
        devicectl: DevicectlApi(),
        fileSystem: MemoryFileSystem(),
      );
    }

    test('lists a device that is only reachable over the network', () async {
      final devices = await platformWith(
        reachable: const [wireless],
      ).observeDevices().first;

      expect(devices.single.id, wireless.id);
      expect(devices.single.isWireless, isTrue);
    });

    test('lists a plugged-in device once, as plugged in', () async {
      const sameDevice = IosDeviceDto(
        serialNumber: '000081200009555001C2601E',
        productName: 'iPhone',
      );

      final devices = await platformWith(
        plugged: const [sameDevice],
        reachable: const [wireless],
      ).observeDevices().first;

      expect(devices.single.id, sameDevice.serialNumber);
      expect(devices.single.isWireless, isFalse);
    });

    test('mirrors a device without its cable over the media stream', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      const mediaStream = MethodChannel('dev.synk/ios_media_stream');
      const captureSession = MethodChannel('dev.synk/ios_mirror');
      const hid = MethodChannel('dev.synk/ios_hid');
      final mediaStreamCalls = <String>[];
      final captureSessionCalls = <String>[];
      messenger.setMockMethodCallHandler(mediaStream, (call) async {
        mediaStreamCalls.add(call.method);
        return call.method == 'startMirror'
            ? {'textureId': 4, 'width': 1184, 'height': 2576, 'hasAudio': true}
            : null;
      });
      messenger.setMockMethodCallHandler(captureSession, (call) async {
        captureSessionCalls.add(call.method);
        return null;
      });
      messenger.setMockMethodCallHandler(hid, (call) async => null);
      addTearDown(() {
        for (final channel in [mediaStream, captureSession, hid]) {
          messenger.setMockMethodCallHandler(channel, null);
        }
      });

      final platform = platformWith(reachable: const [wireless]);
      await platform.observeDevices().first;

      final session = await platform.connect(
        wireless.id,
        const MirrorOptions.defaults(),
      );
      addTearDown(session.dispose);

      expect(mediaStreamCalls, ['startMirror']);
      expect(captureSessionCalls, isEmpty);
      expect(session.textureId, const NativeTextureId(4));
      expect(session.screenSize.width, 1184);
      expect(session.audio, isNotNull);
    });
  });

  group('IosDevicePlatform.connect', () {
    const deviceId = DeviceId('000081200009555001C2601E');
    const channels = [
      MethodChannel('dev.synk/ios_hid'),
      MethodChannel('dev.synk/ios_mirror'),
      MethodChannel('dev.synk/ios_mirror/screen_size'),
      MethodChannel('dev.synk/ios_media_stream'),
    ];

    late String? inputProblem;
    late bool mirrorFails;
    late FakeProcessManager processManager;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      inputProblem = null;
      mirrorFails = false;
      processManager = FakeProcessManager();

      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(channels[0], (call) async {
        return call.method == 'prepareInput' ? inputProblem : null;
      });
      messenger.setMockMethodCallHandler(channels[1], (call) async {
        if (mirrorFails) throw PlatformException(code: 'no_frame');
        return call.method == 'startMirror'
            ? {'textureId': 1, 'width': 1179, 'height': 2556}
            : null;
      });
      messenger.setMockMethodCallHandler(channels[2], (call) async => null);
      messenger.setMockMethodCallHandler(channels[3], (call) async {
        throw PlatformException(code: 'no_audio');
      });
    });

    tearDown(() {
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      for (final channel in channels) {
        messenger.setMockMethodCallHandler(channel, null);
      }
    });

    void answerDevicectl({
      String pairingState = 'paired',
      String developerModeStatus = 'enabled',
      bool ddiServicesAvailable = true,
    }) {
      processManager = FakeProcessManager(
        respond: (_) => (
          exitCode: 0,
          stdout:
              '{"result": {"devices": [{'
              '"hardwareProperties": {"udid": "00008120-0009555001C2601E"}, '
              '"connectionProperties": {"pairingState": "$pairingState"}, '
              '"deviceProperties": '
              '{"developerModeStatus": "$developerModeStatus", '
              '"ddiServicesAvailable": $ddiServicesAvailable}'
              '}]}}',
          stderr: '',
        ),
      );
    }

    Future<DeviceSession> connectSession() {
      final platform = IosDevicePlatform(
        discoveryChannel: _FakeIosDeviceDiscoveryChannel(const Stream.empty()),
        networkDiscovery: _FakeNetworkDiscovery(const Stream.empty()),
        channel: IosMirrorChannel(),
        mediaStreamChannel: IosMediaStreamChannel(),
        hidChannel: IosHidChannel(),
        devicectl: DevicectlApi(processManager: processManager),
        fileSystem: MemoryFileSystem(),
      );

      return platform.connect(deviceId, const MirrorOptions.defaults());
    }

    Future<InteractionUnavailableReason?> connect() async {
      final session = await connectSession();
      addTearDown(session.dispose);

      return session.interactionUnavailableReason;
    }

    test('takes input when the device could be prepared', () async {
      expect(await connect(), isNull);
    });

    test('blames the Mac when CoreDevice is unavailable', () async {
      inputProblem = 'coreDeviceUnavailable';

      expect(
        await connect(),
        InteractionUnavailableReason.coreDeviceUnavailable,
      );
      expect(processManager.commands, isEmpty);
    });

    test(
      'blames a missing pairing for a device CoreDevice does not know',
      () async {
        inputProblem = 'deviceUnknown';
        answerDevicectl(pairingState: 'unpaired');

        expect(await connect(), InteractionUnavailableReason.deviceNotPaired);
      },
    );

    test('blames developer mode when it is off', () async {
      inputProblem = 'preparationFailed';
      answerDevicectl(developerModeStatus: 'disabled');

      expect(
        await connect(),
        InteractionUnavailableReason.developerModeDisabled,
      );
    });

    test(
      'blames the missing developer disk image when developer mode is on',
      () async {
        inputProblem = 'preparationFailed';
        answerDevicectl(ddiServicesAvailable: false);

        expect(
          await connect(),
          InteractionUnavailableReason.developerDiskImageUnavailable,
        );
      },
    );

    test('names the setup problem when mirroring fails', () async {
      mirrorFails = true;
      answerDevicectl(
        developerModeStatus: 'disabled',
        ddiServicesAvailable: false,
      );

      await expectLater(
        connectSession,
        throwsA(
          isA<DeviceSetupException>().having(
            (e) => e.problem,
            'problem',
            DeviceSetupProblem.developerModeDisabled,
          ),
        ),
      );
    });

    test(
      'passes the mirroring error on when the device looks fine',
      () async {
        mirrorFails = true;
        answerDevicectl();

        await expectLater(
          connectSession,
          throwsA(isA<PlatformException>()),
        );
      },
    );

    test('admits not knowing when the device looks fine', () async {
      inputProblem = 'preparationFailed';
      answerDevicectl();

      expect(await connect(), InteractionUnavailableReason.unknown);
    });
  });
}

const _pluggedDevice = IosDeviceDto(
  serialNumber: 'late-listener-ios-device',
  productName: 'iPhone',
);

class _FakeIosDeviceDiscoveryChannel implements IosDeviceDiscoveryChannel {
  _FakeIosDeviceDiscoveryChannel(this._frames);

  final Stream<List<IosDeviceDto>> _frames;

  @override
  Stream<List<IosDeviceDto>> observeDevices() => _frames;
}

class _FakeNetworkDiscovery implements IosNetworkDeviceDiscovery {
  _FakeNetworkDiscovery(this._devices);

  final Stream<List<IosDevice>> _devices;

  @override
  DevicectlApi get devicectl => throw UnimplementedError();

  @override
  Duration get interval => Duration.zero;

  @override
  Stream<List<IosDevice>> observeDevices() => _devices;
}
