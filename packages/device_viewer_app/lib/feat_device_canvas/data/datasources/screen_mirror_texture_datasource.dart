import 'dart:typed_data';

import 'package:flutter/services.dart';

/// Bridges to the native `ScreenMirrorPlugin` (macOS: VideoToolbox decode +
/// FlutterTexture). The native side keeps one decode session per texture id,
/// so any number of textures can be live at once - this datasource is
/// stateless and just addresses each call/chunk by texture id.
class const ScreenMirrorTextureDatasource() {
  static const _methodChannel = MethodChannel('dev.deviceviewer/screen_mirror');
  static const _videoChunkChannel = BasicMessageChannel<ByteData?>(
    'dev.deviceviewer/screen_mirror/video_chunk',
    BinaryCodec(),
  );

  Future<int> createTexture() {
    return _methodChannel
        .invokeMethod<int>('createTexture')
        .then((value) => value!);
  }

  Future<void> destroyTexture(int textureId) {
    return _methodChannel.invokeMethod('destroyTexture', {
      'textureId': textureId,
    });
  }

  /// Sends [chunk] to the decoder feeding [textureId], prefixed with the
  /// texture id so the native side can route it to the right session.
  void sendChunk(int textureId, Uint8List chunk) {
    final message = Uint8List(8 + chunk.length);
    ByteData.view(message.buffer).setInt64(0, textureId, Endian.big);
    message.setRange(8, message.length, chunk);
    _videoChunkChannel.send(message.buffer.asByteData());
  }
}
