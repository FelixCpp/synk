import 'package:bench_ui/src/tokens/bench_colors.dart';
import 'package:bench_ui/src/tokens/bench_typography.dart';
import 'package:flutter/widgets.dart';

@immutable
class BenchThemeData {
  const BenchThemeData._({
    required this.brightness,
    required this.colors,
    required this.type,
  });

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
      type: BenchTypography.forColors(colors),
    );
  }

  static BenchThemeData forBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }

  final Brightness brightness;
  final BenchColors colors;
  final BenchTypography type;
}

class BenchTheme extends InheritedWidget {
  const BenchTheme({super.key, required this.data, required super.child});

  final BenchThemeData data;

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
