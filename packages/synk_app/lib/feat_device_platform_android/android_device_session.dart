import 'dart:async';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform_android/device_agent/android_device_agent_client.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_server_launcher.dart';
import 'package:synk/feat_device_platform_android/device_agent/android_device_info.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_android/adb/adb_file_transfer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_audio.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_interaction.dart';
import 'package:synk/feat_device_platform_android/android_screen_capture.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_mirror.dart';

class AndroidDeviceSession({
  required final ScrcpyMirror mirror,
  required final ScrcpyServerConnection server,
  required final AndroidDeviceAgentCommunicator communicator,
  required AdbDeviceCommunicator adbCommunicator,
  required DeviceScreenSize initialScreenSize,
  required final AndroidDeviceInfo info,
}) implements DeviceSession {
  final _audio = ScrcpyAudio(
    mirror: mirror,
    byteStream: server.audioSocket,
  );

  final _screenCapture = AndroidScreenCapture(
    mirror: mirror,
    communicator: communicator,
  );

  final _fileTransfer = AdbFileTransfer(adbCommunicator);

  final _screenSize = BehaviorSubject.seeded(initialScreenSize);
  late final ScrcpyInteraction _interaction;
  late final StreamSubscription<Uint8List> _videoSubscription;
  late final StreamSubscription<DeviceScreenSize> _screenSizeSubscription;

  this {
    _interaction = ScrcpyInteraction(
      interactionSocket: server.controlSocket,
      screenSize: _screenSize,
    );
    _videoSubscription = server.videoStream.listen(
      (bytes) => mirror.uploadVideo(bytes),
    );
    _screenSizeSubscription = mirror.screenSizeChanges.listen(_screenSize.add);
  }

  @override
  NativeTextureId get textureId => mirror.textureId;

  @override
  DeviceScreenSize get screenSize => _screenSize.value;

  @override
  Stream<DeviceScreenSize> get screenSizeChanges => _screenSize.stream;

  @override
  DeviceAudio? get audio => _audio;

  @override
  DeviceClipboard? get clipboard => _interaction;

  @override
  DeviceInteraction? get interaction => _interaction;

  @override
  DeviceScreenCapture? get screenCapture => _screenCapture;

  @override
  DeviceFileTransfer? get fileTransfer => _fileTransfer;

  @override
  Future<void> dispose() async {
    await _videoSubscription.cancel();
    await _screenSizeSubscription.cancel();
    await _screenSize.close();
    await _audio.dispose();
    await _interaction.dispose();
    await server.dispose();
    await mirror.dispose();
    await communicator.dispose();
  }
}
