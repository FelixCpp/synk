import 'package:device_viewer/feat_devices/adb/domain/models/adb_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';
import 'package:device_viewer/feat_sidebar/domain/repositories/sidebar_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sidebar_bloc.freezed.dart';
part 'sidebar_state.dart';
part 'sidebar_event.dart';

class SidebarBloc(
  final SidebarRepository repository,
  final AdbDevicesRepository devicesRepository,
) extends Bloc<SidebarEvent, SidebarState> {
  this : super(SidebarState.initial()) {
    on<_OnSetup>((event, emit) {
      return emit.forEach(
        devicesRepository.observeAdbDevices(),
        onData: (adbDevices) {
          return state.copyWith(adbDevices: adbDevices);
        },
      );
    });

    add(const SidebarEvent.onSetup());
  }
}
