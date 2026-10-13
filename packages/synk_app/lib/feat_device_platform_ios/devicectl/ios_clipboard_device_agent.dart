import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:flutter/services.dart';
import 'package:synk/feat_device_platform/domain/models/device_key_event.dart';
import 'package:synk/feat_device_platform/application/agents/clipboard_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/interaction_device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';

class const IosClipboardDeviceAgent({
  required final DevicectlApi devicectl,
  required final DeviceId deviceId,
  required final InteractionDeviceAgent? interaction,
}) implements ClipboardDeviceAgent {
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
