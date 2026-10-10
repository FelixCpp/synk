import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_hid_channel.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_mirror_channel.dart';
import 'package:synk/feat_device_agent/domain/models/clipboard_agent.dart';
import 'package:synk/feat_device_agent/domain/models/device_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_agent/domain/models/ios_hardware_button.dart';
import 'package:synk/feat_device_agent/domain/models/ios_key_input.dart';
import 'package:synk/feat_device_agent/domain/models/ios_touch_gesture.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:rxdart/rxdart.dart';

class IosDeviceAgent(
  final IosMirrorChannel channel,
  final IosHidChannel hidChannel,
  final DevicectlApi devicectl,
  final DeviceId deviceId,
  @override final NativeTextureId textureId,
  final DeviceScreenSize initialScreenSize,
  final bool supportsInteraction,
) implements ScreenCaptureAgent, ClipboardAgent, InteractionAgent {
  late final _screenSize = BehaviorSubject.seeded(initialScreenSize);
  late final StreamSubscription<IosMirrorScreenSize> _screenSizeSubscription;

  var _activeEdge = IosTouchEdge.none;

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
  Future<Uint8List> captureScreenshot() async {
    try {
      return await _captureScreenshotViaDevicectl();
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'Falling back to the mirrored frame for the screenshot of $deviceId',
        error: error,
        stackTrace: stackTrace,
      );

      return channel.captureScreenshot(textureId);
    }
  }

  Future<Uint8List> _captureScreenshotViaDevicectl() async {
    final directory = await Directory.systemTemp.createTemp('synk_screenshot');

    try {
      final destination = '${directory.path}/screenshot.png';
      await devicectl.captureScreenshot(
        deviceId: deviceId,
        destination: destination,
      );

      return await File(destination).readAsBytes();
    } finally {
      await directory.delete(recursive: true);
    }
  }

  @override
  Future<String> readDeviceClipboardContent() {
    return devicectl.readPasteboard(deviceId: deviceId);
  }

  @override
  Future<void> setDeviceClipboardContent(String clipboard) {
    return devicectl.writePasteboard(deviceId: deviceId, text: clipboard);
  }

  @override
  Future<void> startRecording(String filepath) {
    return channel.startRecording(textureId, filepath);
  }

  @override
  Future<bool> stopRecording() {
    return channel.stopRecording(textureId);
  }

  @override
  Future<void> simulateKeyEvent(DeviceKeyEvent event) async {
    final usageCode = iosKeyUsageOf(event.key);
    if (usageCode == null) {
      return;
    }

    await hidChannel.sendKey(
      deviceId: deviceId,
      usageCode: usageCode,
      isDown: event.type != .up,
    );
  }

  @override
  Future<void> simulatePointerEvent(DevicePointerEvent event) {
    if (event.type == .down) {
      _activeEdge = iosTouchEdgeAtPointerDown(
        event.normalizedPointerX,
        event.normalizedPointerY,
      );
    }

    return hidChannel.sendTouch(
      deviceId: deviceId,
      point: (x: event.normalizedPointerX, y: event.normalizedPointerY),
      phase: iosTouchPhaseOf(event.type),
      edge: _activeEdge,
    );
  }

  @override
  Future<void> simulatePinchEvent(PinchEvent event) {
    final leftX = _clampedToScreen(event.centerX - event.spread);
    final rightX = _clampedToScreen(event.centerX + event.spread);

    return hidChannel.sendTouch(
      deviceId: deviceId,
      point: (x: leftX, y: event.centerY),
      secondPoint: (x: rightX, y: event.centerY),
      phase: iosTouchPhaseOf(event.type),
      edge: .none,
    );
  }

  @override
  Future<void> simulateControlAction(DeviceControlAction action) async {
    if (iosSwipeForControlAction(action) case final swipe?) {
      await hidChannel.sendSwipe(deviceId: deviceId, swipe: swipe);
      return;
    }

    if (iosButtonForControlAction(action) case final button?) {
      await hidChannel.pressButton(deviceId: deviceId, button: button);
    }
  }

  Future<void> dispose() async {
    await _screenSizeSubscription.cancel();
    await _screenSize.close();

    try {
      await hidChannel.releaseInput(deviceId);
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'Failed to release the touch input of $deviceId',
        error: error,
        stackTrace: stackTrace,
      );
    }

    await channel.stopMirror(textureId);
  }
}

double _clampedToScreen(double normalizedPosition) {
  return normalizedPosition.clamp(0.0, 1.0);
}
