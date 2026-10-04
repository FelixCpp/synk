import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_theme_mode/domain/models/theme_mode.dart';
import 'package:synk/feat_theme_mode/domain/repositories/theme_mode_repository.dart';
import 'package:synk/feat_theme_mode/domain/usecases/toggle_theme_mode_interactor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_in_case/use_in_case.dart';

part 'theme_mode_bloc.freezed.dart';
part 'theme_mode_state.dart';
part 'theme_mode_event.dart';

class ThemeModeBloc({
  required final ThemeMode themeMode,
  required final ThemeModeRepository repository,
  required final NotificationService notifications,
}) extends Bloc<ThemeModeEvent, ThemeModeState> {
  final toggleThemeMode = ToggleThemeModeInteractor(repository);

  this : super(.new(themeMode: themeMode)) {
    on<_OnSetup>(_onSetup);
    on<_OnToggleThemeMode>(_onToggleThemeMode, transformer: sequential());

    add(const .onSetup());
  }

  FutureOr<void> _onSetup(_OnSetup event, Emitter<ThemeModeState> emit) {
    return emit.forEach(
      repository.observeThemeMode(),
      onData: (themeMode) => state.copyWith(themeMode: themeMode),
    );
  }

  FutureOr<void> _onToggleThemeMode(
    _OnToggleThemeMode event,
    Emitter<ThemeModeState> emit,
  ) {
    return toggleThemeMode
        .logger()
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to togge theme mode: $e'),
          ),
        )
        .run(unit);
  }
}
