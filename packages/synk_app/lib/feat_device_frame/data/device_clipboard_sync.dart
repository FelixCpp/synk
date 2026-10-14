import 'dart:io';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:flutter/services.dart';
import 'package:synk/feat_clipboard/application/host_clipboard.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

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

class const DeviceClipboardSync({
  required final DeviceId deviceId,
  required final HostClipboard hostClipboard,
}) {
  Future<ClipboardSyncFailure?> perform(
    ClipboardShortcut shortcut,
    DeviceClipboard clipboard,
  ) {
    return switch (shortcut) {
      .copyFromDevice => _copyFromDevice(clipboard),
      .pasteToDevice => _pasteToDevice(clipboard),
    };
  }

  Future<ClipboardSyncFailure?> _copyFromDevice(
    DeviceClipboard clipboard,
  ) async {
    final String text;
    try {
      text = await clipboard.getClipboard();
    } on Object catch (error, stackTrace) {
      return _unreachable(error, stackTrace);
    }

    if (text.isEmpty) {
      return null;
    }

    await hostClipboard.writeText(text);
    return null;
  }

  Future<ClipboardSyncFailure?> _pasteToDevice(
    DeviceClipboard clipboard,
  ) async {
    final text = await hostClipboard.readText();
    if (text == null) {
      return null;
    }

    try {
      await clipboard.setClipboard(text);
      return null;
    } on Object catch (error, stackTrace) {
      return _unreachable(error, stackTrace);
    }
  }

  ClipboardSyncFailure _unreachable(Object error, StackTrace stackTrace) {
    appLogger.w(
      'No clipboard sync for $deviceId; swallowing the shortcut',
      error: error,
      stackTrace: stackTrace,
    );

    return switch (error) {
      DevicectlCommandException() || ProcessException() => .toolUnavailable,
      _ => .deviceUnreachable,
    };
  }
}
