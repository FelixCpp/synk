// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adb_device_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdbDeviceDto {

 String get serialNumber; AdbDeviceStateDto get state; AdbConnectionTypeDto get connectionType; String? get busAddress; String? get product; String? get model; String? get device; int? get negotiatedSpeed; int? get maxSpeed; int? get transportId;
/// Create a copy of AdbDeviceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbDeviceDtoCopyWith<AdbDeviceDto> get copyWith => _$AdbDeviceDtoCopyWithImpl<AdbDeviceDto>(this as AdbDeviceDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbDeviceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbDeviceDto&&(identical(other.serialNumber, _this.serialNumber) || other.serialNumber == _this.serialNumber)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.connectionType, _this.connectionType) || other.connectionType == _this.connectionType)&&(identical(other.busAddress, _this.busAddress) || other.busAddress == _this.busAddress)&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.negotiatedSpeed, _this.negotiatedSpeed) || other.negotiatedSpeed == _this.negotiatedSpeed)&&(identical(other.maxSpeed, _this.maxSpeed) || other.maxSpeed == _this.maxSpeed)&&(identical(other.transportId, _this.transportId) || other.transportId == _this.transportId));
}


@override
int get hashCode {
  final _this = this as AdbDeviceDto;
  return Object.hash(runtimeType,_this.serialNumber,_this.state,_this.connectionType,_this.busAddress,_this.product,_this.model,_this.device,_this.negotiatedSpeed,_this.maxSpeed,_this.transportId);
}

@override
String toString() {
  final _this = this as AdbDeviceDto;
  return 'AdbDeviceDto(serialNumber: ${_this.serialNumber}, state: ${_this.state}, connectionType: ${_this.connectionType}, busAddress: ${_this.busAddress}, product: ${_this.product}, model: ${_this.model}, device: ${_this.device}, negotiatedSpeed: ${_this.negotiatedSpeed}, maxSpeed: ${_this.maxSpeed}, transportId: ${_this.transportId})';
}


}

