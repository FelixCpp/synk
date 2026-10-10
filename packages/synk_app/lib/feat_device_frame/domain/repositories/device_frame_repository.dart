import 'package:synk/feat_device_agent/domain/models/device_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_frame/domain/models/control_button_type.dart';
import 'package:synk/feat_device_frame/domain/models/dropped_file_outcome.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';

abstract interface class DeviceFrameRepository {
  Future<void> simulateKeyEvent(DeviceId deviceId, DeviceKeyEvent event);
  Future<void> simulatePointerEvent(
    DeviceId deviceId,
    DevicePointerEvent event,
  );
  Future<void> simulatePinchEvent(DeviceId deviceId, PinchEvent event);
  Future<void> simulateControlButtonEvent(
    DeviceId deviceId,
    ControlButtonType type,
  );

  Future<void> captureScreenshot(DeviceId deviceId);
  Future<bool> startRecording(DeviceId deviceId);
  Future<void> stopRecording(DeviceId deviceId);
  bool isAudioMuted(DeviceId deviceId);
  Future<void> setAudioMuted(DeviceId deviceId, bool muted);
  Future<List<DroppedFileOutcome>> handleDroppedFiles(
    DeviceId deviceId,
    List<String> filepaths,
  );

  Future<DroppedFileOutcome?> installApk(DeviceId deviceId);
  Future<DroppedFileOutcome?> shareFile(DeviceId deviceId);
}
