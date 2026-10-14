import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_settings/domain/usecases/reveal_screen_capture_save_path_interactor.dart';
import 'package:synk/feat_settings/domain/usecases/save_settings_interactor.dart';
import 'package:use_in_case/use_in_case.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';

class SettingsBloc({
  required final Settings defaults,
  required final SettingsRepository repository,
  required final NotificationService notifications,
}) extends Bloc<SettingsEvent, Settings> {
  final saveSettings = SaveSettingsInteractor(repository);
  final revealScreenCaptureSavePath = RevealScreenCaptureSavePathInteractor(
    repository,
    const SystemFileOpener(),
  );

  this : super(defaults) {
    on<_OnSetup>(_onSetup);
    on<_OnSave>(_onSave, transformer: sequential());
    on<_OnRevealScreenCaptureSavePath>(
      _onRevealScreenCaptureSavePath,
      transformer: droppable(),
    );

    add(const .onSetup());
  }

  FutureOr<void> _onSetup(_OnSetup event, Emitter<Settings> emit) {
    return emit.forEach(repository.observe(), onData: (settings) => settings);
  }

  FutureOr<void> _onSave(_OnSave event, Emitter<Settings> emit) {
    return saveSettings
        .logger()
        .intercept(
          _notify('Die Einstellungen konnten nicht gespeichert werden'),
        )
        .run(event.settings);
  }

  FutureOr<void> _onRevealScreenCaptureSavePath(
    _OnRevealScreenCaptureSavePath event,
    Emitter<Settings> emit,
  ) {
    return revealScreenCaptureSavePath
        .logger()
        .intercept(_notify('Der Ordner konnte nicht geöffnet werden'))
        .run(unit);
  }

  void Function(Object) _notify(String message) {
    return (error) => notifications.notify(.new(message: '$message: $error'));
  }
}
