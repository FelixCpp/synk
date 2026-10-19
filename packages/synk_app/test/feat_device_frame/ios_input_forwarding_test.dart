import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/device_frame_harness.dart';

DevicePointerEvent _pointer(
  DevicePointerEventType type,
  double x,
  double y,
) {
  return DevicePointerEvent(
    type: type,
    normalizedPointerX: x,
    normalizedPointerY: y,
  );
}

void main() {
  group('what the frame forwards to the device', () {
    test('passes navigation and the power button on to the device', () async {
      final interaction = _RecordingInteraction();
      final repository = DeviceFrameHarness(interaction: interaction).repository;

      await repository.navigate(.back);
      await repository.navigate(.home);
      await repository.navigate(.appSwitch);
      await repository.pressPowerButton();

      expect(interaction.navigations, [
        DeviceNavigation.back,
        DeviceNavigation.home,
        DeviceNavigation.appSwitch,
      ]);
      expect(interaction.powerButtonPresses, 1);
    });

    test('drops input for a device that does not take any', () async {
      // A device with no interaction at all: the calls must simply
      // go nowhere instead of throwing.
      final repository = DeviceFrameHarness().repository;

      await repository.simulatePointerEvent(
        _pointer(.down, 0.5, 0.5),
      );
      await repository.navigate(.home);
      await repository.pressPowerButton();
    });
  });
}


class _RecordingInteraction implements DeviceInteraction {
  final navigations = <DeviceNavigation>[];
  var powerButtonPresses = 0;
  final pointerEvents = <DevicePointerEvent>[];

  @override
  Future<void> simulateKeyEvent(DeviceKeyEvent event) async {}

  @override
  Future<void> simulatePointerEvent(DevicePointerEvent event) async {
    pointerEvents.add(event);
  }

  @override
  Future<void> simulatePinchEvent(PinchEvent event) async {}

  @override
  Set<DeviceNavigation> get supportedNavigations => const {};

  @override
  Future<void> navigate(DeviceNavigation navigation) async {
    navigations.add(navigation);
  }

  @override
  Future<void> pressPowerButton() async {
    powerButtonPresses++;
  }
}
