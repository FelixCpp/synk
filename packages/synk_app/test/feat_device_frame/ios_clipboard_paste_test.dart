import 'dart:io';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:synk/feat_device_agent/application/ios_device_agent.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_hid_channel.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_mirror_channel.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_mirror_transport.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _deviceId = DeviceId('00008120-0009555001C2601E');

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

IosDeviceAgent _buildAgent({
  required DevicectlApi devicectl,
  required bool supportsInteraction,
}) {
  return IosDeviceAgent(
    IosCaptureSessionTransport(IosMirrorChannel(), null),
    IosHidChannel(),
    devicectl,
    _deviceId,
    const NativeTextureId(1),
    const DeviceScreenSize(width: 1179, height: 2556),
    supportsInteraction,
  );
}

void main() {
  group('pasting onto an iOS device', () {
    late Directory directory;
    late List<MethodCall> hidCalls;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      directory = Directory.systemTemp.createTempSync('ios_clipboard_test');
      hidCalls = [];

      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_hid'),
        (call) async {
          hidCalls.add(call);
          return call.method == 'prepareInput' ? true : null;
        },
      );

      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_mirror/screen_size'),
        (call) async => null,
      );
      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_mirror'),
        (call) async => null,
      );
    });

    tearDown(() {
      directory.deleteSync(recursive: true);

      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_hid'),
        null,
      );
      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_mirror/screen_size'),
        null,
      );
      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_mirror'),
        null,
      );
    });

    test(
      'taps Cmd+V on the device so the text lands immediately, '
      'like it does on Android',
      () async {
        final script = _writeFakeXcrun(directory);
        final agent = _buildAgent(
          devicectl: DevicectlApi(xcrunPath: script.path),
          supportsInteraction: true,
        );
        await pumpEventQueue();
        hidCalls.clear();

        await agent.setDeviceClipboardContent('from the host');

        expect(hidCalls.map((call) => call.method), ['sendKey', 'sendKey']);
        expect(hidCalls.first.arguments['usage'], 0x19); // HID usage for V
        expect(hidCalls.first.arguments['isDown'], isTrue);
        expect(hidCalls.last.arguments['isDown'], isFalse);
      },
    );

    test(
      'only writes the pasteboard when the device has no HID session',
      () async {
        final script = _writeFakeXcrun(directory);
        final agent = _buildAgent(
          devicectl: DevicectlApi(xcrunPath: script.path),
          supportsInteraction: false,
        );

        await agent.setDeviceClipboardContent('from the host');

        expect(hidCalls, isEmpty);
      },
    );

    test(
      'keeps the pasteboard write a success even if the keystroke fails',
      () async {
        final script = _writeFakeXcrun(directory);
        final agent = _buildAgent(
          devicectl: DevicectlApi(xcrunPath: script.path),
          supportsInteraction: true,
        );
        await pumpEventQueue();
        hidCalls.clear();

        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        messenger.setMockMethodCallHandler(
          const MethodChannel('dev.synk/ios_hid'),
          (call) async {
            hidCalls.add(call);
            throw PlatformException(code: 'no_hid_session');
          },
        );

        await expectLater(
          agent.setDeviceClipboardContent('from the host'),
          completes,
        );
      },
    );
  });
}
