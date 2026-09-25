import 'package:api_adb/adb/application/adb_device_connection.dart';
import 'package:api_adb/adb/application/adb_process_runner.dart';
import 'package:api_adb/adb/dtos/adb_device_dto.dart';
import 'package:api_adb/adb/dtos/adb_version_dto.dart';
import 'package:api_adb/adb/parsers/adb_version_parser.dart';
import 'package:api_adb/adb/proto/generated/lib/adb/proto/devices.pb.dart';
import 'package:api_adb/adb/readers/adb_frame_reader.dart';

import 'package:api_adb/adb/conversions/device.dart';

class AdbApi({required final String adbPath}) {
  final processRunner = AdbProcessRunner(adbPath: adbPath);

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

  AdbDeviceConnection connect(String serialNumber) {
    return AdbDeviceConnection(
      serialNumber: serialNumber,
      processRunner: processRunner,
    );
  }
}
