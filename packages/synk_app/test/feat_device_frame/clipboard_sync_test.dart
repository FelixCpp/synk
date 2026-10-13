import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:api_devicectl/api_devicectl.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_device_session.dart';

const _deviceId = DeviceId('00008120-0009555001C2601E');

DeviceKeyEvent _shortcut(
  LogicalKeyboardKey key, {
  DeviceKeyEventType type = DeviceKeyEventType.down,
  bool withMeta = true,
}) {
  return DeviceKeyEvent(
    key: key,
    type: type,
    modifiers: withMeta ? const {DeviceKeyModifier.metaLeft} : const {},
  );
}

void main() {
  late _FakeClipboard clipboard;
  late DeviceFrameRepository repository;
  String? hostClipboard;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    clipboard = _FakeClipboard();
    repository = DeviceFrameRepository(
      deviceId: _deviceId,
      session: FakeDeviceSession(clipboard: clipboard),
    );
    hostClipboard = null;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          switch (call.method) {
            case 'Clipboard.getData':
              return hostClipboard == null ? null : {'text': hostClipboard};
            case 'Clipboard.setData':
              hostClipboard = (call.arguments as Map)['text'] as String?;
              return null;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('clipboard shortcuts', () {
    test('copy pulls the device clipboard onto the host', () async {
      clipboard.content = 'from the device';

      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC),
      );

      expect(clipboard.reads, 1);
      expect(hostClipboard, 'from the device');
    });

    test('paste pushes the host clipboard onto the device', () async {
      hostClipboard = 'from the host';

      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(clipboard.content, 'from the host');
    });

    test('syncs once per shortcut, on the key down', () async {
      clipboard.content = 'from the device';

      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC, type: .up),
      );
      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC, type: .repeat),
      );

      expect(clipboard.reads, 0);
      expect(hostClipboard, isNull);
    });

    test(
      'leaves the host clipboard alone when the device has no text',
      () async {
        hostClipboard = 'keep me';
        clipboard.content = '';

        await repository.simulateKeyEvent(
          _shortcut(LogicalKeyboardKey.keyC),
        );

        expect(hostClipboard, 'keep me');
      },
    );

    test(
      'leaves the device clipboard alone when the host has no text',
      () async {
        clipboard.content = 'keep me';

        await repository.simulateKeyEvent(
          _shortcut(LogicalKeyboardKey.keyV),
        );

        expect(clipboard.content, 'keep me');
      },
    );

    test('reports a device clipboard it cannot reach', () async {
      clipboard.isReachable = false;
      hostClipboard = 'keep me';

      final copy = await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC),
      );
      final paste = await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(copy, ClipboardSyncFailure.deviceUnreachable);
      expect(paste, ClipboardSyncFailure.deviceUnreachable);
      expect(hostClipboard, 'keep me');
    });

    test('reports a missing devicectl as an unavailable tool', () async {
      clipboard.failure = const DevicectlCommandException(message: 'no xcode');
      hostClipboard = 'text';

      final failure = await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(failure, ClipboardSyncFailure.toolUnavailable);
    });

    test('ignores the keys without the meta modifier', () async {
      clipboard.content = 'from the device';

      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC, withMeta: false),
      );

      expect(clipboard.reads, 0);
      expect(hostClipboard, isNull);
    });
  });
}

class _FakeClipboard implements DeviceClipboard {
  String content = '';
  int reads = 0;
  bool isReachable = true;
  Object? failure;

  @override
  Future<String> getClipboard() async {
    reads++;
    if (!isReachable || failure != null) {
      throw failure ?? Exception('no pasteboard on this device');
    }

    return content;
  }

  @override
  Future<void> setClipboard(String clipboard) async {
    if (!isReachable || failure != null) {
      throw failure ?? Exception('no pasteboard on this device');
    }

    content = clipboard;
  }
}
