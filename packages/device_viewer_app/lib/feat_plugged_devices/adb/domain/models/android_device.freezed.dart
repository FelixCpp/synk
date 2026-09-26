// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'android_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AndroidDevice {

 DeviceId get id; String get modelName; AndroidDeviceState get state; AndroidDeviceConnection get connection;
/// Create a copy of AndroidDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AndroidDeviceCopyWith<AndroidDevice> get copyWith => _$AndroidDeviceCopyWithImpl<AndroidDevice>(this as AndroidDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AndroidDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AndroidDevice&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.modelName, _this.modelName) || other.modelName == _this.modelName)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.connection, _this.connection) || other.connection == _this.connection));
}


@override
int get hashCode {
  final _this = this as AndroidDevice;
  return Object.hash(runtimeType,_this.id,_this.modelName,_this.state,_this.connection);
}

@override
String toString() {
  final _this = this as AndroidDevice;
  return 'AndroidDevice(id: ${_this.id}, modelName: ${_this.modelName}, state: ${_this.state}, connection: ${_this.connection})';
}


}

/// @nodoc
abstract mixin class $AndroidDeviceCopyWith<$Res>  {
  factory $AndroidDeviceCopyWith(AndroidDevice value, $Res Function(AndroidDevice) _then) = _$AndroidDeviceCopyWithImpl;
@useResult
$Res call({
 DeviceId id, String modelName, AndroidDeviceState state, AndroidDeviceConnection connection
});




}
/// @nodoc
class _$AndroidDeviceCopyWithImpl<$Res>
    implements $AndroidDeviceCopyWith<$Res> {
  _$AndroidDeviceCopyWithImpl(this._self, this._then);

  final AndroidDevice _self;
  final $Res Function(AndroidDevice) _then;

/// Create a copy of AndroidDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? modelName = null,Object? state = null,Object? connection = null,}) {
  return _then(AndroidDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AndroidDeviceState,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as AndroidDeviceConnection,
  ));
}

}


/// Adds pattern-matching-related methods to [AndroidDevice].
extension AndroidDevicePatterns on AndroidDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AndroidDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AndroidDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AndroidDevice value)  $default,){
final _that = this;
switch (_that) {
case _AndroidDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AndroidDevice value)?  $default,){
final _that = this;
switch (_that) {
case _AndroidDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceId id,  String modelName,  AndroidDeviceState state,  AndroidDeviceConnection connection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AndroidDevice() when $default != null:
return $default(_that.id,_that.modelName,_that.state,_that.connection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceId id,  String modelName,  AndroidDeviceState state,  AndroidDeviceConnection connection)  $default,) {final _that = this;
switch (_that) {
case _AndroidDevice():
return $default(_that.id,_that.modelName,_that.state,_that.connection);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceId id,  String modelName,  AndroidDeviceState state,  AndroidDeviceConnection connection)?  $default,) {final _that = this;
switch (_that) {
case _AndroidDevice() when $default != null:
return $default(_that.id,_that.modelName,_that.state,_that.connection);case _:
  return null;

}
}

}

/// @nodoc


class _AndroidDevice implements AndroidDevice {
  const _AndroidDevice({required this.id, required this.modelName, required this.state, required this.connection});
  

@override final  DeviceId id;
@override final  String modelName;
@override final  AndroidDeviceState state;
@override final  AndroidDeviceConnection connection;

/// Create a copy of AndroidDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AndroidDeviceCopyWith<_AndroidDevice> get copyWith => __$AndroidDeviceCopyWithImpl<_AndroidDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AndroidDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.state, state) || other.state == state)&&(identical(other.connection, connection) || other.connection == connection));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,modelName,state,connection);
}

@override
String toString() {
    return 'AndroidDevice(id: $id, modelName: $modelName, state: $state, connection: $connection)';
}


}

/// @nodoc
abstract mixin class _$AndroidDeviceCopyWith<$Res> implements $AndroidDeviceCopyWith<$Res> {
  factory _$AndroidDeviceCopyWith(_AndroidDevice value, $Res Function(_AndroidDevice) _then) = __$AndroidDeviceCopyWithImpl;
@override @useResult
$Res call({
 DeviceId id, String modelName, AndroidDeviceState state, AndroidDeviceConnection connection
});




}
/// @nodoc
class __$AndroidDeviceCopyWithImpl<$Res>
    implements _$AndroidDeviceCopyWith<$Res> {
  __$AndroidDeviceCopyWithImpl(this._self, this._then);

  final _AndroidDevice _self;
  final $Res Function(_AndroidDevice) _then;

/// Create a copy of AndroidDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? modelName = null,Object? state = null,Object? connection = null,}) {
  return _then(_AndroidDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AndroidDeviceState,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as AndroidDeviceConnection,
  ));
}


}

// dart format on
