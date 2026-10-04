import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';

@immutable
class const SynkColors._({
  required final Color canvas,
  required final Color card,
  required final Color cardHover,
  required final Color divider,
  required final Color shadow,
  required final Color label,
  required final Color secondaryLabel,
  required final Color tertiaryLabel,
  required final Color error,
  required final Color success,
  required final Color deviceConnected,
  required final Color deviceDisconnected,
  required final Color deviceUnauthorized,
  required final Color focusRing,
  required final Color focusGlow,
}) {
  factory SynkColors.of(BuildContext context) {
    final colors = SynkUiTheme.of(context).colors;

    return SynkColors._(
      canvas: colors.canvas,
      card: colors.surface,
      cardHover: colors.raised,
      divider: colors.line,
      shadow: const Color(0x00000000),
      label: colors.text,
      secondaryLabel: colors.textSecondary,
      tertiaryLabel: colors.textTertiary,
      error: colors.error,
      success: colors.live,
      deviceConnected: colors.live,
      deviceDisconnected: colors.idle,
      deviceUnauthorized: colors.warn,
      focusRing: colors.accent,
      focusGlow: colors.soft(colors.accent),
    );
  }

  static const Color mirrorBackground = Color(0xFF0C0E10);
  static const Color screenshotFlash = Color(0xFFFFFFFF);

  static const List<Color> mirrorBackdrop = [
    Color(0xFF181C21),
    Color(0xFF0C0E10),
  ];
  static const Color statusOverlayBackground = Color(0x99000000);
  static const Color statusOverlayLabel = Color(0xF2FFFFFF);

  static const Color mirrorLabel = Color(0xCCFFFFFF);
  static const Color mirrorOutline = Color(0x59FFFFFF);
  static const Color mirrorGlow = Color(0x1AFFFFFF);
}
