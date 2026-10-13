import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:synk/feat_device_platform/domain/models/device_key_event.dart';
import 'package:synk/feat_device_platform/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_platform/domain/models/device_navigation.dart';
import 'package:synk/feat_device_platform/domain/models/pinch_event.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_frame/domain/usecases/capture_screenshot_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/handle_dropped_files_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/install_apk_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/is_audio_muted_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/set_audio_muted_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/share_file_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/navigate_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/press_power_button_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/simulate_key_event_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/simulate_pinch_event_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/simulate_pointer_event_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/start_recording_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/stop_recording_interactor.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_in_case/use_in_case.dart';

part 'device_frame_bloc.freezed.dart';
part 'device_frame_event.dart';
part 'device_frame_state.dart';

class DeviceFrameBloc({
  required final DeviceId deviceId,
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
  final isAudioMuted = IsAudioMutedInteractor(repository);
  final handleDroppedFiles = HandleDroppedFilesInteractor(repository);
  final navigate = NavigateInteractor(repository);
  final pressPowerButton = PressPowerButtonInteractor(repository);
  final installApk = InstallApkInteractor(repository);
  final shareFile = ShareFileInteractor(repository);

  this : super(.initial()) {
    on<_OnSetup>(_onSetup);
    on<_OnKeyEvent>(_onKeyEvent, transformer: sequential());
    on<_OnPointerEvent>(_onPointerEvent, transformer: sequential());
    on<_OnPinchEvent>(_onPinchEvent, transformer: sequential());
    on<_OnCaptureScreenshot>(_onCaptureScreenshot, transformer: sequential());
    on<_OnToggleRecording>(_onToggleRecording, transformer: sequential());
    on<_OnToggleAudioMute>(_onToggleAudioMute, transformer: sequential());
    on<_OnFilesDropped>(_onFilesDropped, transformer: sequential());
    on<_OnNavigate>(_onNavigate, transformer: sequential());
    on<_OnPowerButtonPressed>(
      _onPowerButtonPressed,
      transformer: sequential(),
    );
    on<_OnInstallApk>(_onInstallApk, transformer: sequential());
    on<_OnShareFile>(_onShareFile, transformer: sequential());

    add(const .onSetup());
  }

  FutureOr<void> _onSetup(_OnSetup event, Emitter<DeviceFrameState> emit) {
    return isAudioMuted
        .logger(level: .trace)
        .after((muted) => emit(state.copyWith(isAudioMuted: muted)))
        .run(deviceId);
  }

  FutureOr<void> _onKeyEvent(
    _OnKeyEvent event,
    Emitter<DeviceFrameState> emit,
  ) async {
    final keyEvent = event.keyEvent.toDeviceKeyEvent();
    if (keyEvent == null) {
      return;
    }

    return simulateKeyEvent
        .logger(level: .trace)
        .after((failure) {
          if (failure == null) {
            return;
          }

          notifications.notify(
            .new(
              message: switch (failure) {
                .toolUnavailable =>
                  'Zwischenablage nicht verfügbar: Xcode (devicectl) lässt '
                      'sich nicht ausführen oder das Gerät ist nicht '
                      'erreichbar.',
                .deviceUnreachable =>
                  'Die Zwischenablage des Geräts ist nicht erreichbar.',
              },
            ),
          );
        })
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to simulate key stroke: $e'),
          ),
        )
        .run((deviceId: deviceId, keyEvent: keyEvent));
  }

  FutureOr<void> _onPointerEvent(
    _OnPointerEvent event,
    Emitter<DeviceFrameState> emit,
  ) async {
    final pointerEvent = DevicePointerEvent(
      type: event.type,
      normalizedPointerX: event.normalizedPointerX,
      normalizedPointerY: event.normalizedPointerY,
    );

    await simulatePointerEvent
        .logger(level: .trace)
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to simulate pointer event: $e'),
          ),
        )
        .run((deviceId: deviceId, pointerEvent: pointerEvent));
  }

  FutureOr<void> _onPinchEvent(
    _OnPinchEvent event,
    Emitter<DeviceFrameState> emit,
  ) async {
    final PinchEvent pinchEvent = (
      type: event.type,
      centerX: event.centerX,
      centerY: event.centerY,
      spread: event.spread,
    );

    await simulatePinchEvent
        .logger(level: .trace)
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to simulate pinch gesture: $e'),
          ),
        )
        .run((deviceId: deviceId, pinchEvent: pinchEvent));
  }

  FutureOr<void> _onCaptureScreenshot(
    _OnCaptureScreenshot event,
    Emitter<DeviceFrameState> emit,
  ) {
    return captureScreenshot
        .logger()
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to capture screenshot: $e'),
          ),
        )
        .run(deviceId);
  }

  FutureOr<void> _onToggleRecording(
    _OnToggleRecording event,
    Emitter<DeviceFrameState> emit,
  ) {
    if (state.isRecording) {
      emit(state.copyWith(isRecording: false));

      return stopRecording
          .logger()
          .intercept(
            (e) => notifications.notify(
              .new(message: 'Failed to stop recording: $e'),
            ),
          )
          .run(deviceId);
    }

    return startRecording
        .logger()
        .after((started) {
          if (started) emit(state.copyWith(isRecording: true));
        })
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to start recording: $e'),
          ),
        )
        .run(deviceId);
  }

  FutureOr<void> _onToggleAudioMute(
    _OnToggleAudioMute event,
    Emitter<DeviceFrameState> emit,
  ) {
    final muted = !state.isAudioMuted;
    emit(state.copyWith(isAudioMuted: muted));

    return setAudioMuted
        .logger()
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to toggle audio: $e'),
          ),
        )
        .run((deviceId: deviceId, muted: muted));
  }

  FutureOr<void> _onFilesDropped(
    _OnFilesDropped event,
    Emitter<DeviceFrameState> emit,
  ) {
    return handleDroppedFiles
        .logger()
        .busyStateChange(
          (isBusy) => emit(state.copyWith(isProcessingDroppedFiles: isBusy)),
        )
        .after((outcomes) {
          for (final outcome in outcomes) {
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
        })
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to handle dropped files: $e'),
          ),
        )
        .run((deviceId: deviceId, filepaths: event.filepaths));
  }

  FutureOr<void> _onNavigate(
    _OnNavigate event,
    Emitter<DeviceFrameState> emit,
  ) {
    return navigate
        .logger()
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to navigate: $e'),
          ),
        )
        .run((deviceId: deviceId, navigation: event.navigation));
  }

  FutureOr<void> _onPowerButtonPressed(
    _OnPowerButtonPressed event,
    Emitter<DeviceFrameState> emit,
  ) {
    return pressPowerButton
        .logger()
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to press the power button: $e'),
          ),
        )
        .run(deviceId);
  }

  FutureOr<void> _onInstallApk(
    _OnInstallApk event,
    Emitter<DeviceFrameState> emit,
  ) {
    return installApk
        .logger()
        .busyStateChange(
          (isBusy) => emit(state.copyWith(isProcessingDroppedFiles: isBusy)),
        )
        .after((outcome) {
          if (outcome == null) {
            return;
          }

          notifications.notify(
            .new(
              severity: .success,
              message: 'App installiert: ${outcome.filename}',
            ),
          );
        })
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to install APK: $e'),
          ),
        )
        .run(deviceId);
  }

  FutureOr<void> _onShareFile(
    _OnShareFile event,
    Emitter<DeviceFrameState> emit,
  ) {
    return shareFile
        .logger()
        .busyStateChange(
          (isBusy) => emit(state.copyWith(isProcessingDroppedFiles: isBusy)),
        )
        .after((outcome) {
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
        })
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to share file: $e'),
          ),
        )
        .run(deviceId);
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
      type: type,
      modifiers: _pressedModifiers(HardwareKeyboard.instance),
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
