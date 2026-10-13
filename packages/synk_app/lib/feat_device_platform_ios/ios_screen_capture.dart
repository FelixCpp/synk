import 'dart:io';
import 'dart:typed_data';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_transport.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

class const IosScreenCapture({
  required final IosMirrorTransport transport,
  required final DevicectlApi devicectl,
  required final DeviceId deviceId,
  required final NativeTextureId textureId,
}) implements DeviceScreenCapture {
  @override
  Future<Uint8List> captureScreenshot() async {
    try {
      return await _captureScreenshotViaDevicectl();
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'Falling back to the mirrored frame for the screenshot of $deviceId',
        error: error,
        stackTrace: stackTrace,
      );

      return transport.captureScreenshot(textureId);
    }
  }

  Future<Uint8List> _captureScreenshotViaDevicectl() async {
    final directory = await Directory.systemTemp.createTemp('synk_screenshot');

    try {
      final destination = '${directory.path}/screenshot.png';
      await devicectl.captureScreenshot(
        deviceId: deviceId,
        destination: destination,
      );

      return await File(destination).readAsBytes();
    } finally {
      await directory.delete(recursive: true);
    }
  }

  @override
  Future<void> startRecording(String path) {
    return transport.startRecording(textureId, path);
  }

  @override
  Future<bool> stopRecording() {
    return transport.stopRecording(textureId);
  }
}
