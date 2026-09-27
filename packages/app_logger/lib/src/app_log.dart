import 'package:app_logger/src/compact_printer.dart';
import 'package:logger/logger.dart';

/// The logger the application writes through.
///
/// Replace it during start-up to pick a threshold, or in a test to capture
/// output. A mutable global rather than something passed around: the
/// alternative is threading a logger through every widget, bloc and
/// interactor, and the point of `.logger()` is that it takes no arguments.
Logger appLogger = createAppLogger();

/// A [Logger] configured the way this application wants one.
///
/// [ProductionFilter] rather than the default [DevelopmentFilter], which
/// drops *everything* in release builds - that is a decision for whoever
/// picks [level], not one to inherit silently.
Logger createAppLogger({Level level = Level.debug, LogOutput? output}) {
  return Logger(
    filter: ProductionFilter(),
    level: level,
    printer: CompactPrinter(),
    output: output,
  );
}
