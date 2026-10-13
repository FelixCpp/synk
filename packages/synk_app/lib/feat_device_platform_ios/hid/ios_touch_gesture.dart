import 'package:synk/feat_device_platform/domain/models/device_input.dart';

enum IosTouchEdge {
  none,
  top,
  bottom,
  left,
  right,
}

enum IosTouchPhase {
  start,
  move,
  end,
}

typedef IosTouchPoint = ({double x, double y});

typedef IosSwipe = ({
  IosTouchPoint from,
  IosTouchPoint to,
  IosTouchEdge edge,
  Duration hold,
});

const _edgeStripExtent = 0.02;

IosTouchPhase iosTouchPhaseOf(DevicePointerEventType type) {
  return switch (type) {
    .down => .start,
    .move => .move,
    .up => .end,
  };
}

IosTouchEdge iosTouchEdgeAtPointerDown(double x, double y) {
  if (y >= 1.0 - _edgeStripExtent) return .bottom;
  if (y <= _edgeStripExtent) return .top;
  if (x <= _edgeStripExtent) return .left;
  if (x >= 1.0 - _edgeStripExtent) return .right;

  return .none;
}

IosSwipe iosSwipeForNavigation(DeviceNavigation navigation) {
  return switch (navigation) {
    .home => (
      from: (x: 0.5, y: 1.0),
      to: (x: 0.5, y: 0.35),
      edge: .bottom,
      hold: Duration.zero,
    ),
    .appSwitch => (
      from: (x: 0.5, y: 1.0),
      to: (x: 0.5, y: 0.45),
      edge: .bottom,
      hold: const Duration(milliseconds: 600),
    ),
    .back => (
      from: (x: 0.0, y: 0.5),
      to: (x: 0.45, y: 0.5),
      edge: .left,
      hold: Duration.zero,
    ),
  };
}
