import 'dart:convert';
import 'dart:io';

import 'package:api_devicectl/devicectl/process/devicectl_process_runner.dart';

class const DevicectlCommandException({required final String message})
    implements Exception {
  @override
  String toString() => 'DevicectlCommandException: $message';
}

class DevicectlApi({final String xcrunPath = defaultXcrunPath}) {
  final processRunner = DevicectlProcessRunner(xcrunPath: xcrunPath);

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
      deviceId,
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
      deviceId,
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
      deviceId,
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
}

String _describeOutput(ProcessResult process) {
  final output = [process.stdout, process.stderr]
      .whereType<String>()
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .join('\n');

  return output.isEmpty ? 'no output' : output;
}
