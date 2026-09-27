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

  static const deviceFrameToolBarHeight = 56.0;
  static const deviceFrameToolBarPadding = EdgeInsets.only(
    left: 14.0,
    right: 6.0,
  );

  static const deviceFrameWidth = 320.0;
  static const deviceFrameReferenceAspectRatio = 9 / 20;
  static const deviceFrameHeight =
      deviceFrameToolBarHeight +
      (deviceFrameWidth / deviceFrameReferenceAspectRatio);
}
