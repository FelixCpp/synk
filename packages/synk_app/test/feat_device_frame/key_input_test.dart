import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
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

const _deviceId = DeviceId('serial-1');

final _usPositionOf = {
  LogicalKeyboardKey.keyA: PhysicalKeyboardKey.keyA,
  LogicalKeyboardKey.keyC: PhysicalKeyboardKey.keyC,
  LogicalKeyboardKey.keyV: PhysicalKeyboardKey.keyV,
};

DeviceKeyEvent _key(
  LogicalKeyboardKey key, {
  DeviceKeyEventType type = DeviceKeyEventType.down,
  Set<DeviceKeyModifier> modifiers = const {},
}) {
  return DeviceKeyEvent(
    key: key,
    physicalKey: _usPositionOf[key]!,
    type: type,
    modifiers: modifiers,
  );
}

void main() {
  late _RecordingInteraction interaction;
  late DeviceFrameRepositoryImpl repository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    interaction = _RecordingInteraction();
    repository = DeviceFrameRepositoryImpl(
      deviceId: _deviceId,
      modelName: 'Test Device',
      session: FakeDeviceSession(interaction: interaction),
      settingsRepository: FakeSettingsRepository(),
      screenCaptureEventChannel: ScreenCaptureEventChannel(),
      hostClipboard: FakeHostClipboard(),
      filePicker: const SystemFilePicker(),
      fileSystem: MemoryFileSystem(),
      clock: const Clock(),
    );
  });

  group('typing on the host', () {
    test('reaches the device for an ordinary letter', () async {
      await repository.simulateKeyEvent(
        _key(LogicalKeyboardKey.keyA),
      );

      expect(interaction.keyEvents.single.key, LogicalKeyboardKey.keyA);
      expect(interaction.keyEvents.single.type, DeviceKeyEventType.down);
    });

    test('reaches the device for every phase of a keystroke', () async {
      for (final type in DeviceKeyEventType.values) {
        await repository.simulateKeyEvent(
          _key(LogicalKeyboardKey.keyA, type: type),
        );
      }

      expect(
        interaction.keyEvents.map((event) => event.type),
        DeviceKeyEventType.values,
      );
    });

    test('reaches the device for a letter held with a modifier', () async {
      await repository.simulateKeyEvent(
        _key(
          LogicalKeyboardKey.keyA,
          modifiers: const {DeviceKeyModifier.shiftLeft},
        ),
      );

      expect(interaction.keyEvents.single.key, LogicalKeyboardKey.keyA);
    });

    test(
      'carries the modifiers along for the interaction to translate',
      () async {
        await repository.simulateKeyEvent(
          _key(
            LogicalKeyboardKey.keyA,
            modifiers: const {
              DeviceKeyModifier.shiftLeft,
              DeviceKeyModifier.capsLock,
            },
          ),
        );

        expect(interaction.keyEvents.single.modifiers, {
          DeviceKeyModifier.shiftLeft,
          DeviceKeyModifier.capsLock,
        });
      },
    );

    test('stops at the host for the clipboard shortcuts', () async {
      for (final key in [LogicalKeyboardKey.keyC, LogicalKeyboardKey.keyV]) {
        for (final type in DeviceKeyEventType.values) {
          await repository.simulateKeyEvent(
            _key(
              key,
              type: type,
              modifiers: const {DeviceKeyModifier.metaLeft},
            ),
          );
        }
      }

      expect(interaction.keyEvents, isEmpty);
    });

    test('reaches the device for c and v without the meta key', () async {
      await repository.simulateKeyEvent(
        _key(LogicalKeyboardKey.keyC),
      );
      await repository.simulateKeyEvent(
        _key(LogicalKeyboardKey.keyV),
      );

      expect(
        interaction.keyEvents.map((event) => event.key),
        [LogicalKeyboardKey.keyC, LogicalKeyboardKey.keyV],
      );
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
  Future<void> simulatePointerEvent(DevicePointerEvent event) async {}

  @override
  Future<void> simulatePinchEvent(PinchEvent event) async {}

  @override
  Set<DeviceNavigation> get supportedNavigations => const {};

  @override
  Future<void> navigate(DeviceNavigation navigation) async {}

  @override
  Future<void> pressPowerButton() async {}
}
