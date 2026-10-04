import 'dart:typed_data';

import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_native_texture/native_texture_channel.dart';

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

  Future<void> uploadAudio(Uint8List chunk) async {
    await NativeTextureChannel.sendAudioChunk(id, chunk);
  }

  Future<void> setAudioMuted(bool muted) async {
    await NativeTextureChannel.setAudioMuted(id, muted);
  }

  Stream<DeviceScreenSize> get screenSizeChanges {
    return NativeTextureChannel.screenSizeChanges
        .where((event) => event.textureId == id)
        .map((event) => event.size);
  }

  Future<void> startRecording(String path) {
    return NativeTextureChannel.startRecording(id, path);
  }

  Future<bool> stopRecording() {
    return NativeTextureChannel.stopRecording(id);
  }
}
