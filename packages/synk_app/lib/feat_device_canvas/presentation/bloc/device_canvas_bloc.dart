import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_connections/domain/usecases/disconnect_device_interactor.dart';
import 'package:synk/feat_notifications/domain/models/user_message.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_in_case/use_in_case.dart';

part 'device_canvas_bloc.freezed.dart';
part 'device_canvas_state.dart';
part 'device_canvas_event.dart';

class DeviceCanvasBloc(
  final DeviceConnectionsRepository connectionsRepository,
  final NotificationService notifications,
) extends Bloc<DeviceCanvasEvent, DeviceCanvasState> {
  final disconnectDevice = DisconnectDeviceInteractor(connectionsRepository);

  this : super(DeviceCanvasState.initial()) {
    on<_OnSetup>(_onSetup);
    on<_OnCloseDevice>(_onCloseDevice, transformer: sequential());

    add(DeviceCanvasEvent.onSetup());
  }

  FutureOr<void> _onSetup(_OnSetup event, Emitter<DeviceCanvasState> emit) {
    return emit.onEach(
      connectionsRepository.observeDeviceConnections(),
      onData: (devices) {
        emit(state.copyWith(devices: devices));
      },
    );
  }

  FutureOr<void> _onCloseDevice(
    _OnCloseDevice event,
    Emitter<DeviceCanvasState> emit,
  ) {
    return disconnectDevice
        .logger()
        .intercept(
          (error) => notifications.notify(
            .new(
              message: userMessageFor(
                error,
                'Die Spiegelung ließ sich nicht beenden.',
              ),
            ),
          ),
        )
        .run(event.device.device);
  }
}
