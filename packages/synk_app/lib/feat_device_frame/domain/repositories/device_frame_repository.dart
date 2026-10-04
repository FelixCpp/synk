import 'package:synk/feat_device_agent/domain/models/scrcpy_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_pointer_action.dart';
import 'package:synk/feat_device_frame/domain/models/control_button_type.dart';
import 'package:synk/feat_device_frame/domain/models/dropped_file_outcome.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';

abstract interface class DeviceFrameRepository {
  Future<void> simulateKeyEvent(DeviceId deviceId, ScrcpyKeyEvent event);
  void simulatePointerEvent(DeviceId deviceId, ScrcpyPointerEvent event);
  void simulateControlButtonEvent(DeviceId deviceId, ControlButtonType type);

  Future<void> captureScreenshot(DeviceId deviceId);
  Future<bool> startRecording(DeviceId deviceId);
  Future<void> stopRecording(DeviceId deviceId);
  Future<List<DroppedFileOutcome>> handleDroppedFiles(
    DeviceId deviceId,
    List<String> filepaths,
  );

  Future<DroppedFileOutcome?> installApk(DeviceId deviceId);
  Future<DroppedFileOutcome?> shareFile(DeviceId deviceId);
}
