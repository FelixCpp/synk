import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

@immutable
class DeviceViewerColors {
  const DeviceViewerColors._({
    required this.canvas,
    required this.card,
    required this.cardHover,
    required this.divider,
    required this.shadow,
    required this.label,
    required this.secondaryLabel,
    required this.tertiaryLabel,
    required this.error,
    required this.deviceConnected,
    required this.deviceDisconnected,
  });

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
      deviceConnected: variant(MacosColors.systemGreenColor),
      deviceDisconnected: variant(MacosColors.systemGrayColor),
    );
  }

  final Color canvas;
  final Color card;
  final Color cardHover;
  final Color divider;
  final Color shadow;
  final Color label;
  final Color secondaryLabel;
  final Color tertiaryLabel;
  final Color error;
  final Color deviceConnected;
  final Color deviceDisconnected;

  static const Color mirrorBackground = MacosColors.black;
  static const Color screenshotFlash = MacosColors.white;

  static const List<Color> mirrorBackdrop = [
    Color(0xFF20242B),
    Color(0xFF0B0D10),
  ];
  static const Color mirrorLabel = Color(0xCCFFFFFF);
  static const Color mirrorOutline = Color(0x59FFFFFF);
  static const Color mirrorGlow = Color(0x1AFFFFFF);
}
