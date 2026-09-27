import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class DeviceViewerTypography {
  const DeviceViewerTypography._();

  static const double scale = 1.2;

  static MacosTypography scaled(MacosTypography base) {
    TextStyle grow(TextStyle style) {
      final size = style.fontSize;
      if (size == null) return style;
      return style.copyWith(fontSize: (size * scale * 2).roundToDouble() / 2);
    }

    return MacosTypography.raw(
      largeTitle: grow(base.largeTitle),
      title1: grow(base.title1),
      title2: grow(base.title2),
      title3: grow(base.title3),
      headline: grow(base.headline),
      subheadline: grow(base.subheadline),
      body: grow(base.body),
      callout: grow(base.callout),
      footnote: grow(base.footnote),
      caption1: grow(base.caption1),
      caption2: grow(base.caption2),
    );
  }
}
