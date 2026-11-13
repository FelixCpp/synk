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
