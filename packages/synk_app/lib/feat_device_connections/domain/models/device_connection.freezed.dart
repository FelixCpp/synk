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

 PluggedDevice get device; NativeTextureId get textureId; DeviceScreenSize get screenSize; bool get supportsInteraction;
/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceConnectionCopyWith<DeviceConnection> get copyWith => _$DeviceConnectionCopyWithImpl<DeviceConnection>(this as DeviceConnection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceConnection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceConnection&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.textureId, _this.textureId) || other.textureId == _this.textureId)&&(identical(other.screenSize, _this.screenSize) || other.screenSize == _this.screenSize)&&(identical(other.supportsInteraction, _this.supportsInteraction) || other.supportsInteraction == _this.supportsInteraction));
}


@override
int get hashCode {
  final _this = this as DeviceConnection;
  return Object.hash(runtimeType,_this.device,_this.textureId,_this.screenSize,_this.supportsInteraction);
}

@override
String toString() {
  final _this = this as DeviceConnection;
  return 'DeviceConnection(device: ${_this.device}, textureId: ${_this.textureId}, screenSize: ${_this.screenSize}, supportsInteraction: ${_this.supportsInteraction})';
}


}

/// @nodoc
abstract mixin class $DeviceConnectionCopyWith<$Res>  {
  factory $DeviceConnectionCopyWith(DeviceConnection value, $Res Function(DeviceConnection) _then) = _$DeviceConnectionCopyWithImpl;
@useResult
$Res call({
 PluggedDevice device, NativeTextureId textureId, DeviceScreenSize screenSize, bool supportsInteraction
});


$DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class _$DeviceConnectionCopyWithImpl<$Res>
    implements $DeviceConnectionCopyWith<$Res> {
  _$DeviceConnectionCopyWithImpl(this._self, this._then);

  final DeviceConnection _self;
  final $Res Function(DeviceConnection) _then;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? textureId = null,Object? screenSize = null,Object? supportsInteraction = null,}) {
  return _then(_self.copyWith(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PluggedDevice,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,supportsInteraction: null == supportsInteraction ? _self.supportsInteraction : supportsInteraction // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DeviceConnection
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AndroidDeviceConnection value)?  android,TResult Function( _IosDeviceConnection value)?  ios,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AndroidDeviceConnection() when android != null:
return android(_that);case _IosDeviceConnection() when ios != null:
return ios(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AndroidDeviceConnection value)  android,required TResult Function( _IosDeviceConnection value)  ios,}){
final _that = this;
switch (_that) {
case _AndroidDeviceConnection():
return android(_that);case _IosDeviceConnection():
return ios(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AndroidDeviceConnection value)?  android,TResult? Function( _IosDeviceConnection value)?  ios,}){
final _that = this;
switch (_that) {
case _AndroidDeviceConnection() when android != null:
return android(_that);case _IosDeviceConnection() when ios != null:
return ios(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PluggedDevice device,  AndroidDeviceInfo info,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction)?  android,TResult Function( PluggedDevice device,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction)?  ios,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AndroidDeviceConnection() when android != null:
return android(_that.device,_that.info,_that.textureId,_that.screenSize,_that.supportsInteraction);case _IosDeviceConnection() when ios != null:
return ios(_that.device,_that.textureId,_that.screenSize,_that.supportsInteraction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PluggedDevice device,  AndroidDeviceInfo info,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction)  android,required TResult Function( PluggedDevice device,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction)  ios,}) {final _that = this;
switch (_that) {
case _AndroidDeviceConnection():
return android(_that.device,_that.info,_that.textureId,_that.screenSize,_that.supportsInteraction);case _IosDeviceConnection():
return ios(_that.device,_that.textureId,_that.screenSize,_that.supportsInteraction);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PluggedDevice device,  AndroidDeviceInfo info,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction)?  android,TResult? Function( PluggedDevice device,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction)?  ios,}) {final _that = this;
switch (_that) {
case _AndroidDeviceConnection() when android != null:
return android(_that.device,_that.info,_that.textureId,_that.screenSize,_that.supportsInteraction);case _IosDeviceConnection() when ios != null:
return ios(_that.device,_that.textureId,_that.screenSize,_that.supportsInteraction);case _:
  return null;

}
}

}

/// @nodoc


