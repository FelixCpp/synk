import 'package:freezed_annotation/freezed_annotation.dart';

part 'newer_app_version.freezed.dart';

@freezed
sealed class NewerAppVersion with _$NewerAppVersion {
  const factory NewerAppVersion.upToDate() = _UpToDate;
  const factory NewerAppVersion.updateAvailable(String version) = _Available;
  const factory NewerAppVersion.failedToFetch() = _FailedToFetch;
}
