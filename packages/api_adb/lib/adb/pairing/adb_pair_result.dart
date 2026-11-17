import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_pair_result.freezed.dart';

@freezed
sealed class AdbPairResult with _$AdbPairResult {
  const factory AdbPairResult({
    required bool success,
    required String message,
    required String? serviceName,
  }) = _AdbPairResult;
}
