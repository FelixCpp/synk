import 'dart:typed_data';

import 'package:device_viewer/feat_native_texture/native_texture_channel.dart';

extension type const NativeTextureId(int value) implements int {}

class const NativeTexture._({
  required final NativeTextureId id,
}) {
  static Future<NativeTexture> create() async {
    final textureId = await NativeTextureChannel.createTexture();
    return ._(id: textureId);
  }

  Future<void> dispose() async {
    await NativeTextureChannel.destroyTexture(id);
  }

  Future<void> upload(Uint8List chunk) async {
    await NativeTextureChannel.sendChunk(id, chunk);
  }
}
