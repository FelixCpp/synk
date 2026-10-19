import 'package:flutter/widgets.dart';

/// Measurements of the full-window device view and the way it fades in.
class MaximizedDeviceMetrics {
  const MaximizedDeviceMetrics._();

  static const Duration transitionDuration = Duration(milliseconds: 340);
  static const double backdropBlur = 10.0;
  static const int scrimAlpha = 140;
  static const EdgeInsets devicePadding = EdgeInsets.all(28.0);
}
