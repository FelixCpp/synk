import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

@immutable
class const DeviceViewerColors._({
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
  required final Color focusRing,
  required final Color focusGlow,
}) {
  factory DeviceViewerColors.of(BuildContext context) {
    final theme = MacosTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color variant(CupertinoDynamicColor color) =>
        isDark ? color.darkColor : color.color;

    return DeviceViewerColors._(
      canvas: theme.canvasColor,
      card: variant(MacosColors.controlBackgroundColor),
      cardHover: isDark ? const Color(0x14FFFFFF) : const Color(0x0A000000),
      divider: theme.dividerColor,
      shadow: isDark ? const Color(0x59000000) : const Color(0x24000000),
      label: variant(MacosColors.labelColor),
      secondaryLabel: variant(MacosColors.secondaryLabelColor),
      tertiaryLabel: variant(MacosColors.tertiaryLabelColor),
      error: variant(MacosColors.systemRedColor),
      success: variant(MacosColors.systemGreenColor),
      deviceConnected: variant(MacosColors.systemGreenColor),
      deviceDisconnected: variant(MacosColors.systemGrayColor),
      focusRing: theme.primaryColor,
      focusGlow: theme.primaryColor.withAlpha(isDark ? 0x80 : 0x59),
    );
  }

  static const Color mirrorBackground = MacosColors.black;
  static const Color screenshotFlash = MacosColors.white;

  static const List<Color> mirrorBackdrop = [
    Color(0xFF20242B),
    Color(0xFF0B0D10),
  ];
  static const Color statusOverlayBackground = Color(0x99000000);
  static const Color statusOverlayLabel = Color(0xF2FFFFFF);

  static const Color mirrorLabel = Color(0xCCFFFFFF);
  static const Color mirrorOutline = Color(0x59FFFFFF);
  static const Color mirrorGlow = Color(0x1AFFFFFF);
}
