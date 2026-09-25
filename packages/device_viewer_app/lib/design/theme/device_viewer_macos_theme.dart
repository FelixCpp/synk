import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

/// The [MacosThemeData] used to style the [MacosApp] and its descendants.
///
/// Mirrors the teal brand color already used by [DeviceViewerTheme]'s
/// Material color scheme so macOS-native widgets (buttons, icons, popups)
/// and Material widgets stay visually consistent.
class DeviceViewerMacosTheme {
  const DeviceViewerMacosTheme._();

  static const _lightPrimary = Color(0xFF09677F);
  static const _lightCanvas = Color(0xFFF5FAFD);
  static const _lightDivider = Color(0xFFBFC8CC);

  static const _darkPrimary = Color(0xFF88D0EC);
  static const _darkCanvas = Color(0xFF0F1416);
  static const _darkDivider = Color(0xFF40484C);

  static MacosThemeData get light {
    const primary = _lightPrimary;
    return MacosThemeData.light().copyWith(
      primaryColor: primary,
      canvasColor: _lightCanvas,
      dividerColor: _lightDivider,
      pushButtonTheme: const PushButtonThemeData(
        color: primary,
        secondaryColor: MacosColors.white,
        disabledColor: Color.fromRGBO(244, 245, 245, 1.0),
      ),
      iconTheme: const MacosIconThemeData(color: primary, size: 20),
      popupButtonTheme: MacosPopupButtonThemeData(
        highlightColor: primary.withValues(alpha: 0.78),
        backgroundColor: MacosColors.white,
        popupColor: const Color.fromRGBO(242, 242, 247, 1),
      ),
      pulldownButtonTheme: MacosPulldownButtonThemeData(
        highlightColor: primary.withValues(alpha: 0.78),
        backgroundColor: MacosColors.white,
        pulldownColor: const Color.fromRGBO(242, 242, 247, 1),
        iconColor: const Color.fromRGBO(0, 0, 0, 0.7),
      ),
      searchFieldTheme: MacosSearchFieldThemeData(
        highlightColor: primary.withValues(alpha: 0.78),
        resultsBackgroundColor: const Color.fromRGBO(242, 242, 247, 1),
      ),
    );
  }

  static MacosThemeData get dark {
    const primary = _darkPrimary;
    return MacosThemeData.dark().copyWith(
      primaryColor: primary,
      canvasColor: _darkCanvas,
      dividerColor: _darkDivider,
      pushButtonTheme: const PushButtonThemeData(
        color: primary,
        secondaryColor: Color.fromRGBO(110, 109, 112, 1.0),
        disabledColor: Color.fromRGBO(255, 255, 255, 0.1),
      ),
      iconTheme: const MacosIconThemeData(color: primary, size: 20),
      popupButtonTheme: MacosPopupButtonThemeData(
        highlightColor: primary.withValues(alpha: 0.78),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.247),
        popupColor: const Color.fromRGBO(30, 30, 30, 1),
      ),
      pulldownButtonTheme: MacosPulldownButtonThemeData(
        highlightColor: primary.withValues(alpha: 0.78),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.247),
        pulldownColor: const Color.fromRGBO(30, 30, 30, 1),
        iconColor: const Color.fromRGBO(255, 255, 255, 0.7),
      ),
      searchFieldTheme: MacosSearchFieldThemeData(
        highlightColor: primary.withValues(alpha: 0.78),
        resultsBackgroundColor: const Color.fromRGBO(30, 30, 30, 1),
      ),
    );
  }
}
