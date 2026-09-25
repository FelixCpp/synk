import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_canvas/domain/usecases/capture_screenshot_interactor.dart';
import 'package:device_viewer/feat_device_canvas/domain/usecases/start_screen_mirror_interactor.dart';
import 'package:device_viewer/feat_device_canvas/domain/usecases/stop_screen_mirror_interactor.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_notifications/application/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_in_case/use_in_case.dart';

part 'device_canvas_bloc.freezed.dart';
part 'device_canvas_state.dart';
part 'device_canvas_event.dart';

class DeviceCanvasBloc(
  final DeviceCanvasRepository repository,
  final NotificationService notifications,
) extends Bloc<DeviceCanvasEvent, DeviceCanvasState> {
  final captureScreenshot = CaptureScreenshotInteractor(repository);
  final startScreenMirror = StartScreenMirrorInteractor(repository);
  final stopScreenMirror = StopScreenMirrorInteractor(repository);

  this : super(DeviceCanvasState.initial()) {
    on<_OnSetup>(_onSetup);
    on<_OnCaptureScreenshot>(_onCaptureScreenshot, transformer: droppable());
    on<_OnToggleScreenMirror>(_onToggleScreenMirror, transformer: sequential());

    add(DeviceCanvasEvent.onSetup());
  }

  FutureOr<void> _onSetup(_OnSetup event, Emitter<DeviceCanvasState> emit) {
    return emit.onEach(
      repository.observeDevices(),
      onData: (devices) async {
        final previousIds = state.devices.map((d) => d.device.id).toSet();
        final currentIds = devices.map((d) => d.device.id).toSet();
        emit(state.copyWith(devices: devices));

        final disconnectedMirroringIds = state.mirrorTextureIds.keys
            .where((id) => !currentIds.contains(id))
            .toList();

        for (final id in disconnectedMirroringIds) {
          await stopScreenMirror.run(id);
          emit(
            state.copyWith(
              mirrorTextureIds: {...state.mirrorTextureIds}..remove(id),
            ),
          );
        }

        for (final canvasDevice in devices) {
          if (!previousIds.contains(canvasDevice.device.id)) {
            add(DeviceCanvasEvent.onToggleScreenMirror(canvasDevice));
          }
        }
      },
    );
  }

  FutureOr<void> _onCaptureScreenshot(
    _OnCaptureScreenshot event,
    Emitter<DeviceCanvasState> emit,
  ) {
    return captureScreenshot
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to capture screenshot: $e'),
          ),
        )
        .run(event.device.device);
  }

  FutureOr<void> _onToggleScreenMirror(
    _OnToggleScreenMirror event,
    Emitter<DeviceCanvasState> emit,
  ) async {
    final deviceId = event.device.device.id;

    if (state.mirrorTextureIds.containsKey(deviceId)) {
      await stopScreenMirror.run(deviceId);
      return emit(
        state.copyWith(
          mirrorTextureIds: {...state.mirrorTextureIds}..remove(deviceId),
        ),
      );
    }

    final textureId = await startScreenMirror
        .intercept(
          (e) => notifications.notify(
            .new(message: 'Failed to start screen mirror: $e'),
          ),
        )
        .getOrNull(deviceId);

    if (textureId != null) {
      emit(
        state.copyWith(
          mirrorTextureIds: {...state.mirrorTextureIds, deviceId: textureId},
        ),
      );
    }
  }
}
