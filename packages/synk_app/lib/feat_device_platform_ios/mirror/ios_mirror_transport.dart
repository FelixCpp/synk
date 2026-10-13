import 'dart:typed_data';

import 'package:synk/feat_device_platform_ios/mirror/ios_media_stream_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_channel.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';

/// How a mirrored iOS screen reaches the host.
///
/// The screen comes from the AVFoundation capture session over USB. The
/// CoreDevice media stream can carry it too, and over Wi-Fi at that, but its
/// picture drifts apart within seconds and never recovers, so only its audio
/// is used — see [IosMediaStreamChannel]. The session talks to whichever
/// transport the repository managed to start, so it does not have to know
/// which.
abstract interface class IosMirrorTransport {
  /// Whether this transport can forward the device's audio at all.
  bool get supportsAudio;

  Stream<DeviceScreenSize> screenSizeChanges(NativeTextureId textureId);
  Future<Uint8List> captureScreenshot(NativeTextureId textureId);
  Future<void> startRecording(NativeTextureId textureId, String path);
  Future<bool> stopRecording(NativeTextureId textureId);
  Future<void> setAudioMuted(NativeTextureId textureId, bool muted);
  Future<void> stopMirror(NativeTextureId textureId);
}

/// Mirroring over CoreDevice — wireless capable, with system audio.
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

/// A started audio-only CoreDevice stream, riding alongside a capture session.
class const IosAudioSideCar(
  final IosMediaStreamChannel channel,
  final int sessionId,
) {
  Future<void> setMuted(bool muted) {
    return channel.setAudioSessionMuted(sessionId, muted);
  }

  Future<void> stop() => channel.stopAudio(sessionId);
}

/// Mirroring through an AVFoundation capture session — USB only, and silent on
/// its own, but it reaches every trusted device and its picture is stable.
///
/// [audio] is the separately negotiated CoreDevice audio stream where one could
/// be started; without it the connection is simply mute.
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
    // The audio stream outlives a failed teardown of the picture, so stop it
    // first and regardless.
    await audio?.stop();
    await channel.stopMirror(textureId);
  }
}
