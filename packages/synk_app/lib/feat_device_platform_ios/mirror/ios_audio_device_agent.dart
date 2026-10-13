import 'package:synk/feat_device_platform/application/agents/audio_device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/native_texture_id.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_transport.dart';

class IosAudioDeviceAgent({
  required final IosMirrorTransport transport,
  required final NativeTextureId textureId,
}) implements AudioDeviceAgent {
  var _isAudioMuted = true;

  @override
  bool get isAudioMuted => _isAudioMuted;

  @override
  Future<void> setAudioMuted(bool muted) async {
    await transport.setAudioMuted(textureId, muted);
    _isAudioMuted = muted;
  }
}
