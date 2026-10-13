// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ios_device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IosDeviceDto _$IosDeviceDtoFromJson(Map<String, dynamic> json) =>
    _IosDeviceDto(
      serialNumber: json['id'] as String,
      productName: json['productName'] as String?,
    );

Map<String, dynamic> _$IosDeviceDtoToJson(_IosDeviceDto instance) =>
    <String, dynamic>{
      'id': instance.serialNumber,
      'productName': instance.productName,
    };
