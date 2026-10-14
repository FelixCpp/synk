import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';

abstract interface class DeviceFrameRepository {
  bool get isAudioMuted;
  Future<void> setAudioMuted(bool muted);

  Future<ClipboardSyncFailure?> simulateKeyEvent(DeviceKeyEvent event);
  Future<void> simulatePointerEvent(DevicePointerEvent event);
  Future<void> simulatePinchEvent(PinchEvent event);
  Future<void> navigate(DeviceNavigation navigation);
  Future<void> pressPowerButton();

  Future<void> captureScreenshot();
  Future<void> startRecording();
  Future<void> stopRecording();

  Future<List<FileTransferOutcome>> sendFiles(List<String> filepaths);
  Future<FileTransferOutcome?> sendPickedApk();
  Future<FileTransferOutcome?> sendPickedFile();
}
