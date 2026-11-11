import 'dart:convert';

import 'package:api_adb/api_adb.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';

class AdbRotation(
  final AdbDeviceCommunicator communicator, {
  required final ValueStream<DeviceScreenSize> screenSize,
}) {
  String? _autoRotationBeforeLock;

  Future<void> rotate() async {
    _autoRotationBeforeLock ??= await _readSystemSetting(
      'accelerometer_rotation',
    );

    final isLandscape = screenSize.value.width > screenSize.value.height;

    await _writeSystemSetting('accelerometer_rotation', '0');
    await _writeSystemSetting('user_rotation', isLandscape ? '0' : '1');
  }

  Future<void> restoreAutoRotation() async {
    if (_autoRotationBeforeLock case final autoRotation?) {
      await _writeSystemSetting('accelerometer_rotation', autoRotation);
    }
  }

  Future<String> _readSystemSetting(String name) async {
    final result = await _settings(['get', 'system', name]);
    return utf8.decode(result.stdout).trim();
  }

  Future<void> _writeSystemSetting(String name, String value) async {
    await _settings(['put', 'system', name, value]);
  }

  Future<AdbShellResult> _settings(List<String> arguments) async {
    final result = await communicator.shell(['settings', ...arguments]);

    if (result.exitCode != 0) {
      throw AdbCommandException(
        message:
            'settings ${arguments.join(' ')} failed (${result.exitCode}): '
            '${utf8.decode(result.stderr, allowMalformed: true).trim()}',
      );
    }

    return result;
  }
}
