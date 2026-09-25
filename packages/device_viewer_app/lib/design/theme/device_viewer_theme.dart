import 'package:device_viewer/design/theme/generated/theme.dart';
import 'package:flutter/material.dart';

class DeviceViewerTheme {
  const DeviceViewerTheme._();

  static ThemeData light(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.light();
  }

  static ThemeData dark(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.dark();
  }

  static ThemeData lightMediumContrastMode(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.lightMediumContrast();
  }

  static ThemeData darkMediumContrastMode(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.darkMediumContrast();
  }

  static ThemeData lightHighContrast(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.lightHighContrast();
  }

  static ThemeData darkHighContrastMode(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.darkHighContrast();
  }

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
}
