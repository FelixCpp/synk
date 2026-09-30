import 'package:flutter/widgets.dart';

@immutable
class BenchColors {
  const BenchColors({
    required this.canvas,
    required this.panel,
    required this.surface,
    required this.raised,
    required this.inset,
    required this.line,
    required this.lineStrong,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.onAccent,
    required this.hoverOverlay,
    required this.pressOverlay,
    required this.live,
    required this.idle,
    required this.warn,
    required this.error,
  });

  const BenchColors.dark()
    : this(
        canvas: const Color(0xFF14171A),
        panel: const Color(0xFF1B1F24),
        surface: const Color(0xFF22272E),
        raised: const Color(0xFF2A3038),
        inset: const Color(0xFF0C0E10),
        line: const Color(0xFF2E343C),
        lineStrong: const Color(0xFF3B434E),
        text: const Color(0xFFE4E7EB),
        textSecondary: const Color(0xFF98A1AC),
        textTertiary: const Color(0xFF656D78),
        accent: const Color(0xFF4D7CFE),
        onAccent: const Color(0xFFFFFFFF),
        hoverOverlay: const Color(0x1AFFFFFF),
        pressOverlay: const Color(0x2EFFFFFF),
        live: const Color(0xFF3FB966),
        idle: const Color(0xFF6B7580),
        warn: const Color(0xFFD9A03C),
        error: const Color(0xFFE05A4F),
      );

  const BenchColors.light()
    : this(
        canvas: const Color(0xFFEFF1F4),
        panel: const Color(0xFFF7F8FA),
        surface: const Color(0xFFFFFFFF),
        raised: const Color(0xFFF1F3F6),
        inset: const Color(0xFFE4E7EC),
        line: const Color(0xFFDDE1E7),
        lineStrong: const Color(0xFFC6CCD4),
        text: const Color(0xFF14181D),
        textSecondary: const Color(0xFF5A636E),
        textTertiary: const Color(0xFF868F9A),
        accent: const Color(0xFF2C5FE0),
        onAccent: const Color(0xFFFFFFFF),
        hoverOverlay: const Color(0x0F000000),
        pressOverlay: const Color(0x1F000000),
        live: const Color(0xFF2E9E52),
        idle: const Color(0xFF6B7580),
        warn: const Color(0xFFB57A16),
        error: const Color(0xFFD0453A),
      );

  final Color canvas;
  final Color panel;
  final Color surface;
  final Color raised;
  final Color inset;
  final Color line;
  final Color lineStrong;
  final Color text;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color onAccent;
  final Color hoverOverlay;
  final Color pressOverlay;
  final Color live;
  final Color idle;
  final Color warn;
  final Color error;

  Color soft(Color color) => color.withValues(alpha: 0.16);
}
