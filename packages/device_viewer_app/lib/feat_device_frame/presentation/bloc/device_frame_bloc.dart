import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_key_event.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_pointer_action.dart';
import 'package:device_viewer/feat_device_frame/domain/models/control_button_type.dart';
import 'package:device_viewer/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/capture_screenshot_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/handle_dropped_files_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/install_apk_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/share_file_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/simulate_control_button_event_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/simulate_key_event_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/simulate_pointer_event_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/start_recording_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/stop_recording_interactor.dart';
import 'package:device_viewer/feat_notifications/application/notification_service.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';
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
  final captureScreenshot = CaptureScreenshotInteractor(repository);
  final startRecording = StartRecordingInteractor(repository);
  final stopRecording = StopRecordingInteractor(repository);
  final handleDroppedFiles = HandleDroppedFilesInteractor(repository);
  final simulateControlButton = SimulateControlButtonEventInteractor(
    repository,
  );
  final installApk = InstallApkInteractor(repository);
  final shareFile = ShareFileInteractor(repository);

  this : super(.initial()) {
    on<_OnSetup>(_onSetup);
    on<_OnKeyEvent>(_onKeyEvent, transformer: sequential());
    on<_OnPointerEvent>(_onPointerEvent, transformer: sequential());
    on<_OnCaptureScreenshot>(_onCaptureScreenshot, transformer: sequential());
    on<_OnToggleRecording>(_onToggleRecording, transformer: sequential());
    on<_OnFilesDropped>(_onFilesDropped, transformer: sequential());
    on<_OnControlButtonPressed>(
      _onControlButtonPressed,
      transformer: sequential(),
    );
    on<_OnInstallApk>(_onInstallApk, transformer: sequential());
    on<_OnShareFile>(_onShareFile, transformer: sequential());

    add(const .onSetup());
  }

  FutureOr<void> _onSetup(_OnSetup event, Emitter<DeviceFrameState> emit) {}

  FutureOr<void> _onKeyEvent(
    _OnKeyEvent event,
    Emitter<DeviceFrameState> emit,
  ) async {
    final keyEvent = event.keyEvent.toKeyEvent();
    if (keyEvent == null) {
      return;
    }

    return simulateKeyEvent
        .logger(level: .trace)
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
    final pointerEvent = ScrcpyPointerEvent(
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

  FutureOr<void> _onControlButtonPressed(
    _OnControlButtonPressed event,
    Emitter<DeviceFrameState> emit,
  ) {
    return simulateControlButton
        .logger()
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to simulate control button press: $e'),
          ),
        )
        .run((deviceId: deviceId, type: event.type));
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
  static final _androidKeyByLogicalKey = Map.fromEntries(
    kAndroidToLogicalKey.entries.map(
      (entry) => MapEntry(entry.value, ScrcpyKeyCode(entry.key)),
    ),
  );

  ScrcpyKeyEvent? toKeyEvent() {
    final androidKey = _androidKeyByLogicalKey[logicalKey];
    if (androidKey == null) {
      return null;
    }

    final type = toKeyType();
    if (type == null) {
      return null;
    }

    final hardwareKeyboard = HardwareKeyboard.instance;
    final metaState = resolveMetaState(hardwareKeyboard);

    return .new(
      keyCode: androidKey,
      type: type,
      metaState: metaState,
    );
  }

  ScrcpyKeyEventType? toKeyType() {
    return switch (this) {
      KeyDownEvent() => .down,
      KeyRepeatEvent() => .repeat,
      KeyUpEvent() => .up,
      _ => null,
    };
  }

  ScrcpyKeyMetaState resolveMetaState(HardwareKeyboard keyboard) {
    var metaState = ScrcpyKeyMetaState.none.value;

    for (final key in keyboard.logicalKeysPressed) {
      metaState |= switch (key) {
        LogicalKeyboardKey.shiftLeft =>
          ScrcpyKeyMetaState.shiftLeftOn | ScrcpyKeyMetaState.shiftOn,
        LogicalKeyboardKey.shiftRight =>
          ScrcpyKeyMetaState.shiftRightOn | ScrcpyKeyMetaState.shiftOn,
        LogicalKeyboardKey.controlLeft =>
          ScrcpyKeyMetaState.ctrlLeftOn | ScrcpyKeyMetaState.ctrlOn,
        LogicalKeyboardKey.controlRight =>
          ScrcpyKeyMetaState.ctrlRightOn | ScrcpyKeyMetaState.ctrlOn,
        LogicalKeyboardKey.altLeft =>
          ScrcpyKeyMetaState.altLeftOn | ScrcpyKeyMetaState.altOn,
        LogicalKeyboardKey.altRight =>
          ScrcpyKeyMetaState.altRightOn | ScrcpyKeyMetaState.altOn,
        LogicalKeyboardKey.metaLeft =>
          ScrcpyKeyMetaState.metaLeftOn | ScrcpyKeyMetaState.metaOn,
        LogicalKeyboardKey.metaRight =>
          ScrcpyKeyMetaState.metaRightOn | ScrcpyKeyMetaState.metaOn,
        _ => ScrcpyKeyMetaState.none,
      };
    }

    for (final lockMode in keyboard.lockModesEnabled) {
      metaState |= switch (lockMode) {
        .capsLock => ScrcpyKeyMetaState.capsLockOn,
        .numLock => ScrcpyKeyMetaState.numLockOn,
        .scrollLock => ScrcpyKeyMetaState.scrollLockOn,
      };
    }

    return ScrcpyKeyMetaState(metaState);
  }
}
