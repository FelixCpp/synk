import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_agent/application/android_device_agent.dart';
import 'package:device_viewer/feat_device_agent/application/android_device_agent_client.dart';
import 'package:device_viewer/feat_device_agent/application/android_interaction_transmission.dart';
import 'package:device_viewer/feat_device_agent/application/android_screen_transmission.dart';
import 'package:device_viewer/feat_device_agent/data/datasources/device_agent_launcher.dart';
import 'package:device_viewer/feat_device_agent/data/datasources/scrcpy_server_launcher.dart';
import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:device_viewer/feat_device_canvas/data/datasources/screen_mirror_texture_datasource.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_connections/application/scrcpy/scrcpy_constants.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

class AndroidDeviceAgentRepositoryImpl(final AdbApi api)
    implements DeviceAgentRepository {
  final nativeTextureAdapter = ScreenMirrorTextureDatasource();
  final runningAgents = <DeviceId, AndroidDeviceAgent>{};

  @override
  Future<void> dispose() async {
    for (final agent in runningAgents.values) {
      await agent.dispose();
    }

    runningAgents.clear();
  }

  @override
  Future<AndroidDeviceAgent> establishConnection(DeviceId deviceId) async {
    if (runningAgents.containsKey(deviceId)) {
      throw DeviceAgentAlreadyConnectedException(deviceId: deviceId);
    }

    final communicator = api.connect(deviceId);
    await _killStaleProcesses(communicator);

    AndroidDeviceAgentCommunicator? agentCommunicator;
    ScrcpyServerConnection? scrcpyServer;
    NativeTexture? texture;

    try {
      await Future.wait([
        DeviceAgentLauncher.launch(communicator).then(
          (value) => agentCommunicator = value,
        ),
        ScrcpyServerLauncher.launch(communicator).then(
          (value) => scrcpyServer = value,
        ),
      ]);

      final scrcpy = scrcpyServer!;
      final screenSize = await _fetchScreenSize(communicator);
      texture = await NativeTexture.create(nativeTextureAdapter);

      final agent = AndroidDeviceAgent(
        agentCommunicator!,
        AndroidScreenTransmission(
          socket: scrcpy.videoSocket,
          byteStream: scrcpy.videoStream,
          process: scrcpy.process,
          portForward: scrcpy.portForward,
          texture: texture,
        ),
        AndroidInteractionTransmission(
          socket: scrcpy.controlSocket,
          screenSize: screenSize,
        ),
      );

      runningAgents[deviceId] = agent;
      return agent;
    } catch (error, stackTrace) {
      developer.log(
        'Failed to establish a connection to device $deviceId',
        name: 'AndroidDeviceAgentRepositoryImpl',
        error: error,
        stackTrace: stackTrace,
      );

      await agentCommunicator?.dispose();
      await scrcpyServer?.dispose();
      await texture?.dispose();
      rethrow;
    }
  }

  @override
  Future<void> cutConnection(DeviceId deviceId) async {
    final connection = runningAgents.remove(deviceId);
    if (connection == null) {
      throw DeviceAgentNotConnectedException(deviceId: deviceId);
    }

    await connection.dispose();
  }

  Future<void> _killStaleProcesses(AdbDeviceCommunicator communicator) {
    return Future.wait([
      communicator.shell(['pkill', '-f', scrcpyServerMainClass]),
      communicator.shell(['pkill', '-f', DeviceAgentLauncher.mainClass]),
    ]);
  }

  Future<DeviceScreenSize> _fetchScreenSize(
    AdbDeviceCommunicator communicator,
  ) async {
    final result = await communicator.shell(const ['wm', 'size']);
    final output = utf8.decode(result.stdout, allowMalformed: true);

    final match =
        RegExp(r'Override size:\s*(\d+)x(\d+)').firstMatch(output) ??
        RegExp(r'Physical size:\s*(\d+)x(\d+)').firstMatch(output);

    if (match == null) {
      throw Exception('Could not parse "wm size": $output');
    }

    return .new(
      width: int.parse(match.group(1)!),
      height: int.parse(match.group(2)!),
    );
  }
}
