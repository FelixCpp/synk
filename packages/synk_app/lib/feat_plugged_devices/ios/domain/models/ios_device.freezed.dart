// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ios_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IosDevice {

 DeviceId get id; String get modelName;
/// Create a copy of IosDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IosDeviceCopyWith<IosDevice> get copyWith => _$IosDeviceCopyWithImpl<IosDevice>(this as IosDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as IosDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IosDevice&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.modelName, _this.modelName) || other.modelName == _this.modelName));
}


@override
int get hashCode {
  final _this = this as IosDevice;
  return Object.hash(runtimeType,_this.id,_this.modelName);
}

@override
String toString() {
  final _this = this as IosDevice;
  return 'IosDevice(id: ${_this.id}, modelName: ${_this.modelName})';
}


}

/// @nodoc
abstract mixin class $IosDeviceCopyWith<$Res>  {
  factory $IosDeviceCopyWith(IosDevice value, $Res Function(IosDevice) _then) = _$IosDeviceCopyWithImpl;
@useResult
$Res call({
 DeviceId id, String modelName
});




}
/// @nodoc
class _$IosDeviceCopyWithImpl<$Res>
    implements $IosDeviceCopyWith<$Res> {
  _$IosDeviceCopyWithImpl(this._self, this._then);

  final IosDevice _self;
  final $Res Function(IosDevice) _then;

/// Create a copy of IosDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? modelName = null,}) {
  return _then(IosDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IosDevice].
extension IosDevicePatterns on IosDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IosDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IosDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IosDevice value)  $default,){
final _that = this;
switch (_that) {
case _IosDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IosDevice value)?  $default,){
final _that = this;
switch (_that) {
case _IosDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceId id,  String modelName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IosDevice() when $default != null:
return $default(_that.id,_that.modelName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceId id,  String modelName)  $default,) {final _that = this;
switch (_that) {
case _IosDevice():
return $default(_that.id,_that.modelName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceId id,  String modelName)?  $default,) {final _that = this;
switch (_that) {
case _IosDevice() when $default != null:
return $default(_that.id,_that.modelName);case _:
  return null;

}
}

}

/// @nodoc


class _IosDevice extends IosDevice {
  const _IosDevice({required this.id, required this.modelName}): super._();
  

@override final  DeviceId id;
@override final  String modelName;

/// Create a copy of IosDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IosDeviceCopyWith<_IosDevice> get copyWith => __$IosDeviceCopyWithImpl<_IosDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IosDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.modelName, modelName) || other.modelName == modelName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,modelName);
}

@override
String toString() {
    return 'IosDevice(id: $id, modelName: $modelName)';
}


}

/// @nodoc
abstract mixin class _$IosDeviceCopyWith<$Res> implements $IosDeviceCopyWith<$Res> {
  factory _$IosDeviceCopyWith(_IosDevice value, $Res Function(_IosDevice) _then) = __$IosDeviceCopyWithImpl;
@override @useResult
$Res call({
 DeviceId id, String modelName
});




}
/// @nodoc
class __$IosDeviceCopyWithImpl<$Res>
    implements _$IosDeviceCopyWith<$Res> {
  __$IosDeviceCopyWithImpl(this._self, this._then);

  final _IosDevice _self;
  final $Res Function(_IosDevice) _then;

/// Create a copy of IosDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? modelName = null,}) {
  return _then(_IosDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
