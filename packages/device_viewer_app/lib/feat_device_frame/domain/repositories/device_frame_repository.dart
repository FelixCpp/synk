import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_key_event.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_pointer_action.dart';
import 'package:device_viewer/feat_device_frame/domain/models/dropped_file_outcome.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

abstract interface class DeviceFrameRepository {
  Future<void> simulateKeyEvent(DeviceId deviceId, ScrcpyKeyEvent event);
  void simulatePointerEvent(DeviceId deviceId, ScrcpyPointerEvent event);

  Future<void> captureScreenshot(DeviceId deviceId);
  Future<List<DroppedFileOutcome>> handleDroppedFiles(
    DeviceId deviceId,
    List<String> filepaths,
  );
}
