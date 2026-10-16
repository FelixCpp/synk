import 'dart:async';
import 'dart:typed_data';

import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_mirror.dart';

class ScrcpyAudio({
  required final ScrcpyMirror mirror,
  required Stream<Uint8List> byteStream,
}) implements DeviceAudio {
  late final StreamSubscription<Uint8List> _subscription;

  var _isAudioMuted = true;
  var _audioVolume = 1.0;

  this {
    _subscription = byteStream.listen((bytes) => mirror.uploadAudio(bytes));
  }

  Future<void> dispose() async {
    await _subscription.cancel();
  }

  @override
  bool get isAudioMuted => _isAudioMuted;

  @override
  Future<void> setAudioMuted(bool muted) async {
    _isAudioMuted = muted;
    await mirror.setAudioMuted(muted);
  }

  @override
  double get audioVolume => _audioVolume;

  @override
  Future<void> setAudioVolume(double volume) async {
    _audioVolume = volume;
    await mirror.setAudioVolume(volume);
  }
}
