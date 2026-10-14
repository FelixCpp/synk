import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/clipboard_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/display_power_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/key_event_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/pointer_event_interaction_layer.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_key_input.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_pointer_input.dart';

class ScrcpyInteraction({
  required final Socket interactionSocket,
  required final ValueStream<DeviceScreenSize> screenSize,

  /// Keeps the device's own display dark for the whole session.
  final bool keepDisplayOff = false,
}) implements DeviceInteraction, DeviceClipboard {
  final _clipboard = ClipboardInteractionLayer(interactionSocket);
  final _key = KeyEventInteractionLayer(interactionSocket);
  final _pointer = PointerEventInteractionLayer(interactionSocket);
  final _displayPower = DisplayPowerInteractionLayer(interactionSocket);

  this {
    _clipboard.listenForDeviceMessages();
    if (keepDisplayOff) _displayPower.setDisplayPower(on: false);
  }

  Future<void> dispose() async {
    await interactionSocket.close();
  }

  @override
  Future<void> simulateKeyEvent(DeviceKeyEvent event) async {
    if (event.toScrcpyKeyEvent() case final event?) {
      _key.simulateKeyEvent(event);
    }
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
  Future<String> getClipboard() {
    return _clipboard.getClipboard();
  }
}
