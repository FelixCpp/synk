import 'dart:io';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/native_texture_id.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hid_channel.dart';
import 'package:synk/feat_device_platform_ios/ios_device_agent.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_media_stream_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_transport.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';

const _deviceId = DeviceId('00008120-0009555001C2601E');

const _mockedChannels = [
  'dev.synk/ios_hid',
  'dev.synk/ios_mirror',
  'dev.synk/ios_mirror/screen_size',
  'dev.synk/ios_media_stream',
];

File _writeFakeXcrun(Directory directory) {
  final script = File('${directory.path}/xcrun')
    ..writeAsStringSync('''
#!/bin/sh
cat > /dev/null
exit 0
''');

  Process.runSync('chmod', ['+x', script.path]);
  return script;
}

DevicePointerEvent _pointer(DevicePointerEventType type, double x, double y) {
  return DevicePointerEvent(
    type: type,
    normalizedPointerX: x,
    normalizedPointerY: y,
  );
}

void main() {
  late Directory directory;
  late Map<String, List<MethodCall>> calls;
  late List<IosDeviceAgent> agents;

  List<MethodCall> callsOn(String channel) => calls[channel]!;

  Future<IosDeviceAgent> buildAgent({
    bool supportsInteraction = true,
    bool hasAudio = false,
  }) async {
    final agent = IosDeviceAgent(
      transport: IosCaptureSessionTransport(
        IosMirrorChannel(),
        hasAudio ? IosAudioSideCar(IosMediaStreamChannel(), 7) : null,
      ),
      hidChannel: IosHidChannel(),
      devicectl: DevicectlApi(xcrunPath: _writeFakeXcrun(directory).path),
      deviceId: _deviceId,
      textureId: const NativeTextureId(1),
      initialScreenSize: const DeviceScreenSize(width: 1179, height: 2556),
      supportsInteraction: supportsInteraction,
    );
    agents.add(agent);

    // Let the orientation refresh fired on construction settle.
    await pumpEventQueue();
    return agent;
  }

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    directory = Directory.systemTemp.createTempSync('ios_device_agent_test');
    calls = {for (final channel in _mockedChannels) channel: []};
    agents = [];

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
    for (final agent in agents) {
      await agent.dispose();
    }

    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    for (final channel in _mockedChannels) {
      messenger.setMockMethodCallHandler(MethodChannel(channel), null);
    }

    directory.deleteSync(recursive: true);
  });

  group('what an iOS agent can do', () {
    test('includes interaction once the HID session is prepared', () async {
      final agent = await buildAgent(supportsInteraction: true);

      expect(agent.interaction, isNotNull);
      expect(
        callsOn('dev.synk/ios_hid').map((call) => call.method),
        contains('refreshOrientation'),
      );
    });

    test('is view-only without a HID session', () async {
      final agent = await buildAgent(supportsInteraction: false);

      expect(agent.interaction, isNull);
      expect(callsOn('dev.synk/ios_hid'), isEmpty);
    });

    test('includes audio only beside a CoreDevice audio stream', () async {
      final silent = await buildAgent(hasAudio: false);
      final audible = await buildAgent(hasAudio: true);

      expect(silent.audio, isNull);
      expect(audible.audio, isNotNull);
    });

    test('never includes file transfer', () async {
      final agent = await buildAgent();

      expect(agent.fileTransfer, isNull);
    });

    test('always includes screen capture and the clipboard', () async {
      final agent = await buildAgent(supportsInteraction: false);

      expect(agent.screenCapture, isNotNull);
      expect(agent.clipboard, isNotNull);
    });
  });

  group('muting an iOS agent', () {
    test('mutes the audio stream and remembers it', () async {
      final agent = await buildAgent(hasAudio: true);
      final audio = agent.audio!;

      expect(audio.isAudioMuted, isTrue);
      await audio.setAudioMuted(false);

      final call = callsOn('dev.synk/ios_media_stream').single;
      expect(call.method, 'setAudioSessionMuted');
      expect(call.arguments, {'sessionId': 7, 'muted': false});
      expect(audio.isAudioMuted, isFalse);
    });
  });

  group('touching an iOS agent', () {
    test('keeps the edge a gesture started at until it ends', () async {
      final agent = await buildAgent();
      callsOn('dev.synk/ios_hid').clear();

      await agent.interaction!.simulatePointerEvent(_pointer(.down, 0.5, 1.0));
      await agent.interaction!.simulatePointerEvent(_pointer(.move, 0.5, 0.5));
      await agent.interaction!.simulatePointerEvent(_pointer(.up, 0.5, 0.4));
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

  group('navigating an iOS agent', () {
    test('swipes in from the edge the navigation belongs to', () async {
      final agent = await buildAgent();
      callsOn('dev.synk/ios_hid').clear();

      await agent.interaction!.navigate(.home);
      await agent.interaction!.navigate(.back);

      final swipes = callsOn(
        'dev.synk/ios_hid',
      ).where((call) => call.method == 'sendSwipe');

      expect(swipes.map((call) => call.arguments['edge']), ['bottom', 'left']);
    });

    test('holds the swipe for the app switcher', () async {
      final agent = await buildAgent();
      callsOn('dev.synk/ios_hid').clear();

      await agent.interaction!.navigate(.appSwitch);

      final swipe = callsOn(
        'dev.synk/ios_hid',
      ).singleWhere((call) => call.method == 'sendSwipe');

      expect(swipe.arguments['holdMs'], greaterThan(0));
    });
  });

  group('the power button of an iOS agent', () {
    test('is pressed as the consumer sleep/wake usage', () async {
      final agent = await buildAgent();
      callsOn('dev.synk/ios_hid').clear();

      await agent.interaction!.pressPowerButton();

      final press = callsOn(
        'dev.synk/ios_hid',
      ).singleWhere((call) => call.method == 'pressButton');

      expect(press.arguments['usagePage'], 0x0c);
      expect(press.arguments['usageCode'], 0x30);
    });
  });

  group('pasting onto an iOS agent', () {
    test('taps V on the device so the text lands immediately', () async {
      final agent = await buildAgent(supportsInteraction: true);
      callsOn('dev.synk/ios_hid').clear();

      await agent.clipboard!.setClipboard('from the host');

      final keys = callsOn(
        'dev.synk/ios_hid',
      ).where((call) => call.method == 'sendKey');

      expect(keys.map((call) => call.arguments['usage']), [0x19, 0x19]);
      expect(keys.map((call) => call.arguments['isDown']), [true, false]);
    });

    test('only writes the pasteboard without a HID session', () async {
      final agent = await buildAgent(supportsInteraction: false);

      await agent.clipboard!.setClipboard('from the host');

      expect(callsOn('dev.synk/ios_hid'), isEmpty);
    });

    test('stays a success even if the keystroke fails', () async {
      final agent = await buildAgent(supportsInteraction: true);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('dev.synk/ios_hid'),
            (call) async => throw PlatformException(code: 'no_hid_session'),
          );

      await expectLater(
        agent.clipboard!.setClipboard('from the host'),
        completes,
      );
    });
  });

  group('disposing an iOS agent', () {
    test('releases the input and stops the mirror', () async {
      final agent = await buildAgent();
      agents.clear();
      callsOn('dev.synk/ios_hid').clear();

      await agent.dispose();

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
