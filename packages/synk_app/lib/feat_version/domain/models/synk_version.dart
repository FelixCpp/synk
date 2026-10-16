import 'package:freezed_annotation/freezed_annotation.dart';

part 'synk_version.freezed.dart';

@freezed
sealed class SynkVersion with _$SynkVersion {
  const factory SynkVersion({
    required String appName,
    required String packageName,
    required String version,
    required String buildNumber,
  }) = _SynkVersion;
}
