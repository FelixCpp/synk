import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_version_dto.freezed.dart';

@freezed
sealed class AdbVersionDto with _$AdbVersionDto {
  const factory AdbVersionDto({
    required int major,
    required int minor,
    required int patch,
    required int build,
  }) = _AdbVersionDto;
}
