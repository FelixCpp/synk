import 'dart:async';

import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device_connection.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device_state.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device_state.dart';
import 'package:synk/feat_sidebar/data/repositories/sidebar_repository.dart';
import 'package:synk/feat_sidebar/presentation/bloc/sidebar_bloc.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSidebarRepository implements SidebarRepository {
  final _controller = StreamController<List<SidebarDevice>>.broadcast();

  @override
  Stream<List<SidebarDevice>> observeDevices() => _controller.stream;

  void emit(List<SidebarDevice> devices) => _controller.add(devices);

  Future<void> close() => _controller.close();
}

class FakeDeviceConnectionsRepository implements DeviceConnectionsRepository {
  @override
  DeviceAgent? getAgent(DeviceId id) => null;

  @override
  Stream<List<PluggedDevice>> observePluggedDevices() {
    return Stream.value(const []);
  }

  Object? errorToThrow;
  PluggedDevice? lastToggled;

  @override
  Future<void> toggleConnection(PluggedDevice device) async {
    lastToggled = device;
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<void> dispose() async {}

  @override
  bool isConnected(DeviceId id) => false;

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return Stream.value(const {});
  }

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() {
    return const Stream.empty();
  }
}

AndroidDevice buildDevice(String serial) {
  return AndroidDevice(
    id: DeviceId(serial),
    modelName: 'Pixel',
    state: AndroidDeviceState.device,
    connection: AndroidDeviceConnection.usb,
  );
}

IosDevice buildIosDevice(String serial) {
  return IosDevice(id: DeviceId(serial), modelName: 'iPhone');
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
      connectionsRepository,
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

  test('reflects an iOS device emitted by the repository', () async {
    final device = buildIosDevice('ios-serial-1');

    sidebarRepository.emit([
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
