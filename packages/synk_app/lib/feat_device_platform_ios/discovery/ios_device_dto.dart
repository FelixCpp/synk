import 'package:freezed_annotation/freezed_annotation.dart';

part 'ios_device_dto.freezed.dart';
part 'ios_device_dto.g.dart';

@freezed
sealed class IosDeviceDto with _$IosDeviceDto {
  const factory IosDeviceDto({
    @JsonKey(name: 'id') required String serialNumber,
    required String? productName,
  }) = _IosDeviceDto;

  factory IosDeviceDto.fromJson(Map<String, dynamic> json) =>
      _$IosDeviceDtoFromJson(json);
}
