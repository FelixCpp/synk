import 'dart:convert';
import 'dart:io';

import 'package:api_devicectl/devicectl/process/devicectl_process_runner.dart';
import 'package:process/process.dart';

class const DevicectlCommandException({required final String message})
    implements Exception {
  @override
  String toString() => 'DevicectlCommandException: $message';
}

class const DevicectlDeviceStatus({
  required final bool isPaired,
  required final bool? isDeveloperModeEnabled,
  required final bool? isDeveloperDiskImageAvailable,
});

class DevicectlApi({
  final String xcrunPath = defaultXcrunPath,
  final ProcessManager processManager = const LocalProcessManager(),
}) {
  final processRunner = DevicectlProcessRunner(
    xcrunPath: xcrunPath,
    processManager: processManager,
  );

  Future<void> captureScreenshot({
    required String deviceId,
    required String destination,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final process = await processRunner.run([
      'device',
      'capture',
      'screenshot',
      '--device',
      _normalizedDeviceId(deviceId),
      '--destination',
      destination,
      '--timeout',
      '${timeout.inSeconds}',
      '--quiet',
    ]);

    if (process.exitCode != 0) {
      throw DevicectlCommandException(
        message:
            'Failed to capture a screenshot of $deviceId '
            '(${process.exitCode}): ${_describeOutput(process)}',
      );
    }
  }

  Future<String> readPasteboard({
    required String deviceId,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final process = await processRunner.runRaw([
      'device',
      'pasteboard',
      'paste',
      '--device',
      _normalizedDeviceId(deviceId),
      '--timeout',
      '${timeout.inSeconds}',
      '--quiet',
    ]);

    if (process.exitCode != 0) {
      throw DevicectlCommandException(
        message:
            'Failed to read the pasteboard of $deviceId '
            '(${process.exitCode}): ${_describeOutput(process)}',
      );
    }

    return utf8.decode(
      process.stdout as List<int>,
      allowMalformed: true,
    );
  }

  Future<void> writePasteboard({
    required String deviceId,
    required String text,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final process = await processRunner.runWithStdin([
      'device',
      'pasteboard',
      'copy',
      '--device',
      _normalizedDeviceId(deviceId),
      '--timeout',
      '${timeout.inSeconds}',
      '--quiet',
    ], utf8.encode(text));

    if (process.exitCode != 0) {
      throw DevicectlCommandException(
        message:
            'Failed to write the pasteboard of $deviceId '
            '(${process.exitCode}): ${_describeOutput(process)}',
      );
    }
  }

  Future<DevicectlDeviceStatus?> deviceStatus({
    required String deviceId,
  }) async {
    final process = await processRunner.run([
      'list',
      'devices',
      '--json-output',
      '-',
      '--quiet',
    ]);

    if (process.exitCode != 0) {
      throw DevicectlCommandException(
        message:
            'Failed to list the devices '
            '(${process.exitCode}): ${_describeOutput(process)}',
      );
    }

    final json = jsonDecode(process.stdout as String) as Map<String, Object?>;
    final result = json['result'] as Map<String, Object?>? ?? const {};
    final devices = result['devices'] as List<Object?>? ?? const [];
    final wanted = _comparableUdid(deviceId);

    for (final device in devices.cast<Map<String, Object?>>()) {
      final hardware = device['hardwareProperties'] as Map<String, Object?>?;
      final udid = hardware?['udid'] as String?;
      if (udid == null || _comparableUdid(udid) != wanted) continue;

      final connection =
          device['connectionProperties'] as Map<String, Object?>?;
      final properties = device['deviceProperties'] as Map<String, Object?>?;
      final developerMode = properties?['developerModeStatus'] as String?;
      final ddiServices = properties?['ddiServicesAvailable'] as bool?;

      return DevicectlDeviceStatus(
        isPaired: connection?['pairingState'] == 'paired',
        isDeveloperModeEnabled: developerMode == null
            ? null
            : developerMode == 'enabled',
        isDeveloperDiskImageAvailable: ddiServices,
      );
    }

    return null;
  }
}

String _comparableUdid(String udid) {
  return udid.replaceAll('-', '').toLowerCase();
}

final _compactUdidPattern = RegExp(r'^[0-9A-Fa-f]{24}$');

/// `devicectl` rejects a device identifier that doesn't match CoreDevice's
/// UDID formatting — `XXXXXXXX-XXXXXXXXXXXXXXXX` for modern (A12+) devices.
///
/// IOKit, which is how synk discovers plugged-in iPhones over USB, reports
/// that same UDID without the dash. Passing it straight through makes every
/// `devicectl` call fail with "device not found", so it's reinserted here —
/// the one place every `devicectl` invocation funnels through — rather than
/// in each caller.
String _normalizedDeviceId(String deviceId) {
  if (!_compactUdidPattern.hasMatch(deviceId)) {
    return deviceId;
  }

  return '${deviceId.substring(0, 8)}-${deviceId.substring(8)}';
}

String _describeOutput(ProcessResult process) {
  final output = [process.stdout, process.stderr]
      .whereType<String>()
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .join('\n');

  return output.isEmpty ? 'no output' : output;
}
