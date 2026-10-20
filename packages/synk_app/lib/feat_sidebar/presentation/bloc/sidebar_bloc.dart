import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:synk/feat_sidebar/domain/usecases/connect_device_interactor.dart';
import 'package:synk/feat_sidebar/domain/usecases/disconnect_device_interactor.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:synk/feat_notifications/application/notified_interactor.dart';
import 'package:synk/feat_sidebar/domain/usecases/open_camera_privacy_settings_interactor.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/domain/sidebar_feature.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sidebar_bloc.freezed.dart';
part 'sidebar_state.dart';
part 'sidebar_event.dart';

class SidebarBloc(
  final SidebarFeature feature,
  final NotificationFeature notifications,
) extends Bloc<SidebarEvent, SidebarState> {
  final connectDevice = ConnectDeviceInteractor(feature);
  final disconnectDevice = DisconnectDeviceInteractor(feature);
  final openCameraPrivacySettings = OpenCameraPrivacySettingsInteractor(
    feature,
  );

  this : super(SidebarState.initial()) {
    on<_OnSetup>((event, emit) {
      return emit.forEach(
        feature.observeDevices(),
        onData: (devices) {
          return state.copyWith(devices: devices);
        },
      );
    }, transformer: droppable());

    on<_OnConnectRequested>((event, emit) {
      return connectDevice.logger().runReporting(
        event.device,
        to: notifications,
        whenItFails: 'Das Gerät ließ sich nicht verbinden.',
      );
    }, transformer: droppable());

    on<_OnDisconnectRequested>((event, emit) {
      return disconnectDevice.logger().runReporting(
        event.device,
        to: notifications,
        whenItFails: 'Das Gerät ließ sich nicht trennen.',
      );
    }, transformer: droppable());

    on<_OnOpenCameraPrivacySettings>((event, emit) {
      return openCameraPrivacySettings.logger().runReporting(
        unit,
        to: notifications,
        whenItFails: 'Die Systemeinstellungen ließen sich nicht öffnen.',
      );
    }, transformer: droppable());

    add(const SidebarEvent.onSetup());
  }
}
