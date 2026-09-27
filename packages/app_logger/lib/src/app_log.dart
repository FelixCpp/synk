import 'package:app_logger/src/compact_printer.dart';
import 'package:logger/logger.dart';

Logger appLogger = createAppLogger();

Logger createAppLogger({Level level = Level.debug, LogOutput? output}) {
  return Logger(
    filter: ProductionFilter(),
    level: level,
    printer: CompactPrinter(),
    output: output,
  );
}
