import 'package:synk_ui/src/tokens/bench_colors.dart';
import 'package:synk_ui/src/tokens/bench_typography.dart';
import 'package:flutter/widgets.dart';

@immutable
class const BenchThemeData._({
  required final Brightness brightness,
  required final BenchColors colors,
  required final BenchTypography typography,
}) {
  static final BenchThemeData dark = _of(
    Brightness.dark,
    const BenchColors.dark(),
  );

  static final BenchThemeData light = _of(
    Brightness.light,
    const BenchColors.light(),
  );

  static BenchThemeData _of(Brightness brightness, BenchColors colors) {
    return BenchThemeData._(
      brightness: brightness,
      colors: colors,
      typography: BenchTypography.forColors(colors),
    );
  }

  static BenchThemeData forBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}

class const BenchTheme({
  super.key,
  required final BenchThemeData data,
  required super.child,
}) extends InheritedWidget {
  static BenchThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<BenchTheme>();
    assert(theme != null, 'No BenchTheme found in the widget tree.');
    return theme!.data;
  }

  @override
  bool updateShouldNotify(BenchTheme oldWidget) => oldWidget.data != data;
}

extension BenchThemeContext on BuildContext {
  BenchThemeData get bench => BenchTheme.of(this);
}
