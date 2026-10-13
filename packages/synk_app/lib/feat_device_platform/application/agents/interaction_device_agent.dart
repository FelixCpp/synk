import 'package:synk/feat_device_platform/domain/models/device_key_event.dart';
import 'package:synk/feat_device_platform/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_platform/domain/models/pinch_event.dart';
import 'package:synk/feat_device_platform/domain/models/device_navigation.dart';

abstract interface class InteractionDeviceAgent {
  Future<void> simulateKeyEvent(DeviceKeyEvent event);
  Future<void> simulatePointerEvent(DevicePointerEvent event);
  Future<void> simulatePinchEvent(PinchEvent event);

  Set<DeviceNavigation> get supportedNavigations;
  Future<void> navigate(DeviceNavigation navigation);
  Future<void> pressPowerButton();
}
