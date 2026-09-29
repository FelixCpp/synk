import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_key_event.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_pointer_action.dart';
import 'package:device_viewer/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/capture_screenshot_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/handle_dropped_files_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/simulate_key_event_interactor.dart';
import 'package:device_viewer/feat_device_frame/domain/usecases/simulate_pointer_event_interactor.dart';
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
  final handleDroppedFiles = HandleDroppedFilesInteractor(repository);

  this : super(.initial()) {
    on<_OnSetup>(_onSetup);
    on<_OnKeyEvent>(_onKeyEvent, transformer: sequential());
    on<_OnPointerEvent>(_onPointerEvent, transformer: sequential());
    on<_OnCaptureScreenshot>(_onCaptureScreenshot, transformer: sequential());
    on<_OnFilesDropped>(_onFilesDropped, transformer: sequential());

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
