import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_connections/domain/usecases/toggle_connection_interactor.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/domain/repositories/sidebar_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_in_case/use_in_case.dart';

part 'sidebar_bloc.freezed.dart';
part 'sidebar_state.dart';
part 'sidebar_event.dart';

class SidebarBloc(
  final SidebarRepository sidebarRepository,
  final DeviceConnectionsRepository deviceConnectionsRepository,
  final NotificationService notifications,
) extends Bloc<SidebarEvent, SidebarState> {
  final toggleConnection = ToggleConnectionInteractor(
    deviceConnectionsRepository,
  );

  this : super(SidebarState.initial()) {
    on<_OnSetup>((event, emit) {
      return emit.forEach(
        sidebarRepository.observeDevices(),
        onData: (devices) {
          return state.copyWith(devices: devices);
        },
      );
    }, transformer: droppable());

    on<_OnConnect>((event, emit) {
      return toggleConnection
          .logger()
          .intercept((e) {
            notifications.notify(
              AppNotification(message: 'Verbindung fehlgeschlagen: $e'),
            );
          })
          .run(event.device);
    }, transformer: droppable());

    add(const SidebarEvent.onSetup());
  }
}
