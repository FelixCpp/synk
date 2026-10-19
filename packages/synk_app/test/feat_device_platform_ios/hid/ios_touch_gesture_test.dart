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

  group('the gesture behind a navigation', () {
    test('leaves the bottom edge for home', () {
      final swipe = iosSwipeForNavigation(.home);

      expect(swipe.edge, IosTouchEdge.bottom);
      expect(swipe.from.y, 1.0);
      expect(swipe.to.y, lessThan(swipe.from.y));
      expect(swipe.hold, Duration.zero);
    });

    test('holds at the top for the app switcher', () {
      final swipe = iosSwipeForNavigation(.appSwitch);

      expect(swipe.edge, IosTouchEdge.bottom);
      expect(swipe.hold, greaterThan(Duration.zero));
    });

    test('comes in from the left edge for back', () {
      final swipe = iosSwipeForNavigation(.back);

      expect(swipe.edge, IosTouchEdge.left);
      expect(swipe.from.x, 0.0);
      expect(swipe.to.x, greaterThan(swipe.from.x));
    });
  });
}
