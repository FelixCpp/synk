import 'dart:math' as math;

import 'dart:ui' show Size;

/// The size of a box that holds [area] at [aspectRatio].
///
/// Both the device tiles and the capture previews are measured this way, so a
/// device that rotates keeps its tile — portrait and landscape only trade
/// places. Without it, a landscape tile would either tower over the others or
/// shrink to a strip.
Size sizeForConstantArea(double area, double aspectRatio) {
  final width = math.sqrt(area * aspectRatio);
  return Size(width, width / aspectRatio);
}
