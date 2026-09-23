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

 String get serialNumber; String get modelName; String get manufacturer;
/// Create a copy of AdbDeviceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbDeviceDtoCopyWith<AdbDeviceDto> get copyWith => _$AdbDeviceDtoCopyWithImpl<AdbDeviceDto>(this as AdbDeviceDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbDeviceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbDeviceDto&&(identical(other.serialNumber, _this.serialNumber) || other.serialNumber == _this.serialNumber)&&(identical(other.modelName, _this.modelName) || other.modelName == _this.modelName)&&(identical(other.manufacturer, _this.manufacturer) || other.manufacturer == _this.manufacturer));
}


@override
int get hashCode {
  final _this = this as AdbDeviceDto;
  return Object.hash(runtimeType,_this.serialNumber,_this.modelName,_this.manufacturer);
}

@override
String toString() {
  final _this = this as AdbDeviceDto;
  return 'AdbDeviceDto(serialNumber: ${_this.serialNumber}, modelName: ${_this.modelName}, manufacturer: ${_this.manufacturer})';
}


}

/// @nodoc
abstract mixin class $AdbDeviceDtoCopyWith<$Res>  {
  factory $AdbDeviceDtoCopyWith(AdbDeviceDto value, $Res Function(AdbDeviceDto) _then) = _$AdbDeviceDtoCopyWithImpl;
@useResult
$Res call({
 String serialNumber, String modelName, String manufacturer
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
@pragma('vm:prefer-inline') @override $Res call({Object? serialNumber = null,Object? modelName = null,Object? manufacturer = null,}) {
  return _then(AdbDeviceDto(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serialNumber,  String modelName,  String manufacturer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdbDeviceDto() when $default != null:
return $default(_that.serialNumber,_that.modelName,_that.manufacturer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serialNumber,  String modelName,  String manufacturer)  $default,) {final _that = this;
switch (_that) {
case _AdbDeviceDto():
return $default(_that.serialNumber,_that.modelName,_that.manufacturer);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serialNumber,  String modelName,  String manufacturer)?  $default,) {final _that = this;
switch (_that) {
case _AdbDeviceDto() when $default != null:
return $default(_that.serialNumber,_that.modelName,_that.manufacturer);case _:
  return null;

}
}

}

/// @nodoc


class _AdbDeviceDto implements AdbDeviceDto {
  const _AdbDeviceDto({required this.serialNumber, required this.modelName, required this.manufacturer});
  

@override final  String serialNumber;
@override final  String modelName;
@override final  String manufacturer;

/// Create a copy of AdbDeviceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdbDeviceDtoCopyWith<_AdbDeviceDto> get copyWith => __$AdbDeviceDtoCopyWithImpl<_AdbDeviceDto>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdbDeviceDto&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer));
}


@override
int get hashCode {
    return Object.hash(runtimeType,serialNumber,modelName,manufacturer);
}

@override
String toString() {
    return 'AdbDeviceDto(serialNumber: $serialNumber, modelName: $modelName, manufacturer: $manufacturer)';
}


}

/// @nodoc
abstract mixin class _$AdbDeviceDtoCopyWith<$Res> implements $AdbDeviceDtoCopyWith<$Res> {
  factory _$AdbDeviceDtoCopyWith(_AdbDeviceDto value, $Res Function(_AdbDeviceDto) _then) = __$AdbDeviceDtoCopyWithImpl;
@override @useResult
$Res call({
 String serialNumber, String modelName, String manufacturer
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
@override @pragma('vm:prefer-inline') $Res call({Object? serialNumber = null,Object? modelName = null,Object? manufacturer = null,}) {
  return _then(_AdbDeviceDto(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
