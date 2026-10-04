import 'package:synk_ui/src/tokens/synk_ui_colors.dart';
import 'package:synk_ui/src/tokens/synk_ui_typography.dart';
import 'package:flutter/widgets.dart';

@immutable
class const SynkUiThemeData._({
  required final Brightness brightness,
  required final SynkUiColors colors,
  required final SynkUiTypography typography,
}) {
  static final SynkUiThemeData dark = _of(
    Brightness.dark,
    const SynkUiColors.dark(),
  );

  static final SynkUiThemeData light = _of(
    Brightness.light,
    const SynkUiColors.light(),
  );

  static SynkUiThemeData _of(Brightness brightness, SynkUiColors colors) {
    return SynkUiThemeData._(
      brightness: brightness,
      colors: colors,
      typography: SynkUiTypography.forColors(colors),
    );
  }

  static SynkUiThemeData forBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}

class const SynkUiTheme({
  super.key,
  required final SynkUiThemeData data,
  required super.child,
}) extends InheritedWidget {
  static SynkUiThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<SynkUiTheme>();
    assert(theme != null, 'No SynkUiTheme found in the widget tree.');
    return theme!.data;
  }

  @override
  bool updateShouldNotify(SynkUiTheme oldWidget) => oldWidget.data != data;
}

extension SynkUiThemeContext on BuildContext {
  SynkUiThemeData get synkUi => SynkUiTheme.of(this);
}
