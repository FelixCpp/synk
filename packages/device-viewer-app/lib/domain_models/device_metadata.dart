import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_metadata.freezed.dart';

extension type const DeviceModelName(String value) implements String {}

extension type const DeviceSerialNumber(String value) implements String {}

@freezed
sealed class DeviceMetadata with _$DeviceMetadata {
  const factory DeviceMetadata({
    required DeviceModelName modelName,
    required DeviceSerialNumber serialNumber,
  }) = _DeviceMetadata;
}
