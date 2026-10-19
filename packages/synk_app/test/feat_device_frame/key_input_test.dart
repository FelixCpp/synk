import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository_impl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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
  late DeviceFrameRepositoryImpl repository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    interaction = _RecordingInteraction();
    final harness = DeviceFrameHarness(interaction: interaction);
    addTearDown(harness.dispose);
    repository = harness.repository;
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

    test(
      'reaches the device with its modifiers, for the interaction to '
      'translate',
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
