import 'dart:typed_data';

import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_mirror_session/mirror_session_channel.dart';

extension type const NativeTextureId(int value) implements int {}

class const MirrorSession._({
  required final NativeTextureId textureId,
}) {
  static Future<MirrorSession> create() async {
    final textureId = await MirrorSessionChannel.createSession();
    return ._(textureId: textureId);
  }

  Future<void> dispose() async {
    await MirrorSessionChannel.destroySession(textureId);
  }

  Future<void> uploadVideo(Uint8List chunk) async {
    await MirrorSessionChannel.sendVideoChunk(textureId, chunk);
  }

  Future<void> uploadAudio(Uint8List chunk) async {
    await MirrorSessionChannel.sendAudioChunk(textureId, chunk);
  }

  Future<void> setAudioMuted(bool muted) async {
    await MirrorSessionChannel.setAudioMuted(textureId, muted);
  }

  Stream<DeviceScreenSize> get screenSizeChanges {
    return MirrorSessionChannel.screenSizeChanges
        .where((event) => event.textureId == textureId)
        .map((event) => event.size);
  }

  Future<void> startRecording(String path) {
    return MirrorSessionChannel.startRecording(textureId, path);
  }

  Future<bool> stopRecording() {
    return MirrorSessionChannel.stopRecording(textureId);
  }
}
