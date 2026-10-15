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

    return FakeProcess(
      exitCode: result.exitCode,
      stdout: result.stdout,
      stderr: result.stderr,
      stdin: IOSink(stdin),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

FakeCommandResult _succeed(List<String> _) => fakeSuccess;

/// A `null` encoding asks for the raw bytes, like [Process.run] does.
Object _encoded(String text, Encoding? encoding) {
  return encoding == null ? utf8.encode(text) : text;
}

/// A process that already printed [stdout] and [stderr]. Unless it
/// [keepsRunning], its output streams end right after that.
class FakeProcess implements Process {
  FakeProcess({
    this._exitCode = 0,
    this._stdout = '',
    this._stderr = '',
    this.keepsRunning = false,
    IOSink? stdin,
  }) : stdin = stdin ?? IOSink(StreamController<List<int>>());

  final int _exitCode;
  final String _stdout;
  final String _stderr;
  final bool keepsRunning;
  var killed = false;

  @override
  final IOSink stdin;

  @override
  int get pid => 0;

  @override
  Future<int> get exitCode async => _exitCode;

  @override
  Stream<List<int>> get stdout => _output(_stdout);

  @override
  Stream<List<int>> get stderr => _output(_stderr);

  Stream<List<int>> _output(String text) {
    final controller = StreamController<List<int>>()..add(utf8.encode(text));
    if (!keepsRunning) {
      unawaited(controller.close());
    }

    return controller.stream;
  }

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    killed = true;
    return true;
  }
}
