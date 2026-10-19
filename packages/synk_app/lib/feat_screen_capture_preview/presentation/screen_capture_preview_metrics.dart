import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:synk/feat_device_frame/presentation/device_frame_metrics.dart';

/// Measurements of the capture pile in the canvas corner.
class ScreenCapturePreviewMetrics {
  const ScreenCapturePreviewMetrics._();

  static const double referenceWidth = 140.0;
  static const double referenceAspectRatio =
      DeviceFrameMetrics.referenceAspectRatio;

  /// Like a device tile, a preview keeps its area across orientations.
  static const double area =
      referenceWidth * (referenceWidth / referenceAspectRatio);

  static Size sizeFor(double aspectRatio) {
    final width = math.sqrt(area * aspectRatio);
    return Size(width, width / aspectRatio);
  }

  /// How far each card below the top one peeks out of the pile.
  static const Offset stackOffset = Offset(-7.0, -7.0);
  static const double stackScaleStep = 0.04;

  static const double dismissSlot = 22.0;
  static const double playSlot = 30.0;
}
