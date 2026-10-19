import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:api_devicectl/api_devicectl.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository_impl.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/device_frame_harness.dart';

const _deviceId = DeviceId('00008120-0009555001C2601E');

final _usPositionOf = {
  LogicalKeyboardKey.keyA: PhysicalKeyboardKey.keyA,
  LogicalKeyboardKey.keyC: PhysicalKeyboardKey.keyC,
  LogicalKeyboardKey.keyV: PhysicalKeyboardKey.keyV,
};

DeviceKeyEvent _shortcut(
  LogicalKeyboardKey key, {
  DeviceKeyEventType type = DeviceKeyEventType.down,
  bool withMeta = true,
}) {
  return DeviceKeyEvent(
    key: key,
    physicalKey: _usPositionOf[key]!,
    type: type,
    modifiers: withMeta ? const {DeviceKeyModifier.metaLeft} : const {},
  );
}

void main() {
  late DeviceFrameHarness harness;
  late _FakeClipboard clipboard;
  late _RecordingInteraction interaction;
  late DeviceFrameRepositoryImpl repository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    clipboard = _FakeClipboard();
    interaction = _RecordingInteraction();
    harness = DeviceFrameHarness(
      clipboard: clipboard,
      interaction: interaction,
      deviceId: _deviceId,
    );
    addTearDown(harness.dispose);
    repository = harness.repository;
  });

  group('clipboard shortcuts', () {
    test('copy pulls the device clipboard onto the host', () async {
      clipboard.content = 'from the device';

      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC),
      );

      expect(clipboard.reads, 1);
      expect(harness.host.text, 'from the device');
    });

    test('paste pushes the host clipboard onto the device', () async {
      harness.host.text = 'from the host';

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
      expect(harness.host.text, isNull);
    });

    test(
      'leaves the host clipboard alone when the device has no text',
      () async {
        harness.host.text = 'keep me';
        clipboard.content = '';

        await repository.simulateKeyEvent(
          _shortcut(LogicalKeyboardKey.keyC),
        );

        expect(harness.host.text, 'keep me');
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
      harness.host.text = 'keep me';

      final copy = await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC),
      );
      final paste = await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(copy, ClipboardSyncFailure.deviceUnreachable);
      expect(paste, ClipboardSyncFailure.deviceUnreachable);
      expect(harness.host.text, 'keep me');
    });

    test('reports a missing devicectl as an unavailable tool', () async {
      clipboard.failure = const DevicectlCommandException(message: 'no xcode');
      harness.host.text = 'text';

      final failure = await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(failure, ClipboardSyncFailure.toolUnavailable);
    });

    test('passes ⌘C to the device untouched when sync is off', () async {
      harness.settings.update((it) => it.copyWith(syncClipboard: false));
      clipboard.content = 'from the device';

      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC),
      );

      expect(clipboard.reads, 0);
      expect(harness.host.text, isNull);
      expect(interaction.keyEvents, hasLength(1));
    });

    test('passes ⌘V to the device untouched when sync is off', () async {
      harness.settings.update((it) => it.copyWith(syncClipboard: false));
      harness.host.text = 'from the host';
      clipboard.content = 'keep me';

      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(clipboard.content, 'keep me');
      expect(interaction.keyEvents, hasLength(1));
    });

    test('leaves ordinary typing off the preference path', () async {
      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyA, withMeta: false),
      );

      expect(interaction.keyEvents, hasLength(1));
    });

    test('ignores the keys without the meta modifier', () async {
      clipboard.content = 'from the device';

      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC, withMeta: false),
      );

      expect(clipboard.reads, 0);
      expect(harness.host.text, isNull);
    });
  });
}

class _RecordingInteraction implements DeviceInteraction {
  final keyEvents = <DeviceKeyEvent>[];

  @override
  Future<void> simulateKeyEvent(DeviceKeyEvent event) async {
    keyEvents.add(event);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
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
