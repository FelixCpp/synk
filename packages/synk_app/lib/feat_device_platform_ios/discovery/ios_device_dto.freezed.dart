// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ios_device_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IosDeviceDto {

@JsonKey(name: 'id') String get serialNumber; String? get productName;
/// Create a copy of IosDeviceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IosDeviceDtoCopyWith<IosDeviceDto> get copyWith => _$IosDeviceDtoCopyWithImpl<IosDeviceDto>(this as IosDeviceDto, _$identity);

  /// Serializes this IosDeviceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as IosDeviceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IosDeviceDto&&(identical(other.serialNumber, _this.serialNumber) || other.serialNumber == _this.serialNumber)&&(identical(other.productName, _this.productName) || other.productName == _this.productName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as IosDeviceDto;
  return Object.hash(runtimeType,_this.serialNumber,_this.productName);
}

@override
String toString() {
  final _this = this as IosDeviceDto;
  return 'IosDeviceDto(serialNumber: ${_this.serialNumber}, productName: ${_this.productName})';
}


}

/// @nodoc
abstract mixin class $IosDeviceDtoCopyWith<$Res>  {
  factory $IosDeviceDtoCopyWith(IosDeviceDto value, $Res Function(IosDeviceDto) _then) = _$IosDeviceDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String serialNumber, String? productName
});




}
/// @nodoc
class _$IosDeviceDtoCopyWithImpl<$Res>
    implements $IosDeviceDtoCopyWith<$Res> {
  _$IosDeviceDtoCopyWithImpl(this._self, this._then);

  final IosDeviceDto _self;
  final $Res Function(IosDeviceDto) _then;

/// Create a copy of IosDeviceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serialNumber = null,Object? productName = freezed,}) {
  return _then(IosDeviceDto(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [IosDeviceDto].
extension IosDeviceDtoPatterns on IosDeviceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IosDeviceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IosDeviceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IosDeviceDto value)  $default,){
final _that = this;
switch (_that) {
case _IosDeviceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IosDeviceDto value)?  $default,){
final _that = this;
switch (_that) {
case _IosDeviceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String serialNumber,  String? productName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IosDeviceDto() when $default != null:
return $default(_that.serialNumber,_that.productName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String serialNumber,  String? productName)  $default,) {final _that = this;
switch (_that) {
case _IosDeviceDto():
return $default(_that.serialNumber,_that.productName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String serialNumber,  String? productName)?  $default,) {final _that = this;
switch (_that) {
case _IosDeviceDto() when $default != null:
return $default(_that.serialNumber,_that.productName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IosDeviceDto implements IosDeviceDto {
  const _IosDeviceDto({@JsonKey(name: 'id') required this.serialNumber, required this.productName});
  factory _IosDeviceDto.fromJson(Map<String, dynamic> json) => _$IosDeviceDtoFromJson(json);

@override@JsonKey(name: 'id') final  String serialNumber;
@override final  String? productName;

/// Create a copy of IosDeviceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IosDeviceDtoCopyWith<_IosDeviceDto> get copyWith => __$IosDeviceDtoCopyWithImpl<_IosDeviceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IosDeviceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IosDeviceDto&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.productName, productName) || other.productName == productName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,serialNumber,productName);
}

@override
String toString() {
    return 'IosDeviceDto(serialNumber: $serialNumber, productName: $productName)';
}


}

/// @nodoc
abstract mixin class _$IosDeviceDtoCopyWith<$Res> implements $IosDeviceDtoCopyWith<$Res> {
  factory _$IosDeviceDtoCopyWith(_IosDeviceDto value, $Res Function(_IosDeviceDto) _then) = __$IosDeviceDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String serialNumber, String? productName
});




}
/// @nodoc
class __$IosDeviceDtoCopyWithImpl<$Res>
    implements _$IosDeviceDtoCopyWith<$Res> {
  __$IosDeviceDtoCopyWithImpl(this._self, this._then);

  final _IosDeviceDto _self;
  final $Res Function(_IosDeviceDto) _then;

/// Create a copy of IosDeviceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serialNumber = null,Object? productName = freezed,}) {
  return _then(_IosDeviceDto(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