class _AndroidDeviceConnection implements DeviceConnection {
  const _AndroidDeviceConnection({required this.device, required this.info, required this.textureId, required this.screenSize, required this.supportsInteraction});
  

@override final  PluggedDevice device;
 final  AndroidDeviceInfo info;
@override final  NativeTextureId textureId;
@override final  DeviceScreenSize screenSize;
@override final  bool supportsInteraction;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AndroidDeviceConnectionCopyWith<_AndroidDeviceConnection> get copyWith => __$AndroidDeviceConnectionCopyWithImpl<_AndroidDeviceConnection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AndroidDeviceConnection&&(identical(other.device, device) || other.device == device)&&(identical(other.info, info) || other.info == info)&&(identical(other.textureId, textureId) || other.textureId == textureId)&&(identical(other.screenSize, screenSize) || other.screenSize == screenSize)&&(identical(other.supportsInteraction, supportsInteraction) || other.supportsInteraction == supportsInteraction));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,info,textureId,screenSize,supportsInteraction);
}

@override
String toString() {
    return 'DeviceConnection.android(device: $device, info: $info, textureId: $textureId, screenSize: $screenSize, supportsInteraction: $supportsInteraction)';
}


}

/// @nodoc
abstract mixin class _$AndroidDeviceConnectionCopyWith<$Res> implements $DeviceConnectionCopyWith<$Res> {
  factory _$AndroidDeviceConnectionCopyWith(_AndroidDeviceConnection value, $Res Function(_AndroidDeviceConnection) _then) = __$AndroidDeviceConnectionCopyWithImpl;
@override @useResult
$Res call({
 PluggedDevice device, AndroidDeviceInfo info, NativeTextureId textureId, DeviceScreenSize screenSize, bool supportsInteraction
});


$AndroidDeviceInfoCopyWith<$Res> get info;@override $DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class __$AndroidDeviceConnectionCopyWithImpl<$Res>
    implements _$AndroidDeviceConnectionCopyWith<$Res> {
  __$AndroidDeviceConnectionCopyWithImpl(this._self, this._then);

  final _AndroidDeviceConnection _self;
  final $Res Function(_AndroidDeviceConnection) _then;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? info = null,Object? textureId = null,Object? screenSize = null,Object? supportsInteraction = null,}) {
  return _then(_AndroidDeviceConnection(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PluggedDevice,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as AndroidDeviceInfo,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,supportsInteraction: null == supportsInteraction ? _self.supportsInteraction : supportsInteraction // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DeviceConnection
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

/// @nodoc


class _IosDeviceConnection implements DeviceConnection {
  const _IosDeviceConnection({required this.device, required this.textureId, required this.screenSize, required this.supportsInteraction});
  

@override final  PluggedDevice device;
@override final  NativeTextureId textureId;
@override final  DeviceScreenSize screenSize;
@override final  bool supportsInteraction;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IosDeviceConnectionCopyWith<_IosDeviceConnection> get copyWith => __$IosDeviceConnectionCopyWithImpl<_IosDeviceConnection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IosDeviceConnection&&(identical(other.device, device) || other.device == device)&&(identical(other.textureId, textureId) || other.textureId == textureId)&&(identical(other.screenSize, screenSize) || other.screenSize == screenSize)&&(identical(other.supportsInteraction, supportsInteraction) || other.supportsInteraction == supportsInteraction));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,textureId,screenSize,supportsInteraction);
}

@override
String toString() {
    return 'DeviceConnection.ios(device: $device, textureId: $textureId, screenSize: $screenSize, supportsInteraction: $supportsInteraction)';
}


}

/// @nodoc
abstract mixin class _$IosDeviceConnectionCopyWith<$Res> implements $DeviceConnectionCopyWith<$Res> {
  factory _$IosDeviceConnectionCopyWith(_IosDeviceConnection value, $Res Function(_IosDeviceConnection) _then) = __$IosDeviceConnectionCopyWithImpl;
@override @useResult
$Res call({
 PluggedDevice device, NativeTextureId textureId, DeviceScreenSize screenSize, bool supportsInteraction
});


@override $DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class __$IosDeviceConnectionCopyWithImpl<$Res>
    implements _$IosDeviceConnectionCopyWith<$Res> {
  __$IosDeviceConnectionCopyWithImpl(this._self, this._then);

  final _IosDeviceConnection _self;
  final $Res Function(_IosDeviceConnection) _then;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? textureId = null,Object? screenSize = null,Object? supportsInteraction = null,}) {
  return _then(_IosDeviceConnection(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PluggedDevice,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,supportsInteraction: null == supportsInteraction ? _self.supportsInteraction : supportsInteraction // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DeviceConnection
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
