import 'dart:io';

import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';
import 'package:synk/feat_tool_validation/domain/repositories/tool_validation_repository.dart';

typedef ToolProbe = Future<ProcessResult> Function(
  String executable,
  List<String> arguments,
);

class ToolValidationRepositoryImpl({
  required final String adbPath,
  final String xcrunPath = '/usr/bin/xcrun',
  final bool checkXcode = true,
  final ToolProbe probe = _runProbe,
  final bool Function(String path) fileExists = _fileExists,
}) implements ToolValidationRepository {
  @override
  Future<List<ToolIssue>> validateTools() async {
    final results = await Future.wait([
      _checkAdb(),
      if (checkXcode) _checkDevicectl(),
    ]);

    return [for (final issue in results) ?issue];
  }

  Future<ToolIssue?> _checkAdb() async {
    if (!fileExists(adbPath)) {
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

  Future<String?> _tryRun(String executable, List<String> arguments) async {
    try {
      final result = await probe(executable, arguments).timeout(
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

Future<ProcessResult> _runProbe(String executable, List<String> arguments) {
  return Process.run(executable, arguments);
}

bool _fileExists(String path) => File(path).existsSync();
