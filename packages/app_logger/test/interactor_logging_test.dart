import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:test/test.dart';
import 'package:use_in_case/use_in_case.dart';

void main() {
  late MemoryOutput recorded;
  late Logger logger;

  setUp(() {
    recorded = MemoryOutput();
    logger = createAppLogger(level: Level.all, output: recorded);
  });

  List<String> linesLogged() => [
    for (final event in recorded.buffer) ...event.lines,
  ];

  List<Level> levelsLogged() => [
    for (final event in recorded.buffer) event.level,
  ];

  test('logs the start and the outcome, tagged with the interactor', () async {
    await _EchoInteractor().logger(target: logger).run('ping');

    expect(linesLogged(), [
      contains('_EchoInteractor started with ping'),
      contains('_EchoInteractor finished in'),
    ]);
    expect(linesLogged().last, endsWith('with echo:ping'));
  });

  test(
    'says nothing about the result of an interactor that has none',
    () async {
      await _SilentInteractor().logger(target: logger).run('ping');

      expect(linesLogged().last, isNot(contains('with')));
    },
  );

  test('logs failures at error level, with the exception attached', () async {
    await _FailingInteractor().logger(target: logger).run('ping');

    expect(levelsLogged().last, Level.error);
    expect(linesLogged().last, contains('_FailingInteractor failed after'));
    expect(linesLogged().last, contains('device went away'));
  });

  test('lets the exception through to the caller', () async {
    await expectLater(
      _FailingInteractor().logger(target: logger).runUnsafe('ping'),
      throwsA(isA<FormatException>()),
    );
  });

  test('leaves a following intercept able to handle the exception', () async {
    Exception? intercepted;

    await _FailingInteractor()
        .logger(target: logger)
        .intercept((exception) => intercepted = exception)
        .run('ping');

    expect(intercepted, isA<FormatException>());
    expect(levelsLogged().last, Level.error);
  });

  test('logs at the requested level', () async {
    await _EchoInteractor()
        .logger(target: logger, level: Level.trace)
        .run('ping');

    expect(levelsLogged(), [Level.trace, Level.trace]);
  });

  test('honours an explicit tag', () async {
    await _EchoInteractor().logger(target: logger, tag: 'Echo').run('ping');

    expect(linesLogged().first, contains('Echo started'));
  });

  test('drops the type arguments of a generic interactor', () async {
    await _GenericInteractor<int>().logger(target: logger).run(1);

    expect(linesLogged().first, contains('_GenericInteractor started'));
  });

  test('does not build messages the logger would discard', () async {
    // Interactors that run per input event would otherwise stringify their
    // input on every single invocation, filtered out or not.
    final muted = createAppLogger(level: Level.error, output: recorded);

    await _MutedInputInteractor().logger(target: muted).run(_ExplodingInput());

    expect(recorded.buffer, isEmpty);
  });
}

class _EchoInteractor implements ParameterizedResultInteractor<String, String> {
  @override
  FutureOr<String> getOrThrow(String input) => 'echo:$input';
}

class _SilentInteractor implements ParameterizedInteractor<String> {
  @override
  FutureOr<void> getOrThrow(String input) {}
}

class _FailingInteractor implements ParameterizedInteractor<String> {
  @override
  FutureOr<void> getOrThrow(String input) {
    throw const FormatException('device went away mid-handshake');
  }
}

class _GenericInteractor<T> implements ParameterizedInteractor<T> {
  @override
  FutureOr<void> getOrThrow(T input) {}
}

class _MutedInputInteractor
    implements ParameterizedInteractor<_ExplodingInput> {
  @override
  FutureOr<void> getOrThrow(_ExplodingInput input) {}
}

/// Blows up if anyone puts it in a log message.
class _ExplodingInput {
  @override
  String toString() => throw StateError('input was stringified needlessly');
}
