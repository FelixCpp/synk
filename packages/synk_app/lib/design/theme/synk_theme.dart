import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class SynkTheme {
  const SynkTheme._();

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

  static const focusRingThickness = 3.0;
  static const focusRingBlur = 4.0;
  static const focusTransitionDuration = Duration(milliseconds: 140);

  static const deviceFrameToolBarHeight = 44.0;
  static const deviceFrameToolBarPadding = EdgeInsets.only(
    left: 14.0,
    right: 6.0,
  );
  static const deviceFrameToolBarIconSlot = 24.0;

  static const deviceFrameControlsBarHeight = 44.0;
  static const deviceFrameControlsBarPadding = EdgeInsets.only(
    left: 14.0,
    right: 6.0,
  );

  static const actionRevealDuration = Duration(milliseconds: 120);

  static const statusOverlayPadding = EdgeInsets.all(8.0);
  static const statusOverlayRadius = 6.0;
  static const statusOverlayInsets = EdgeInsets.symmetric(
    horizontal: 6.0,
    vertical: 4.0,
  );
  static const statusOverlayIconSize = 13.0;

  static const maximizeTransitionDuration = Duration(milliseconds: 340);
  static const maximizeBackdropBlur = 10.0;
  static const maximizeScrimAlpha = 140;
  static const maximizeDevicePadding = EdgeInsets.all(28.0);

  static const deviceFrameWidth = 320.0;
  static const deviceFrameReferenceAspectRatio = 9 / 20;
  static const deviceFrameChromeHeight =
      deviceFrameToolBarHeight + deviceFrameControlsBarHeight;
  static const deviceFrameHeight =
      deviceFrameChromeHeight +
      (deviceFrameWidth / deviceFrameReferenceAspectRatio);

  static const deviceFrameMirrorArea =
      deviceFrameWidth * (deviceFrameWidth / deviceFrameReferenceAspectRatio);

  static Size deviceFrameSizeFor(double aspectRatio) {
    final mirrorWidth = math.sqrt(deviceFrameMirrorArea * aspectRatio);
    return Size(
      mirrorWidth,
      mirrorWidth / aspectRatio + deviceFrameChromeHeight,
    );
  }

  static const screenCapturePreviewWidth = 140.0;
  static const screenCapturePreviewReferenceAspectRatio =
      deviceFrameReferenceAspectRatio;
  static const screenCapturePreviewArea =
      screenCapturePreviewWidth *
      (screenCapturePreviewWidth / screenCapturePreviewReferenceAspectRatio);

  static Size screenCapturePreviewSizeFor(double aspectRatio) {
    final width = math.sqrt(screenCapturePreviewArea * aspectRatio);
    return Size(width, width / aspectRatio);
  }

  static const screenCapturePreviewStackOffset = Offset(-7.0, -7.0);
  static const screenCapturePreviewStackScaleStep = 0.04;
  static const screenCapturePreviewDismissSlot = 22.0;
  static const screenCapturePreviewPlaySlot = 30.0;
}
