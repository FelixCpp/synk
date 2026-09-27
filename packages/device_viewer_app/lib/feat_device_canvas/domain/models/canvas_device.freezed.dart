// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canvas_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CanvasDevice {

 AndroidDevice get device;
/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CanvasDeviceCopyWith<CanvasDevice> get copyWith => _$CanvasDeviceCopyWithImpl<CanvasDevice>(this as CanvasDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CanvasDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CanvasDevice&&(identical(other.device, _this.device) || other.device == _this.device));
}


@override
int get hashCode {
  final _this = this as CanvasDevice;
  return Object.hash(runtimeType,_this.device);
}

@override
String toString() {
  final _this = this as CanvasDevice;
  return 'CanvasDevice(device: ${_this.device})';
}


}

/// @nodoc
abstract mixin class $CanvasDeviceCopyWith<$Res>  {
  factory $CanvasDeviceCopyWith(CanvasDevice value, $Res Function(CanvasDevice) _then) = _$CanvasDeviceCopyWithImpl;
@useResult
$Res call({
 AndroidDevice device
});


$AndroidDeviceCopyWith<$Res> get device;

}
/// @nodoc
class _$CanvasDeviceCopyWithImpl<$Res>
    implements $CanvasDeviceCopyWith<$Res> {
  _$CanvasDeviceCopyWithImpl(this._self, this._then);

  final CanvasDevice _self;
  final $Res Function(CanvasDevice) _then;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,}) {
  return _then(_self.copyWith(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,
  ));
}
/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceCopyWith<$Res> get device {
  
  return $AndroidDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [CanvasDevice].
extension CanvasDevicePatterns on CanvasDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AndroidCanvasDevice value)?  android,TResult Function( _ConnectingCanvasDevice value)?  connecting,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AndroidCanvasDevice() when android != null:
return android(_that);case _ConnectingCanvasDevice() when connecting != null:
return connecting(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AndroidCanvasDevice value)  android,required TResult Function( _ConnectingCanvasDevice value)  connecting,}){
final _that = this;
switch (_that) {
case _AndroidCanvasDevice():
return android(_that);case _ConnectingCanvasDevice():
return connecting(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AndroidCanvasDevice value)?  android,TResult? Function( _ConnectingCanvasDevice value)?  connecting,}){
final _that = this;
switch (_that) {
case _AndroidCanvasDevice() when android != null:
return android(_that);case _ConnectingCanvasDevice() when connecting != null:
return connecting(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( AndroidDevice device,  bool isConnected,  NativeTextureId textureId,  DeviceScreenSize screenSize)?  android,TResult Function( AndroidDevice device)?  connecting,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AndroidCanvasDevice() when android != null:
return android(_that.device,_that.isConnected,_that.textureId,_that.screenSize);case _ConnectingCanvasDevice() when connecting != null:
return connecting(_that.device);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( AndroidDevice device,  bool isConnected,  NativeTextureId textureId,  DeviceScreenSize screenSize)  android,required TResult Function( AndroidDevice device)  connecting,}) {final _that = this;
switch (_that) {
case _AndroidCanvasDevice():
return android(_that.device,_that.isConnected,_that.textureId,_that.screenSize);case _ConnectingCanvasDevice():
return connecting(_that.device);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( AndroidDevice device,  bool isConnected,  NativeTextureId textureId,  DeviceScreenSize screenSize)?  android,TResult? Function( AndroidDevice device)?  connecting,}) {final _that = this;
switch (_that) {
case _AndroidCanvasDevice() when android != null:
return android(_that.device,_that.isConnected,_that.textureId,_that.screenSize);case _ConnectingCanvasDevice() when connecting != null:
return connecting(_that.device);case _:
  return null;

}
}

}

/// @nodoc


class _AndroidCanvasDevice implements CanvasDevice {
  const _AndroidCanvasDevice({required this.device, required this.isConnected, required this.textureId, required this.screenSize});
  

@override final  AndroidDevice device;
 final  bool isConnected;
 final  NativeTextureId textureId;
/// Shape the mirror has to be drawn in. Devices differ widely here
/// (9:19.5, 9:20, tablets), so the frame follows this instead of
/// assuming a ratio.
 final  DeviceScreenSize screenSize;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AndroidCanvasDeviceCopyWith<_AndroidCanvasDevice> get copyWith => __$AndroidCanvasDeviceCopyWithImpl<_AndroidCanvasDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AndroidCanvasDevice&&(identical(other.device, device) || other.device == device)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.textureId, textureId) || other.textureId == textureId)&&(identical(other.screenSize, screenSize) || other.screenSize == screenSize));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,isConnected,textureId,screenSize);
}

@override
String toString() {
    return 'CanvasDevice.android(device: $device, isConnected: $isConnected, textureId: $textureId, screenSize: $screenSize)';
}


}

/// @nodoc
abstract mixin class _$AndroidCanvasDeviceCopyWith<$Res> implements $CanvasDeviceCopyWith<$Res> {
  factory _$AndroidCanvasDeviceCopyWith(_AndroidCanvasDevice value, $Res Function(_AndroidCanvasDevice) _then) = __$AndroidCanvasDeviceCopyWithImpl;
@override @useResult
$Res call({
 AndroidDevice device, bool isConnected, NativeTextureId textureId, DeviceScreenSize screenSize
});


@override $AndroidDeviceCopyWith<$Res> get device;$DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class __$AndroidCanvasDeviceCopyWithImpl<$Res>
    implements _$AndroidCanvasDeviceCopyWith<$Res> {
  __$AndroidCanvasDeviceCopyWithImpl(this._self, this._then);

  final _AndroidCanvasDevice _self;
  final $Res Function(_AndroidCanvasDevice) _then;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? isConnected = null,Object? textureId = null,Object? screenSize = null,}) {
  return _then(_AndroidCanvasDevice(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,
  ));
}

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceCopyWith<$Res> get device {
  
  return $AndroidDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}/// Create a copy of CanvasDevice
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


class _ConnectingCanvasDevice implements CanvasDevice {
  const _ConnectingCanvasDevice({required this.device});
  

@override final  AndroidDevice device;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectingCanvasDeviceCopyWith<_ConnectingCanvasDevice> get copyWith => __$ConnectingCanvasDeviceCopyWithImpl<_ConnectingCanvasDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectingCanvasDevice&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device);
}

@override
String toString() {
    return 'CanvasDevice.connecting(device: $device)';
}


}

/// @nodoc
abstract mixin class _$ConnectingCanvasDeviceCopyWith<$Res> implements $CanvasDeviceCopyWith<$Res> {
  factory _$ConnectingCanvasDeviceCopyWith(_ConnectingCanvasDevice value, $Res Function(_ConnectingCanvasDevice) _then) = __$ConnectingCanvasDeviceCopyWithImpl;
@override @useResult
$Res call({
 AndroidDevice device
});


@override $AndroidDeviceCopyWith<$Res> get device;

}
/// @nodoc
class __$ConnectingCanvasDeviceCopyWithImpl<$Res>
    implements _$ConnectingCanvasDeviceCopyWith<$Res> {
  __$ConnectingCanvasDeviceCopyWithImpl(this._self, this._then);

  final _ConnectingCanvasDevice _self;
  final $Res Function(_ConnectingCanvasDevice) _then;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,}) {
  return _then(_ConnectingCanvasDevice(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,
  ));
}

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceCopyWith<$Res> get device {
  
  return $AndroidDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

// dart format on
