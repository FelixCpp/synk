import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class SynkUiScrim {
  const SynkUiScrim._();

  static const Color surface = Color(0x99000000);
  static const Color label = Color(0xF2FFFFFF);
  static const Color below = Color(0xFF0C0E10);
  static const double radius = SynkUiRadius.control;

  static const EdgeInsets insets = EdgeInsets.symmetric(
    horizontal: SynkUiSpace.s6,
    vertical: SynkUiSpace.s4,
  );
}
