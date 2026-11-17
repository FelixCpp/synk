import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device.dart';

class IosNetworkDeviceDiscovery({
  required final DevicectlApi devicectl,
  final Duration interval = const Duration(seconds: 3),
}) {
  var _hasWarned = false;

  Stream<List<IosDevice>> observeDevices() {
    return Stream<void>.periodic(interval)
        .startWith(null)
        .asyncMap((_) => _reachableOverNetwork())
        .distinct(listEquals);
  }

  Future<List<IosDevice>> _reachableOverNetwork() async {
    try {
      final devices = await devicectl.listDevices();
      return [
        for (final device in devices)
          if (device.transport == DevicectlTransport.localNetwork &&
              device.isPaired)
            IosDevice(
              id: DeviceId(device.udid.replaceAll('-', '')),
              modelName: device.name ?? device.modelName ?? 'Unbekanntes Gerät',
              isWireless: true,
            ),
      ];
    } on Object catch (error, stackTrace) {
      if (!_hasWarned) {
        _hasWarned = true;
        appLogger.w(
          'Cannot look for iOS devices on the network',
          error: error,
          stackTrace: stackTrace,
        );
      }
      return const [];
    }
  }
}
