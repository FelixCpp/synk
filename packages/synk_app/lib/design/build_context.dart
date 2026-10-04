import 'package:synk_ui/synk_ui.dart';
import 'package:synk/design/theme/synk_colors.dart';
import 'package:synk/design/theme/synk_typography.dart';
import 'package:flutter/widgets.dart';

extension ThemeGetters on BuildContext {
  SynkUiThemeData get synkUiTheme => SynkUiTheme.of(this);
  SynkColors get colors => SynkColors.of(this);
  SynkTypography get typo => SynkTypography.of(this);
}
