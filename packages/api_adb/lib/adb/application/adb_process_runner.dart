import 'dart:io';

class const AdbProcessRunner({
  required final String adbPath,
}) {
  Future<ProcessResult> run(List<String> arguments) async {
    return Process.run(adbPath, arguments, runInShell: true);
  }

  Future<Process> start(List<String> arguments) async {
    return Process.start(adbPath, arguments, runInShell: true);
  }
}
