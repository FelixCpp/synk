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

 PluggedDevice get device; NativeTextureId get textureId; DeviceScreenSize get screenSize; bool get supportsInteraction; bool get supportsDeviceActions; bool get supportsAudio;
/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CanvasDeviceCopyWith<CanvasDevice> get copyWith => _$CanvasDeviceCopyWithImpl<CanvasDevice>(this as CanvasDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CanvasDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CanvasDevice&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.textureId, _this.textureId) || other.textureId == _this.textureId)&&(identical(other.screenSize, _this.screenSize) || other.screenSize == _this.screenSize)&&(identical(other.supportsInteraction, _this.supportsInteraction) || other.supportsInteraction == _this.supportsInteraction)&&(identical(other.supportsDeviceActions, _this.supportsDeviceActions) || other.supportsDeviceActions == _this.supportsDeviceActions)&&(identical(other.supportsAudio, _this.supportsAudio) || other.supportsAudio == _this.supportsAudio));
}


@override
int get hashCode {
  final _this = this as CanvasDevice;
  return Object.hash(runtimeType,_this.device,_this.textureId,_this.screenSize,_this.supportsInteraction,_this.supportsDeviceActions,_this.supportsAudio);
}

@override
String toString() {
  final _this = this as CanvasDevice;
  return 'CanvasDevice(device: ${_this.device}, textureId: ${_this.textureId}, screenSize: ${_this.screenSize}, supportsInteraction: ${_this.supportsInteraction}, supportsDeviceActions: ${_this.supportsDeviceActions}, supportsAudio: ${_this.supportsAudio})';
}


}

/// @nodoc
abstract mixin class $CanvasDeviceCopyWith<$Res>  {
  factory $CanvasDeviceCopyWith(CanvasDevice value, $Res Function(CanvasDevice) _then) = _$CanvasDeviceCopyWithImpl;
@useResult
$Res call({
 PluggedDevice device, NativeTextureId textureId, DeviceScreenSize screenSize, bool supportsInteraction, bool supportsDeviceActions, bool supportsAudio
});


$DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class _$CanvasDeviceCopyWithImpl<$Res>
    implements $CanvasDeviceCopyWith<$Res> {
  _$CanvasDeviceCopyWithImpl(this._self, this._then);

  final CanvasDevice _self;
  final $Res Function(CanvasDevice) _then;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? textureId = null,Object? screenSize = null,Object? supportsInteraction = null,Object? supportsDeviceActions = null,Object? supportsAudio = null,}) {
  return _then(CanvasDevice(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PluggedDevice,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,supportsInteraction: null == supportsInteraction ? _self.supportsInteraction : supportsInteraction // ignore: cast_nullable_to_non_nullable
as bool,supportsDeviceActions: null == supportsDeviceActions ? _self.supportsDeviceActions : supportsDeviceActions // ignore: cast_nullable_to_non_nullable
as bool,supportsAudio: null == supportsAudio ? _self.supportsAudio : supportsAudio // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceScreenSizeCopyWith<$Res> get screenSize {
  
  return $DeviceScreenSizeCopyWith<$Res>(_self.screenSize, (value) {
    return _then(_self.copyWith(screenSize: value));
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectedCanvasDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectedCanvasDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectedCanvasDevice value)  $default,){
final _that = this;
switch (_that) {
case _ConnectedCanvasDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectedCanvasDevice value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectedCanvasDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PluggedDevice device,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction,  bool supportsDeviceActions,  bool supportsAudio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectedCanvasDevice() when $default != null:
return $default(_that.device,_that.textureId,_that.screenSize,_that.supportsInteraction,_that.supportsDeviceActions,_that.supportsAudio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PluggedDevice device,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction,  bool supportsDeviceActions,  bool supportsAudio)  $default,) {final _that = this;
switch (_that) {
case _ConnectedCanvasDevice():
return $default(_that.device,_that.textureId,_that.screenSize,_that.supportsInteraction,_that.supportsDeviceActions,_that.supportsAudio);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PluggedDevice device,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction,  bool supportsDeviceActions,  bool supportsAudio)?  $default,) {final _that = this;
switch (_that) {
case _ConnectedCanvasDevice() when $default != null:
return $default(_that.device,_that.textureId,_that.screenSize,_that.supportsInteraction,_that.supportsDeviceActions,_that.supportsAudio);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectedCanvasDevice implements CanvasDevice {
  const _ConnectedCanvasDevice({required this.device, required this.textureId, required this.screenSize, required this.supportsInteraction, required this.supportsDeviceActions, required this.supportsAudio});
  

@override final  PluggedDevice device;
@override final  NativeTextureId textureId;
@override final  DeviceScreenSize screenSize;
@override final  bool supportsInteraction;
@override final  bool supportsDeviceActions;
@override final  bool supportsAudio;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectedCanvasDeviceCopyWith<_ConnectedCanvasDevice> get copyWith => __$ConnectedCanvasDeviceCopyWithImpl<_ConnectedCanvasDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectedCanvasDevice&&(identical(other.device, device) || other.device == device)&&(identical(other.textureId, textureId) || other.textureId == textureId)&&(identical(other.screenSize, screenSize) || other.screenSize == screenSize)&&(identical(other.supportsInteraction, supportsInteraction) || other.supportsInteraction == supportsInteraction)&&(identical(other.supportsDeviceActions, supportsDeviceActions) || other.supportsDeviceActions == supportsDeviceActions)&&(identical(other.supportsAudio, supportsAudio) || other.supportsAudio == supportsAudio));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,textureId,screenSize,supportsInteraction,supportsDeviceActions,supportsAudio);
}

@override
String toString() {
    return 'CanvasDevice(device: $device, textureId: $textureId, screenSize: $screenSize, supportsInteraction: $supportsInteraction, supportsDeviceActions: $supportsDeviceActions, supportsAudio: $supportsAudio)';
}


}

/// @nodoc
abstract mixin class _$ConnectedCanvasDeviceCopyWith<$Res> implements $CanvasDeviceCopyWith<$Res> {
  factory _$ConnectedCanvasDeviceCopyWith(_ConnectedCanvasDevice value, $Res Function(_ConnectedCanvasDevice) _then) = __$ConnectedCanvasDeviceCopyWithImpl;
@override @useResult
$Res call({
 PluggedDevice device, NativeTextureId textureId, DeviceScreenSize screenSize, bool supportsInteraction, bool supportsDeviceActions, bool supportsAudio
});


@override $DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class __$ConnectedCanvasDeviceCopyWithImpl<$Res>
    implements _$ConnectedCanvasDeviceCopyWith<$Res> {
  __$ConnectedCanvasDeviceCopyWithImpl(this._self, this._then);

  final _ConnectedCanvasDevice _self;
  final $Res Function(_ConnectedCanvasDevice) _then;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? textureId = null,Object? screenSize = null,Object? supportsInteraction = null,Object? supportsDeviceActions = null,Object? supportsAudio = null,}) {
  return _then(_ConnectedCanvasDevice(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PluggedDevice,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,supportsInteraction: null == supportsInteraction ? _self.supportsInteraction : supportsInteraction // ignore: cast_nullable_to_non_nullable
as bool,supportsDeviceActions: null == supportsDeviceActions ? _self.supportsDeviceActions : supportsDeviceActions // ignore: cast_nullable_to_non_nullable
as bool,supportsAudio: null == supportsAudio ? _self.supportsAudio : supportsAudio // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CanvasDevice
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
