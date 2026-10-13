import 'dart:typed_data';

import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/native_texture_id.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_channel.dart';

class const ScrcpySession._({required final NativeTextureId textureId}) {
  static Future<ScrcpySession> create() async {
    final textureId = await ScrcpyChannel.createSession();
    return ._(textureId: textureId);
  }

  Future<void> dispose() async {
    await ScrcpyChannel.destroySession(textureId);
  }

  Future<void> uploadVideo(Uint8List chunk) async {
    await ScrcpyChannel.sendVideoChunk(textureId, chunk);
  }

  Future<void> uploadAudio(Uint8List chunk) async {
    await ScrcpyChannel.sendAudioChunk(textureId, chunk);
  }

  Future<void> setAudioMuted(bool muted) async {
    await ScrcpyChannel.setAudioMuted(textureId, muted);
  }

  Stream<DeviceScreenSize> get screenSizeChanges {
    return ScrcpyChannel.screenSizeChanges
        .where((event) => event.textureId == textureId)
        .map((event) => event.size);
  }

  Future<void> startRecording(String path) {
    return ScrcpyChannel.startRecording(textureId, path);
  }

  Future<bool> stopRecording() {
    return ScrcpyChannel.stopRecording(textureId);
  }
}
