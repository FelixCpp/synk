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

 AndroidDeviceId get id; AndroidDeviceState get state; AndroidDeviceConnection get connection; AndroidDeviceInfo get info;
/// Create a copy of AdbDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbDeviceCopyWith<AdbDevice> get copyWith => _$AdbDeviceCopyWithImpl<AdbDevice>(this as AdbDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbDevice&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.connection, _this.connection) || other.connection == _this.connection)&&(identical(other.info, _this.info) || other.info == _this.info));
}


@override
int get hashCode {
  final _this = this as AdbDevice;
  return Object.hash(runtimeType,_this.id,_this.state,_this.connection,_this.info);
}

@override
String toString() {
  final _this = this as AdbDevice;
  return 'AdbDevice(id: ${_this.id}, state: ${_this.state}, connection: ${_this.connection}, info: ${_this.info})';
}


}

/// @nodoc
abstract mixin class $AdbDeviceCopyWith<$Res>  {
  factory $AdbDeviceCopyWith(AdbDevice value, $Res Function(AdbDevice) _then) = _$AdbDeviceCopyWithImpl;
@useResult
$Res call({
 AndroidDeviceId id, AndroidDeviceState state, AndroidDeviceConnection connection, AndroidDeviceInfo info
});


$AndroidDeviceInfoCopyWith<$Res> get info;

}
/// @nodoc
class _$AdbDeviceCopyWithImpl<$Res>
    implements $AdbDeviceCopyWith<$Res> {
  _$AdbDeviceCopyWithImpl(this._self, this._then);

  final AdbDevice _self;
  final $Res Function(AdbDevice) _then;

/// Create a copy of AdbDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? state = null,Object? connection = null,Object? info = null,}) {
  return _then(AdbDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as AndroidDeviceId,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AndroidDeviceState,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as AndroidDeviceConnection,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as AndroidDeviceInfo,
  ));
}
/// Create a copy of AdbDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceInfoCopyWith<$Res> get info {
  
  return $AndroidDeviceInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AndroidDeviceId id,  AndroidDeviceState state,  AndroidDeviceConnection connection,  AndroidDeviceInfo info)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdbDevice() when $default != null:
return $default(_that.id,_that.state,_that.connection,_that.info);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AndroidDeviceId id,  AndroidDeviceState state,  AndroidDeviceConnection connection,  AndroidDeviceInfo info)  $default,) {final _that = this;
switch (_that) {
case _AdbDevice():
return $default(_that.id,_that.state,_that.connection,_that.info);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AndroidDeviceId id,  AndroidDeviceState state,  AndroidDeviceConnection connection,  AndroidDeviceInfo info)?  $default,) {final _that = this;
switch (_that) {
case _AdbDevice() when $default != null:
return $default(_that.id,_that.state,_that.connection,_that.info);case _:
  return null;

}
}

}

/// @nodoc


class _AdbDevice implements AdbDevice {
  const _AdbDevice({required this.id, required this.state, required this.connection, required this.info});
  

@override final  AndroidDeviceId id;
@override final  AndroidDeviceState state;
@override final  AndroidDeviceConnection connection;
@override final  AndroidDeviceInfo info;

/// Create a copy of AdbDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdbDeviceCopyWith<_AdbDevice> get copyWith => __$AdbDeviceCopyWithImpl<_AdbDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdbDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.state, state) || other.state == state)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.info, info) || other.info == info));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,state,connection,info);
}

@override
String toString() {
    return 'AdbDevice(id: $id, state: $state, connection: $connection, info: $info)';
}


}

/// @nodoc
abstract mixin class _$AdbDeviceCopyWith<$Res> implements $AdbDeviceCopyWith<$Res> {
  factory _$AdbDeviceCopyWith(_AdbDevice value, $Res Function(_AdbDevice) _then) = __$AdbDeviceCopyWithImpl;
@override @useResult
$Res call({
 AndroidDeviceId id, AndroidDeviceState state, AndroidDeviceConnection connection, AndroidDeviceInfo info
});


@override $AndroidDeviceInfoCopyWith<$Res> get info;

}
/// @nodoc
class __$AdbDeviceCopyWithImpl<$Res>
    implements _$AdbDeviceCopyWith<$Res> {
  __$AdbDeviceCopyWithImpl(this._self, this._then);

  final _AdbDevice _self;
  final $Res Function(_AdbDevice) _then;

/// Create a copy of AdbDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? state = null,Object? connection = null,Object? info = null,}) {
  return _then(_AdbDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as AndroidDeviceId,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AndroidDeviceState,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as AndroidDeviceConnection,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as AndroidDeviceInfo,
  ));
}

/// Create a copy of AdbDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceInfoCopyWith<$Res> get info {
  
  return $AndroidDeviceInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}

// dart format on
