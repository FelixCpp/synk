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

 String get serialNumber; AdbDeviceState get state; String? get product; String? get model; String? get device; String? get transportId;
/// Create a copy of AdbDeviceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbDeviceDtoCopyWith<AdbDeviceDto> get copyWith => _$AdbDeviceDtoCopyWithImpl<AdbDeviceDto>(this as AdbDeviceDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbDeviceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbDeviceDto&&(identical(other.serialNumber, _this.serialNumber) || other.serialNumber == _this.serialNumber)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.transportId, _this.transportId) || other.transportId == _this.transportId));
}


@override
int get hashCode {
  final _this = this as AdbDeviceDto;
  return Object.hash(runtimeType,_this.serialNumber,_this.state,_this.product,_this.model,_this.device,_this.transportId);
}

@override
String toString() {
  final _this = this as AdbDeviceDto;
  return 'AdbDeviceDto(serialNumber: ${_this.serialNumber}, state: ${_this.state}, product: ${_this.product}, model: ${_this.model}, device: ${_this.device}, transportId: ${_this.transportId})';
}


}

/// @nodoc
abstract mixin class $AdbDeviceDtoCopyWith<$Res>  {
  factory $AdbDeviceDtoCopyWith(AdbDeviceDto value, $Res Function(AdbDeviceDto) _then) = _$AdbDeviceDtoCopyWithImpl;
@useResult
$Res call({
 String serialNumber, AdbDeviceState state, String? product, String? model, String? device, String? transportId
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
@pragma('vm:prefer-inline') @override $Res call({Object? serialNumber = null,Object? state = null,Object? product = freezed,Object? model = freezed,Object? device = freezed,Object? transportId = freezed,}) {
  return _then(AdbDeviceDto(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AdbDeviceState,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String?,transportId: freezed == transportId ? _self.transportId : transportId // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serialNumber,  AdbDeviceState state,  String? product,  String? model,  String? device,  String? transportId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdbDeviceDto() when $default != null:
return $default(_that.serialNumber,_that.state,_that.product,_that.model,_that.device,_that.transportId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serialNumber,  AdbDeviceState state,  String? product,  String? model,  String? device,  String? transportId)  $default,) {final _that = this;
switch (_that) {
case _AdbDeviceDto():
return $default(_that.serialNumber,_that.state,_that.product,_that.model,_that.device,_that.transportId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serialNumber,  AdbDeviceState state,  String? product,  String? model,  String? device,  String? transportId)?  $default,) {final _that = this;
switch (_that) {
case _AdbDeviceDto() when $default != null:
return $default(_that.serialNumber,_that.state,_that.product,_that.model,_that.device,_that.transportId);case _:
  return null;

}
}

}

/// @nodoc


class _AdbDeviceDto implements AdbDeviceDto {
  const _AdbDeviceDto({required this.serialNumber, required this.state, required this.product, required this.model, required this.device, required this.transportId});
  

@override final  String serialNumber;
@override final  AdbDeviceState state;
@override final  String? product;
@override final  String? model;
@override final  String? device;
@override final  String? transportId;

/// Create a copy of AdbDeviceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdbDeviceDtoCopyWith<_AdbDeviceDto> get copyWith => __$AdbDeviceDtoCopyWithImpl<_AdbDeviceDto>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdbDeviceDto&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.state, state) || other.state == state)&&(identical(other.product, product) || other.product == product)&&(identical(other.model, model) || other.model == model)&&(identical(other.device, device) || other.device == device)&&(identical(other.transportId, transportId) || other.transportId == transportId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,serialNumber,state,product,model,device,transportId);
}

@override
String toString() {
    return 'AdbDeviceDto(serialNumber: $serialNumber, state: $state, product: $product, model: $model, device: $device, transportId: $transportId)';
}


}

/// @nodoc
abstract mixin class _$AdbDeviceDtoCopyWith<$Res> implements $AdbDeviceDtoCopyWith<$Res> {
  factory _$AdbDeviceDtoCopyWith(_AdbDeviceDto value, $Res Function(_AdbDeviceDto) _then) = __$AdbDeviceDtoCopyWithImpl;
@override @useResult
$Res call({
 String serialNumber, AdbDeviceState state, String? product, String? model, String? device, String? transportId
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
@override @pragma('vm:prefer-inline') $Res call({Object? serialNumber = null,Object? state = null,Object? product = freezed,Object? model = freezed,Object? device = freezed,Object? transportId = freezed,}) {
  return _then(_AdbDeviceDto(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AdbDeviceState,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String?,transportId: freezed == transportId ? _self.transportId : transportId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
