import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/clipboard_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/display_power_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/key_event_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/media_scan_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/pointer_event_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/text_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/video_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_key_input.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_pointer_input.dart';

class ScrcpyInteraction({
  required final Socket interactionSocket,
  required final ValueStream<DeviceScreenSize> screenSize,
  required final Future<void> Function() rotateDevice,

  /// Keeps the device's own display dark for the whole session.
  final bool keepDisplayOff = false,
}) implements DeviceInteraction, DeviceClipboard, DeviceTextInput {
  final _clipboard = ClipboardInteractionLayer(interactionSocket);
  final _key = KeyEventInteractionLayer(interactionSocket);
  final _text = TextInteractionLayer(interactionSocket);
  final _pointer = PointerEventInteractionLayer(interactionSocket);
  final _displayPower = DisplayPowerInteractionLayer(interactionSocket);
  final _video = VideoInteractionLayer(interactionSocket);
  final _mediaScan = MediaScanInteractionLayer(interactionSocket);

  /// Keys whose press went out as text. Their release must not reach the
  /// device as a key code for a press it never saw.
  final _keysTypedAsText = <PhysicalKeyboardKey>{};
  final _keyCodesAtPress = <PhysicalKeyboardKey, ScrcpyKeyCode>{};

  this {
    _clipboard.listenForDeviceMessages();
    if (keepDisplayOff) _displayPower.setDisplayPower(on: false);
  }

  void requestKeyframe() {
    _video.resetVideo();
  }

  void scanFile(String remoteFilepath) {
    _mediaScan.scanFile(remoteFilepath);
  }

  Future<void> dispose() async {
    await interactionSocket.close();
  }

  @override
  Future<void> simulateKeyEvent(DeviceKeyEvent event) async {
    if (event.toScrcpyText() case final text?) {
      _keysTypedAsText.add(event.physicalKey);
      _text.injectText(text);
      return;
    }

    if (event.type == .up && _keysTypedAsText.remove(event.physicalKey)) {
      return;
    }

    final keyEvent = event.toScrcpyKeyEvent();
    if (keyEvent == null) {
      return;
    }

    final pressedAs = switch (event.type) {
      .down => _keyCodesAtPress[event.physicalKey] = keyEvent.key,
      .repeat => _keyCodesAtPress[event.physicalKey] ?? keyEvent.key,
      .up => _keyCodesAtPress.remove(event.physicalKey) ?? keyEvent.key,
    };

    _key.simulateKeyEvent(keyEvent.copyWith(key: pressedAs));
  }

  @override
  Future<void> simulatePointerEvent(DevicePointerEvent event) async {
    // Waking the device would undo the dark display the user asked for.
    if (event.type == .down && !keepDisplayOff) {
      _pressKey(.wakeup);
    }

    _pointer.simulatePointerEvent(
      event.toScrcpyPointerEvent(),
      screenSize.value,
    );
  }

  @override
  Future<void> simulatePinchEvent(PinchEvent event) async {}

  @override
  Set<DeviceNavigation> get supportedNavigations {
    return const {.back, .home, .appSwitch};
  }

  @override
  Future<void> navigate(DeviceNavigation navigation) async {
    _pressKey(switch (navigation) {
      .back => .back,
      .home => .home,
      .appSwitch => .appSwitch,
    });
  }

  @override
  Future<void> pressPowerButton() async {
    _pressKey(.power);
  }

  @override
  Future<void> rotate() {
    return rotateDevice();
  }

  void _pressKey(ScrcpyKeyCode key) {
    for (final type in [ScrcpyKeyEventType.down, ScrcpyKeyEventType.up]) {
      _key.simulateKeyEvent(.new(key: key, type: type, metaState: .none));
    }
  }

  @override
  Future<void> setClipboard(String content) async {
    _clipboard.setClipboard(text: content);
  }

  @override
  Future<void> typeText(String text) async {
    _text.injectText(text);
  }

  @override
  Future<String> getClipboard() {
    return _clipboard.getClipboard();
  }
}
