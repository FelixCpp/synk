import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';

/// Everything Synk can do with one mirrored device.
abstract interface class DeviceFrameFeature {
  bool get isRecording;
  bool get isAudioMuted;
  double get audioVolume;
  Future<void> setAudioMuted(bool muted);
  Future<void> setAudioVolume(double volume);

  Future<void> simulateKeyEvent(DeviceKeyEvent event);
  Future<void> releasePressedKeys();
  Future<void> typeText(String text);
  Future<void> typeHostClipboard();
  Future<void> simulatePointerEvent(DevicePointerEvent event);
  Future<void> simulatePinchEvent(PinchEvent event);
  Future<void> navigate(DeviceNavigation navigation);
  Future<void> pressPowerButton();
  Future<void> rotate();

  Future<void> captureScreenshot();
  Future<void> startRecording();
  Future<void> stopRecording();

  Future<List<FileTransferOutcome>> sendFiles(List<String> filepaths);
  Future<FileTransferOutcome?> sendPickedApk();
  Future<FileTransferOutcome?> sendPickedFile();
}
