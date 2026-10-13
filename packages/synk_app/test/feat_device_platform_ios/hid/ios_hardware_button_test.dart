import 'package:synk/feat_device_platform_ios/hid/ios_hardware_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the power button', () {
    test('is the consumer sleep key', () {
      expect(iosPowerButton.usagePage, 0x0c);
      expect(iosPowerButton.usageCode, 0x30);
    });
  });
}
