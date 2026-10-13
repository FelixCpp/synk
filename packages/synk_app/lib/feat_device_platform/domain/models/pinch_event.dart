import 'package:synk/feat_device_platform/domain/models/device_pointer_event.dart';

typedef PinchEvent = ({
  DevicePointerEventType type,
  double centerX,
  double centerY,
  double spread,
});
