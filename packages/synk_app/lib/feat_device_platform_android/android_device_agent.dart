import 'dart:async';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform_android/device_agent/android_device_agent_client.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_server_launcher.dart';
import 'package:synk/feat_device_platform_android/device_agent/android_device_info.dart';
import 'package:synk/feat_device_platform/application/agents/audio_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/clipboard_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/file_transfer_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/interaction_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/screen_capture_device_agent.dart';
import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/native_texture_id.dart';
import 'package:synk/feat_device_platform_android/adb/adb_file_transfer_device_agent.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_audio_device_agent.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_interaction_device_agent.dart';
import 'package:synk/feat_device_platform_android/android_screen_capture_device_agent.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_session.dart';

class AndroidDeviceAgent({
  required final ScrcpySession session,
  required final ScrcpyServerConnection server,
  required final AndroidDeviceAgentCommunicator communicator,
  required AdbDeviceCommunicator adbCommunicator,
  required DeviceScreenSize initialScreenSize,
  required final AndroidDeviceInfo info,
}) implements DeviceAgent {
  final _audio = ScrcpyAudioDeviceAgent(
    session: session,
    byteStream: server.audioSocket,
  );

  final _screenCapture = AndroidScreenCaptureDeviceAgent(
    session: session,
    communicator: communicator,
  );

  final _fileTransfer = AdbFileTransferDeviceAgent(adbCommunicator);

  final _screenSize = BehaviorSubject.seeded(initialScreenSize);
  late final ScrcpyInteractionDeviceAgent _interaction;
  late final StreamSubscription<Uint8List> _videoSubscription;
  late final StreamSubscription<DeviceScreenSize> _screenSizeSubscription;

  this {
    _interaction = ScrcpyInteractionDeviceAgent(
      interactionSocket: server.controlSocket,
      screenSize: _screenSize,
    );
    _videoSubscription = server.videoStream.listen(
      (bytes) => session.uploadVideo(bytes),
    );
    _screenSizeSubscription = session.screenSizeChanges.listen(_screenSize.add);
  }

  @override
  NativeTextureId get textureId => session.textureId;

  @override
  DeviceScreenSize get screenSize => _screenSize.value;

  @override
  Stream<DeviceScreenSize> get screenSizeChanges => _screenSize.stream;

  @override
  AudioDeviceAgent? get audio => _audio;

  @override
  ClipboardDeviceAgent? get clipboard => _interaction;

  @override
  InteractionDeviceAgent? get interaction => _interaction;

  @override
  ScreenCaptureDeviceAgent? get screenCapture => _screenCapture;

  @override
  FileTransferDeviceAgent? get fileTransfer => _fileTransfer;

  @override
  Future<void> dispose() async {
    await _videoSubscription.cancel();
    await _screenSizeSubscription.cancel();
    await _screenSize.close();
    await _audio.dispose();
    await _interaction.dispose();
    await server.dispose();
    await session.dispose();
    await communicator.dispose();
  }
}
