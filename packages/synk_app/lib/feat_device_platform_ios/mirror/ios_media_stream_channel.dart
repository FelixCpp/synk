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

/// The CoreDevice media stream: the device sends its own screen and system
/// audio as RTP.
///
/// Only the audio half is in use. Its video decodes into a picture that drifts
/// apart and never recovers — the encoder predicts from long-term reference
/// pictures and expects an RTCP acknowledgement that is not implemented, and it
/// sends no keyframes to heal the drift. The screen therefore comes from
/// [IosMirrorChannel]; see `docs/spikes/ios-mediastream/README.md`.
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

  /// Whether this Mac has the private frameworks the path needs at all.
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

  /// Starts only the system-audio stream, without mirroring the screen.
  ///
  /// The picture comes from the AVFoundation capture session, which carries no
  /// sound. This is what puts the sound back alongside it.
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
