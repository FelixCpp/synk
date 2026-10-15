import 'dart:convert';
import 'dart:io';

import 'package:process/process.dart';

const defaultXcrunPath = '/usr/bin/xcrun';

class const DevicectlProcessRunner({
  final String xcrunPath = defaultXcrunPath,
  final ProcessManager processManager = const LocalProcessManager(),
}) {
  Future<ProcessResult> run(List<String> arguments) {
    return processManager.run([xcrunPath, 'devicectl', ...arguments]);
  }

  Future<ProcessResult> runRaw(List<String> arguments) {
    return processManager.run(
      [xcrunPath, 'devicectl', ...arguments],
      stdoutEncoding: null,
    );
  }

  Future<ProcessResult> runWithStdin(
    List<String> arguments,
    List<int> input,
  ) async {
    final process = await processManager.start([
      xcrunPath,
      'devicectl',
      ...arguments,
    ]);

    final stdout = _collect(process.stdout);
    final stderr = _collect(process.stderr);

    process.stdin.add(input);

    await process.stdin.close().catchError((Object _) {});

    return ProcessResult(
      process.pid,
      await process.exitCode,
      await stdout,
      await stderr,
    );
  }

  Future<String> _collect(Stream<List<int>> stream) {
    return utf8.decoder.bind(stream).join();
  }
}
