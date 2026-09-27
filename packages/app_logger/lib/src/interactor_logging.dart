import 'package:app_logger/src/app_log.dart';
import 'package:logger/logger.dart';
import 'package:use_in_case/use_in_case.dart';

extension InteractorLoggingExt<Input, Output>
    on ParameterizedResultInteractor<Input, Output> {
  ParameterizedResultInteractor<Input, Output> logger({
    String? tag,
    Level level = Level.debug,
    Logger? target,
  }) {
    final sink = target ?? appLogger;
    final name = tag ?? _typeNameOf(this);

    return logEvents(
      logStart: (input) => sink.log(level, () => '$name started with $input'),
      logSuccess: (duration, output) => sink.log(level, () {
        final result = output == null ? '' : ' with $output';
        return '$name finished in ${_formatted(duration)}$result';
      }),
      logError: (duration, exception) => sink.log(
        Level.error,
        () => '$name failed after ${_formatted(duration)}',
        error: exception,
      ),
    );
  }
}

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
