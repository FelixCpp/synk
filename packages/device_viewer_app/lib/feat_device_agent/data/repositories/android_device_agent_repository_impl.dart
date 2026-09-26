import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_agent/application/android_device_agent_client.dart';
import 'package:device_viewer/feat_device_agent/application/android_device_agent.dart';
import 'package:device_viewer/feat_device_agent/application/android_screen_transmission.dart';
import 'package:device_viewer/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:device_viewer/feat_device_canvas/data/datasources/screen_mirror_texture_datasource.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_connections/application/dex_file_provider.dart';
import 'package:device_viewer/feat_device_connections/application/free_port_provider.dart';
import 'package:device_viewer/feat_device_connections/application/scrcpy/scrcpy_server_file_provider.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

class AndroidDeviceAgentRepositoryImpl(final AdbApi api)
    implements DeviceAgentRepository {
  final nativeTextureAdapter = ScreenMirrorTextureDatasource();
  final dexFilepathProvider = getDexFilepathProvider();
  final scrcpyFilepathProvider = getScrcpyServerFilepathProvider();
  final runningAgents = <DeviceId, AndroidDeviceAgent>{};

  @override
  Future<void> dispose() async {
    for (final agent in runningAgents.values) {
      await agent.dispose();
    }

    runningAgents.clear();
  }

  @override
  Future<AndroidDeviceAgent> establishConnection(
    DeviceId deviceId,
  ) async {
    if (runningAgents.containsKey(deviceId)) {
      // TODO(Felix): Own exception type required
      throw Exception('Connection already established to device ($deviceId)');
    }

    final communicator = await openCommunicationPipe(deviceId);
    final screenTransmission = await openScreenTransmission(deviceId);
    final agent = AndroidDeviceAgent(communicator, screenTransmission);

    runningAgents[deviceId] = agent;
    return agent;
  }

  @override
  Future<void> cutConnection(DeviceId deviceId) async {
    final connection = runningAgents.remove(deviceId);
    if (connection == null) {
      // TODO(Felix): Own exception type required
      throw Exception(
        'Tried to close Connection to unconnected device ($deviceId)',
      );
    }

    await connection.dispose();
  }

  Future<AndroidDeviceAgentCommunicator> openCommunicationPipe(
    DeviceId deviceId,
  ) async {
    // Push our communication program to the device

    final deviceCommunicator = api.connect(deviceId);
    final dexFilepath = await dexFilepathProvider();

    await deviceCommunicator.pushFile(
      localFilepath: dexFilepath,
      remoteFilepath: '/data/local/tmp/device_agent.dex',
    );

    final agentProcess = await deviceCommunicator.startShell([
      'CLASSPATH=/data/local/tmp/device_agent.dex',
      'app_process',
      '/system/bin',
      'de.deviceviewer.MainKt',
    ]);

    // stdout and stderr are blocking the stream from closing
    // until they've been read at least once. We don't do this
    // but want them to close anyways.
    unawaited(agentProcess.stdout.drain());
    unawaited(agentProcess.stderr.drain());

    // TODO(Felix): There must be a better way to do this.
    await Future.delayed(const .new(seconds: 1));

    // Open socket where data is transferred

    final localControlPort = await reserveFreeLocalPort();
    final portForward = await deviceCommunicator.forward(
      localPort: localControlPort,
      remotePort: 27183,
    );

    final socket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      portForward.localPort,
    );

    return AndroidDeviceAgentCommunicator(
      socket: socket,
      process: agentProcess,
      portForward: portForward,
    );
  }

  Future<AndroidScreenTransmission> openScreenTransmission(
    DeviceId deviceId,
  ) async {
    final deviceCommunicator = api.connect(deviceId);
    final remoteFilepath = '/data/local/tmp/scrcpy-server.jar';
    final socketNamePrefix = 'scrcpy';
    final serverVersion = '4.1';
    final scrcpyFilepath = await scrcpyFilepathProvider();

    await deviceCommunicator.pushFile(
      localFilepath: scrcpyFilepath,
      remoteFilepath: remoteFilepath,
    );

    final scid = Random().nextInt(0x7fffffff);
    final scidHex = scid.toRadixString(16).padLeft(8, '0');
    final socketName = '${socketNamePrefix}_$scidHex';

    final process = await deviceCommunicator.startShell([
      'CLASSPATH=$remoteFilepath',
      'app_process',
      '/',
      'com.genymobile.scrcpy.Server',
      serverVersion,
      'scid=$scidHex',
      'audio=false',
      'control=false',
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

    final connection = await _connectToScrcpyServer(
      deviceCommunicator,
      socketName,
    );
    final nativeTexture = await NativeTexture.create(nativeTextureAdapter);

    return AndroidScreenTransmission(
      socket: connection.socket,
      byteStream: connection.stream,
      process: process,
      portForward: connection.portForward,
      texture: nativeTexture,
    );
  }

  /// The device only starts listening on [socketName] once its video
  /// encoder is up, which can take a moment after the server process was
  /// launched - connecting immediately regularly races that startup, so we
  /// forward, connect and wait to see a first byte before trusting the pipe,
  /// retrying (with a fresh forward) if that doesn't happen in time.
  Future<({AdbPortForward portForward, Socket socket, Stream<Uint8List> stream})>
  _connectToScrcpyServer(
    AdbDeviceCommunicator deviceCommunicator,
    String socketName, {
    int attempts = 5,
    Duration firstByteTimeout = const Duration(seconds: 3),
  }) async {
    for (var attempt = 1; ; attempt++) {
      final portForward = await deviceCommunicator.forwardAbstract(
        localPort: await reserveFreeLocalPort(),
        remoteSocketName: socketName,
      );

      try {
        final socket = await Socket.connect(
          InternetAddress.loopbackIPv4,
          portForward.localPort,
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

        return (
          portForward: portForward,
          socket: socket,
          stream: controller.stream,
        );
      } catch (e) {
        await portForward.dispose();
        if (attempt >= attempts) rethrow;
      }
    }
  }
}
