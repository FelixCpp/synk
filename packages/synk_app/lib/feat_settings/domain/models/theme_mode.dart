import 'dart:ui';

extension type const ThemeMode._(Brightness brightness) implements Brightness {
  static const ThemeMode light = ._(.light);
  static const ThemeMode dark = ._(.dark);

  ThemeMode inverted() {
    return switch (this) {
      Brightness.dark => light,
      Brightness.light => dark,
    };
  }
}
