import 'dart:io';
import 'dart:typed_data';

import 'package:api_adb/adb/process/adb_process_runner.dart';

class const AdbShellResult({
  required final int exitCode,
  required final Uint8List stdout,
  required final Uint8List stderr,
});

class const AdbPortForward({
  required final AdbProcessRunner processRunner,
  required final String serialNumber,
  required final int localPort,
  final int? remotePort,
  final String? remoteSocketName,
}) {
  Future<void> dispose() {
    return processRunner.run([
      '-s',
      serialNumber,
      'forward',
      '--remove',
      'tcp:$localPort',
    ]);
  }
}

class const AdbDeviceConnection({
  required final String serialNumber,
  required final AdbProcessRunner processRunner,
}) {
  Future<AdbShellResult> shell(List<String> arguments) async {
    final process = await processRunner.run([
      '-s',
      serialNumber,
      'shell',
      ...arguments,
    ]);

    return AdbShellResult(
      exitCode: process.exitCode,
      stdout: process.stdout,
      stderr: process.stderr,
    );
  }

  Future<Process> startShell(List<String> arguments) {
    return processRunner.start([
      '-s',
      serialNumber,
      'shell',
      ...arguments,
    ]);
  }

  Future<void> pushFile({
    required String localFilepath,
    required String remoteFilepath,
  }) async {
    final process = await processRunner.run([
      '-s',
      serialNumber,
      'push',
      localFilepath,
      remoteFilepath,
    ]);

    if (process.exitCode != 0) {
      // TODO(Felix): AdbException type
      throw Exception('adb push failed: ${process.stderr}');
    }
  }

  Future<AdbPortForward> forward({
    required int localPort,
    required int remotePort,
  }) async {
    final process = await processRunner.run([
      '-s',
      serialNumber,
      'forward',
      'tcp:$localPort',
      'tcp:$remotePort',
    ]);

    if (process.exitCode != 0) {
      // TODO(Felix): AdbException type
      throw Exception('adb forward failed: ${process.stderr}');
    }

    return AdbPortForward(
      processRunner: processRunner,
      serialNumber: serialNumber,
      localPort: localPort,
      remotePort: remotePort,
    );
  }

  Future<AdbPortForward> forwardAbstract({
    required int localPort,
    required String remoteSocketName,
  }) async {
    final process = await processRunner.run([
      '-s',
      serialNumber,
      'forward',
      'tcp:$localPort',
      'localabstract:$remoteSocketName',
    ]);

    if (process.exitCode != 0) {
      // TODO(Felix): AdbException type
      throw Exception('adb forward failed: ${process.stderr}');
    }

    return AdbPortForward(
      processRunner: processRunner,
      serialNumber: serialNumber,
      localPort: localPort,
      remoteSocketName: remoteSocketName,
    );
  }
}
