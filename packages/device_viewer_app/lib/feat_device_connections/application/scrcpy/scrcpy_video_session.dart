import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_connections/application/free_port_provider.dart';
import 'package:device_viewer/feat_device_connections/application/scrcpy/scrcpy_constants.dart';

final _random = Random();

class ScrcpyVideoSession({
  required final AdbDeviceConnection connection,
  required final Future<String> Function() serverFilepathProvider,
}) {
  Process? _serverProcess;
  AdbPortForward? _portForward;
  Socket? _socket;

  Future<Stream<Uint8List>> start() async {
    await stop();

    // TODO(Felix): Get size of video
    // final size = await connection.shell([('wm', 'size']);

    final jarFilepath = await serverFilepathProvider();
    await connection.pushFile(
      localFilepath: jarFilepath,
      remoteFilepath: scrcpyServerRemotePath,
    );

    final scid = _random.nextInt(0x7fffffff);
    final scidHex = scid.toRadixString(16).padLeft(8, '0');
    final socketName = '${scrcpySocketNamePrefix}_$scidHex';

    final process = await connection.startShell([
      'CLASSPATH=$scrcpyServerRemotePath',
      'app_process',
      '/',
      'com.genymobile.scrcpy.Server',
      scrcpyServerVersion,
      'scid=$scidHex',
      'audio=false',
      'control=true',
      'video=true',
      'video_codec=h264',
      'video_bit_rate=8000000',
      'max_fps=60',
      'tunnel_forward=true',
      'raw_stream=true',
      'cleanup=true',
    ]);

    unawaited(process.stdout.drain());
    unawaited(process.stderr.drain());
    _serverProcess = process;

    final result = await _connectAndVerify(socketName);
    _portForward = result.forward;
    _socket = result.socket;

    return result.stream;
  }

  Future<_ScrcpyConnection> _connectAndVerify(
    String socketName, {
    int attempts = 5,
    Duration firstByteTimeout = const Duration(seconds: 3),
  }) async {
    for (var attempt = 1; ; attempt++) {
      final localPort = await reserveFreeLocalPort();
      final forward = await connection.forwardAbstract(
        localPort: localPort,
        remoteSocketName: socketName,
      );

      try {
        final socket = await Socket.connect(
          InternetAddress.loopbackIPv4,
          forward.localPort,
        );

        final controller = StreamController<Uint8List>();
        final firstByte = Completer<void>();
        final subscription = socket.listen(
          (chunk) {
            if (!firstByte.isCompleted) firstByte.complete();
            controller.add(chunk);
          },
          onError: controller.addError,
          onDone: controller.close,
          cancelOnError: false,
        );
        controller.onCancel = subscription.cancel;

        await firstByte.future.timeout(firstByteTimeout);

        return _ScrcpyConnection(
          forward: forward,
          socket: socket,
          stream: controller.stream,
        );
      } catch (e) {
        await forward.dispose();
        if (attempt >= attempts) rethrow;
      }
    }
  }

  Future<void> stop() async {
    await _socket?.close();
    await _portForward?.dispose();
    _serverProcess?.kill();

    _socket = null;
    _portForward = null;
    _serverProcess = null;
  }
}

class const _ScrcpyConnection({
  required final AdbPortForward forward,
  required final Socket socket,
  required final Stream<Uint8List> stream,
});
