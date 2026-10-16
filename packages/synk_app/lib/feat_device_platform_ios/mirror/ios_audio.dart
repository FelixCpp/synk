import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_transport.dart';

class IosAudio({
  required final IosMirrorTransport transport,
  required final NativeTextureId textureId,
}) implements DeviceAudio {
  var _isAudioMuted = true;
  var _audioVolume = 1.0;

  @override
  bool get isAudioMuted => _isAudioMuted;

  @override
  Future<void> setAudioMuted(bool muted) async {
    await transport.setAudioMuted(textureId, muted);
    _isAudioMuted = muted;
  }

  @override
  double get audioVolume => _audioVolume;

  @override
  Future<void> setAudioVolume(double volume) async {
    await transport.setAudioVolume(textureId, volume);
    _audioVolume = volume;
  }
}
