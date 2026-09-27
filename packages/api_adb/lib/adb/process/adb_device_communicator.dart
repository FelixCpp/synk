import 'dart:io';
import 'dart:typed_data';

import 'package:api_adb/adb/process/adb_process_runner.dart';

class const AdbCommandException({required final String message})
    implements Exception {
  @override
  String toString() => 'AdbCommandException: $message';
}

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
  Future<Socket> connect() {
    return Socket.connect(InternetAddress.loopbackIPv4, localPort);
  }

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

/// Asks the OS for a port it currently considers free, by binding it and
/// releasing it again.
///
/// Inherently a hint rather than a reservation - nothing stops another
/// process from taking the port in between - but it is the only way to let
/// `adb forward` use an arbitrary free port, as it has no "pick one for me"
/// mode of its own.
Future<int> _reserveFreeLocalPort() async {
  final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = socket.port;
  await socket.close();

  return port;
}

class const AdbDeviceCommunicator({
  required final String serialNumber,
  required final AdbProcessRunner processRunner,
}) {
  Future<AdbShellResult> shell(List<String> arguments) async {
    final process = await processRunner.runRaw([
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
      throw AdbCommandException(message: 'adb push failed: ${process.stderr}');
    }
  }

  /// Forwards a local port to [remotePort] on the device. Without an
  /// explicit [localPort] a free one is picked automatically; either way the
  /// port actually used is on the returned [AdbPortForward].
  Future<AdbPortForward> forward({
    required int remotePort,
    int? localPort,
  }) async {
    localPort ??= await _reserveFreeLocalPort();

    final process = await processRunner.run([
      '-s',
      serialNumber,
      'forward',
      'tcp:$localPort',
      'tcp:$remotePort',
    ]);

    if (process.exitCode != 0) {
      throw AdbCommandException(
        message: 'adb forward failed: ${process.stderr}',
      );
    }

    return AdbPortForward(
      processRunner: processRunner,
      serialNumber: serialNumber,
      localPort: localPort,
      remotePort: remotePort,
    );
  }

  /// Like [forward], but to an abstract Unix domain socket on the device
  /// instead of a TCP port.
  Future<AdbPortForward> forwardAbstract({
    required String remoteSocketName,
    int? localPort,
  }) async {
    localPort ??= await _reserveFreeLocalPort();

    final process = await processRunner.run([
      '-s',
      serialNumber,
      'forward',
      'tcp:$localPort',
      'localabstract:$remoteSocketName',
    ]);

    if (process.exitCode != 0) {
      throw AdbCommandException(
        message: 'adb forward failed: ${process.stderr}',
      );
    }

    return AdbPortForward(
      processRunner: processRunner,
      serialNumber: serialNumber,
      localPort: localPort,
      remoteSocketName: remoteSocketName,
    );
  }
}
