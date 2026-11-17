import 'package:api_adb/adb/pairing/adb_pair_result.dart';

AdbPairResult parseAdbPairResult({
  required int exitCode,
  required String output,
}) {
  final success = exitCode == 0 && output.contains('Successfully paired');
  final serviceName = RegExp(r'\[guid=([^\]\s]+)\]').firstMatch(output);

  return AdbPairResult(
    success: success,
    message: output.trim(),
    serviceName: success ? serviceName?.group(1) : null,
  );
}
