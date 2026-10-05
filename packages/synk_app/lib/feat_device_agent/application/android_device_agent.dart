import 'dart:async';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:synk/feat_device_agent/application/android_audio_transmission.dart';
import 'package:synk/feat_device_agent/application/android_device_agent_client.dart';
import 'package:synk/feat_device_agent/application/android_interaction_transmission.dart';
import 'package:synk/feat_device_agent/application/android_screen_transmission.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_pointer_action.dart';
import 'package:synk/feat_device_connections/domain/models/android_device_info.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';

const _androidDownloadsDirectory = '/sdcard/Download';

class AndroidDeviceAgent(
  final AdbDeviceCommunicator adbCommunicator,
  final AndroidDeviceAgentCommunicator communicator,
  final MirrorSession session,
  final AndroidScreenTransmission screenTransmission,
  final AndroidAudioTransmission audioTransmission,
  final AndroidInteractionTransmission interactionTransmission,
) implements ScreenCaptureAgent {
  final StreamSubscription<Uint8List> _mirrorSubscription;
  final StreamSubscription<Uint8List> _audioSubscription;

  late final _screenSize = BehaviorSubject.seeded(
    interactionTransmission.screenSize,
  );
  late final StreamSubscription<DeviceScreenSize> _screenSizeSubscription;

  var _isAudioMuted = true;

  this
    : _mirrorSubscription = screenTransmission.byteStream.listen(
        (bytes) => session.uploadVideo(bytes),
      ),
      _audioSubscription = audioTransmission.byteStream.listen(
        (bytes) => session.uploadAudio(bytes),
      ) {
    _screenSizeSubscription = session.screenSizeChanges.listen((size) {
      interactionTransmission.screenSize = size;
      _screenSize.add(size);
    });
  }

  @override
  NativeTextureId get textureId => session.textureId;
  @override
  DeviceScreenSize get screenSize => _screenSize.value;

  Stream<DeviceScreenSize> get screenSizeChanges => _screenSize.stream;

  bool get isAudioMuted => _isAudioMuted;

  Future<void> dispose() async {
    await _mirrorSubscription.cancel();
    await _audioSubscription.cancel();
    await _screenSizeSubscription.cancel();
    await _screenSize.close();
    await screenTransmission.dispose();
    await audioTransmission.dispose();
    await interactionTransmission.dispose();
    await session.dispose();
    await communicator.dispose();
  }

  Future<void> setAudioMuted(bool muted) {
    _isAudioMuted = muted;
    return session.setAudioMuted(muted);
  }

  void simulatePointerEvent(ScrcpyPointerEvent event) {
    interactionTransmission.simulatePointerEvent(
      type: event.type,
      normalizedPointerX: event.normalizedPointerX,
      normalizedPointerY: event.normalizedPointerY,
    );
  }

  void simulateKeyEvent(ScrcpyKeyEvent event) {
    interactionTransmission.simulateKeyEvent(
      keyCode: event.keyCode,
      type: event.type,
      metaState: event.metaState,
    );
  }

  void setDeviceClipboardContent(String clipboard) {
    interactionTransmission.setClipboard(text: clipboard);
  }

  Future<String> readDeviceClipboardContent() {
    return interactionTransmission.getClipboard();
  }

  Future<void> installApk(String filepath) {
    return adbCommunicator.install(localFilepath: filepath);
  }

  Future<void> pushFile(String localFilepath) {
    return adbCommunicator.pushFile(
      localFilepath: localFilepath,
      remoteFilepath: '$_androidDownloadsDirectory/${path.basename(localFilepath)}',
    );
  }

  Future<AndroidDeviceInfo> fetchDeviceInfo() async {
    final response = await communicator.fetchInfo();

    return AndroidDeviceInfo(
      model: response.model,
      manufacturer: response.manufacturer,
      androidVersion: response.androidVersion,
      sdkVersion: response.sdkVersion,
    );
  }

  @override
  Future<Uint8List> captureScreenshot() async {
    final response = await communicator.captureScreenshot();
    return Uint8List.fromList(response.png);
  }

  @override
  Future<void> startRecording(String path) {
    return session.startRecording(path);
  }

  @override
  Future<bool> stopRecording() {
    return session.stopRecording();
  }
}
