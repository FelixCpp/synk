import 'package:synk/feat_device_platform_android/discovery/android_device_connection.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device_state.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PluggedDevice.isAuthorized', () {
    test('holds for an Android device that adb reports as ready', () {
      expect(_android(AndroidDeviceState.device).isAuthorized, isTrue);
    });

    test('fails for every other Android device state', () {
      final states = AndroidDeviceState.values.where(
        (state) => state != AndroidDeviceState.device,
      );

      for (final state in states) {
        expect(
          _android(state).isAuthorized,
          isFalse,
          reason: '$state must not count as authorized',
        );
      }
    });

    test('holds for an iOS device, which pairs outside of synk', () {
      expect(_ios().isAuthorized, isTrue);
    });
  });
}

PluggedDevice _android(AndroidDeviceState state) {
  return AndroidDevice(
    id: DeviceId('serial-1'),
    modelName: 'Pixel',
    state: state,
    connection: AndroidDeviceConnection.usb,
  );
}

PluggedDevice _ios() {
  return IosDevice(id: DeviceId('ios-1'), modelName: 'iPhone');
}
