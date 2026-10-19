import 'dart:io' show ProcessException;

import 'package:api_devicectl/api_devicectl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform/domain/models/device_clipboard_exception.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_ios/devicectl/ios_clipboard.dart';

import '../support/fake_process_manager.dart';

void main() {
  IosClipboard clipboardOver(FakeProcessManager processManager) {
    return IosClipboard(
      devicectl: DevicectlApi(processManager: processManager),
      deviceId: const DeviceId('00008120-0009555001C2601E'),
      interaction: null,
    );
  }

  test('calls a devicectl that answers with an exit code unavailable', () {
    final clipboard = clipboardOver(
      FakeProcessManager(
        respond: (_) => (exitCode: 1, stdout: '', stderr: 'no xcode'),
      ),
    );

    expect(
      clipboard.getClipboard(),
      throwsA(isA<DeviceClipboardUnavailableException>()),
    );
  });

  test('calls a devicectl that cannot be spawned unavailable', () {
    final clipboard = clipboardOver(
      FakeProcessManager(
        respond: (_) => throw const ProcessException('/usr/bin/xcrun', []),
      ),
    );

    expect(
      clipboard.setClipboard('text'),
      throwsA(isA<DeviceClipboardUnavailableException>()),
    );
  });

  test('keeps the devicectl error type out of what it throws', () {
    final clipboard = clipboardOver(
      FakeProcessManager(
        respond: (_) => (exitCode: 1, stdout: '', stderr: 'no xcode'),
      ),
    );

    expect(
      clipboard.getClipboard(),
      throwsA(isNot(isA<DevicectlCommandException>())),
    );
  });
}
