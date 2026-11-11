import 'package:app_logger/app_logger.dart';

Future<void> tearDownEach(
  String subject,
  List<Future<void> Function()> steps,
) async {
  for (final step in steps) {
    try {
      await step();
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'A step of tearing down $subject failed, carrying on with the rest',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
