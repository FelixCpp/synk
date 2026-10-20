import 'package:flutter/widgets.dart';

class SynkUiSpace {
  const SynkUiSpace._();

  static const s2 = 2.0;
  static const s4 = 4.0;
  static const s6 = 6.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s24 = 24.0;
  static const s32 = 32.0;
}

class SynkUiRadius {
  const SynkUiRadius._();

  static const tag = 4.0;
  static const control = 6.0;
  static const row = 8.0;
  static const card = 10.0;
  static const frame = 14.0;
  static const segment = 7.0;
}

class SynkUiSize {
  const SynkUiSize._();

  static const hairline = 1.0;
  static const iconButton = 26.0;
  static const icon = 14.0;
  static const control = 28.0;
  static const statusTile = 28.0;
  static const statusDot = 7.0;
  static const segment = 24.0;
  static const segmentDense = 22.0;
  static const toggleWidth = 34.0;
  static const toggleHeight = 20.0;
  static const toggleKnob = 16.0;
  static const sliderKnob = 14.0;
  static const sliderTrack = 4.0;
  static const toastWidth = 360.0;
  static const toastRail = 3.0;
  static const toastProgress = 2.0;
  static const titleStrip = 52.0;
  static const trafficGutter = 88.0;
  static const sidebarWidth = 248.0;
  static const deviceToolbar = 34.0;
}

class SynkUiElevation {
  const SynkUiElevation._();

  static const List<BoxShadow> flat = [];

  static const List<BoxShadow> overlay = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 24.0,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> overlayOnLight = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 4.0,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 20.0,
      offset: Offset(0, 6),
    ),
  ];

  static List<BoxShadow> overlayFor(Brightness brightness) {
    return brightness == Brightness.dark ? overlay : overlayOnLight;
  }

  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x8C000000),
      blurRadius: 64.0,
      offset: Offset(0, 24),
    ),
  ];
}

class SynkUiMotion {
  const SynkUiMotion._();

  static const reveal = Duration(milliseconds: 80);
  static const state = Duration(milliseconds: 140);
  static const move = Duration(milliseconds: 220);
  static const present = Duration(milliseconds: 320);

  static const standard = Curves.easeOutCubic;
  static const emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
}

class SynkUiInsets {
  const SynkUiInsets._();

  /// Breathing room between a scrollable page and the window chrome.
  static const EdgeInsets page = .all(SynkUiSpace.s12);

  /// Inner padding of a card that holds content rather than a single control.
  static const EdgeInsets card = .all(SynkUiSpace.s12);
}
