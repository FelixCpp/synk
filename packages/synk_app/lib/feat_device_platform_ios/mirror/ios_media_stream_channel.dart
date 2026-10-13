import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:flutter/services.dart';

typedef IosMediaStreamScreenSize = ({
  NativeTextureId textureId,
  DeviceScreenSize size,
});

class const IosMediaStreamStartResult({
  required final NativeTextureId textureId,
  required final int width,
  required final int height,
  required final bool hasAudio,
});

class IosMediaStreamChannel {
  static const _channel = MethodChannel('dev.synk/ios_media_stream');
  static const _screenSizeChannel = EventChannel(
    'dev.synk/ios_media_stream/screen_size',
  );

  static final _screenSizeEvents = _screenSizeChannel.receiveBroadcastStream();

  Stream<IosMediaStreamScreenSize> get screenSizeChanges {
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

  Future<bool> isAvailable() async {
    final available = await _channel.invokeMethod<bool>('isAvailable');
    return available ?? false;
  }

  Future<IosMediaStreamStartResult> startMirror(String deviceId) async {
    final result = await _channel.invokeMapMethod<String, Object?>(
      'startMirror',
      {'deviceId': deviceId},
    );

    return IosMediaStreamStartResult(
      textureId: NativeTextureId(result!['textureId']! as int),
      width: result['width']! as int,
      height: result['height']! as int,
      hasAudio: result['hasAudio']! as bool,
    );
  }

  Future<void> stopMirror(NativeTextureId textureId) {
    return _channel.invokeMethod('stopMirror', {'textureId': textureId.value});
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

  Future<void> setAudioMuted(NativeTextureId textureId, bool muted) {
    return _channel.invokeMethod('setAudioMuted', {
      'textureId': textureId.value,
      'muted': muted,
    });
  }

  Future<int> startAudio(String deviceId) async {
    final result = await _channel.invokeMapMethod<String, Object?>(
      'startAudio',
      {
        'deviceId': deviceId,
      },
    );

    return result!['sessionId']! as int;
  }

  Future<void> stopAudio(int sessionId) {
    return _channel.invokeMethod('stopAudio', {'sessionId': sessionId});
  }

  Future<void> setAudioSessionMuted(int sessionId, bool muted) {
    return _channel.invokeMethod('setAudioSessionMuted', {
      'sessionId': sessionId,
      'muted': muted,
    });
  }
}
