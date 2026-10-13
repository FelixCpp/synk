import 'dart:async';
import 'dart:typed_data';

import 'package:synk/feat_device_platform/application/agents/audio_device_agent.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_session.dart';

class ScrcpyAudioDeviceAgent({
  required final ScrcpySession session,
  required Stream<Uint8List> byteStream,
}) implements AudioDeviceAgent {
  late final StreamSubscription<Uint8List> _subscription;

  var _isAudioMuted = true;

  this {
    _subscription = byteStream.listen((bytes) => session.uploadAudio(bytes));
  }

  Future<void> dispose() async {
    await _subscription.cancel();
  }

  @override
  bool get isAudioMuted => _isAudioMuted;

  @override
  Future<void> setAudioMuted(bool muted) async {
    _isAudioMuted = muted;
    await session.setAudioMuted(muted);
  }
}
