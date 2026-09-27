import 'dart:io';

class const AdbProcessRunner({
  required final String adbPath,
}) {
  Future<ProcessResult> run(List<String> arguments) async {
    return Process.run(adbPath, arguments, runInShell: true);
  }

  /// Like [run], but leaves stdout/stderr as raw bytes instead of decoding
  /// them as text - needed for callers that read binary output (or that
  /// just want the exact bytes a device shell command produced).
  Future<ProcessResult> runRaw(List<String> arguments) async {
    return Process.run(
      adbPath,
      arguments,
      runInShell: true,
      stdoutEncoding: null,
      stderrEncoding: null,
    );
  }

  Future<Process> start(List<String> arguments) async {
    return Process.start(adbPath, arguments, runInShell: true);
  }
}
