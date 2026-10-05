import 'dart:async';
import 'dart:typed_data';

import 'package:synk/feat_device_agent/data/datasources/ios_mirror_channel.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:rxdart/rxdart.dart';

class IosDeviceAgent(
  final IosMirrorChannel channel,
  @override final NativeTextureId textureId,
  final DeviceScreenSize initialScreenSize,
) implements ScreenCaptureAgent {
  late final _screenSize = BehaviorSubject.seeded(initialScreenSize);
  late final StreamSubscription<IosMirrorScreenSize> _screenSizeSubscription;

  this {
    _screenSizeSubscription = channel.screenSizeChanges
        .where((event) => event.textureId == textureId)
        .listen((event) => _screenSize.add(event.size));
  }

  @override
  DeviceScreenSize get screenSize => _screenSize.value;

  @override
  Stream<DeviceScreenSize> get screenSizeChanges => _screenSize.stream;

  @override
  Future<Uint8List> captureScreenshot() {
    return channel.captureScreenshot(textureId);
  }

  @override
  Future<void> startRecording(String path) {
    return channel.startRecording(textureId, path);
  }

  @override
  Future<bool> stopRecording() {
    return channel.stopRecording(textureId);
  }

  Future<void> dispose() async {
    await _screenSizeSubscription.cancel();
    await _screenSize.close();
    await channel.stopMirror(textureId);
  }
}
