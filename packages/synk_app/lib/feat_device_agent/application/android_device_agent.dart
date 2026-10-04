import 'dart:async';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:synk/feat_device_agent/application/android_device_agent_client.dart';
import 'package:synk/feat_device_agent/application/android_interaction_transmission.dart';
import 'package:synk/feat_device_agent/application/android_screen_transmission.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_pointer_action.dart';
import 'package:synk/feat_device_connections/domain/models/android_device_info.dart';
import 'package:synk/feat_native_texture/native_texture.dart';
import 'package:path/path.dart' as path;

const _androidDownloadsDirectory = '/sdcard/Download';

class AndroidDeviceAgent(
  final AdbDeviceCommunicator adbCommunicator,
  final AndroidDeviceAgentCommunicator communicator,
  final AndroidScreenTransmission screenTransmission,
  final AndroidInteractionTransmission interactionTransmission,
) implements ScreenCaptureAgent {
  final StreamSubscription<Uint8List> _mirrorSubscription;

  this
    : _mirrorSubscription = screenTransmission.byteStream.listen(
        (bytes) => screenTransmission.texture.upload(bytes),
      );

  @override
  NativeTextureId get textureId => screenTransmission.texture.id;
  @override
  DeviceScreenSize get screenSize => interactionTransmission.screenSize;

  Future<void> dispose() async {
    await _mirrorSubscription.cancel();
    await screenTransmission.dispose();
    await interactionTransmission.dispose();
    await communicator.dispose();
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
    return screenTransmission.texture.startRecording(path);
  }

  @override
  Future<bool> stopRecording() {
    return screenTransmission.texture.stopRecording();
  }
}
