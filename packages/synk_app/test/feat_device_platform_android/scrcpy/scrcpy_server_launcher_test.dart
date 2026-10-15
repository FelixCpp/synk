import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:clock/clock.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform_android/bundled_files.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_server_launcher.dart';

import '../../support/fake_adb_device_communicator.dart';
import '../../support/fake_asset_bundle.dart';
import '../../support/fake_process_manager.dart';

void main() {
  ScrcpyServerLauncher launcherWith(Clock clock) {
    return ScrcpyServerLauncher(
      bundledFiles: BundledFiles(
        bundle: FakeAssetBundle({
          'assets/bundled_files/scrcpy-server.jar': [1, 2, 3],
        }),
        fileSystem: MemoryFileSystem(),
        directory: '/cache',
      ),
      clock: clock,
    );
  }

  test('pushes the bundled server and starts it from there', () async {
    final device = FakeAdbDeviceCommunicator(process: FakeProcess());

    await expectLater(
      launcherWith(const Clock()).launch(device),
      throwsA(isA<AdbCommandException>()),
    );

    expect(device.pushes.single, (
      localFilepath: '/cache/scrcpy-server.jar',
      remoteFilepath: scrcpyServerRemotePath,
    ));
    expect(
      device.startedShells.single,
      containsAllInOrder([
        'CLASSPATH=$scrcpyServerRemotePath',
        'app_process',
        '/',
        scrcpyServerMainClass,
        scrcpyServerVersion,
      ]),
    );
  });

  test('stops the server when the port forward fails', () async {
    final process = FakeProcess();
    final device = FakeAdbDeviceCommunicator(process: process);

    await expectLater(
      launcherWith(const Clock()).launch(device),
      throwsA(isA<AdbCommandException>()),
    );

    expect(process.killed, isTrue);
  });

  test('retries a forward that is not ready until the deadline', () async {
    // Every look at the clock is 20 seconds later than the one before, so the
    // 30 second deadline passes on the second retry.
    final start = DateTime(2026, 10, 15, 9, 41);
    var looks = 0;
    final clock = Clock(() => start.add(Duration(seconds: 20 * looks++)));

    final process = FakeProcess();
    final portForward = _NotReadyPortForward();
    final device = FakeAdbDeviceCommunicator(
      process: process,
      portForward: portForward,
    );

    await expectLater(
      launcherWith(clock).launch(
        device,
        connectTimeout: const Duration(seconds: 30),
      ),
      throwsA(isA<Exception>()),
    );

    expect(portForward.connects, 2);
    expect(portForward.isDisposed, isTrue);
    expect(process.killed, isTrue);
  });
}

/// A forward whose device side is not listening yet: adb accepts the
/// connection and closes it straight away.
class _NotReadyPortForward implements AdbPortForward {
  var connects = 0;
  var isDisposed = false;

  @override
  Future<Socket> connect() async {
    connects++;
    return _ClosedSocket();
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ClosedSocket implements Socket {
  @override
  StreamSubscription<Uint8List> listen(
    void Function(Uint8List event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return const Stream<Uint8List>.empty().listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  void destroy() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
