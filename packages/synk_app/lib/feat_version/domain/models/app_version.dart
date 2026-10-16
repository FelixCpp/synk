import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_version.freezed.dart';

@freezed
sealed class AppVersion with _$AppVersion {
  const factory AppVersion({
    required String appName,
    required String packageName,
    required String version,
    required String buildNumber,
  }) = _AppVersion;
}
