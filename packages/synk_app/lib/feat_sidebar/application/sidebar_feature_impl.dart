import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/device_connections_feature.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device_state.dart';
import 'package:synk/feat_sidebar/domain/sidebar_feature.dart';

class const SidebarFeatureImpl({
  required final DeviceConnectionsFeature connections,
  required final SystemFileOpener fileOpener,
}) implements SidebarFeature {
  static const _cameraPrivacySettings =
      'x-apple.systempreferences:com.apple.preference.security?Privacy_Camera';

  @override
  Stream<List<SidebarDevice>> observeDevices() {
    return Rx.combineLatest2(
      connections.observePluggedDevices(),
      connections.observeConnectionStates(),
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

  @override
  Future<void> connect(PluggedDevice device) => connections.connect(device);

  @override
  Future<void> disconnect(PluggedDevice device) =>
      connections.disconnect(device);

  @override
  Future<void> openCameraPrivacySettings() =>
      fileOpener.open(_cameraPrivacySettings);
}
