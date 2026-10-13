import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_adb/api_adb.dart';
import 'package:synk/feat_device_platform_android/device_agent/android_device_agent_client.dart';
import 'package:synk/feat_device_platform_android/device_agent/dex_file_provider.dart';

class const DeviceAgentStartupException({required final String message})
    implements Exception {
  @override
  String toString() => 'DeviceAgentStartupException: $message';
}

class const DeviceAgentLauncher._() {
  static final _dexFilepathProvider = getDexFilepathProvider();
  static const mainClass = 'de.synk.MainKt';
  static const _remoteDexPath = '/data/local/tmp/device_agent.dex';
  static const _devicePort = 27183;
  static const _listeningMarker = 'Agent listening on port';

  static Future<AndroidDeviceAgentCommunicator> launch(
    AdbDeviceCommunicator communicator, {
    Duration startupTimeout = const Duration(seconds: 30),
  }) async {
    await communicator.pushFile(
      localFilepath: await _dexFilepathProvider(),
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
