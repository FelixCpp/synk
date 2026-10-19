import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_maximized_device/presentation/maximized_device_watch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'maximized_device_bloc.freezed.dart';
part 'maximized_device_state.dart';
part 'maximized_device_event.dart';

class MaximizedDeviceBloc({
  required final DeviceConnection device,
  required final MaximizedDeviceWatch watch,
}) extends Bloc<MaximizedDeviceEvent, MaximizedDeviceState> {
  this : super(MaximizedDeviceState(device: device, isGone: false)) {
    on<_OnSetup>(_onSetup, transformer: droppable());

    add(const .onSetup());
  }

  FutureOr<void> _onSetup(_OnSetup event, Emitter<MaximizedDeviceState> emit) {
    return emit.forEach(
      watch.observe(device.device.id),
      onData: (device) {
        if (device == null) {
          return state.copyWith(isGone: true);
        }

        return state.copyWith(device: device);
      },
    );
  }
}
