import 'dart:typed_data';

import 'package:synk/feat_device_platform_ios/mirror/ios_media_stream_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_channel.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';

class const IosAudioSideCar(
  final IosMediaStreamChannel channel,
  final int sessionId,
) {
  Future<void> setMuted(bool muted) {
    return channel.setAudioSessionMuted(sessionId, muted);
  }

  Future<void> setVolume(double volume) {
    return channel.setAudioSessionVolume(sessionId, volume);
  }

  Future<void> stop() async {
    await channel.stopAudio(sessionId);
  }
}

class const IosMirrorTransport(
  final IosMirrorChannel channel,
  final IosAudioSideCar? audio,
) {
  bool get supportsAudio => audio != null;

  Stream<DeviceScreenSize> screenSizeChanges(NativeTextureId textureId) {
    return channel.screenSizeChanges
        .where((event) => event.textureId == textureId)
        .map((event) => event.size);
  }

  Future<Uint8List> captureScreenshot(NativeTextureId textureId) {
    return channel.captureScreenshot(textureId);
  }

  Future<void> startRecording(NativeTextureId textureId, String path) {
    return channel.startRecording(textureId, path);
  }

  Future<bool> stopRecording(NativeTextureId textureId) {
    return channel.stopRecording(textureId);
  }

  Future<void> setAudioMuted(NativeTextureId textureId, bool muted) async {
    await audio?.setMuted(muted);
  }

  Future<void> setAudioVolume(NativeTextureId textureId, double volume) async {
    await audio?.setVolume(volume);
  }

  Future<void> stopMirror(NativeTextureId textureId) async {
    await audio?.stop();
    await channel.stopMirror(textureId);
  }
}
