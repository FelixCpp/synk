import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_settings/domain/models/settings_defaults.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_settings/domain/usecases/reveal_screen_capture_save_path_interactor.dart';
import 'package:synk/feat_settings/domain/usecases/set_adb_path_interactor.dart';
import 'package:synk/feat_settings/domain/usecases/set_frame_rate_interactor.dart';
import 'package:synk/feat_settings/domain/usecases/set_mute_on_connect_interactor.dart';
import 'package:synk/feat_settings/domain/usecases/set_quality_interactor.dart';
import 'package:synk/feat_settings/domain/usecases/set_screen_capture_save_path_interactor.dart';
import 'package:synk/feat_settings/domain/usecases/set_show_capture_preview_interactor.dart';
import 'package:synk/feat_settings/domain/usecases/set_sync_clipboard_interactor.dart';
import 'package:synk/feat_settings/domain/usecases/set_theme_mode_interactor.dart';
import 'package:synk/feat_settings/domain/usecases/set_turn_device_screen_off_interactor.dart';
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
  final setScreenCaptureSavePath = SetScreenCaptureSavePathInteractor(
    repository,
  );
  final revealScreenCaptureSavePath = RevealScreenCaptureSavePathInteractor(
    repository,
    const SystemFileOpener(),
  );
  final setShowCapturePreview = SetShowCapturePreviewInteractor(repository);
  final setFrameRate = SetFrameRateInteractor(repository);
  final setQuality = SetQualityInteractor(repository);
  final setTurnDeviceScreenOff = SetTurnDeviceScreenOffInteractor(repository);
  final setMuteOnConnect = SetMuteOnConnectInteractor(repository);
  final setSyncClipboard = SetSyncClipboardInteractor(repository);
  final setAdbPath = SetAdbPathInteractor(repository);

  this : super(SettingsState.initial(themeMode)) {
    on<_OnSetup>(_onSetup);
    on<_OnSetThemeMode>(_onSetThemeMode, transformer: sequential());
    on<_OnSetScreenCaptureSavePath>(
      _onSetScreenCaptureSavePath,
      transformer: sequential(),
    );
    on<_OnRevealScreenCaptureSavePath>(
      _onRevealScreenCaptureSavePath,
      transformer: droppable(),
    );
    on<_OnSetShowCapturePreview>(
      _onSetShowCapturePreview,
      transformer: sequential(),
    );
    on<_OnSetFrameRate>(_onSetFrameRate, transformer: sequential());
    on<_OnSetQuality>(_onSetQuality, transformer: sequential());
    on<_OnSetTurnDeviceScreenOff>(
      _onSetTurnDeviceScreenOff,
      transformer: sequential(),
    );
    on<_OnSetMuteOnConnect>(_onSetMuteOnConnect, transformer: sequential());
    on<_OnSetSyncClipboard>(_onSetSyncClipboard, transformer: sequential());
    on<_OnSetAdbPath>(_onSetAdbPath, transformer: sequential());

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
        .intercept(_report('Design'))
        .run(event.themeMode);
  }

  FutureOr<void> _onSetScreenCaptureSavePath(
    _OnSetScreenCaptureSavePath event,
    Emitter<SettingsState> emit,
  ) {
    return setScreenCaptureSavePath
        .logger()
        .intercept(_report('Speicherort'))
        .run(event.path);
  }

  FutureOr<void> _onRevealScreenCaptureSavePath(
    _OnRevealScreenCaptureSavePath event,
    Emitter<SettingsState> emit,
  ) {
    return revealScreenCaptureSavePath
        .logger()
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Ordner konnte nicht geöffnet werden: $e'),
          ),
        )
        .run(unit);
  }

  FutureOr<void> _onSetShowCapturePreview(
    _OnSetShowCapturePreview event,
    Emitter<SettingsState> emit,
  ) {
    return setShowCapturePreview
        .logger()
        .intercept(_report('Vorschau'))
        .run(event.value);
  }

  FutureOr<void> _onSetFrameRate(
    _OnSetFrameRate event,
    Emitter<SettingsState> emit,
  ) {
    return setFrameRate
        .logger()
        .intercept(_report('Bildrate'))
        .run(event.frameRate);
  }

  FutureOr<void> _onSetQuality(
    _OnSetQuality event,
    Emitter<SettingsState> emit,
  ) {
    return setQuality
        .logger()
        .intercept(_report('Bildqualität'))
        .run(event.quality);
  }

  FutureOr<void> _onSetTurnDeviceScreenOff(
    _OnSetTurnDeviceScreenOff event,
    Emitter<SettingsState> emit,
  ) {
    return setTurnDeviceScreenOff
        .logger()
        .intercept(_report('Display am Gerät ausschalten'))
        .run(event.value);
  }

  FutureOr<void> _onSetMuteOnConnect(
    _OnSetMuteOnConnect event,
    Emitter<SettingsState> emit,
  ) {
    return setMuteOnConnect
        .logger()
        .intercept(_report('Ton stummschalten'))
        .run(event.value);
  }

  FutureOr<void> _onSetSyncClipboard(
    _OnSetSyncClipboard event,
    Emitter<SettingsState> emit,
  ) {
    return setSyncClipboard
        .logger()
        .intercept(_report('Zwischenablage synchronisieren'))
        .run(event.value);
  }

  FutureOr<void> _onSetAdbPath(
    _OnSetAdbPath event,
    Emitter<SettingsState> emit,
  ) {
    return setAdbPath.logger().intercept(_report('adb-Pfad')).run(event.path);
  }

  void Function(Object) _report(String setting) {
    return (error) => notifications.notify(
      .new(message: '„$setting" konnte nicht gespeichert werden: $error'),
    );
  }
}
