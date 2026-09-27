import 'package:flutter/widgets.dart';

class DeviceViewerTheme {
  const DeviceViewerTheme._();

  static const verticalComponentSpacingSmall = 4.0;
  static const verticalComponentSpacingMedium = 8.0;
  static const verticalComponentSpacingLarge = 12.0;

  static const horizontalComponentSpacingSmall = 4.0;
  static const horizontalComponentSpacingMedium = 8.0;
  static const horizontalComponentSpacingLarge = 12.0;

  static const horizontalPagePadding = 12.0;
  static const verticalPagePadding = 12.0;
  static const pagePadding = EdgeInsets.symmetric(
    vertical: verticalPagePadding,
    horizontal: horizontalPagePadding,
  );

  static const horizontalCardPadding = 12.0;
  static const verticalCardPadding = 12.0;
  static const cardPadding = EdgeInsets.symmetric(
    vertical: verticalCardPadding,
    horizontal: horizontalCardPadding,
  );

  static const cornerRadius = 16.0;
  static const smallCornerRadius = 10.0;

  static const hairlineThickness = 1.0;

  static const cardShadow = 18.0;
  static const cardShadowOffset = Offset(0, 6);

  /// Fixed so a device frame can work out how much room is left for the
  /// mirror before laying it out - the mirror has to be sized to the
  /// device's aspect ratio, which is impossible if the toolbar above it
  /// takes an unknown amount of the height.
  static const deviceFrameToolBarHeight = 56.0;

  static const deviceFrameToolBarPadding = EdgeInsets.only(
    left: 14.0,
    right: 6.0,
  );

  static const deviceFrameWidth = 320.0;

  /// The tallest device shape a frame is laid out for. Anything up to this
  /// fills the frame's full width; taller devices (and tablets, which are
  /// wider) get a correspondingly narrower frame rather than a distorted
  /// picture. 9:20 covers current phones - a Pixel 6 sits exactly on it.
  static const deviceFrameReferenceAspectRatio = 9 / 20;

  static const deviceFrameHeight =
      deviceFrameToolBarHeight +
      deviceFrameWidth / deviceFrameReferenceAspectRatio;
}
