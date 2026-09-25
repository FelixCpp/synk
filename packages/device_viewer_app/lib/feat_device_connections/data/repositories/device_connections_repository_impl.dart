import 'dart:async';
import 'dart:io';

import 'package:api_adb/adb/application/adb_device_connection.dart';
import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_agent/application/device_agent_client.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:rxdart/rxdart.dart';

class const AdbAgentSession({
  required final Process agentProcess,
  required final AdbPortForward portForward,
  required final DeviceAgentClient agent,
}) {
  Future<void> dispose() async {
    await agent.dispose();
    await portForward.dispose();
    agentProcess.kill();
  }
}

class DeviceConnectionsRepositoryImpl({
  required final AdbApi api,
}) implements DeviceConnectionsRepository {
  final sessions = <AndroidDeviceId, AdbAgentSession>{};
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

  Future<void> connect(AndroidDevice device) async {
    final connection = api.connect(device.id);

    await connection.pushFile(
      localFilepath: 'assets/bundled_files/classes.dex',
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
    final portForward = await connection.forward(
      localPort: 27183,
      remotePort: 27183,
    );

    final socket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      portForward.localPort,
    );

    sessions.putIfAbsent(device.id, () {
      return AdbAgentSession(
        agentProcess: agentProcess,
        portForward: portForward,
        agent: DeviceAgentClient(socket: socket),
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
