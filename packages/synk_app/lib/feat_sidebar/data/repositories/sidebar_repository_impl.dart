import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:synk/feat_plugged_devices/ios/domain/repositories/plugged_ios_devices_repository.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device_state.dart';
import 'package:synk/feat_sidebar/domain/repositories/sidebar_repository.dart';
import 'package:rxdart/rxdart.dart';

class const SidebarRepositoryImpl(
  final DeviceConnectionsRepository connectionsRepository,
  final PluggedAdbDevicesRepository adbDevicesRepository,
  final PluggedIosDevicesRepository iosDevicesRepository,
) implements SidebarRepository {
  @override
  Stream<List<SidebarDevice>> observeDevices() {
    return Rx.combineLatest3(
      adbDevicesRepository.observeAdbDevices(),
      iosDevicesRepository.observeIosDevices(),
      connectionsRepository.observeConnectionStates(),
      (androidDevices, iosDevices, states) {
        final pluggedDevices = <PluggedDevice>[
          ...androidDevices,
          ...iosDevices,
        ];

        return [
          for (final device in pluggedDevices)
            SidebarDevice(
              device: device,
              state: _stateOf(device, states[device.id]),
            ),
        ];
      },
    );
  }

  SidebarDeviceState _stateOf(
    PluggedDevice device,
    DeviceConnectionState? connectionState,
  ) {
    if (!device.isAuthorized) {
      return const .unableToConnect();
    }

    final SidebarDeviceState? mappedState = connectionState?.map(
      disconnected: (_) => const .disconnected(),
      connecting: (_) => const .connecting(),
      connected: (_) => const .connected(),
      failed: (state) => .failedToConnect(failure: state.failure),
    );

    if (mappedState != null) {
      return mappedState;
    }

    return const .disconnected();
  }
}
