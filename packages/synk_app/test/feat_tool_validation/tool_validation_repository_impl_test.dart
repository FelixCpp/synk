import 'dart:io' show ProcessException;

import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform/testing.dart';
import 'package:synk/feat_tool_validation/data/repositories/tool_validation_repository_impl.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

import '../support/fake_process_manager.dart';

void main() {
  final macos = TestNativePlatform(operatingSystem: NativePlatform.macOS);

  MemoryFileSystem withAdb() {
    return MemoryFileSystem()..file('/adb').createSync();
  }

  test('reports nothing when all tools run', () async {
    final repository = ToolValidationRepositoryImpl(
      adbPath: '/adb',
      platform: macos,
      fileSystem: withAdb(),
      processManager: FakeProcessManager(),
    );

    expect(await repository.validateTools(), isEmpty);
  });

  test('reports a missing adb binary', () async {
    final repository = ToolValidationRepositoryImpl(
      adbPath: '/adb',
      platform: macos,
      fileSystem: MemoryFileSystem(),
      processManager: FakeProcessManager(),
    );

    final issue = (await repository.validateTools()).single;
    expect(issue.tool, ExternalTool.adb);
    expect(issue.problem, ToolProblem.notFound);
  });

  test('reports a failing devicectl with its output', () async {
    final repository = ToolValidationRepositoryImpl(
      adbPath: '/adb',
      platform: macos,
      fileSystem: withAdb(),
      processManager: FakeProcessManager(
        respond: (command) => command.first == '/adb'
            ? fakeSuccess
            : (exitCode: 69, stdout: '', stderr: 'xcode license'),
      ),
    );

    final issue = (await repository.validateTools()).single;
    expect(issue.tool, ExternalTool.devicectl);
    expect(issue.detail, contains('xcode license'));
  });

  test('reports a tool that cannot be spawned', () async {
    final repository = ToolValidationRepositoryImpl(
      adbPath: '/adb',
      platform: TestNativePlatform(operatingSystem: NativePlatform.linux),
      fileSystem: withAdb(),
      processManager: FakeProcessManager(
        respond: (_) => throw const ProcessException('/adb', []),
      ),
    );

    final issue = (await repository.validateTools()).single;
    expect(issue.problem, ToolProblem.notRunnable);
  });

  test('skips devicectl away from macOS', () async {
    final processManager = FakeProcessManager();
    final repository = ToolValidationRepositoryImpl(
      adbPath: '/adb',
      platform: TestNativePlatform(operatingSystem: NativePlatform.linux),
      fileSystem: withAdb(),
      processManager: processManager,
    );

    await repository.validateTools();

    expect(processManager.commands, [
      ['/adb', 'version'],
    ]);
  });

  test('probes adb with its version and devicectl through xcrun', () async {
    final processManager = FakeProcessManager();
    final repository = ToolValidationRepositoryImpl(
      adbPath: '/adb',
      platform: macos,
      fileSystem: withAdb(),
      processManager: processManager,
    );

    await repository.validateTools();

    expect(processManager.commands, [
      ['/adb', 'version'],
      ['/usr/bin/xcrun', 'devicectl', '--version'],
    ]);
  });
}
