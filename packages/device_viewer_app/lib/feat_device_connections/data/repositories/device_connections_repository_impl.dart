import 'dart:async';
import 'dart:io';

import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_agent/application/device_agent_client.dart';
import 'package:device_viewer/feat_device_connections/application/connected_adb_device.dart';
import 'package:device_viewer/feat_device_connections/application/dex_file_provider.dart';
import 'package:device_viewer/feat_device_connections/application/free_port_provider.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:rxdart/rxdart.dart';

class DeviceConnectionsRepositoryImpl({
  required final AdbApi api,
}) implements DeviceConnectionsRepository {
  final dexFilepathProvider = getDexFilepathProvider();
  final sessions = <AndroidDeviceId, _AdbAgentSession>{};
  final connectedIds = BehaviorSubject.seeded(<AndroidDeviceId>{});

  @override
  Future<void> dispose() async {
    for (final session in sessions.values) {
      await session.dispose();
    }

    sessions.clear();
    await connectedIds.close();
  }

  @override
  Future<void> toggleConnection(AndroidDevice device) async {
    if (await isConnected(device.id)) {
      await disconnect(device);
    } else {
      await connect(device);
    }
  }

  @override
  Future<bool> isConnected(AndroidDeviceId id) async {
    return sessions.containsKey(id);
  }

  @override
  Stream<Set<AndroidDeviceId>> observeConnectedDeviceIds() {
    return connectedIds.stream;
  }

  @override
  ConnectedAdbDevice? getConnectedAdbDevice(AndroidDeviceId id) {
    return sessions[id]?.connectedDevice;
  }

  Future<void> connect(AndroidDevice device) async {
    final connection = api.connect(device.id);
    final dexFilepath = await dexFilepathProvider();

    await connection.pushFile(
      localFilepath: dexFilepath,
      remoteFilepath: '/data/local/tmp/device_agent.dex',
    );

    final agentProcess = await connection.startShell([
      'CLASSPATH=/data/local/tmp/device_agent.dex',
      'app_process',
      '/system/bin',
      'de.deviceviewer.MainKt',
    ]);

    // stdout and stderr are blocking the stream from closing
    // until they've been read at least once. We don't do this
    // but want them to close anyways.
    agentProcess.stdout.drain();
    agentProcess.stderr.drain();

    await Future.delayed(const .new(seconds: 1));

    // A fixed local port only works for a single device: two connected
    // devices would both need to forward to the same host-side port, and
    // the second `adb forward` would silently steal it from the first.
    final localControlPort = await reserveFreeLocalPort();
    final portForward = await connection.forward(
      localPort: localControlPort,
      remotePort: 27183,
    );

    final socket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      portForward.localPort,
    );

    final agent = DeviceAgentClient(socket: socket);

    sessions.putIfAbsent(device.id, () {
      return _AdbAgentSession(
        agentProcess: agentProcess,
        portForward: portForward,
        agent: agent,
        connectedDevice: ConnectedAdbDevice(agent: agent, connection: connection),
      );
    });

    connectedIds.add(sessions.keys.toSet());
  }

  Future<void> disconnect(AndroidDevice device) async {
    final session = sessions.remove(device.id);
    await session?.dispose();
    connectedIds.add(sessions.keys.toSet());
  }
}

class const _AdbAgentSession({
  required final Process agentProcess,
  required final AdbPortForward portForward,
  required final DeviceAgentClient agent,
  required final ConnectedAdbDevice connectedDevice,
}) {
  Future<void> dispose() async {
    await connectedDevice.stopScreenMirror();
    await agent.dispose();
    await portForward.dispose();
    agentProcess.kill();
  }
}
