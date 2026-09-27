import 'package:logger/logger.dart';

/// One line per entry, and a stack trace only when there is a real one.
///
/// Neither printer that ships with the package does this. [PrettyPrinter]
/// puts the timestamp on a line of its own, doubling the height of the log,
/// and substitutes `StackTrace.current` whenever the caller supplied none -
/// which under interactor logging points at the logging code itself, eight
/// frames of noise below every failure. Turning that off via
/// `errorMethodCount: 0` also discards the stack traces that *were* passed
/// in. [SimplePrinter] fits on one line but writes the timestamp as a full
/// ISO string behind a `TIME:` label.
class CompactPrinter extends LogPrinter {
  static const _labels = {
    Level.trace: 'TRACE',
    Level.debug: 'DEBUG',
    Level.info: 'INFO ',
    Level.warning: 'WARN ',
    Level.error: 'ERROR',
    Level.fatal: 'FATAL',
  };

  static const _colors = {
    Level.trace: AnsiColor.fg(245),
    Level.debug: AnsiColor.fg(44),
    Level.info: AnsiColor.fg(39),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.fatal: AnsiColor.fg(199),
  };

  static const _dim = AnsiColor.fg(240);
  static const _plain = AnsiColor.none();

  @override
  List<String> log(LogEvent event) {
    final label = _labels[event.level] ?? event.level.name.toUpperCase();
    final level = _colors[event.level] ?? _plain;
    final message = event.message is Function
        ? (event.message as Function)()
        : event.message;

    final body = event.level.value >= Level.warning.value ? level : _plain;
    final error = event.error == null
        ? ''
        : _colors[Level.error]!(' | ${event.error}');

    return [
      '${_dim(_time(event.time))}  ${level(label)}  ${body('$message')}$error',
      ...?event.stackTrace
          ?.toString()
          .trimRight()
          .split('\n')
          .map((frame) => _dim(frame)),
    ];
  }

  /// `21:28:16.457` - the date is never in question for a log you are
  /// watching scroll past.
  static String _time(DateTime time) {
    return time.toIso8601String().substring(11, 23);
  }
}
