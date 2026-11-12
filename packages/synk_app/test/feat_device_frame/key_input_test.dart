import 'package:synk/feat_device_platform/domain/models/screen_orientation.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_frame/domain/device_frame_interactors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_in_case/use_in_case.dart';

import '../support/device_frame_harness.dart';

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
  late DeviceFrameInteractors device;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    interaction = _RecordingInteraction();
    final harness = DeviceFrameHarness(interaction: interaction);
    addTearDown(harness.dispose);
    device = harness.device;
  });

  group('typing on the host', () {
    test('reaches the device for an ordinary letter', () async {
      await device.simulateKeyEvent.getOrThrow(
        _key(LogicalKeyboardKey.keyA),
      );

      expect(interaction.keyEvents.single.key, LogicalKeyboardKey.keyA);
      expect(interaction.keyEvents.single.type, DeviceKeyEventType.down);
    });

    test('reaches the device for every phase of a keystroke', () async {
      for (final type in DeviceKeyEventType.values) {
        await device.simulateKeyEvent.getOrThrow(
          _key(LogicalKeyboardKey.keyA, type: type),
        );
      }

      expect(
        interaction.keyEvents.map((event) => event.type),
        DeviceKeyEventType.values,
      );
    });

    test(
      'reaches the device with its modifiers, for the interaction to '
      'translate',
      () async {
        await device.simulateKeyEvent.getOrThrow(
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
  });

  group('leaving the keyboard', () {
    test('releases every key still held, the last pressed first', () async {
      await device.simulateKeyEvent.getOrThrow(_key(LogicalKeyboardKey.keyA));
      await device.simulateKeyEvent.getOrThrow(_key(LogicalKeyboardKey.keyC));
      interaction.keyEvents.clear();

      await device.releasePressedKeys.getOrThrow();

      expect(
        interaction.keyEvents.map((event) => (event.key, event.type)),
        [
          (LogicalKeyboardKey.keyC, DeviceKeyEventType.up),
          (LogicalKeyboardKey.keyA, DeviceKeyEventType.up),
        ],
      );
    });

    test('leaves keys alone that were already let go', () async {
      await device.simulateKeyEvent.getOrThrow(_key(LogicalKeyboardKey.keyA));
      await device.simulateKeyEvent.getOrThrow(
        _key(LogicalKeyboardKey.keyA, type: .up),
      );
      interaction.keyEvents.clear();

      await device.releasePressedKeys.getOrThrow();

      expect(interaction.keyEvents, isEmpty);
    });

    test('releases a key only once', () async {
      await device.simulateKeyEvent.getOrThrow(_key(LogicalKeyboardKey.keyA));
      await device.releasePressedKeys.getOrThrow();
      interaction.keyEvents.clear();

      await device.releasePressedKeys.getOrThrow();
      await device.simulateKeyEvent.getOrThrow(
        _key(LogicalKeyboardKey.keyA, type: .up),
      );

      expect(
        interaction.keyEvents,
        isEmpty,
        reason: 'the host reports the release once it is back in front',
      );
    });

    test('does not hold a release for a press the device never saw', () async {
      await device.simulateKeyEvent.getOrThrow(
        _key(LogicalKeyboardKey.keyA, type: .up),
      );

      expect(interaction.keyEvents, isEmpty);
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

  @override
  Future<void> rotate(DeviceRotationDirection direction) async {}
}
