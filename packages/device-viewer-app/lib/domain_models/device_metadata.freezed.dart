// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceMetadata {

 DeviceModelName get modelName; DeviceSerialNumber get serialNumber;
/// Create a copy of DeviceMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceMetadataCopyWith<DeviceMetadata> get copyWith => _$DeviceMetadataCopyWithImpl<DeviceMetadata>(this as DeviceMetadata, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceMetadata;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceMetadata&&(identical(other.modelName, _this.modelName) || other.modelName == _this.modelName)&&(identical(other.serialNumber, _this.serialNumber) || other.serialNumber == _this.serialNumber));
}


@override
int get hashCode {
  final _this = this as DeviceMetadata;
  return Object.hash(runtimeType,_this.modelName,_this.serialNumber);
}

@override
String toString() {
  final _this = this as DeviceMetadata;
  return 'DeviceMetadata(modelName: ${_this.modelName}, serialNumber: ${_this.serialNumber})';
}


}

/// @nodoc
abstract mixin class $DeviceMetadataCopyWith<$Res>  {
  factory $DeviceMetadataCopyWith(DeviceMetadata value, $Res Function(DeviceMetadata) _then) = _$DeviceMetadataCopyWithImpl;
@useResult
$Res call({
 DeviceModelName modelName, DeviceSerialNumber serialNumber
});




}
/// @nodoc
class _$DeviceMetadataCopyWithImpl<$Res>
    implements $DeviceMetadataCopyWith<$Res> {
  _$DeviceMetadataCopyWithImpl(this._self, this._then);

  final DeviceMetadata _self;
  final $Res Function(DeviceMetadata) _then;

/// Create a copy of DeviceMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? modelName = null,Object? serialNumber = null,}) {
  return _then(DeviceMetadata(
modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as DeviceModelName,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as DeviceSerialNumber,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceMetadata].
extension DeviceMetadataPatterns on DeviceMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceMetadata value)  $default,){
final _that = this;
switch (_that) {
case _DeviceMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceModelName modelName,  DeviceSerialNumber serialNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceMetadata() when $default != null:
return $default(_that.modelName,_that.serialNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceModelName modelName,  DeviceSerialNumber serialNumber)  $default,) {final _that = this;
switch (_that) {
case _DeviceMetadata():
return $default(_that.modelName,_that.serialNumber);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceModelName modelName,  DeviceSerialNumber serialNumber)?  $default,) {final _that = this;
switch (_that) {
case _DeviceMetadata() when $default != null:
return $default(_that.modelName,_that.serialNumber);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceMetadata implements DeviceMetadata {
  const _DeviceMetadata({required this.modelName, required this.serialNumber});
  

@override final  DeviceModelName modelName;
@override final  DeviceSerialNumber serialNumber;

/// Create a copy of DeviceMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceMetadataCopyWith<_DeviceMetadata> get copyWith => __$DeviceMetadataCopyWithImpl<_DeviceMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceMetadata&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber));
}


@override
int get hashCode {
    return Object.hash(runtimeType,modelName,serialNumber);
}

@override
String toString() {
    return 'DeviceMetadata(modelName: $modelName, serialNumber: $serialNumber)';
}


}

/// @nodoc
abstract mixin class _$DeviceMetadataCopyWith<$Res> implements $DeviceMetadataCopyWith<$Res> {
  factory _$DeviceMetadataCopyWith(_DeviceMetadata value, $Res Function(_DeviceMetadata) _then) = __$DeviceMetadataCopyWithImpl;
@override @useResult
$Res call({
 DeviceModelName modelName, DeviceSerialNumber serialNumber
});




}
/// @nodoc
class __$DeviceMetadataCopyWithImpl<$Res>
    implements _$DeviceMetadataCopyWith<$Res> {
  __$DeviceMetadataCopyWithImpl(this._self, this._then);

  final _DeviceMetadata _self;
  final $Res Function(_DeviceMetadata) _then;

/// Create a copy of DeviceMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? modelName = null,Object? serialNumber = null,}) {
  return _then(_DeviceMetadata(
modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as DeviceModelName,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as DeviceSerialNumber,
  ));
}


}

// dart format on
