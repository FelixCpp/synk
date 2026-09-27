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

 AndroidDevice get device; AndroidDeviceInfo get info; NativeTextureId get textureId; DeviceScreenSize get screenSize;
/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceConnectionCopyWith<DeviceConnection> get copyWith => _$DeviceConnectionCopyWithImpl<DeviceConnection>(this as DeviceConnection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceConnection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceConnection&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.info, _this.info) || other.info == _this.info)&&(identical(other.textureId, _this.textureId) || other.textureId == _this.textureId)&&(identical(other.screenSize, _this.screenSize) || other.screenSize == _this.screenSize));
}


@override
int get hashCode {
  final _this = this as DeviceConnection;
  return Object.hash(runtimeType,_this.device,_this.info,_this.textureId,_this.screenSize);
}

@override
String toString() {
  final _this = this as DeviceConnection;
  return 'DeviceConnection(device: ${_this.device}, info: ${_this.info}, textureId: ${_this.textureId}, screenSize: ${_this.screenSize})';
}


}

/// @nodoc
abstract mixin class $DeviceConnectionCopyWith<$Res>  {
  factory $DeviceConnectionCopyWith(DeviceConnection value, $Res Function(DeviceConnection) _then) = _$DeviceConnectionCopyWithImpl;
@useResult
$Res call({
 AndroidDevice device, AndroidDeviceInfo info, NativeTextureId textureId, DeviceScreenSize screenSize
});


$AndroidDeviceCopyWith<$Res> get device;$AndroidDeviceInfoCopyWith<$Res> get info;$DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class _$DeviceConnectionCopyWithImpl<$Res>
    implements $DeviceConnectionCopyWith<$Res> {
  _$DeviceConnectionCopyWithImpl(this._self, this._then);

  final DeviceConnection _self;
  final $Res Function(DeviceConnection) _then;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? info = null,Object? textureId = null,Object? screenSize = null,}) {
  return _then(DeviceConnection.android(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as AndroidDeviceInfo,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,
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
}/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceScreenSizeCopyWith<$Res> get screenSize {
  
  return $DeviceScreenSizeCopyWith<$Res>(_self.screenSize, (value) {
    return _then(_self.copyWith(screenSize: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( AndroidDevice device,  AndroidDeviceInfo info,  NativeTextureId textureId,  DeviceScreenSize screenSize)?  android,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AndroidDeviceConnection() when android != null:
return android(_that.device,_that.info,_that.textureId,_that.screenSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( AndroidDevice device,  AndroidDeviceInfo info,  NativeTextureId textureId,  DeviceScreenSize screenSize)  android,}) {final _that = this;
switch (_that) {
case _AndroidDeviceConnection():
return android(_that.device,_that.info,_that.textureId,_that.screenSize);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( AndroidDevice device,  AndroidDeviceInfo info,  NativeTextureId textureId,  DeviceScreenSize screenSize)?  android,}) {final _that = this;
switch (_that) {
case _AndroidDeviceConnection() when android != null:
return android(_that.device,_that.info,_that.textureId,_that.screenSize);case _:
  return null;

}
}

}

/// @nodoc


class _AndroidDeviceConnection implements DeviceConnection {
  const _AndroidDeviceConnection({required this.device, required this.info, required this.textureId, required this.screenSize});
  

@override final  AndroidDevice device;
@override final  AndroidDeviceInfo info;
@override final  NativeTextureId textureId;
@override final  DeviceScreenSize screenSize;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AndroidDeviceConnectionCopyWith<_AndroidDeviceConnection> get copyWith => __$AndroidDeviceConnectionCopyWithImpl<_AndroidDeviceConnection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AndroidDeviceConnection&&(identical(other.device, device) || other.device == device)&&(identical(other.info, info) || other.info == info)&&(identical(other.textureId, textureId) || other.textureId == textureId)&&(identical(other.screenSize, screenSize) || other.screenSize == screenSize));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,info,textureId,screenSize);
}

@override
String toString() {
    return 'DeviceConnection.android(device: $device, info: $info, textureId: $textureId, screenSize: $screenSize)';
}


}

/// @nodoc
abstract mixin class _$AndroidDeviceConnectionCopyWith<$Res> implements $DeviceConnectionCopyWith<$Res> {
  factory _$AndroidDeviceConnectionCopyWith(_AndroidDeviceConnection value, $Res Function(_AndroidDeviceConnection) _then) = __$AndroidDeviceConnectionCopyWithImpl;
@override @useResult
$Res call({
 AndroidDevice device, AndroidDeviceInfo info, NativeTextureId textureId, DeviceScreenSize screenSize
});


@override $AndroidDeviceCopyWith<$Res> get device;@override $AndroidDeviceInfoCopyWith<$Res> get info;@override $DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class __$AndroidDeviceConnectionCopyWithImpl<$Res>
    implements _$AndroidDeviceConnectionCopyWith<$Res> {
  __$AndroidDeviceConnectionCopyWithImpl(this._self, this._then);

  final _AndroidDeviceConnection _self;
  final $Res Function(_AndroidDeviceConnection) _then;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? info = null,Object? textureId = null,Object? screenSize = null,}) {
  return _then(_AndroidDeviceConnection(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as AndroidDeviceInfo,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,
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
}/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceScreenSizeCopyWith<$Res> get screenSize {
  
  return $DeviceScreenSizeCopyWith<$Res>(_self.screenSize, (value) {
    return _then(_self.copyWith(screenSize: value));
  });
}
}

// dart format on
