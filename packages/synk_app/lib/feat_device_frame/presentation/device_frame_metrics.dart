import 'package:flutter/widgets.dart';
import 'package:synk/design/constant_area.dart';
import 'package:synk_ui/synk_ui.dart';

/// Measurements of the chrome Synk draws around a mirrored screen.
class DeviceFrameMetrics {
  const DeviceFrameMetrics._();

  static const double toolBarHeight = 44.0;
  static const EdgeInsets toolBarPadding = EdgeInsets.only(
    left: 14.0,
    right: SynkUiSpace.s6,
  );

  static const double controlsBarHeight = 44.0;
  static const EdgeInsets controlsBarPadding = EdgeInsets.only(
    left: 14.0,
    right: SynkUiSpace.s6,
  );

  static const double chromeHeight = toolBarHeight + controlsBarHeight;

  /// Width of a tile showing a device of [referenceAspectRatio].
  static const double referenceWidth = 320.0;
  static const double referenceAspectRatio = 9 / 20;

  static const double height =
      chromeHeight + (referenceWidth / referenceAspectRatio);

  /// A tile's mirror area stays constant, so a device that rotates keeps its
  /// tile — only portrait and landscape swap.
  static const double mirrorArea =
      referenceWidth * (referenceWidth / referenceAspectRatio);

  static const double minScale = 0.75;
  static const double maxScale = 2.0;

  /// The tile for a device of [aspectRatio]: a constant mirror area, plus the
  /// chrome above and below it.
  static Size sizeFor(double aspectRatio, {double scale = 1}) {
    final mirror = sizeForConstantArea(
      mirrorArea * scale * scale,
      aspectRatio,
    );
    return Size(mirror.width, mirror.height + chromeHeight);
  }
}
