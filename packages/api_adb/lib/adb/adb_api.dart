import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:api_adb/adb/dtos/adb_device_dto.dart';
import 'package:api_adb/adb/dtos/adb_version_dto.dart';
import 'package:api_adb/adb/parsers/adb_version_parser.dart';
import 'package:api_adb/adb/proto/generated/lib/adb/proto/devices.pb.dart';
import 'package:api_adb/adb/readers/adb_frame_reader.dart';

import 'package:api_adb/adb/conversions/device.dart';

class const AdbApi({required final String executablePath}) {
  Future<AdbVersionDto> fetchVersion() async {
    final process = await Process.run(
      executablePath,
      const ['version'],
      runInShell: true,
    );

    if (process.exitCode != 0) {
      throw Exception(
        'Failed to run adb process command (${process.exitCode}): ${process.stderr}',
      );
    }

    final processOutput = process.stdout.toString();
    return parseAdbVersionDto(processOutput);
  }

  Stream<List<AdbDeviceDto>> observeDevices() async* {
    final process = await Process.start(
      executablePath,
      const ['track-devices', '--proto-binary'],
      runInShell: true,
    );

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

  Future<Uint8List> captureScreenshot(String serialNumber) async {
    final process = await Process.start(
      executablePath,
      ['-s', serialNumber, 'exec-out', 'screencap', '-p'],
      runInShell: true,
    );

    final bytes = await process.stdout.fold<List<int>>(
      [],
      (buffer, data) {
        buffer.addAll(data);
        return buffer;
      },
    );

    final exitCode = await process.exitCode;

    if (exitCode != 0) {
      final stderr = await process.stderr.transform(utf8.decoder).join();
      throw Exception(
        'Failed to run adb process command ($exitCode): $stderr',
      );
    }

    return Uint8List.fromList(bytes);
  }
}
