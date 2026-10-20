import 'dart:async';

import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device_state.dart';
import 'package:synk/feat_device_connections/domain/device_connections_feature.dart';
import 'package:synk/feat_sidebar/domain/sidebar_feature.dart';
import 'package:synk/feat_sidebar/presentation/bloc/sidebar_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSidebarFeature implements SidebarFeature {
  final _devices = StreamController<List<SidebarDevice>>.broadcast();

  Object? errorToThrow;
  PluggedDevice? lastConnected;
  PluggedDevice? lastDisconnected;
  var cameraSettingsOpened = 0;

  @override
  Stream<List<SidebarDevice>> observeDevices() => _devices.stream;

  @override
  Future<void> connect(PluggedDevice device) async {
    lastConnected = device;
    if (errorToThrow case final error?) throw error;
  }

  @override
  Future<void> disconnect(PluggedDevice device) async {
    lastDisconnected = device;
    if (errorToThrow case final error?) throw error;
  }

  @override
  Future<void> openCameraPrivacySettings() async {
    cameraSettingsOpened++;
    if (errorToThrow case final error?) throw error;
  }

  void emit(List<SidebarDevice> devices) => _devices.add(devices);

  Future<void> close() => _devices.close();
}

AndroidDevice buildDevice(String serial) {
  return AndroidDevice(
    id: DeviceId(serial),
    modelName: 'Pixel',
    state: AndroidDeviceState.device,
    connection: AndroidDeviceConnection.usb,
  );
}

void main() {
  late FakeSidebarFeature feature;
  late NotificationService notifications;
  late SidebarBloc bloc;

  setUp(() {
    feature = FakeSidebarFeature();
    notifications = NotificationService();
    bloc = SidebarBloc(feature, notifications);
  });

  tearDown(() async {
    await bloc.close();
    await feature.close();
    await notifications.dispose();
  });

  test('reflects the devices emitted by the repository', () async {
    final device = buildDevice('serial-1');

    feature.emit([
      SidebarDevice(
        device: device,
        state: const SidebarDeviceState.disconnected(),
      ),
    ]);
    await pumpEventQueue();

    expect(bloc.state.devices, [
      SidebarDevice(
        device: device,
        state: const SidebarDeviceState.disconnected(),
      ),
    ]);
  });

  test('does not notify when connecting succeeds', () async {
    final device = buildDevice('serial-2');
    final emitted = <AppNotification>[];
    final subscription = notifications.observeNotifications().listen(
      emitted.add,
    );

    bloc.add(SidebarEvent.onConnectRequested(device));
    await pumpEventQueue();

    expect(feature.lastConnected, device);
    expect(emitted, isEmpty);

    await subscription.cancel();
  });

  test('passes a message meant for the user through as it is', () async {
    final device = buildDevice('serial-5');
    feature.errorToThrow = DeviceNotPluggedException(
      deviceId: device.id,
    );

    final emitted = <AppNotification>[];
    final subscription = notifications.observeNotifications().listen(
      emitted.add,
    );

    bloc.add(SidebarEvent.onConnectRequested(device));
    await pumpEventQueue();

    expect(emitted.single.message, contains('nicht mehr angeschlossen'));

    await subscription.cancel();
  });

  test('disconnecting asks to disconnect, never to connect', () async {
    final device = buildDevice('serial-4');

    bloc.add(SidebarEvent.onDisconnectRequested(device));
    await pumpEventQueue();

    expect(feature.lastDisconnected, device);
    expect(feature.lastConnected, isNull);
  });

  test('notifies when connecting fails', () async {
    final device = buildDevice('serial-3');
    feature.errorToThrow = Exception('boom');

    final emitted = <AppNotification>[];
    final subscription = notifications.observeNotifications().listen(
      emitted.add,
    );

    bloc.add(SidebarEvent.onConnectRequested(device));
    await pumpEventQueue();

    expect(emitted, hasLength(1));
    expect(
      emitted.single.message,
      'Das Gerät ließ sich nicht verbinden.',
      reason: 'a developer-facing error must not reach the user verbatim',
    );

    await subscription.cancel();
  });

  test('asks the feature for the camera privacy settings', () async {
    bloc.add(const SidebarEvent.onOpenCameraPrivacySettings());
    await pumpEventQueue();

    expect(feature.cameraSettingsOpened, 1);
  });
}
