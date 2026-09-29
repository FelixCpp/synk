import 'dart:typed_data';

import 'package:device_viewer/feat_native_texture/native_texture.dart';
import 'package:flutter/services.dart';

class const NativeTextureChannel._() {
  static const _methodChannel = MethodChannel('dev.deviceviewer/screen_mirror');
  static const _videoChunkChannel = BasicMessageChannel<ByteData?>(
    'dev.deviceviewer/screen_mirror/video_chunk',
    BinaryCodec(),
  );

  static Future<NativeTextureId> createTexture() {
    return _methodChannel
        .invokeMethod<int>('createTexture')
        .then((value) => NativeTextureId(value!));
  }

  static Future<void> destroyTexture(NativeTextureId textureId) {
    return _methodChannel.invokeMethod('destroyTexture', {
      'textureId': textureId.value,
    });
  }

  static Future<void> sendChunk(NativeTextureId textureId, Uint8List chunk) {
    final message = Uint8List(8 + chunk.length);
    ByteData.view(message.buffer).setInt64(0, textureId, Endian.big);
    message.setRange(8, message.length, chunk);
    return _videoChunkChannel.send(message.buffer.asByteData());
  }
}
