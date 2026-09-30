import 'package:device_viewer/feat_native_texture/native_texture.dart';
import 'package:flutter/services.dart';

class IosMirrorStartResult {
  const IosMirrorStartResult({
    required this.textureId,
    required this.width,
    required this.height,
  });

  final NativeTextureId textureId;
  final int width;
  final int height;
}

class IosMirrorChannel {
  static const _channel = MethodChannel('dev.deviceviewer/ios_mirror');

  Future<IosMirrorStartResult> startMirror(String deviceId) async {
    final result = await _channel.invokeMapMethod<String, Object?>(
      'startMirror',
      {'deviceId': deviceId},
    );

    return IosMirrorStartResult(
      textureId: NativeTextureId(result!['textureId']! as int),
      width: result['width']! as int,
      height: result['height']! as int,
    );
  }

  Future<void> stopMirror(NativeTextureId textureId) {
    return _channel.invokeMethod('stopMirror', {
      'textureId': textureId.value,
    });
  }

  Future<Uint8List> captureScreenshot(NativeTextureId textureId) async {
    final bytes = await _channel.invokeMethod<Uint8List>('captureScreenshot', {
      'textureId': textureId.value,
    });

    return bytes!;
  }

  Future<void> startRecording(NativeTextureId textureId, String path) {
    return _channel.invokeMethod('startRecording', {
      'textureId': textureId.value,
      'path': path,
    });
  }

  Future<bool> stopRecording(NativeTextureId textureId) {
    return _channel
        .invokeMethod<bool>('stopRecording', {'textureId': textureId.value})
        .then((value) => value ?? false);
  }
}
