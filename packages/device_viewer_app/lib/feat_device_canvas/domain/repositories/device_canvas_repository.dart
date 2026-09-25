import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';

abstract interface class DeviceCanvasRepository {
  Stream<List<CanvasDevice>> observeDevices();
}
