import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:process/process.dart';

/// What a faked command answers with.
typedef FakeCommandResult = ({int exitCode, String stdout, String stderr});

const FakeCommandResult fakeSuccess = (exitCode: 0, stdout: '', stderr: '');

/// A process manager that runs nothing: it records every command and answers
/// with whatever [respond] returns for it. [respond] may also throw, the way a
/// missing executable makes the real one throw.
class FakeProcessManager implements ProcessManager {
  FakeProcessManager({this.respond = _succeed});

  final FakeCommandResult Function(List<String> command) respond;

  /// Every command in the order it was run or started.
  final commands = <List<String>>[];

  /// What each started process was given on stdin, once it was closed.
  final stdinWrites = <String>[];

  FakeCommandResult _answer(List<Object> command) {
    final arguments = [for (final part in command) '$part'];
    commands.add(arguments);
    return respond(arguments);
  }

  @override
  Future<ProcessResult> run(
    List<Object> command, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Encoding? stdoutEncoding = systemEncoding,
    Encoding? stderrEncoding = systemEncoding,
  }) async {
    final result = _answer(command);

    return ProcessResult(
      0,
      result.exitCode,
      _encoded(result.stdout, stdoutEncoding),
      _encoded(result.stderr, stderrEncoding),
    );
  }

  @override
  Future<Process> start(
    List<Object> command, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    ProcessStartMode mode = ProcessStartMode.normal,
  }) async {
    final result = _answer(command);
    final stdin = StreamController<List<int>>();
    unawaited(utf8.decoder.bind(stdin.stream).join().then(stdinWrites.add));

    return _FakeProcess(result, IOSink(stdin));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

FakeCommandResult _succeed(List<String> _) => fakeSuccess;

/// A `null` encoding asks for the raw bytes, like [Process.run] does.
Object _encoded(String text, Encoding? encoding) {
  return encoding == null ? utf8.encode(text) : text;
}

class _FakeProcess implements Process {
  _FakeProcess(this._result, this.stdin);

  final FakeCommandResult _result;

  @override
  final IOSink stdin;

  @override
  int get pid => 0;

  @override
  Future<int> get exitCode async => _result.exitCode;

  @override
  Stream<List<int>> get stdout => Stream.value(utf8.encode(_result.stdout));

  @override
  Stream<List<int>> get stderr => Stream.value(utf8.encode(_result.stderr));

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) => true;
}
