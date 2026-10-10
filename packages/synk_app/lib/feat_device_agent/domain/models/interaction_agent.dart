import 'package:synk/feat_device_agent/domain/models/device_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/device_pointer_event.dart';

enum DeviceControlAction {
  back,
  home,
  appSwitch,
  standby,
}

typedef PinchEvent = ({
  DevicePointerEventType type,
  double centerX,
  double centerY,
  double spread,
});

abstract interface class InteractionAgent {
  Future<void> simulateKeyEvent(DeviceKeyEvent event);
  Future<void> simulatePointerEvent(DevicePointerEvent event);
  Future<void> simulatePinchEvent(PinchEvent event);
  Future<void> simulateControlAction(DeviceControlAction action);
}
