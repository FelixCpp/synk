import 'dart:typed_data';

import 'package:synk/feat_device_platform_ios/mirror/ios_media_stream_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_channel.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';

abstract interface class IosMirrorTransport {
  bool get supportsAudio;

  Stream<DeviceScreenSize> screenSizeChanges(NativeTextureId textureId);
  Future<Uint8List> captureScreenshot(NativeTextureId textureId);
  Future<void> startRecording(NativeTextureId textureId, String path);
  Future<bool> stopRecording(NativeTextureId textureId);
  Future<void> setAudioMuted(NativeTextureId textureId, bool muted);
  Future<void> stopMirror(NativeTextureId textureId);
}

class const IosMediaStreamTransport(
  final IosMediaStreamChannel channel,
  final bool deviceHasAudio,
) implements IosMirrorTransport {
  @override
  bool get supportsAudio => deviceHasAudio;

  @override
  Stream<DeviceScreenSize> screenSizeChanges(NativeTextureId textureId) {
    return channel.screenSizeChanges
        .where((event) => event.textureId == textureId)
        .map((event) => event.size);
  }

  @override
  Future<Uint8List> captureScreenshot(NativeTextureId textureId) {
    return channel.captureScreenshot(textureId);
  }

  @override
  Future<void> startRecording(NativeTextureId textureId, String path) {
    return channel.startRecording(textureId, path);
  }

  @override
  Future<bool> stopRecording(NativeTextureId textureId) {
    return channel.stopRecording(textureId);
  }

  @override
  Future<void> setAudioMuted(NativeTextureId textureId, bool muted) {
    return channel.setAudioMuted(textureId, muted);
  }

  @override
  Future<void> stopMirror(NativeTextureId textureId) {
    return channel.stopMirror(textureId);
  }
}

class const IosAudioSideCar(
  final IosMediaStreamChannel channel,
  final int sessionId,
) {
  Future<void> setMuted(bool muted) {
    return channel.setAudioSessionMuted(sessionId, muted);
  }

  Future<void> stop() => channel.stopAudio(sessionId);
}

class const IosCaptureSessionTransport(
  final IosMirrorChannel channel,
  final IosAudioSideCar? audio,
) implements IosMirrorTransport {
  @override
  bool get supportsAudio => audio != null;

  @override
  Stream<DeviceScreenSize> screenSizeChanges(NativeTextureId textureId) {
    return channel.screenSizeChanges
        .where((event) => event.textureId == textureId)
        .map((event) => event.size);
  }

  @override
  Future<Uint8List> captureScreenshot(NativeTextureId textureId) {
    return channel.captureScreenshot(textureId);
  }

  @override
  Future<void> startRecording(NativeTextureId textureId, String path) {
    return channel.startRecording(textureId, path);
  }

  @override
  Future<bool> stopRecording(NativeTextureId textureId) {
    return channel.stopRecording(textureId);
  }

  @override
  Future<void> setAudioMuted(NativeTextureId textureId, bool muted) async {
    await audio?.setMuted(muted);
  }

  @override
  Future<void> stopMirror(NativeTextureId textureId) async {
    await audio?.stop();
    await channel.stopMirror(textureId);
  }
}
