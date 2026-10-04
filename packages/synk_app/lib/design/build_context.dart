import 'package:bench_ui/bench_ui.dart';
import 'package:synk/design/theme/synk_colors.dart';
import 'package:synk/design/theme/synk_typography.dart';
import 'package:flutter/widgets.dart';

extension ThemeGetters on BuildContext {
  BenchThemeData get benchTheme => BenchTheme.of(this);
  SynkColors get colors => SynkColors.of(this);
  SynkTypography get typo => SynkTypography.of(this);
}
