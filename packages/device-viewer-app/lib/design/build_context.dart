import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

extension ThemeGetters on BuildContext {
  ColorScheme get colors => ColorScheme.of(this);
  MacosTypography get typo => MacosTypography.of(this);
}
