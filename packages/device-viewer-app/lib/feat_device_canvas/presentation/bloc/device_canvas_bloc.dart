import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_canvas_bloc.freezed.dart';
part 'device_canvas_state.dart';
part 'device_canvas_event.dart';

class DeviceCanvasBloc(final DeviceCanvasRepository repository)
    extends Bloc<DeviceCanvasEvent, DeviceCanvasState> {
  this : super(DeviceCanvasState.initial()) {
    on<_OnSetup>((event, emit) {
      return emit.forEach(
        repository.observeDevices(),
        onData: (devices) {
          return state.copyWith(devices: devices);
        },
      );
    });

    add(DeviceCanvasEvent.onSetup());
  }
}
