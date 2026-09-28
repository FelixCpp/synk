import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_key_event.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_touch_action.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_canvas/domain/usecases/capture_screenshot_interactor.dart';
import 'package:device_viewer/feat_device_canvas/domain/usecases/simulate_key_event_interactor.dart';
import 'package:device_viewer/feat_device_canvas/domain/usecases/simulate_touch_event_interactor.dart';
import 'package:device_viewer/feat_device_canvas/domain/usecases/wakeup_device_interactor.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/usecases/toggle_connection_interactor.dart';
import 'package:device_viewer/feat_notifications/application/notification_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_in_case/use_in_case.dart';

part 'device_canvas_bloc.freezed.dart';
part 'device_canvas_state.dart';
part 'device_canvas_event.dart';

class DeviceCanvasBloc(
  final DeviceCanvasRepository repository,
  final DeviceConnectionsRepository connectionsRepository,
  final NotificationService notifications,
) extends Bloc<DeviceCanvasEvent, DeviceCanvasState> {
  final captureScreenshot = CaptureScreenshotInteractor(repository);
  final simulateTouch = SimulateTouchEventInteractor(repository);
  final simulateKey = SimulateKeyEventInteractor(repository);
  final wakeupDevice = WakeupDeviceInteractor(repository);
  final toggleConnection = ToggleConnectionInteractor(connectionsRepository);

  this : super(DeviceCanvasState.initial()) {
    on<_OnSetup>(_onSetup);
    on<_OnCaptureScreenshot>(_onCaptureScreenshot, transformer: droppable());
    on<_OnPointerEvent>(_onPointerEvent, transformer: sequential());
    on<_OnCloseDevice>(_onCloseDevice, transformer: sequential());
    on<_OnKeyEvent>(_onKeyEvent, transformer: sequential());

    add(DeviceCanvasEvent.onSetup());
  }

  FutureOr<void> _onSetup(_OnSetup event, Emitter<DeviceCanvasState> emit) {
    return emit.onEach(
      repository.observeDevices(),
      onData: (devices) {
        emit(state.copyWith(devices: devices));
      },
    );
  }

  FutureOr<void> _onCaptureScreenshot(
    _OnCaptureScreenshot event,
    Emitter<DeviceCanvasState> emit,
  ) {
    return captureScreenshot
        .logger()
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to capture screenshot: $e'),
          ),
        )
        .run(event.device.device);
  }

  FutureOr<void> _onPointerEvent(
    _OnPointerEvent event,
    Emitter<DeviceCanvasState> emit,
  ) async {
    if (event.type == .down) {
      await wakeupDevice
          .logger(level: .trace)
          .intercept(
            (e) => notifications.notify(
              .new(message: 'Failed to wake up device: $e'),
            ),
          )
          .run(event.device.device);
    }

    final action = ScrcpyPointerEvent(
      type: event.type,
      normalizedPointerX: event.normalizedPointerX,
      normalizedPointerY: event.normalizedPointerY,
    );

    return simulateTouch
        .logger(level: .trace)
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to simulate pointer event: $e'),
          ),
        )
        .run((
          device: event.device.device,
          action: action,
        ));
  }

  FutureOr<void> _onCloseDevice(
    _OnCloseDevice event,
    Emitter<DeviceCanvasState> emit,
  ) {
    return toggleConnection
        .logger()
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to close device: $e'),
          ),
        )
        .run(event.device.device);
  }

  FutureOr<void> _onKeyEvent(
    _OnKeyEvent event,
    Emitter<DeviceCanvasState> emit,
  ) async {
    final action = event.event.toKeyEvent();
    if (action == null) {
      return;
    }

    return simulateKey
        .logger(level: .trace)
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to simulate key stroke: $e'),
          ),
        )
        .run((device: event.device.device, action: action));
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