/// @nodoc
abstract mixin class $AdbDeviceDtoCopyWith<$Res>  {
  factory $AdbDeviceDtoCopyWith(AdbDeviceDto value, $Res Function(AdbDeviceDto) _then) = _$AdbDeviceDtoCopyWithImpl;
@useResult
$Res call({
 String serialNumber, AdbDeviceStateDto state, AdbConnectionTypeDto connectionType, String? busAddress, String? product, String? model, String? device, int? negotiatedSpeed, int? maxSpeed, int? transportId
});




}
/// @nodoc
class _$AdbDeviceDtoCopyWithImpl<$Res>
    implements $AdbDeviceDtoCopyWith<$Res> {
  _$AdbDeviceDtoCopyWithImpl(this._self, this._then);

  final AdbDeviceDto _self;
  final $Res Function(AdbDeviceDto) _then;

/// Create a copy of AdbDeviceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serialNumber = null,Object? state = null,Object? connectionType = null,Object? busAddress = freezed,Object? product = freezed,Object? model = freezed,Object? device = freezed,Object? negotiatedSpeed = freezed,Object? maxSpeed = freezed,Object? transportId = freezed,}) {
  return _then(AdbDeviceDto(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AdbDeviceStateDto,connectionType: null == connectionType ? _self.connectionType : connectionType // ignore: cast_nullable_to_non_nullable
as AdbConnectionTypeDto,busAddress: freezed == busAddress ? _self.busAddress : busAddress // ignore: cast_nullable_to_non_nullable
as String?,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String?,negotiatedSpeed: freezed == negotiatedSpeed ? _self.negotiatedSpeed : negotiatedSpeed // ignore: cast_nullable_to_non_nullable
as int?,maxSpeed: freezed == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as int?,transportId: freezed == transportId ? _self.transportId : transportId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdbDeviceDto].
extension AdbDeviceDtoPatterns on AdbDeviceDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdbDeviceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdbDeviceDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdbDeviceDto value)  $default,){
final _that = this;
switch (_that) {
case _AdbDeviceDto():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdbDeviceDto value)?  $default,){
final _that = this;
switch (_that) {
case _AdbDeviceDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serialNumber,  AdbDeviceStateDto state,  AdbConnectionTypeDto connectionType,  String? busAddress,  String? product,  String? model,  String? device,  int? negotiatedSpeed,  int? maxSpeed,  int? transportId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdbDeviceDto() when $default != null:
return $default(_that.serialNumber,_that.state,_that.connectionType,_that.busAddress,_that.product,_that.model,_that.device,_that.negotiatedSpeed,_that.maxSpeed,_that.transportId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serialNumber,  AdbDeviceStateDto state,  AdbConnectionTypeDto connectionType,  String? busAddress,  String? product,  String? model,  String? device,  int? negotiatedSpeed,  int? maxSpeed,  int? transportId)  $default,) {final _that = this;
switch (_that) {
case _AdbDeviceDto():
return $default(_that.serialNumber,_that.state,_that.connectionType,_that.busAddress,_that.product,_that.model,_that.device,_that.negotiatedSpeed,_that.maxSpeed,_that.transportId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serialNumber,  AdbDeviceStateDto state,  AdbConnectionTypeDto connectionType,  String? busAddress,  String? product,  String? model,  String? device,  int? negotiatedSpeed,  int? maxSpeed,  int? transportId)?  $default,) {final _that = this;
switch (_that) {
case _AdbDeviceDto() when $default != null:
return $default(_that.serialNumber,_that.state,_that.connectionType,_that.busAddress,_that.product,_that.model,_that.device,_that.negotiatedSpeed,_that.maxSpeed,_that.transportId);case _:
  return null;

}
}

}

/// @nodoc


class _AdbDeviceDto implements AdbDeviceDto {
  const _AdbDeviceDto({required this.serialNumber, required this.state, required this.connectionType, this.busAddress, this.product, this.model, this.device, this.negotiatedSpeed, this.maxSpeed, this.transportId});
  

@override final  String serialNumber;
@override final  AdbDeviceStateDto state;
@override final  AdbConnectionTypeDto connectionType;
@override final  String? busAddress;
@override final  String? product;
@override final  String? model;
@override final  String? device;
@override final  int? negotiatedSpeed;
@override final  int? maxSpeed;
@override final  int? transportId;

/// Create a copy of AdbDeviceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdbDeviceDtoCopyWith<_AdbDeviceDto> get copyWith => __$AdbDeviceDtoCopyWithImpl<_AdbDeviceDto>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdbDeviceDto&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.state, state) || other.state == state)&&(identical(other.connectionType, connectionType) || other.connectionType == connectionType)&&(identical(other.busAddress, busAddress) || other.busAddress == busAddress)&&(identical(other.product, product) || other.product == product)&&(identical(other.model, model) || other.model == model)&&(identical(other.device, device) || other.device == device)&&(identical(other.negotiatedSpeed, negotiatedSpeed) || other.negotiatedSpeed == negotiatedSpeed)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.transportId, transportId) || other.transportId == transportId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,serialNumber,state,connectionType,busAddress,product,model,device,negotiatedSpeed,maxSpeed,transportId);
}

@override
String toString() {
    return 'AdbDeviceDto(serialNumber: $serialNumber, state: $state, connectionType: $connectionType, busAddress: $busAddress, product: $product, model: $model, device: $device, negotiatedSpeed: $negotiatedSpeed, maxSpeed: $maxSpeed, transportId: $transportId)';
}


}

/// @nodoc
abstract mixin class _$AdbDeviceDtoCopyWith<$Res> implements $AdbDeviceDtoCopyWith<$Res> {
  factory _$AdbDeviceDtoCopyWith(_AdbDeviceDto value, $Res Function(_AdbDeviceDto) _then) = __$AdbDeviceDtoCopyWithImpl;
@override @useResult
$Res call({
 String serialNumber, AdbDeviceStateDto state, AdbConnectionTypeDto connectionType, String? busAddress, String? product, String? model, String? device, int? negotiatedSpeed, int? maxSpeed, int? transportId
});




}
/// @nodoc
class __$AdbDeviceDtoCopyWithImpl<$Res>
    implements _$AdbDeviceDtoCopyWith<$Res> {
  __$AdbDeviceDtoCopyWithImpl(this._self, this._then);

  final _AdbDeviceDto _self;
  final $Res Function(_AdbDeviceDto) _then;

/// Create a copy of AdbDeviceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serialNumber = null,Object? state = null,Object? connectionType = null,Object? busAddress = freezed,Object? product = freezed,Object? model = freezed,Object? device = freezed,Object? negotiatedSpeed = freezed,Object? maxSpeed = freezed,Object? transportId = freezed,}) {
  return _then(_AdbDeviceDto(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AdbDeviceStateDto,connectionType: null == connectionType ? _self.connectionType : connectionType // ignore: cast_nullable_to_non_nullable
as AdbConnectionTypeDto,busAddress: freezed == busAddress ? _self.busAddress : busAddress // ignore: cast_nullable_to_non_nullable
as String?,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String?,negotiatedSpeed: freezed == negotiatedSpeed ? _self.negotiatedSpeed : negotiatedSpeed // ignore: cast_nullable_to_non_nullable
as int?,maxSpeed: freezed == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as int?,transportId: freezed == transportId ? _self.transportId : transportId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
