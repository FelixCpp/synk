import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:device_viewer/feat_sidebar/domain/repositories/sidebar_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sidebar_bloc.freezed.dart';
part 'sidebar_state.dart';
part 'sidebar_event.dart';

class SidebarBloc(
  final SidebarRepository repository,
  final DeviceConnectionsRepository connectionsRepository,
) extends Bloc<SidebarEvent, SidebarState> {
  this : super(SidebarState.initial()) {
    on<_OnSetup>((event, emit) {
      return emit.forEach(
        repository.observeDevices(),
        onData: (devices) {
          return state.copyWith(devices: devices);
        },
      );
    }, transformer: droppable());

    on<_OnConnect>((event, emit) async {
      await connectionsRepository.connect(event.deviceId);
    }, transformer: restartable());

    add(const SidebarEvent.onSetup());
  }
}
