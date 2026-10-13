import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_transport.dart';

class IosAudio({
  required final IosMirrorTransport transport,
  required final NativeTextureId textureId,
}) implements DeviceAudio {
  var _isAudioMuted = true;

  @override
  bool get isAudioMuted => _isAudioMuted;

  @override
  Future<void> setAudioMuted(bool muted) async {
    await transport.setAudioMuted(textureId, muted);
    _isAudioMuted = muted;
  }
}
