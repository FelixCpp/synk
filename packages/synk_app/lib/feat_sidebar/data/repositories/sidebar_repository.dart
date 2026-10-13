import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device_state.dart';
import 'package:rxdart/rxdart.dart';

class const SidebarRepository(
  final DeviceConnectionsRepository _connectionsRepository,
) {
  Stream<List<SidebarDevice>> observeDevices() {
    return Rx.combineLatest2(
      _connectionsRepository.observePluggedDevices(),
      _connectionsRepository.observeConnectionStates(),
      (devices, states) => [
        for (final device in devices)
          SidebarDevice(
            device: device,
            state: _stateOf(device, states[device.id]),
          ),
      ],
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
