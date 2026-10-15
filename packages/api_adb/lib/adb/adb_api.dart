import 'package:api_adb/adb/devices/adb_device_dto.dart';
import 'package:api_adb/adb/devices/adb_frame_reader.dart';
import 'package:api_adb/adb/devices/device_conversions.dart';
import 'package:api_adb/adb/pairing/adb_pair_result.dart';
import 'package:api_adb/adb/process/adb_device_communicator.dart';
import 'package:api_adb/adb/process/adb_process_runner.dart';
import 'package:api_adb/adb/proto/generated/lib/adb/proto/devices.pb.dart';
import 'package:api_adb/adb/version/adb_version_dto.dart';
import 'package:api_adb/adb/version/adb_version_parser.dart';
import 'package:process/process.dart';

class AdbApi({
  required final String adbPath,
  final ProcessManager processManager = const LocalProcessManager(),
}) {
  final processRunner = AdbProcessRunner(
    adbPath: adbPath,
    processManager: processManager,
  );

  Future<AdbVersionDto> fetchVersion() async {
    final process = await processRunner.run(const ['version']);
    if (process.exitCode != 0) {
      throw Exception(
        'Failed to run adb process command (${process.exitCode}): ${process.stderr}',
      );
    }

    final processOutput = process.stdout.toString();
    return parseAdbVersionDto(processOutput);
  }

  Stream<List<AdbDeviceDto>> observeDevices() async* {
    final process = await processRunner.start(const [
      'track-devices',
      '--proto-binary',
    ]);

    final reader = AdbFrameReader(process.stdout);

    try {
      await for (final frame in reader.frames()) {
        final devices = Devices.fromBuffer(frame);
        yield devices.device.map((device) => device.toDto()).toList();
      }
    } finally {
      process.kill();
    }
  }

  Future<AdbPairResult> pair({
    required String hostPort,
    required String pairingCode,
  }) async {
    final process = await processRunner.run(['pair', hostPort, pairingCode]);
    final output = '${process.stdout}${process.stderr}';

    return AdbPairResult(
      success: process.exitCode == 0 && output.contains('Successfully paired'),
      message: output.trim(),
    );
  }

  Future<void> connectWirelessly(String hostPort) async {
    final process = await processRunner.run(['connect', hostPort]);
    final output = process.stdout.toString();

    if (process.exitCode != 0 || output.contains('failed')) {
      throw AdbCommandException(message: output.trim());
    }
  }

  Future<void> disconnectWirelessly(String hostPort) {
    return processRunner.run(['disconnect', hostPort]);
  }

  AdbDeviceCommunicator connect(String serialNumber) {
    return AdbDeviceCommunicator(
      serialNumber: serialNumber,
      processRunner: processRunner,
    );
  }
}
