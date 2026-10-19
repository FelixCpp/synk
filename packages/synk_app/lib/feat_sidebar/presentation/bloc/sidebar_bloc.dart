import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_connections/domain/usecases/connect_device_interactor.dart';
import 'package:synk/feat_device_connections/domain/usecases/disconnect_device_interactor.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/domain/models/user_message.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_sidebar/domain/usecases/open_camera_privacy_settings_interactor.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/presentation/sidebar_devices.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_in_case/use_in_case.dart';

part 'sidebar_bloc.freezed.dart';
part 'sidebar_state.dart';
part 'sidebar_event.dart';

class SidebarBloc(
  final SidebarDevices sidebarDevices,
  final DeviceConnectionsRepository deviceConnectionsRepository,
  final NotificationService notifications,
  final SystemFileOpener fileOpener,
) extends Bloc<SidebarEvent, SidebarState> {
  final connectDevice = ConnectDeviceInteractor(deviceConnectionsRepository);
  final disconnectDevice = DisconnectDeviceInteractor(
    deviceConnectionsRepository,
  );
  final openCameraPrivacySettings = OpenCameraPrivacySettingsInteractor(
    fileOpener,
  );

  this : super(SidebarState.initial()) {
    on<_OnSetup>((event, emit) {
      return emit.forEach(
        sidebarDevices.observe(),
        onData: (devices) {
          return state.copyWith(devices: devices);
        },
      );
    }, transformer: droppable());

    on<_OnConnectRequested>((event, emit) {
      return connectDevice
          .logger()
          .intercept(_notify('Das Gerät ließ sich nicht verbinden.'))
          .run(event.device);
    }, transformer: droppable());

    on<_OnDisconnectRequested>((event, emit) {
      return disconnectDevice
          .logger()
          .intercept(_notify('Das Gerät ließ sich nicht trennen.'))
          .run(event.device);
    }, transformer: droppable());

    on<_OnOpenCameraPrivacySettings>((event, emit) {
      return openCameraPrivacySettings
          .logger()
          .intercept((e) {
            notifications.notify(
              AppNotification(
                message: 'Systemeinstellungen ließen sich nicht öffnen: $e',
              ),
            );
          })
          .run(unit);
    }, transformer: droppable());

    add(const SidebarEvent.onSetup());
  }

  void Function(Object) _notify(String fallback) {
    return (error) => notifications.notify(
      AppNotification(message: userMessageFor(error, fallback)),
    );
  }
}
