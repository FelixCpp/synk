import 'dart:async';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:synk/feat_device_agent/application/android_audio_transmission.dart';
import 'package:synk/feat_device_agent/application/android_device_agent_client.dart';
import 'package:synk/feat_device_agent/application/android_interaction_transmission.dart';
import 'package:synk/feat_device_agent/application/android_screen_transmission.dart';
import 'package:synk/feat_device_agent/domain/models/clipboard_agent.dart';
import 'package:synk/feat_device_agent/domain/models/device_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_key_input.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
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
) implements ScreenCaptureAgent, ClipboardAgent, InteractionAgent {
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

  @override
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

  @override
  Future<void> simulateKeyEvent(DeviceKeyEvent event) async {
    final keyCode = scrcpyKeyCodeOf(event.key);
    if (keyCode == null) {
      return;
    }

    interactionTransmission.simulateKeyEvent(
      keyCode: keyCode,
      type: scrcpyKeyEventTypeOf(event.type),
      metaState: scrcpyMetaStateOf(event.modifiers),
    );
  }

  @override
  Future<void> simulatePointerEvent(DevicePointerEvent event) async {
    if (event.type == .down) {
      _pressKey(.wakeup);
    }

    interactionTransmission.simulatePointerEvent(
      type: event.type,
      normalizedPointerX: event.normalizedPointerX,
      normalizedPointerY: event.normalizedPointerY,
    );
  }

  @override
  Future<void> simulatePinchEvent(PinchEvent event) async {}

  @override
  Future<void> simulateControlAction(DeviceControlAction action) async {
    _pressKey(switch (action) {
      .back => .back,
      .home => .home,
      .appSwitch => .appSwitch,
      .standby => .power,
    });
  }

  void _pressKey(ScrcpyKeyCode keyCode) {
    for (final type in [ScrcpyKeyEventType.down, ScrcpyKeyEventType.up]) {
      interactionTransmission.simulateKeyEvent(
        keyCode: keyCode,
        type: type,
        metaState: .none,
      );
    }
  }

  @override
  Future<void> setDeviceClipboardContent(String clipboard) async {
    interactionTransmission.setClipboard(text: clipboard);
  }

  @override
  Future<String> readDeviceClipboardContent() {
    return interactionTransmission.getClipboard();
  }

  Future<void> installApk(String filepath) {
    return adbCommunicator.install(localFilepath: filepath);
  }

  Future<void> pushFile(String localFilepath) {
    return adbCommunicator.pushFile(
      localFilepath: localFilepath,
      remoteFilepath:
          '$_androidDownloadsDirectory/${path.basename(localFilepath)}',
    );
  }

  Future<AndroidDeviceInfo> fetchAndroidDeviceInfo() async {
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
