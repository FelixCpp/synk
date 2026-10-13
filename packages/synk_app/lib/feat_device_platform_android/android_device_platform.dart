import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:api_adb/api_adb.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform_android/discovery/adb_device_dto_conversions.dart';
import 'package:synk/feat_device_platform_android/device_agent/android_device_agent_client.dart';
import 'package:synk/feat_device_platform_android/device_agent/device_agent_launcher.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_server_launcher.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_constants.dart';
import 'package:synk/feat_device_platform_android/device_agent/android_device_info.dart';
import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/application/device_platform.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_session.dart';
import 'package:synk/feat_device_platform_android/android_device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

class AndroidDevicePlatform(final AdbApi api) implements DevicePlatform {
  final Stream<List<PluggedDevice>> _devices;

  this
    : _devices = api.observeDevices().map<List<PluggedDevice>>((dtos) {
        return dtos.map((dto) => dto.toDomain()).toList();
      }).shareValue();

  @override
  Set<ExternalTool> getToolRequirements() {
    return {.adb};
  }

  @override
  Stream<List<PluggedDevice>> observeDevices() {
    return _devices;
  }

  @override
  Future<DeviceAgent> connect(DeviceId deviceId) async {
    final adbCommunicator = api.connect(deviceId);
    await _killStaleProcesses(adbCommunicator);

    AndroidDeviceAgentCommunicator? communicator;
    ScrcpyServerConnection? server;
    ScrcpySession? session;

    try {
      await Future.wait([
        DeviceAgentLauncher.launch(adbCommunicator).then(
          (value) => communicator = value,
        ),
        ScrcpyServerLauncher.launch(adbCommunicator).then(
          (value) => server = value,
        ),
      ]);

      // Doubles as the handshake: a device agent that cannot answer this is
      // not worth mirroring.
      final info = await _fetchInfo(communicator!);
      final screenSize = await _fetchScreenSize(adbCommunicator);
      session = await ScrcpySession.create();

      return AndroidDeviceAgent(
        session: session,
        server: server!,
        communicator: communicator!,
        adbCommunicator: adbCommunicator,
        initialScreenSize: screenSize,
        info: info,
      );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to establish a connection to device $deviceId',
        name: 'AndroidDevicePlatform',
        error: error,
        stackTrace: stackTrace,
      );

      await communicator?.dispose();
      await server?.dispose();
      await session?.dispose();
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {}

  Future<void> _killStaleProcesses(AdbDeviceCommunicator communicator) {
    return Future.wait([
      communicator.shell(['pkill', '-f', scrcpyServerMainClass]),
      communicator.shell(['pkill', '-f', DeviceAgentLauncher.mainClass]),
    ]);
  }

  Future<AndroidDeviceInfo> _fetchInfo(
    AndroidDeviceAgentCommunicator communicator,
  ) async {
    final response = await communicator.fetchInfo();

    return AndroidDeviceInfo(
      model: response.model,
      manufacturer: response.manufacturer,
      androidVersion: response.androidVersion,
      sdkVersion: response.sdkVersion,
    );
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
