import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/usecases/toggle_connection_interactor.dart';
import 'package:device_viewer/feat_notifications/application/notification_service.dart';
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
  final toggleConnection = ToggleConnectionInteractor(connectionsRepository);

  this : super(DeviceCanvasState.initial()) {
    on<_OnSetup>(_onSetup);
    on<_OnCloseDevice>(_onCloseDevice, transformer: sequential());

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
}
