import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_tool_validation/data/repositories/tool_validation_repository_impl.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

void main() {
  ProcessResult ok() => ProcessResult(1, 0, '', '');

  test('reports nothing when all tools run', () async {
    final repository = ToolValidationRepositoryImpl(
      adbPath: '/adb',
      probe: (_, _) async => ok(),
      fileExists: (_) => true,
    );

    expect(await repository.validateTools(), isEmpty);
  });

  test('reports a missing adb binary', () async {
    final repository = ToolValidationRepositoryImpl(
      adbPath: '/adb',
      probe: (_, _) async => ok(),
      fileExists: (_) => false,
    );

    final issue = (await repository.validateTools()).single;
    expect(issue.tool, ExternalTool.adb);
    expect(issue.problem, ToolProblem.notFound);
  });

  test('reports a failing devicectl with its output', () async {
    final repository = ToolValidationRepositoryImpl(
      adbPath: '/adb',
      probe: (executable, _) async => executable == '/adb'
          ? ok()
          : ProcessResult(1, 69, '', 'xcode license'),
      fileExists: (_) => true,
    );

    final issue = (await repository.validateTools()).single;
    expect(issue.tool, ExternalTool.devicectl);
    expect(issue.detail, contains('xcode license'));
  });

  test('reports a tool that cannot be spawned', () async {
    final repository = ToolValidationRepositoryImpl(
      adbPath: '/adb',
      checkXcode: false,
      probe: (_, _) async => throw const ProcessException('/adb', []),
      fileExists: (_) => true,
    );

    final issue = (await repository.validateTools()).single;
    expect(issue.problem, ToolProblem.notRunnable);
  });
}
