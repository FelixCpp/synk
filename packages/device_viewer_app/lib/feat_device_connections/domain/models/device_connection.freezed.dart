// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceConnection {

 AndroidDevice get device; AndroidDeviceInfo get info; NativeTextureId get textureId;
/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceConnectionCopyWith<DeviceConnection> get copyWith => _$DeviceConnectionCopyWithImpl<DeviceConnection>(this as DeviceConnection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceConnection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceConnection&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.info, _this.info) || other.info == _this.info)&&(identical(other.textureId, _this.textureId) || other.textureId == _this.textureId));
}


@override
int get hashCode {
  final _this = this as DeviceConnection;
  return Object.hash(runtimeType,_this.device,_this.info,_this.textureId);
}

@override
String toString() {
  final _this = this as DeviceConnection;
  return 'DeviceConnection(device: ${_this.device}, info: ${_this.info}, textureId: ${_this.textureId})';
}


}

/// @nodoc
abstract mixin class $DeviceConnectionCopyWith<$Res>  {
  factory $DeviceConnectionCopyWith(DeviceConnection value, $Res Function(DeviceConnection) _then) = _$DeviceConnectionCopyWithImpl;
@useResult
$Res call({
 AndroidDevice device, AndroidDeviceInfo info, NativeTextureId textureId
});


$AndroidDeviceCopyWith<$Res> get device;$AndroidDeviceInfoCopyWith<$Res> get info;

}
/// @nodoc
class _$DeviceConnectionCopyWithImpl<$Res>
    implements $DeviceConnectionCopyWith<$Res> {
  _$DeviceConnectionCopyWithImpl(this._self, this._then);

  final DeviceConnection _self;
  final $Res Function(DeviceConnection) _then;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? info = null,Object? textureId = null,}) {
  return _then(DeviceConnection.android(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as AndroidDeviceInfo,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,
  ));
}
/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceCopyWith<$Res> get device {
  
  return $AndroidDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceInfoCopyWith<$Res> get info {
  
  return $AndroidDeviceInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeviceConnection].
extension DeviceConnectionPatterns on DeviceConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AndroidDeviceConnection value)?  android,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AndroidDeviceConnection() when android != null:
return android(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AndroidDeviceConnection value)  android,}){
final _that = this;
switch (_that) {
case _AndroidDeviceConnection():
return android(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AndroidDeviceConnection value)?  android,}){
final _that = this;
switch (_that) {
case _AndroidDeviceConnection() when android != null:
return android(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( AndroidDevice device,  AndroidDeviceInfo info,  NativeTextureId textureId)?  android,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AndroidDeviceConnection() when android != null:
return android(_that.device,_that.info,_that.textureId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( AndroidDevice device,  AndroidDeviceInfo info,  NativeTextureId textureId)  android,}) {final _that = this;
switch (_that) {
case _AndroidDeviceConnection():
return android(_that.device,_that.info,_that.textureId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( AndroidDevice device,  AndroidDeviceInfo info,  NativeTextureId textureId)?  android,}) {final _that = this;
switch (_that) {
case _AndroidDeviceConnection() when android != null:
return android(_that.device,_that.info,_that.textureId);case _:
  return null;

}
}

}

/// @nodoc


class _AndroidDeviceConnection implements DeviceConnection {
  const _AndroidDeviceConnection({required this.device, required this.info, required this.textureId});
  

@override final  AndroidDevice device;
@override final  AndroidDeviceInfo info;
@override final  NativeTextureId textureId;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AndroidDeviceConnectionCopyWith<_AndroidDeviceConnection> get copyWith => __$AndroidDeviceConnectionCopyWithImpl<_AndroidDeviceConnection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AndroidDeviceConnection&&(identical(other.device, device) || other.device == device)&&(identical(other.info, info) || other.info == info)&&(identical(other.textureId, textureId) || other.textureId == textureId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,info,textureId);
}

@override
String toString() {
    return 'DeviceConnection.android(device: $device, info: $info, textureId: $textureId)';
}


}

/// @nodoc
abstract mixin class _$AndroidDeviceConnectionCopyWith<$Res> implements $DeviceConnectionCopyWith<$Res> {
  factory _$AndroidDeviceConnectionCopyWith(_AndroidDeviceConnection value, $Res Function(_AndroidDeviceConnection) _then) = __$AndroidDeviceConnectionCopyWithImpl;
@override @useResult
$Res call({
 AndroidDevice device, AndroidDeviceInfo info, NativeTextureId textureId
});


@override $AndroidDeviceCopyWith<$Res> get device;@override $AndroidDeviceInfoCopyWith<$Res> get info;

}
/// @nodoc
class __$AndroidDeviceConnectionCopyWithImpl<$Res>
    implements _$AndroidDeviceConnectionCopyWith<$Res> {
  __$AndroidDeviceConnectionCopyWithImpl(this._self, this._then);

  final _AndroidDeviceConnection _self;
  final $Res Function(_AndroidDeviceConnection) _then;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? info = null,Object? textureId = null,}) {
  return _then(_AndroidDeviceConnection(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as AndroidDeviceInfo,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,
  ));
}

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceCopyWith<$Res> get device {
  
  return $AndroidDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}/// Create a copy of DeviceConnection
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
