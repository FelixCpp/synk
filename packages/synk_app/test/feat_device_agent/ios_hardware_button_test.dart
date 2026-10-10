import 'package:synk/feat_device_agent/domain/models/ios_hardware_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the hardware button behind a control action', () {
    test('is the consumer sleep key for standby', () {
      final button = iosButtonForControlAction(.standby)!;

      expect(button.usagePage, 0x0c);
      expect(button.usageCode, 0x30);
    });

    test('does not exist for the actions that are gestures', () {
      expect(iosButtonForControlAction(.back), isNull);
      expect(iosButtonForControlAction(.home), isNull);
      expect(iosButtonForControlAction(.appSwitch), isNull);
    });
  });
}
