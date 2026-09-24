import 'dart:typed_data';

import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device_connection.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device_info.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device_state.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';

/// Wraps another [AdbDevicesRepository] and adds a fixed set of fake
/// devices to every emission, so the UI can be tested without needing
/// that many physical devices around. Dev-only, not meant to ship.
class DummyAdbDevicesRepository implements AdbDevicesRepository {
  const DummyAdbDevicesRepository(this._delegate);

  final AdbDevicesRepository _delegate;

  @override
  Stream<List<AndroidDevice>> observeAdbDevices() {
    return _delegate.observeAdbDevices().map(
      (devices) => [...devices, ..._dummyDevices],
    );
  }

  @override
  Future<Uint8List> captureScreenshot(AndroidDeviceId id) {
    return _delegate.captureScreenshot(id);
  }
}

const _dummyDevices = [
  AndroidDevice(
    id: AndroidDeviceId('DUMMY-PIXEL7PRO'),
    state: AndroidDeviceState.device,
    connection: AndroidDeviceConnection.usb,
    info: AndroidDeviceInfo(
      product: 'cheetah',
      model: 'Pixel_7_Pro',
      codename: 'cheetah',
    ),
  ),
  AndroidDevice(
    id: AndroidDeviceId('DUMMY-GALAXYS21'),
    state: AndroidDeviceState.device,
    connection: AndroidDeviceConnection.tcp,
    info: AndroidDeviceInfo(
      product: 'o1s',
      model: 'SM_G991B',
      codename: 'o1s',
    ),
  ),
  AndroidDevice(
    id: AndroidDeviceId('DUMMY-NEXUS5'),
    state: AndroidDeviceState.unauthorized,
    connection: AndroidDeviceConnection.usb,
    info: AndroidDeviceInfo(
      product: 'hammerhead',
      model: 'Nexus_5',
      codename: 'hammerhead',
    ),
  ),
  AndroidDevice(
    id: AndroidDeviceId('DUMMY-EMULATOR5554'),
    state: AndroidDeviceState.device,
    connection: AndroidDeviceConnection.emulator,
    info: AndroidDeviceInfo(
      product: 'sdk_gphone64_arm64',
      model: 'sdk_gphone64_arm64',
      codename: 'emu64a',
    ),
  ),
  AndroidDevice(
    id: AndroidDeviceId('DUMMY-ONEPLUS9'),
    state: AndroidDeviceState.offline,
    connection: AndroidDeviceConnection.usb,
    info: AndroidDeviceInfo(
      product: 'lemonades',
      model: 'LE2113',
      codename: 'lemonades',
    ),
  ),
];
