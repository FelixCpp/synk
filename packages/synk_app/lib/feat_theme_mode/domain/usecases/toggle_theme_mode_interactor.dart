import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_theme_mode/domain/repositories/theme_mode_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const ToggleThemeModeInteractor(final ThemeModeRepository repository)
    implements Interactor {
  @override
  FutureOr<void> getOrThrow(Unit input) {
    return repository.toggleThemeMode();
  }
}
