import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:synk/feat_maximized_device/domain/models/maximized_device.dart';
import 'package:synk/feat_maximized_device/domain/repositories/maximized_device_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'maximized_device_bloc.freezed.dart';
part 'maximized_device_state.dart';
part 'maximized_device_event.dart';

class MaximizedDeviceBloc({
  required final MaximizedDevice device,
  required final MaximizedDeviceRepository repository,
}) extends Bloc<MaximizedDeviceEvent, MaximizedDeviceState> {
  this : super(MaximizedDeviceState(device: device, isGone: false)) {
    on<_OnSetup>(_onSetup, transformer: droppable());

    add(const .onSetup());
  }

  FutureOr<void> _onSetup(_OnSetup event, Emitter<MaximizedDeviceState> emit) {
    return emit.forEach(
      repository.observeDevice(device.deviceId),
      onData: (device) {
        if (device == null) {
          return state.copyWith(isGone: true);
        }

        return state.copyWith(device: device);
      },
    );
  }
}
