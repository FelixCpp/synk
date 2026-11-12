import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_frame/domain/device_frame_interactors.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/screen_orientation.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:synk/feat_notifications/application/notified_interactor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_in_case/use_in_case.dart';

part 'device_frame_bloc.freezed.dart';
part 'device_frame_event.dart';
part 'device_frame_state.dart';

class DeviceFrameBloc({
  required final DeviceFrameInteractors device,
  required final NotificationFeature notifications,
}) extends Bloc<DeviceFrameEvent, DeviceFrameState> {
  this
    : super(
        .initial(
          isRecording: device.isRecording,
          isAudioMuted: device.isAudioMuted,
          audioVolume: device.audioVolume,
        ),
      ) {
    on<_OnKeyEvent>(_onKeyEvent, transformer: sequential());
    on<_OnKeyboardLeft>(_onKeyboardLeft, transformer: sequential());
    on<_OnTextComposed>(_onTextComposed, transformer: sequential());
    on<_OnTypeHostClipboard>(_onTypeHostClipboard, transformer: droppable());
    on<_OnPointerEvent>(_onPointerEvent, transformer: sequential());
    on<_OnPinchEvent>(_onPinchEvent, transformer: sequential());
    on<_OnCaptureScreenshot>(_onCaptureScreenshot, transformer: sequential());
    on<_OnToggleRecording>(_onToggleRecording, transformer: sequential());
    on<_OnToggleAudioMute>(_onToggleAudioMute, transformer: sequential());
    on<_OnAudioVolumeChanged>(
      _onAudioVolumeChanged,
      transformer: sequential(),
    );
    on<_OnFilesDropped>(_onFilesDropped, transformer: sequential());
    on<_OnNavigate>(_onNavigate, transformer: sequential());
    on<_OnPowerButtonPressed>(
      _onPowerButtonPressed,
      transformer: sequential(),
    );
    on<_OnRotate>(_onRotate, transformer: droppable());
    on<_OnInstallApk>(_onInstallApk, transformer: sequential());
    on<_OnShareFile>(_onShareFile, transformer: sequential());
  }

  FutureOr<void> _onKeyEvent(
    _OnKeyEvent event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.simulateKeyEvent
        .logger(level: .trace)
        .runReporting(
          event.keyEvent,
          to: notifications,
          whenItFails: 'Die Tastatureingabe kam nicht am Gerät an.',
        );
  }

  FutureOr<void> _onKeyboardLeft(
    _OnKeyboardLeft event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.releasePressedKeys.logger().run();
  }

  FutureOr<void> _onTextComposed(
    _OnTextComposed event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.typeText.logger().runReporting(
      event.text,
      to: notifications,
      whenItFails: 'Der Text kam nicht am Gerät an.',
    );
  }

  FutureOr<void> _onTypeHostClipboard(
    _OnTypeHostClipboard event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.typeHostClipboard.logger().runReporting(
      to: notifications,
      whenItFails: 'Die Zwischenablage ließ sich nicht eintippen.',
    );
  }

  FutureOr<void> _onPointerEvent(
    _OnPointerEvent event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.simulatePointerEvent.runReporting(
      .new(
        type: event.type,
        normalizedPointerX: event.normalizedPointerX,
        normalizedPointerY: event.normalizedPointerY,
      ),
      to: notifications,
      whenItFails: 'Die Mauseingabe kam nicht am Gerät an.',
    );
  }

  FutureOr<void> _onPinchEvent(
    _OnPinchEvent event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.simulatePinchEvent.runReporting(
      (
        type: event.type,
        centerX: event.centerX,
        centerY: event.centerY,
        spread: event.spread,
      ),
      to: notifications,
      whenItFails: 'Die Zoom-Geste kam nicht am Gerät an.',
    );
  }

  FutureOr<void> _onCaptureScreenshot(
    _OnCaptureScreenshot event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.captureScreenshot.logger().runReporting(
      to: notifications,
      whenItFails: 'Der Screenshot ist fehlgeschlagen.',
    );
  }

  FutureOr<void> _onToggleRecording(
    _OnToggleRecording event,
    Emitter<DeviceFrameState> emit,
  ) {
    if (state.isRecording) {
      emit(state.copyWith(isRecording: false));

      return device.stopRecording.logger().runReporting(
        to: notifications,
        whenItFails: 'Die Aufnahme ließ sich nicht beenden.',
      );
    }

    return device.startRecording
        .logger()
        .after((_) => emit(state.copyWith(isRecording: true)))
        .runReporting(
          to: notifications,
          whenItFails: 'Die Aufnahme ließ sich nicht starten.',
        );
  }

  FutureOr<void> _onToggleAudioMute(
    _OnToggleAudioMute event,
    Emitter<DeviceFrameState> emit,
  ) {
    final previous = state.isAudioMuted;
    final muted = !previous;
    emit(state.copyWith(isAudioMuted: muted));

    return device.setAudioMuted.logger().runReporting(
      muted,
      to: notifications,
      whenItFails: 'Der Ton ließ sich nicht umschalten.',
      andUndo: () => emit(state.copyWith(isAudioMuted: previous)),
    );
  }

  Future<void> _onAudioVolumeChanged(
    _OnAudioVolumeChanged event,
    Emitter<DeviceFrameState> emit,
  ) async {
    final previousVolume = state.audioVolume;
    final previouslyMuted = state.isAudioMuted;
    final unmute = previouslyMuted && event.volume > 0.0;

    emit(
      state.copyWith(
        audioVolume: event.volume,
        isAudioMuted: unmute ? false : previouslyMuted,
      ),
    );

    await device.setAudioVolume.runReporting(
      event.volume,
      to: notifications,
      whenItFails: 'Die Lautstärke ließ sich nicht ändern.',
      andUndo: () => emit(
        state.copyWith(
          audioVolume: previousVolume,
          isAudioMuted: previouslyMuted,
        ),
      ),
    );

    if (unmute) {
      await device.setAudioMuted.logger().runReporting(
        false,
        to: notifications,
        whenItFails: 'Der Ton ließ sich nicht umschalten.',
        andUndo: () => emit(state.copyWith(isAudioMuted: previouslyMuted)),
      );
    }
  }

  FutureOr<void> _onFilesDropped(
    _OnFilesDropped event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.sendFiles
        .logger()
        .busyStateChange(
          (isBusy) => emit(state.copyWith(isTransferringFiles: isBusy)),
        )
        .after((outcomes) => outcomes.forEach(_reportTransfer))
        .runReporting(
          event.filepaths,
          to: notifications,
          whenItFails: 'Die abgelegten Dateien ließen sich nicht übertragen.',
        );
  }

  FutureOr<void> _onInstallApk(
    _OnInstallApk event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.sendPickedApk
        .logger()
        .busyStateChange(
          (isBusy) => emit(state.copyWith(isTransferringFiles: isBusy)),
        )
        .after(_reportTransfer)
        .runReporting(
          to: notifications,
          whenItFails: 'Die App ließ sich nicht installieren.',
        );
  }

  FutureOr<void> _onShareFile(
    _OnShareFile event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.sendPickedFile
        .logger()
        .busyStateChange(
          (isBusy) => emit(state.copyWith(isTransferringFiles: isBusy)),
        )
        .after(_reportTransfer)
        .runReporting(
          to: notifications,
          whenItFails: 'Die Datei ließ sich nicht übertragen.',
        );
  }

  void _reportTransfer(FileTransferOutcome? outcome) {
    if (outcome == null) {
      return;
    }

    notifications.notify(
      .new(
        severity: .success,
        message: switch (outcome.action) {
          .installed => 'App installiert: ${outcome.filename}',
          .pushed => 'Datei auf Gerät übertragen: ${outcome.destination}',
        },
      ),
    );
  }

  FutureOr<void> _onNavigate(
    _OnNavigate event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.navigate.logger().runReporting(
      event.navigation,
      to: notifications,
      whenItFails: 'Die Navigation kam nicht am Gerät an.',
    );
  }

  FutureOr<void> _onPowerButtonPressed(
    _OnPowerButtonPressed event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.pressPowerButton.logger().runReporting(
      to: notifications,
      whenItFails: 'Der Standby-Knopf kam nicht am Gerät an.',
    );
  }

  FutureOr<void> _onRotate(
    _OnRotate event,
    Emitter<DeviceFrameState> emit,
  ) {
    return device.rotate.logger().runReporting(
      event.direction,
      to: notifications,
      whenItFails: 'Das Gerät ließ sich nicht drehen.',
    );
  }
}
