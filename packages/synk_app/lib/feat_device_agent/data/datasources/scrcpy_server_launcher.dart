import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:synk/feat_device_connections/application/scrcpy/scrcpy_constants.dart';
import 'package:synk/feat_device_connections/application/scrcpy/scrcpy_server_file_provider.dart';

class const ScrcpyVideoStreamException({required final String message})
    implements Exception {
  @override
  String toString() => 'ScrcpyVideoStreamException: $message';
}

class const ScrcpyServerConnection({
  required final Process process,
  required final AdbPortForward portForward,
  required final Socket videoSocket,
  required final Stream<Uint8List> videoStream,
  required final Socket audioSocket,
  required final Socket controlSocket,
}) {
  Future<void> dispose() async {
    await controlSocket.close();
    await audioSocket.close();
    await videoSocket.close();
    await portForward.dispose();
    process.kill();
  }
}

class ScrcpyServerLauncher {
  static final _serverFilepathProvider = getScrcpyServerFilepathProvider();
  static final _random = Random();

  static Future<ScrcpyServerConnection> launch(
    AdbDeviceCommunicator communicator, {
    Duration connectTimeout = const Duration(seconds: 30),
    Duration firstVideoByteTimeout = const Duration(seconds: 30),
  }) async {
    await communicator.pushFile(
      localFilepath: await _serverFilepathProvider(),
      remoteFilepath: scrcpyServerRemotePath,
    );

    final scid = _random.nextInt(0x7fffffff).toRadixString(16).padLeft(8, '0');

    final process = await communicator.startShell(_serverArguments(scid));

    // stdout and stderr keep the process' streams from closing until they
    // have been read at least once. We have no use for either.
    unawaited(process.stdout.drain());
    unawaited(process.stderr.drain());

    try {
      return await _connect(
        communicator,
        process: process,
        socketName: '${scrcpySocketNamePrefix}_$scid',
        connectTimeout: connectTimeout,
        firstVideoByteTimeout: firstVideoByteTimeout,
      );
    } catch (_) {
      process.kill();
      rethrow;
    }
  }

  static List<String> _serverArguments(String scid) => [
    'CLASSPATH=$scrcpyServerRemotePath',
    'app_process',
    '/',
    scrcpyServerMainClass,
    scrcpyServerVersion,
    'scid=$scid',
    'audio=true',
    'audio_codec=raw',
    'control=true',
    'video=true',
    'video_codec=h264',
    'video_bit_rate=8000000',
    'max_fps=60',
    'tunnel_forward=true',
    'raw_stream=true',
    'send_dummy_byte=true',
    'send_codec_meta=false',
    'cleanup=true',
  ];

  static Future<ScrcpyServerConnection> _connect(
    AdbDeviceCommunicator communicator, {
    required Process process,
    required String socketName,
    required Duration connectTimeout,
    required Duration firstVideoByteTimeout,
  }) async {
    final portForward = await communicator.forwardAbstract(
      remoteSocketName: socketName,
    );

    _VideoChannel? video;
    Socket? audioSocket;
    Socket? controlSocket;

    try {
      video = await _VideoChannel.connect(portForward, timeout: connectTimeout);
      audioSocket = await portForward.connect();
      controlSocket = await portForward.connect();

      await video.firstVideoByte.timeout(firstVideoByteTimeout);

      return ScrcpyServerConnection(
        process: process,
        portForward: portForward,
        videoSocket: video.socket,
        videoStream: video.stream,
        audioSocket: audioSocket,
        controlSocket: controlSocket,
      );
    } catch (_) {
      await controlSocket?.close();
      audioSocket?.destroy();
      video?.socket.destroy();
      await portForward.dispose();
      rethrow;
    }
  }
}

class const _ForwardNotReadyException() implements Exception {
  @override
  String toString() => 'adb forward is not connected to the device (yet).';
}

class const _VideoChannel({
  required final Socket socket,
  required final Stream<Uint8List> stream,
  required final Future<void> firstVideoByte,
}) {
  static Future<_VideoChannel> connect(
    AdbPortForward portForward, {
    required Duration timeout,
    Duration retryDelay = const Duration(milliseconds: 50),
  }) async {
    final deadline = DateTime.now().add(timeout);

    while (true) {
      final socket = await portForward.connect();

      final controller = StreamController<Uint8List>();
      final handshake = Completer<void>();
      final firstVideoByte = Completer<void>();

      void failFirstVideoByte(String reason) {
        if (firstVideoByte.isCompleted) return;

        firstVideoByte.completeError(
          ScrcpyVideoStreamException(message: reason),
        );
      }

      final subscription = socket.listen(
        (chunk) {
          if (!handshake.isCompleted) {
            handshake.complete();
            chunk = Uint8List.sublistView(chunk, 1);
            if (chunk.isEmpty) return;
          }

          if (!firstVideoByte.isCompleted) firstVideoByte.complete();
          controller.add(chunk);
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!handshake.isCompleted) {
            handshake.completeError(error, stackTrace);
            return;
          }

          failFirstVideoByte('Video socket failed: $error');
          controller.addError(error, stackTrace);
        },
        onDone: () {
          if (!handshake.isCompleted) {
            handshake.completeError(const _ForwardNotReadyException());
            return;
          }

          failFirstVideoByte('Video socket closed before any video arrived.');
          controller.close();
        },
        cancelOnError: false,
      );
      controller.onCancel = subscription.cancel;

      try {
        await handshake.future;

        return _VideoChannel(
          socket: socket,
          stream: controller.stream,
          firstVideoByte: firstVideoByte.future,
        );
      } on _ForwardNotReadyException {
        await subscription.cancel();
        socket.destroy();
        unawaited(controller.close());

        if (DateTime.now().isAfter(deadline)) rethrow;
        await Future.delayed(retryDelay);
      }
    }
  }
}
