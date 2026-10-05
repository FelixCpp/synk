import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:flutter/services.dart';

typedef IosMirrorScreenSize = ({
  NativeTextureId textureId,
  DeviceScreenSize size,
});

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
  static const _channel = MethodChannel('dev.synk/ios_mirror');
  static const _screenSizeChannel = EventChannel(
    'dev.synk/ios_mirror/screen_size',
  );

  static final _screenSizeEvents = _screenSizeChannel.receiveBroadcastStream();

  Stream<IosMirrorScreenSize> get screenSizeChanges {
    return _screenSizeEvents.map((event) {
      final args = event as Map<Object?, Object?>;
      return (
        textureId: NativeTextureId(args['textureId']! as int),
        size: DeviceScreenSize(
          width: args['width']! as int,
          height: args['height']! as int,
        ),
      );
    });
  }

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
