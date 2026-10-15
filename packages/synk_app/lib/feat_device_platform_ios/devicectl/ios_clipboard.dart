import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:flutter/services.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

class const IosClipboard({
  required final DevicectlApi devicectl,
  required final DeviceId deviceId,
  required final DeviceInteraction? interaction,
}) implements DeviceClipboard {
  @override
  Future<String> getClipboard() {
    return devicectl.readPasteboard(deviceId: deviceId);
  }

  @override
  Future<void> setClipboard(String content) async {
    await devicectl.writePasteboard(deviceId: deviceId, text: content);
    await _simulatePasteKeystroke();
  }

  Future<void> _simulatePasteKeystroke() async {
    final interaction = this.interaction;
    if (interaction == null) {
      return;
    }

    try {
      for (final type in [DeviceKeyEventType.down, DeviceKeyEventType.up]) {
        await interaction.simulateKeyEvent(
          DeviceKeyEvent(
            key: LogicalKeyboardKey.keyV,
            physicalKey: PhysicalKeyboardKey.keyV,
            type: type,
            modifiers: const {},
          ),
        );
      }
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'Pasted onto the pasteboard of $deviceId but could not trigger the '
        'on-device paste',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
