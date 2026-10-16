import 'dart:ffi';

import 'package:file/file.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';
import 'package:synk/feat_tool_validation/domain/repositories/tool_validation_repository.dart';

class ToolValidationRepositoryImpl({
  required final String adbPath,
  final String xcrunPath = '/usr/bin/xcrun',
  final String coreDevicePath =
      '/Library/Developer/PrivateFrameworks/CoreDevice.framework',
  final Abi? abi,
  required final FileSystem fileSystem,
  required final ProcessManager processManager,
  required final NativePlatform platform,
}) implements ToolValidationRepository {
  static const _minimumCoreDeviceMacOSVersion = 14;

  @override
  Future<List<ToolIssue>> validateTools() async {
    final results = await Future.wait([
      _checkAdb(),
      if (platform.isMacOS) _checkDevicectl(),
      if (platform.isMacOS) Future.value(_checkCoreDevice()),
    ]);

    return [for (final issue in results) ?issue];
  }

  Future<ToolIssue?> _checkAdb() async {
    if (!fileSystem.file(adbPath).existsSync()) {
      return ToolIssue(
        tool: .adb,
        problem: .notFound,
        detail: adbPath,
      );
    }

    final failure = await _tryRun(adbPath, const ['version']);
    if (failure == null) return null;

    return ToolIssue(tool: .adb, problem: .notRunnable, detail: failure);
  }

  Future<ToolIssue?> _checkDevicectl() async {
    final failure = await _tryRun(
      xcrunPath,
      const ['devicectl', '--version'],
    );

    if (failure == null) {
      return null;
    }

    return ToolIssue(tool: .devicectl, problem: .notRunnable, detail: failure);
  }

  ToolIssue? _checkCoreDevice() {
    final runningAbi = abi ?? Abi.current();
    if (runningAbi != Abi.macosArm64) {
      return ToolIssue(
        tool: .coreDevice,
        problem: .unsupportedMac,
        detail: '$runningAbi',
      );
    }

    final macOSVersion = _macOSMajorVersion();
    if (macOSVersion != null && macOSVersion < _minimumCoreDeviceMacOSVersion) {
      return ToolIssue(
        tool: .coreDevice,
        problem: .unsupportedMac,
        detail: platform.operatingSystemVersion,
      );
    }

    if (!fileSystem.directory(coreDevicePath).existsSync()) {
      return ToolIssue(
        tool: .coreDevice,
        problem: .notFound,
        detail: coreDevicePath,
      );
    }

    return null;
  }

  int? _macOSMajorVersion() {
    final match = RegExp(r'(\d+)\.')
        .firstMatch(platform.operatingSystemVersion);
    return match == null ? null : int.parse(match.group(1)!);
  }

  Future<String?> _tryRun(String executable, List<String> arguments) async {
    try {
      final result = await processManager
          .run([executable, ...arguments])
          .timeout(
            const Duration(seconds: 10),
          );

      if (result.exitCode == 0) {
        return null;
      }

      final output = '${result.stderr}'.trim();
      if (output.isEmpty) {
        return 'exit code ${result.exitCode}';
      }

      return 'exit code ${result.exitCode}: $output';
    } on Object catch (error) {
      return '$error';
    }
  }
}
