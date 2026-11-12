import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:api_adb/adb/devices/adb_device_state_dto.dart';
import 'package:api_adb/api_adb.dart';
import 'package:file/file.dart';

const _unknownDeviceName = 'Unbekanntes Gerät';

class AndroidDeviceNames(
  final AdbApi api, {
  required final FileSystem fileSystem,
  required final Map<String, String> environment,
}) {
  final _resolved = <String, String>{};

  Future<Map<String, String>> namesOf(List<AdbDeviceDto> devices) async {
    _resolved.removeWhere(
      (serial, _) => !devices.any(
        (device) =>
            device.serialNumber == serial &&
            device.state == AdbDeviceStateDto.device,
      ),
    );

    final names = await Future.wait(devices.map(_nameOf));

    return {
      for (final (index, device) in devices.indexed)
        device.serialNumber: names[index],
    };
  }

  Future<String> _nameOf(AdbDeviceDto device) async {
    if (device.state != AdbDeviceStateDto.device) {
      return _fallbackName(device);
    }

    if (_resolved[device.serialNumber] case final name?) {
      return name;
    }

    try {
      final properties = await _readProperties(
        device.serialNumber,
      ).timeout(const Duration(seconds: 3));
      final name = await _nameFrom(properties) ?? _fallbackName(device);

      return _resolved[device.serialNumber] = name;
    } on Exception catch (error, stackTrace) {
      developer.log(
        'Failed to resolve the name of ${device.serialNumber}',
        name: 'AndroidDeviceNames',
        error: error,
        stackTrace: stackTrace,
      );

      return _fallbackName(device);
    }
  }

  Future<Map<String, String>> _readProperties(String serialNumber) async {
    final result = await api.connect(serialNumber).shell(const ['getprop']);
    if (result.exitCode != 0) {
      throw AdbCommandException(
        message:
            'getprop failed (${result.exitCode}): '
            '${utf8.decode(result.stderr, allowMalformed: true).trim()}',
      );
    }

    final output = utf8.decode(result.stdout, allowMalformed: true);

    return {
      for (final match in RegExp(
        r'^\[([^\]]+)\]: \[(.*)\]\s*$',
        multiLine: true,
      ).allMatches(output))
        match.group(1)!: match.group(2)!,
    };
  }

  Future<String?> _nameFrom(Map<String, String> properties) async {
    final avdId = _nonEmpty(
      properties['ro.boot.qemu.avd_name'] ??
          properties['ro.kernel.qemu.avd_name'],
    );
    if (avdId != null) {
      return await _avdDisplayName(avdId) ?? avdId.replaceAll('_', ' ');
    }

    final model = _nonEmpty(properties['ro.product.model']);
    if (model == null) {
      return null;
    }

    final manufacturer = _nonEmpty(properties['ro.product.manufacturer']);
    if (manufacturer == null ||
        model.toLowerCase().startsWith(manufacturer.toLowerCase())) {
      return model;
    }

    return '${_capitalized(manufacturer)} $model';
  }

  Future<String?> _avdDisplayName(String avdId) async {
    final avdHome = _avdHome();
    if (avdHome == null) {
      return null;
    }

    try {
      final pointer = await _readIni(
        fileSystem.path.join(avdHome, '$avdId.ini'),
      );
      final avdDirectory =
          _nonEmpty(pointer?['path']) ??
          fileSystem.path.join(avdHome, '$avdId.avd');
      final config = await _readIni(
        fileSystem.path.join(avdDirectory, 'config.ini'),
      );

      return _nonEmpty(config?['avd.ini.displayname']);
    } on FileSystemException {
      return null;
    }
  }

  String? _avdHome() {
    if (_nonEmpty(environment['ANDROID_AVD_HOME']) case final avdHome?) {
      return avdHome;
    }
    if (_nonEmpty(environment['ANDROID_USER_HOME']) case final userHome?) {
      return fileSystem.path.join(userHome, 'avd');
    }
    if (_nonEmpty(environment['ANDROID_SDK_HOME']) case final sdkHome?) {
      return fileSystem.path.join(sdkHome, '.android', 'avd');
    }
    if (_nonEmpty(environment['HOME']) case final home?) {
      return fileSystem.path.join(home, '.android', 'avd');
    }

    return null;
  }

  Future<Map<String, String>?> _readIni(String path) async {
    final file = fileSystem.file(path);
    if (!await file.exists()) {
      return null;
    }

    final lines = await file.readAsLines();

    return {
      for (final line in lines)
        if (line.indexOf('=') case final separator when separator > 0)
          line.substring(0, separator).trim(): line
              .substring(separator + 1)
              .trim(),
    };
  }
}

String _fallbackName(AdbDeviceDto device) {
  return _nonEmpty(device.model?.replaceAll('_', ' ')) ?? _unknownDeviceName;
}

String? _nonEmpty(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

String _capitalized(String value) {
  return value[0].toUpperCase() + value.substring(1);
}
