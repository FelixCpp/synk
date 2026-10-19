import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_frame/domain/device_frame_interactors.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/application/notified_interactor.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_in_case/use_in_case.dart';

part 'device_frame_bloc.freezed.dart';
part 'device_frame_event.dart';
part 'device_frame_state.dart';

class DeviceFrameBloc({
  required final DeviceFrameInteractors device,
  required final NotificationService notifications,
}) extends Bloc<DeviceFrameEvent, DeviceFrameState> {

  this
    : super(
        .initial(
          isAudioMuted: device.isAudioMuted,
          audioVolume: device.audioVolume,
        ),
      ) {
    on<_OnKeyEvent>(_onKeyEvent, transformer: sequential());
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
    on<_OnInstallApk>(_onInstallApk, transformer: sequential());
    on<_OnShareFile>(_onShareFile, transformer: sequential());
  }

  FutureOr<void> _onKeyEvent(
    _OnKeyEvent event,
    Emitter<DeviceFrameState> emit,
  ) {
    final keyEvent = event.keyEvent.toDeviceKeyEvent();
    if (keyEvent == null) {
      return null;
    }

    return device.simulateKeyEvent
        .logger(level: .trace)
        .runReporting(
          keyEvent,
          to: notifications,
          whenItFails: 'Die Tastatureingabe kam nicht am Gerät an.',
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
      unit,
      to: notifications,
      whenItFails: 'Der Screenshot ist fehlgeschlagen.',
    );
  }

  FutureOr<void> _onToggleRecording(
    _OnToggleRecording event,
    Emitter<DeviceFrameState> emit,
  ) {
    if (state.isRecording) {
      return device.stopRecording
          .logger()
          .after((_) => emit(state.copyWith(isRecording: false)))
          .runReporting(
            unit,
            to: notifications,
            whenItFails: 'Die Aufnahme ließ sich nicht beenden.',
          );
    }

    return device.startRecording
        .logger()
        .after((_) => emit(state.copyWith(isRecording: true)))
        .runReporting(
          unit,
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
          unit,
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
          unit,
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
          .pushed => 'Datei auf Gerät übertragen: ${outcome.filename}',
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
      unit,
      to: notifications,
      whenItFails: 'Der Standby-Knopf kam nicht am Gerät an.',
    );
  }
}

extension on KeyEvent {
  DeviceKeyEvent? toDeviceKeyEvent() {
    final DeviceKeyEventType? type = switch (this) {
      KeyDownEvent() => .down,
      KeyRepeatEvent() => .repeat,
      KeyUpEvent() => .up,
      _ => null,
    };

    if (type == null) {
      return null;
    }

    return .new(
      key: logicalKey,
      physicalKey: physicalKey,
      type: type,
      modifiers: _pressedModifiers(HardwareKeyboard.instance),
      character: character,
    );
  }
}

Set<DeviceKeyModifier> _pressedModifiers(HardwareKeyboard keyboard) {
  return {
    for (final key in keyboard.logicalKeysPressed)
      ?switch (key) {
        LogicalKeyboardKey.shiftLeft => DeviceKeyModifier.shiftLeft,
        LogicalKeyboardKey.shiftRight => DeviceKeyModifier.shiftRight,
        LogicalKeyboardKey.controlLeft => DeviceKeyModifier.controlLeft,
        LogicalKeyboardKey.controlRight => DeviceKeyModifier.controlRight,
        LogicalKeyboardKey.altLeft => DeviceKeyModifier.altLeft,
        LogicalKeyboardKey.altRight => DeviceKeyModifier.altRight,
        LogicalKeyboardKey.metaLeft => DeviceKeyModifier.metaLeft,
        LogicalKeyboardKey.metaRight => DeviceKeyModifier.metaRight,
        _ => null,
      },
    for (final lockMode in keyboard.lockModesEnabled)
      switch (lockMode) {
        .capsLock => DeviceKeyModifier.capsLock,
        .numLock => DeviceKeyModifier.numLock,
        .scrollLock => DeviceKeyModifier.scrollLock,
      },
  };
}
