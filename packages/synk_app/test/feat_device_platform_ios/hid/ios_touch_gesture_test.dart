import 'package:synk/feat_device_platform_ios/hid/ios_touch_gesture.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the edge a gesture starts at', () {
    test('is none in the middle of the screen', () {
      expect(iosTouchEdgeAtPointerDown(0.5, 0.5), IosTouchEdge.none);
    });

    test('is the bottom for the home indicator strip', () {
      expect(iosTouchEdgeAtPointerDown(0.5, 1.0), IosTouchEdge.bottom);
      expect(iosTouchEdgeAtPointerDown(0.5, 0.99), IosTouchEdge.bottom);
    });

    test('leaves a tap just above the strip alone', () {
      expect(iosTouchEdgeAtPointerDown(0.5, 0.95), IosTouchEdge.none);
    });

    test('is the side for the left and right strips', () {
      expect(iosTouchEdgeAtPointerDown(0.0, 0.5), IosTouchEdge.left);
      expect(iosTouchEdgeAtPointerDown(1.0, 0.5), IosTouchEdge.right);
    });

    test('is the bottom in the bottom corners', () {
      expect(iosTouchEdgeAtPointerDown(0.0, 1.0), IosTouchEdge.bottom);
      expect(iosTouchEdgeAtPointerDown(1.0, 1.0), IosTouchEdge.bottom);
    });
  });
}
