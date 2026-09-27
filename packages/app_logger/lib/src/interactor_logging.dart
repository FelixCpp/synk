import 'package:app_logger/src/app_log.dart';
import 'package:logger/logger.dart';
import 'package:use_in_case/use_in_case.dart';

/// Adds `logger()` to every interactor, as a counterpart to `intercept`.
extension InteractorLoggingExt<Input, Output>
    on ParameterizedResultInteractor<Input, Output> {
  /// Logs that the interactor started, how long it took, and whether it
  /// succeeded or threw - then passes the outcome through untouched.
  ///
  /// Chain it directly onto the interactor, ahead of every other operator:
  ///
  /// ```dart
  /// toggleConnection
  ///     .logger()
  ///     .intercept((e) => notifications.notify(...))
  ///     .run(device);
  /// ```
  ///
  /// The order is not cosmetic. [tag] defaults to the interactor's own type
  /// name, which is only still visible before another operator has wrapped
  /// it in an anonymous one. And `intercept` consumes the exception by
  /// default, so a `logger()` behind it would never see the failure.
  ///
  /// Build the chain per invocation, the way `intercept` is already used.
  /// `logEvents` keeps a single stopwatch per chain and never resets it, so
  /// a chain stored once and run repeatedly reports accumulating durations.
  ParameterizedResultInteractor<Input, Output> logger({
    String? tag,
    Level level = Level.debug,
    Logger? target,
  }) {
    final sink = target ?? appLogger;
    final name = tag ?? _typeNameOf(this);

    // Messages are closures so that an interactor running at input-event
    // frequency does not stringify its input hundreds of times a second for
    // a level nobody is listening to - the printer, and with it the
    // interpolation, only runs once the filter has said yes.
    return logEvents(
      logStart: (input) => sink.log(level, () => '$name started with $input'),
      logSuccess: (duration, output) => sink.log(level, () {
        // Interactors that produce nothing hand back null here; saying
        // "with null" would be noise.
        final result = output == null ? '' : ' with $output';
        return '$name finished in ${_formatted(duration)}$result';
      }),
      // Always at error level: a failure the caller chose to log at trace is
      // still a failure, and [level] is about how chatty the successful path
      // should be.
      logError: (duration, exception) => sink.log(
        Level.error,
        () => '$name failed after ${_formatted(duration)}',
        error: exception,
      ),
    );
  }
}

/// The interactor's class name without its type arguments, which are noise
/// in a log line.
String _typeNameOf(Object interactor) {
  final name = interactor.runtimeType.toString();
  final typeArguments = name.indexOf('<');

  return typeArguments < 0 ? name : name.substring(0, typeArguments);
}

String _formatted(Duration duration) {
  return duration.inMilliseconds > 0
      ? '${duration.inMilliseconds}ms'
      : '${duration.inMicroseconds}µs';
}
