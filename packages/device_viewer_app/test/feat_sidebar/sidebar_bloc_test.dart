import 'dart:async';

import 'package:device_viewer/feat_device_agent/application/android_device_agent.dart';
import 'package:device_viewer/feat_device_connections/domain/models/device_connection.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/usecases/toggle_connection_interactor.dart';
import 'package:device_viewer/feat_notifications/application/notification_service.dart';
import 'package:device_viewer/feat_notifications/domain/models/app_notification.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device_connection.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device_state.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';
import 'package:device_viewer/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:device_viewer/feat_sidebar/domain/repositories/sidebar_repository.dart';
import 'package:device_viewer/feat_sidebar/presentation/bloc/sidebar_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSidebarRepository implements SidebarRepository {
  final _controller = StreamController<List<SidebarDevice>>.broadcast();

  @override
  Stream<List<SidebarDevice>> observeDevices() => _controller.stream;

  void emit(List<SidebarDevice> devices) => _controller.add(devices);

  Future<void> close() => _controller.close();
}

class FakeDeviceConnectionsRepository implements DeviceConnectionsRepository {
  Object? errorToThrow;
  AndroidDevice? lastToggled;

  @override
  Future<void> toggleConnection(AndroidDevice device) async {
    lastToggled = device;
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<bool> isConnected(DeviceId id) async => false;

  @override
  Stream<List<AndroidDevice>> observeConnectingDevices() {
    return const Stream.empty();
  }

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() {
    return const Stream.empty();
  }

  @override
  AndroidDeviceAgent? getAgent(DeviceId id) => null;
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
  late FakeSidebarRepository sidebarRepository;
  late FakeDeviceConnectionsRepository connectionsRepository;
  late NotificationService notifications;
  late SidebarBloc bloc;

  setUp(() {
    sidebarRepository = FakeSidebarRepository();
    connectionsRepository = FakeDeviceConnectionsRepository();
    notifications = NotificationService();
    bloc = SidebarBloc(
      sidebarRepository,
      ToggleConnectionInteractor(connectionsRepository),
      notifications,
    );
  });

  tearDown(() async {
    await bloc.close();
    await sidebarRepository.close();
    await notifications.dispose();
  });

  test('reflects the devices emitted by the repository', () async {
    final device = buildDevice('serial-1');

    sidebarRepository.emit([
      SidebarDevice(device: device, isConnected: false),
    ]);
    await pumpEventQueue();

    expect(bloc.state.devices, [
      SidebarDevice(device: device, isConnected: false),
    ]);
  });

  test('does not notify when toggling a connection succeeds', () async {
    final device = buildDevice('serial-2');
    final emitted = <AppNotification>[];
    final subscription = notifications.observeNotifications().listen(
      emitted.add,
    );

    bloc.add(SidebarEvent.onConnect(device));
    await pumpEventQueue();

    expect(connectionsRepository.lastToggled, device);
    expect(emitted, isEmpty);

    await subscription.cancel();
  });

  test('notifies when toggling a connection fails', () async {
    final device = buildDevice('serial-3');
    connectionsRepository.errorToThrow = Exception('boom');

    final emitted = <AppNotification>[];
    final subscription = notifications.observeNotifications().listen(
      emitted.add,
    );

    bloc.add(SidebarEvent.onConnect(device));
    await pumpEventQueue();

    expect(emitted, hasLength(1));
    expect(emitted.single.message, contains('boom'));

    await subscription.cancel();
  });
}
