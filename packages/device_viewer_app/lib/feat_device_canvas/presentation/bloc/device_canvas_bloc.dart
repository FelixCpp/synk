import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:device_viewer/feat_device_canvas/application/screen_mirror_channel.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_canvas/domain/usecases/capture_screenshot_interactor.dart';
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
  final screenMirrorChannel = ScreenMirrorChannel();
  StreamSubscription<Uint8List>? _mirrorSubscription;

  this : super(DeviceCanvasState.initial()) {
    on<_OnSetup>((event, emit) {
      return emit.onEach(
        repository.observeDevices(),
        onData: (devices) async {
          final previousIds = state.devices.map((d) => d.device.id).toSet();
          final currentIds = devices.map((d) => d.device.id).toSet();
          emit(state.copyWith(devices: devices));

          final mirroringId = state.mirroringDeviceId;

          if (mirroringId != null && !currentIds.contains(mirroringId)) {
            await _mirrorSubscription?.cancel();
            _mirrorSubscription = null;
            await screenMirrorChannel.stop();
            emit(
              state.copyWith(mirroringDeviceId: null, mirrorTextureId: null),
            );
            return;
          }

          if (mirroringId == null) {
            for (final canvasDevice in devices) {
              if (!previousIds.contains(canvasDevice.device.id)) {
                add(DeviceCanvasEvent.onToggleScreenMirror(canvasDevice));
                break;
              }
            }
          }
        },
      );
    });

    on<_OnCaptureScreenshot>((event, emit) {
      return captureScreenshot
          .intercept(
            (e) => notifications.notify(
              .new(message: 'Failed to capture screenshot: $e'),
            ),
          )
          .run(event.device.device);
    }, transformer: droppable());

    on<_OnToggleScreenMirror>((event, emit) async {
      final device = event.device.device;

      try {
        final textureId =
            state.mirrorTextureId ?? await screenMirrorChannel.createTexture();
        await screenMirrorChannel.start();

        final stream = await repository.startScreenMirror(device);
        _mirrorSubscription = stream.listen(screenMirrorChannel.sendChunk);

        emit(
          state.copyWith(
            mirroringDeviceId: device.id,
            mirrorTextureId: textureId,
          ),
        );
      } catch (e) {
        notifications.notify(
          .new(message: 'Failed to start screen mirror: $e'),
        );
      }
    }, transformer: droppable());

    add(DeviceCanvasEvent.onSetup());
  }
}
