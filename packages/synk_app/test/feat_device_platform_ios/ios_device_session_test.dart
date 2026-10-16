import 'package:api_devicectl/api_devicectl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file/memory.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hid_channel.dart';
import 'package:synk/feat_device_platform_ios/ios_device_session.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_media_stream_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_transport.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

import '../support/fake_process_manager.dart';

const _deviceId = DeviceId('00008120-0009555001C2601E');

const _mockedChannels = [
  'dev.synk/ios_hid',
  'dev.synk/ios_mirror',
  'dev.synk/ios_mirror/screen_size',
  'dev.synk/ios_media_stream',
];

DevicePointerEvent _pointer(DevicePointerEventType type, double x, double y) {
  return DevicePointerEvent(
    type: type,
    normalizedPointerX: x,
    normalizedPointerY: y,
  );
}

void main() {
  late Map<String, List<MethodCall>> calls;
  late List<IosDeviceSession> sessions;
  late FakeProcessManager processManager;

  List<MethodCall> callsOn(String channel) => calls[channel]!;

  Future<IosDeviceSession> buildSession({
    bool supportsInteraction = true,
    bool hasAudio = false,
  }) async {
    final session = IosDeviceSession(
      transport: IosMirrorTransport(
        IosMirrorChannel(),
        hasAudio ? IosAudioSideCar(IosMediaStreamChannel(), 7) : null,
      ),
      hidChannel: IosHidChannel(),
      devicectl: DevicectlApi(processManager: processManager),
      fileSystem: MemoryFileSystem(),
      deviceId: _deviceId,
      textureId: const NativeTextureId(1),
      initialScreenSize: const DeviceScreenSize(width: 1179, height: 2556),
      interactionUnavailableReason: supportsInteraction ? null : .unknown,
    );
    sessions.add(session);

    // Let the orientation refresh fired on construction settle.
    await pumpEventQueue();
    return session;
  }

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    calls = {for (final channel in _mockedChannels) channel: []};
    sessions = [];
    processManager = FakeProcessManager();

    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    for (final channel in _mockedChannels) {
      messenger.setMockMethodCallHandler(MethodChannel(channel), (call) async {
        callsOn(channel).add(call);
        return null;
      });
    }
  });

  tearDown(() async {
    for (final session in sessions) {
      await session.dispose();
    }

    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    for (final channel in _mockedChannels) {
      messenger.setMockMethodCallHandler(MethodChannel(channel), null);
    }
  });

  group('what an iOS session can do', () {
    test('includes interaction once the HID session is prepared', () async {
      final session = await buildSession(supportsInteraction: true);

      expect(session.interaction, isNotNull);
      expect(
        callsOn('dev.synk/ios_hid').map((call) => call.method),
        contains('refreshOrientation'),
      );
    });

    test('is view-only without a HID session', () async {
      final session = await buildSession(supportsInteraction: false);

      expect(session.interaction, isNull);
      expect(callsOn('dev.synk/ios_hid'), isEmpty);
    });

    test('includes audio only beside a CoreDevice audio stream', () async {
      final silent = await buildSession(hasAudio: false);
      final audible = await buildSession(hasAudio: true);

      expect(silent.audio, isNull);
      expect(audible.audio, isNotNull);
    });

    test('never includes file transfer', () async {
      final session = await buildSession();

      expect(session.fileTransfer, isNull);
    });

    test('always includes screen capture and the clipboard', () async {
      final session = await buildSession(supportsInteraction: false);

      expect(session.screenCapture, isNotNull);
      expect(session.clipboard, isNotNull);
    });
  });

  group('muting an iOS session', () {
    test('mutes the audio stream and remembers it', () async {
      final session = await buildSession(hasAudio: true);
      final audio = session.audio!;

      expect(audio.isAudioMuted, isTrue);
      await audio.setAudioMuted(false);

      final call = callsOn('dev.synk/ios_media_stream').single;
      expect(call.method, 'setAudioSessionMuted');
      expect(call.arguments, {'sessionId': 7, 'muted': false});
      expect(audio.isAudioMuted, isFalse);
    });
  });

  group('touching an iOS session', () {
    test('keeps the edge a gesture started at until it ends', () async {
      final session = await buildSession();
      callsOn('dev.synk/ios_hid').clear();

      await session.interaction!.simulatePointerEvent(
        _pointer(.down, 0.5, 1.0),
      );
      await session.interaction!.simulatePointerEvent(
        _pointer(.move, 0.5, 0.5),
      );
      await session.interaction!.simulatePointerEvent(_pointer(.up, 0.5, 0.4));
      await pumpEventQueue();

      final touches = callsOn(
        'dev.synk/ios_hid',
      ).where((call) => call.method == 'sendTouch');

      expect(touches.map((call) => call.arguments['phase']), [
        'start',
        'move',
        'end',
      ]);
      expect(touches.map((call) => call.arguments['edge']), [
        'bottom',
        'bottom',
        'bottom',
      ]);
    });
  });

  group('navigating an iOS session', () {
    test('offers home only', () async {
      final session = await buildSession();

      expect(session.interaction!.supportedNavigations, {
        DeviceNavigation.home,
      });
    });

    test('swipes up from the bottom edge for home', () async {
      final session = await buildSession();
      callsOn('dev.synk/ios_hid').clear();

      await session.interaction!.navigate(.home);

      final swipe = callsOn(
        'dev.synk/ios_hid',
      ).singleWhere((call) => call.method == 'sendSwipe');

      expect(swipe.arguments['edge'], 'bottom');
    });

    test('ignores a navigation it does not offer', () async {
      final session = await buildSession();
      callsOn('dev.synk/ios_hid').clear();

      await session.interaction!.navigate(.back);
      await session.interaction!.navigate(.appSwitch);

      expect(
        callsOn('dev.synk/ios_hid').where((call) => call.method == 'sendSwipe'),
        isEmpty,
      );
    });
  });

  group('the power button of an iOS session', () {
    test('is pressed as the consumer sleep/wake usage', () async {
      final session = await buildSession();
      callsOn('dev.synk/ios_hid').clear();

      await session.interaction!.pressPowerButton();

      final press = callsOn(
        'dev.synk/ios_hid',
      ).singleWhere((call) => call.method == 'pressButton');

      expect(press.arguments['usagePage'], 0x0c);
      expect(press.arguments['usageCode'], 0x30);
    });
  });

  group('pasting onto an iOS session', () {
    test('taps V on the device so the text lands immediately', () async {
      final session = await buildSession(supportsInteraction: true);
      callsOn('dev.synk/ios_hid').clear();

      await session.clipboard!.setClipboard('from the host');

      final keys = callsOn(
        'dev.synk/ios_hid',
      ).where((call) => call.method == 'sendKey');

      expect(keys.map((call) => call.arguments['usage']), [0x19, 0x19]);
      expect(keys.map((call) => call.arguments['isDown']), [true, false]);
    });

    test('only writes the pasteboard without a HID session', () async {
      final session = await buildSession(supportsInteraction: false);

      await session.clipboard!.setClipboard('from the host');

      expect(processManager.stdinWrites, ['from the host']);
      expect(callsOn('dev.synk/ios_hid'), isEmpty);
    });

    test('stays a success even if the keystroke fails', () async {
      final session = await buildSession(supportsInteraction: true);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('dev.synk/ios_hid'),
            (call) async => throw PlatformException(code: 'no_hid_session'),
          );

      await expectLater(
        session.clipboard!.setClipboard('from the host'),
        completes,
      );
    });
  });

  group('disposing an iOS session', () {
    test('releases the input and stops the mirror', () async {
      final session = await buildSession();
      sessions.clear();
      callsOn('dev.synk/ios_hid').clear();

      await session.dispose();

      expect(
        callsOn('dev.synk/ios_hid').map((call) => call.method),
        contains('releaseInput'),
      );
      expect(
        callsOn('dev.synk/ios_mirror').map((call) => call.method),
        contains('stopMirror'),
      );
    });
  });
}
