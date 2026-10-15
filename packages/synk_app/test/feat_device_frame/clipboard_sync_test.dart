import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:api_devicectl/api_devicectl.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository_impl.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clock/clock.dart';
import 'package:file/memory.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';

import '../support/fake_device_session.dart';
import '../support/fake_host_clipboard.dart';
import '../support/fake_settings_repository.dart';

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
  late _RecordingInteraction interaction;
  late FakeSettingsRepository settings;
  late FakeHostClipboard host;
  late DeviceFrameRepositoryImpl repository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    clipboard = _FakeClipboard();
    interaction = _RecordingInteraction();
    settings = FakeSettingsRepository();
    host = FakeHostClipboard();
    repository = DeviceFrameRepositoryImpl(
      deviceId: _deviceId,
      modelName: 'Test Device',
      session: FakeDeviceSession(
        clipboard: clipboard,
        interaction: interaction,
      ),
      settingsRepository: settings,
      screenCaptureEventChannel: ScreenCaptureEventChannel(),
      hostClipboard: host,
      filePicker: const SystemFilePicker(),
      fileSystem: MemoryFileSystem(),
      clock: const Clock(),
    );
  });

  group('clipboard shortcuts', () {
    test('copy pulls the device clipboard onto the host', () async {
      clipboard.content = 'from the device';

      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC),
      );

      expect(clipboard.reads, 1);
      expect(host.text, 'from the device');
    });

    test('paste pushes the host clipboard onto the device', () async {
      host.text = 'from the host';

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
      expect(host.text, isNull);
    });

    test(
      'leaves the host clipboard alone when the device has no text',
      () async {
        host.text = 'keep me';
        clipboard.content = '';

        await repository.simulateKeyEvent(
          _shortcut(LogicalKeyboardKey.keyC),
        );

        expect(host.text, 'keep me');
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
      host.text = 'keep me';

      final copy = await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC),
      );
      final paste = await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(copy, ClipboardSyncFailure.deviceUnreachable);
      expect(paste, ClipboardSyncFailure.deviceUnreachable);
      expect(host.text, 'keep me');
    });

    test('reports a missing devicectl as an unavailable tool', () async {
      clipboard.failure = const DevicectlCommandException(message: 'no xcode');
      host.text = 'text';

      final failure = await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(failure, ClipboardSyncFailure.toolUnavailable);
    });

    test('passes ⌘C to the device untouched when sync is off', () async {
      settings.update((it) => it.copyWith(syncClipboard: false));
      clipboard.content = 'from the device';

      await repository.simulateKeyEvent(
        _shortcut(LogicalKeyboardKey.keyC),
      );

      expect(clipboard.reads, 0);
      expect(host.text, isNull);
      expect(interaction.keyEvents, hasLength(1));
    });

    test('passes ⌘V to the device untouched when sync is off', () async {
      settings.update((it) => it.copyWith(syncClipboard: false));
      host.text = 'from the host';
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
      expect(host.text, isNull);
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
