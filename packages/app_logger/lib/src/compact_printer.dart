import 'package:logger/logger.dart';

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

  static String _time(DateTime time) {
    return time.toIso8601String().substring(11, 23);
  }
}
