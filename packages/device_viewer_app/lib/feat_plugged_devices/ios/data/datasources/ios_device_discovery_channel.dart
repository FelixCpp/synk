import 'dart:async';

import 'package:device_viewer/feat_plugged_devices/ios/data/models/ios_device_dto.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class IosDeviceDiscoveryChannel {
  static const _eventChannel = EventChannel('dev.deviceviewer/ios_devices');

  Stream<List<IosDeviceDto>> observeDevices() {
    final devicesById = <String, IosDeviceDto>{};

    return _eventChannel.receiveBroadcastStream().map((event) {
      final map = event as Map<Object?, Object?>;

      switch (map['type']) {
        case 'attached':
          final dto = IosDeviceDto.fromMap(map);
          devicesById[dto.serialNumber] = dto;
        case 'detached':
          devicesById.remove(map['id'] as String);
      }

      return devicesById.values.toList();
    }).startWith(const []);
  }
}
