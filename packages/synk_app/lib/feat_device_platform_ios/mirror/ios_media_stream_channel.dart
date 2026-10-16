import 'package:flutter/services.dart';

class IosMediaStreamChannel {
  static const _channel = MethodChannel('dev.synk/ios_media_stream');

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

  Future<void> setAudioSessionVolume(int sessionId, double volume) {
    return _channel.invokeMethod('setAudioSessionVolume', {
      'sessionId': sessionId,
      'volume': volume,
    });
  }
}
