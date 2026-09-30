
import 'package:bench_ui/src/tokens/bench_colors.dart';
import 'package:flutter/widgets.dart';

@immutable
class BenchTypography {
  const BenchTypography({
    required this.display,
    required this.heading,
    required this.title,
    required this.label,
    required this.body,
    required this.secondary,
    required this.mono,
    required this.microLabel,
  });

  factory BenchTypography.forColors(BenchColors colors) {
    const tabular = [FontFeature.tabularFigures()];

    return BenchTypography(
      display: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.36,
        height: 1.25,
        color: colors.text,
      ),
      heading: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.18,
        height: 1.25,
        color: colors.text,
      ),
      title: TextStyle(
        fontFamily: fontFamily,
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.08,
        height: 1.3,
        color: colors.text,
      ),
      label: TextStyle(
        fontFamily: fontFamily,
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: colors.text,
      ),
      body: TextStyle(
        fontFamily: fontFamily,
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: colors.text,
      ),
      secondary: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: colors.textSecondary,
      ),
      mono: TextStyle(
        fontFamily: monoFamily,
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
        height: 1.35,
        fontFeatures: tabular,
        color: colors.textTertiary,
      ),
      microLabel: TextStyle(
        fontFamily: monoFamily,
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.88,
        height: 1.35,
        color: colors.textTertiary,
      ),
    );
  }

  static const String? fontFamily = null;
  static const String monoFamily = 'Menlo';

  final TextStyle display;
  final TextStyle heading;
  final TextStyle title;
  final TextStyle label;
  final TextStyle body;
  final TextStyle secondary;
  final TextStyle mono;
  final TextStyle microLabel;
}
