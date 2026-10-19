import 'dart:math' as math;

import 'dart:ui' show Size;

/// The size of a box that holds [area] at [aspectRatio].
Size sizeForConstantArea(double area, double aspectRatio) {
  final width = math.sqrt(area * aspectRatio);
  return Size(width, width / aspectRatio);
}
