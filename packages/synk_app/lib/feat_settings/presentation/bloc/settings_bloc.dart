import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_settings/domain/usecases/set_theme_mode_interactor.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:use_in_case/use_in_case.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc({
  required final ThemeMode themeMode,
  required final SettingsRepository repository,
  required final NotificationService notifications,
}) extends Bloc<SettingsEvent, SettingsState> {
  final setThemeMode = SetThemeModeInteractor(repository);

  this : super(SettingsState.initial(themeMode)) {
    on<_OnSetup>(_onSetup);
    on<_OnSetThemeMode>(_onSetThemeMode, transformer: sequential());

    add(const .onSetup());
  }

  FutureOr<void> _onSetup(_OnSetup event, Emitter<SettingsState> emit) {
    return emit.forEach(
      repository.observeState(),
      onData: (state) => state,
    );
  }

  FutureOr<void> _onSetThemeMode(
    _OnSetThemeMode event,
    Emitter<SettingsState> emit,
  ) {
    return setThemeMode
        .logger()
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to set theme mode: $e'),
          ),
        )
        .run(event.themeMode);
  }
}
