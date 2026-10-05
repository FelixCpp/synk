import 'dart:typed_data';

import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:flutter/services.dart';

typedef MirrorSessionScreenSize = ({
  NativeTextureId textureId,
  DeviceScreenSize size,
});

class const MirrorSessionChannel._() {
  static const _methodChannel = MethodChannel('dev.synk/screen_mirror');
  static const _videoChunkChannel = BasicMessageChannel<ByteData?>(
    'dev.synk/screen_mirror/video_chunk',
    BinaryCodec(),
  );
  static const _audioChunkChannel = BasicMessageChannel<ByteData?>(
    'dev.synk/screen_mirror/audio_chunk',
    BinaryCodec(),
  );
  static const _screenSizeChannel = EventChannel(
    'dev.synk/screen_mirror/screen_size',
  );

  static final _screenSizeEvents = _screenSizeChannel.receiveBroadcastStream();

  static Stream<MirrorSessionScreenSize> get screenSizeChanges {
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

  static Future<NativeTextureId> createSession() {
    return _methodChannel
        .invokeMethod<int>('createTexture')
        .then((value) => NativeTextureId(value!));
  }

  static Future<void> destroySession(NativeTextureId textureId) {
    return _methodChannel.invokeMethod('destroyTexture', {
      'textureId': textureId.value,
    });
  }

  static Future<void> sendVideoChunk(
    NativeTextureId textureId,
    Uint8List chunk,
  ) {
    return _send(_videoChunkChannel, textureId, chunk);
  }

  static Future<void> sendAudioChunk(
    NativeTextureId textureId,
    Uint8List chunk,
  ) {
    return _send(_audioChunkChannel, textureId, chunk);
  }

  static Future<void> _send(
    BasicMessageChannel<ByteData?> channel,
    NativeTextureId textureId,
    Uint8List chunk,
  ) {
    final message = Uint8List(8 + chunk.length);
    ByteData.view(message.buffer).setInt64(0, textureId, Endian.big);
    message.setRange(8, message.length, chunk);
    return channel.send(message.buffer.asByteData());
  }

  static Future<void> setAudioMuted(NativeTextureId textureId, bool muted) {
    return _methodChannel.invokeMethod('setAudioMuted', {
      'textureId': textureId.value,
      'muted': muted,
    });
  }

  static Future<void> startRecording(NativeTextureId textureId, String path) {
    return _methodChannel.invokeMethod('startRecording', {
      'textureId': textureId.value,
      'path': path,
    });
  }

  static Future<bool> stopRecording(NativeTextureId textureId) {
    return _methodChannel
        .invokeMethod<bool>('stopRecording', {'textureId': textureId.value})
        .then((value) => value ?? false);
  }
}
