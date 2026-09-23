// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adb_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdbDevice {

 String get serialNumber; String get modelName; String get manufacturer;
/// Create a copy of AdbDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbDeviceCopyWith<AdbDevice> get copyWith => _$AdbDeviceCopyWithImpl<AdbDevice>(this as AdbDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbDevice&&(identical(other.serialNumber, _this.serialNumber) || other.serialNumber == _this.serialNumber)&&(identical(other.modelName, _this.modelName) || other.modelName == _this.modelName)&&(identical(other.manufacturer, _this.manufacturer) || other.manufacturer == _this.manufacturer));
}


@override
int get hashCode {
  final _this = this as AdbDevice;
  return Object.hash(runtimeType,_this.serialNumber,_this.modelName,_this.manufacturer);
}

@override
String toString() {
  final _this = this as AdbDevice;
  return 'AdbDevice(serialNumber: ${_this.serialNumber}, modelName: ${_this.modelName}, manufacturer: ${_this.manufacturer})';
}


}

/// @nodoc
abstract mixin class $AdbDeviceCopyWith<$Res>  {
  factory $AdbDeviceCopyWith(AdbDevice value, $Res Function(AdbDevice) _then) = _$AdbDeviceCopyWithImpl;
@useResult
$Res call({
 String serialNumber, String modelName, String manufacturer
});




}
/// @nodoc
class _$AdbDeviceCopyWithImpl<$Res>
    implements $AdbDeviceCopyWith<$Res> {
  _$AdbDeviceCopyWithImpl(this._self, this._then);

  final AdbDevice _self;
  final $Res Function(AdbDevice) _then;

/// Create a copy of AdbDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serialNumber = null,Object? modelName = null,Object? manufacturer = null,}) {
  return _then(AdbDevice(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdbDevice].
extension AdbDevicePatterns on AdbDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdbDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdbDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdbDevice value)  $default,){
final _that = this;
switch (_that) {
case _AdbDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdbDevice value)?  $default,){
final _that = this;
switch (_that) {
case _AdbDevice() when $default != null:
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
case _AdbDevice() when $default != null:
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
case _AdbDevice():
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
case _AdbDevice() when $default != null:
return $default(_that.serialNumber,_that.modelName,_that.manufacturer);case _:
  return null;

}
}

}

/// @nodoc


class _AdbDevice implements AdbDevice {
  const _AdbDevice({required this.serialNumber, required this.modelName, required this.manufacturer});
  

@override final  String serialNumber;
@override final  String modelName;
@override final  String manufacturer;

/// Create a copy of AdbDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdbDeviceCopyWith<_AdbDevice> get copyWith => __$AdbDeviceCopyWithImpl<_AdbDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdbDevice&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer));
}


@override
int get hashCode {
    return Object.hash(runtimeType,serialNumber,modelName,manufacturer);
}

@override
String toString() {
    return 'AdbDevice(serialNumber: $serialNumber, modelName: $modelName, manufacturer: $manufacturer)';
}


}

/// @nodoc
abstract mixin class _$AdbDeviceCopyWith<$Res> implements $AdbDeviceCopyWith<$Res> {
  factory _$AdbDeviceCopyWith(_AdbDevice value, $Res Function(_AdbDevice) _then) = __$AdbDeviceCopyWithImpl;
@override @useResult
$Res call({
 String serialNumber, String modelName, String manufacturer
});




}
/// @nodoc
class __$AdbDeviceCopyWithImpl<$Res>
    implements _$AdbDeviceCopyWith<$Res> {
  __$AdbDeviceCopyWithImpl(this._self, this._then);

  final _AdbDevice _self;
  final $Res Function(_AdbDevice) _then;

/// Create a copy of AdbDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serialNumber = null,Object? modelName = null,Object? manufacturer = null,}) {
  return _then(_AdbDevice(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
