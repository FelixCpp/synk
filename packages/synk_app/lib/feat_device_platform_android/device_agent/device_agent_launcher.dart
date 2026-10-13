import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_adb/api_adb.dart';
import 'package:synk/feat_device_platform_android/device_agent/android_device_agent_client.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class const DeviceAgentStartupException({required final String message})
    implements Exception {
  @override
  String toString() => 'DeviceAgentStartupException: $message';
}

class const DeviceAgentLauncher._() {
  static final _dexFilepath = _dexFilepathProvider();
  static const mainClass = 'de.synk.MainKt';
  static const _remoteDexPath = '/data/local/tmp/device_agent.dex';
  static const _devicePort = 27183;
  static const _listeningMarker = 'Agent listening on port';

  static Future<AndroidDeviceAgentCommunicator> launch(
    AdbDeviceCommunicator communicator, {
    Duration startupTimeout = const Duration(seconds: 30),
  }) async {
    await communicator.pushFile(
      localFilepath: await _dexFilepath(),
      remoteFilepath: _remoteDexPath,
    );

    final process = await communicator.startShell([
      'CLASSPATH=$_remoteDexPath',
      'app_process',
      '/system/bin',
      mainClass,
    ]);

    try {
      await _awaitListening(process).timeout(
        startupTimeout,
        onTimeout: () => throw DeviceAgentStartupException(
          message:
              'Agent did not start listening within '
              '${startupTimeout.inSeconds}s.',
        ),
      );

      final portForward = await communicator.forward(remotePort: _devicePort);

      try {
        return AndroidDeviceAgentCommunicator(
          socket: await portForward.connect(),
          process: process,
          portForward: portForward,
        );
      } catch (_) {
        await portForward.dispose();
        rethrow;
      }
    } catch (_) {
      process.kill();
      rethrow;
    }
  }

  static Future<void> _awaitListening(Process process) {
    final listening = Completer<void>();

    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) {
            if (!listening.isCompleted && line.contains(_listeningMarker)) {
              listening.complete();
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!listening.isCompleted) {
              listening.completeError(error, stackTrace);
            }
          },
          onDone: () {
            if (!listening.isCompleted) {
              listening.completeError(
                const DeviceAgentStartupException(
                  message: 'Agent exited before it started listening.',
                ),
              );
            }
          },
        );

    unawaited(process.stderr.drain());

    return listening.future;
  }
}

Future<String> Function() _dexFilepathProvider() {
  String? dexFilepath;

  return () async {
    if (dexFilepath case String dexPath) {
      return dexPath;
    }

    final dexFile = await rootBundle.load('assets/bundled_files/classes.dex');
    final tempDir = await getTemporaryDirectory();
    final location = path.join(tempDir.path, 'device_agent.dex');
    final file = await File(location).create(recursive: true);

    final bytes = dexFile.buffer.asUint8List(
      dexFile.offsetInBytes,
      dexFile.lengthInBytes,
    );

    await file.writeAsBytes(bytes);

    return dexFilepath = file.path;
  };
}
