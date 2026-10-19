import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_clipboard_sync.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const SimulateKeyEventInteractor({
  required final DeviceFrameRepository repository,
  required final DeviceClipboardSync clipboardSync,
  required final SettingsRepository settingsRepository,
}) implements ParameterizedInteractor<DeviceKeyEvent> {
  @override
  FutureOr<void> getOrThrow(DeviceKeyEvent input) async {
    final shortcut = ClipboardShortcut.of(input);
    if (shortcut == null) {
      return repository.simulateKeyEvent(input);
    }

    final settings = await settingsRepository.read();
    final clipboard = repository.clipboard;
    if (!settings.syncClipboard || clipboard == null) {
      return repository.simulateKeyEvent(input);
    }

    if (input.type != DeviceKeyEventType.down) {
      return;
    }

    return clipboardSync.perform(shortcut, clipboard);
  }
}
