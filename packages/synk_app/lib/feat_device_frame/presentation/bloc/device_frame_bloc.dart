import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_frame/domain/usecases/capture_screenshot_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/navigate_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/press_power_button_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/send_files_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/send_picked_apk_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/send_picked_file_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/set_audio_muted_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/set_audio_volume_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/simulate_key_event_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/simulate_pinch_event_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/simulate_pointer_event_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/start_recording_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/stop_recording_interactor.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_in_case/use_in_case.dart';

part 'device_frame_bloc.freezed.dart';
part 'device_frame_event.dart';
part 'device_frame_state.dart';

class DeviceFrameBloc({
  required final DeviceFrameRepository repository,
  required final NotificationService notifications,
}) extends Bloc<DeviceFrameEvent, DeviceFrameState> {
  final simulateKeyEvent = SimulateKeyEventInteractor(repository);
  final simulatePointerEvent = SimulatePointerEventInteractor(repository);
  final simulatePinchEvent = SimulatePinchEventInteractor(repository);
  final captureScreenshot = CaptureScreenshotInteractor(repository);
  final startRecording = StartRecordingInteractor(repository);
  final stopRecording = StopRecordingInteractor(repository);
  final setAudioMuted = SetAudioMutedInteractor(repository);
  final setAudioVolume = SetAudioVolumeInteractor(repository);
  final sendFiles = SendFilesInteractor(repository);
  final sendPickedApk = SendPickedApkInteractor(repository);
  final sendPickedFile = SendPickedFileInteractor(repository);
  final navigate = NavigateInteractor(repository);
  final pressPowerButton = PressPowerButtonInteractor(repository);

  this
    : super(
        .initial(
          isAudioMuted: repository.isAudioMuted,
          audioVolume: repository.audioVolume,
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

    return simulateKeyEvent
        .logger(level: .trace)
        .after(_reportClipboardSyncFailure)
        .intercept(_notify('Failed to simulate key stroke'))
        .run(keyEvent);
  }

  void _reportClipboardSyncFailure(ClipboardSyncFailure? failure) {
    if (failure == null) {
      return;
    }

    notifications.notify(
      .new(
        message: switch (failure) {
          .toolUnavailable =>
            'Zwischenablage nicht verfügbar: Xcode (devicectl) lässt sich '
                'nicht ausführen oder das Gerät ist nicht erreichbar.',
          .deviceUnreachable =>
            'Die Zwischenablage des Geräts ist nicht erreichbar.',
        },
      ),
    );
  }

  FutureOr<void> _onPointerEvent(
    _OnPointerEvent event,
    Emitter<DeviceFrameState> emit,
  ) {
    return simulatePointerEvent
        .logger(level: .trace)
        .intercept(_notify('Failed to simulate pointer event'))
        .run(
          .new(
            type: event.type,
            normalizedPointerX: event.normalizedPointerX,
            normalizedPointerY: event.normalizedPointerY,
          ),
        );
  }

  FutureOr<void> _onPinchEvent(
    _OnPinchEvent event,
    Emitter<DeviceFrameState> emit,
  ) {
    return simulatePinchEvent
        .logger(level: .trace)
        .intercept(_notify('Failed to simulate pinch gesture'))
        .run((
          type: event.type,
          centerX: event.centerX,
          centerY: event.centerY,
          spread: event.spread,
        ));
  }

  FutureOr<void> _onCaptureScreenshot(
    _OnCaptureScreenshot event,
    Emitter<DeviceFrameState> emit,
  ) {
    return captureScreenshot
        .logger()
        .intercept(_notify('Failed to capture screenshot'))
        .run(unit);
  }

  FutureOr<void> _onToggleRecording(
    _OnToggleRecording event,
    Emitter<DeviceFrameState> emit,
  ) {
    if (state.isRecording) {
      emit(state.copyWith(isRecording: false));

      return stopRecording
          .logger()
          .intercept(_notify('Failed to stop recording'))
          .run(unit);
    }

    return startRecording
        .logger()
        .after((_) => emit(state.copyWith(isRecording: true)))
        .intercept(_notify('Failed to start recording'))
        .run(unit);
  }

  FutureOr<void> _onToggleAudioMute(
    _OnToggleAudioMute event,
    Emitter<DeviceFrameState> emit,
  ) {
    final muted = !state.isAudioMuted;
    emit(state.copyWith(isAudioMuted: muted));

    return setAudioMuted
        .logger()
        .intercept(_notify('Failed to toggle audio'))
        .run(muted);
  }

  Future<void> _onAudioVolumeChanged(
    _OnAudioVolumeChanged event,
    Emitter<DeviceFrameState> emit,
  ) async {
    final unmute = state.isAudioMuted && event.volume > 0.0;
    emit(
      state.copyWith(
        audioVolume: event.volume,
        isAudioMuted: unmute ? false : state.isAudioMuted,
      ),
    );

    await setAudioVolume
        .logger(level: .trace)
        .intercept(_notify('Failed to change the volume'))
        .run(event.volume);

    if (unmute) {
      await setAudioMuted
          .logger()
          .intercept(_notify('Failed to toggle audio'))
          .run(false);
    }
  }

  FutureOr<void> _onFilesDropped(
    _OnFilesDropped event,
    Emitter<DeviceFrameState> emit,
  ) {
    return sendFiles
        .logger()
        .busyStateChange(
          (isBusy) => emit(state.copyWith(isTransferringFiles: isBusy)),
        )
        .after((outcomes) => outcomes.forEach(_reportTransfer))
        .intercept(_notify('Failed to handle dropped files'))
        .run(event.filepaths);
  }

  FutureOr<void> _onInstallApk(
    _OnInstallApk event,
    Emitter<DeviceFrameState> emit,
  ) {
    return sendPickedApk
        .logger()
        .busyStateChange(
          (isBusy) => emit(state.copyWith(isTransferringFiles: isBusy)),
        )
        .after(_reportTransfer)
        .intercept(_notify('Failed to install APK'))
        .run(unit);
  }

  FutureOr<void> _onShareFile(
    _OnShareFile event,
    Emitter<DeviceFrameState> emit,
  ) {
    return sendPickedFile
        .logger()
        .busyStateChange(
          (isBusy) => emit(state.copyWith(isTransferringFiles: isBusy)),
        )
        .after(_reportTransfer)
        .intercept(_notify('Failed to share file'))
        .run(unit);
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
    return navigate
        .logger()
        .intercept(_notify('Failed to navigate'))
        .run(event.navigation);
  }

  FutureOr<void> _onPowerButtonPressed(
    _OnPowerButtonPressed event,
    Emitter<DeviceFrameState> emit,
  ) {
    return pressPowerButton
        .logger()
        .intercept(_notify('Failed to press the power button'))
        .run(unit);
  }

  void Function(Object) _notify(String message) {
    return (error) => notifications.notify(.new(message: '$message: $error'));
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
