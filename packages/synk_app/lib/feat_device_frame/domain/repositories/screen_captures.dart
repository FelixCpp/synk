import 'dart:typed_data';

import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_kind.dart';

/// Where a capture is put, and who gets told about it.
abstract interface class ScreenCaptures {
  Future<String> reservePath(ScreenCaptureKind kind);
  Future<void> writeScreenshot(String filepath, Uint8List pngBytes);

  void announceScreenshot({
    required String filepath,
    required Uint8List pngBytes,
    required DeviceScreenSize screenSize,
  });

  void announceRecording({
    required String filepath,
    required Uint8List? posterBytes,
    required DeviceScreenSize screenSize,
  });
}
