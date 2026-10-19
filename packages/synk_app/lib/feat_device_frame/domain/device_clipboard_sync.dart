import 'package:flutter/services.dart';
import 'package:synk/feat_clipboard/domain/clipboard_feature.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';

enum ClipboardShortcut {
  copyFromDevice,
  pasteToDevice;

  static ClipboardShortcut? of(DeviceKeyEvent event) {
    if (!event.isMetaPressed) {
      return null;
    }

    return switch (event.key) {
      LogicalKeyboardKey.keyC => copyFromDevice,
      LogicalKeyboardKey.keyV => pasteToDevice,
      _ => null,
    };
  }
}

class const DeviceClipboardSync(final ClipboardFeature _clipboard) {
  Future<void> perform(
    ClipboardShortcut shortcut,
    DeviceClipboard clipboard,
  ) {
    return switch (shortcut) {
      .copyFromDevice => _copyFromDevice(clipboard),
      .pasteToDevice => _pasteToDevice(clipboard),
    };
  }

  Future<void> _copyFromDevice(DeviceClipboard clipboard) async {
    final text = await clipboard.getClipboard();
    if (text.isEmpty) {
      return;
    }

    await _clipboard.writeText(text);
  }

  Future<void> _pasteToDevice(DeviceClipboard clipboard) async {
    final text = await _clipboard.readText();
    if (text == null) {
      return;
    }

    await clipboard.setClipboard(text);
  }
}
