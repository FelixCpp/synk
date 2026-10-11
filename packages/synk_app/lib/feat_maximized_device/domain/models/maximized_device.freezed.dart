// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maximized_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MaximizedDevice {

 DeviceId get deviceId; String get modelName; bool get isLive; NativeTextureId? get textureId; DeviceScreenSize? get screenSize; bool get supportsInteraction; bool get supportsDeviceActions; bool get supportsAudio;
/// Create a copy of MaximizedDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaximizedDeviceCopyWith<MaximizedDevice> get copyWith => _$MaximizedDeviceCopyWithImpl<MaximizedDevice>(this as MaximizedDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MaximizedDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaximizedDevice&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.modelName, _this.modelName) || other.modelName == _this.modelName)&&(identical(other.isLive, _this.isLive) || other.isLive == _this.isLive)&&(identical(other.textureId, _this.textureId) || other.textureId == _this.textureId)&&(identical(other.screenSize, _this.screenSize) || other.screenSize == _this.screenSize)&&(identical(other.supportsInteraction, _this.supportsInteraction) || other.supportsInteraction == _this.supportsInteraction)&&(identical(other.supportsDeviceActions, _this.supportsDeviceActions) || other.supportsDeviceActions == _this.supportsDeviceActions)&&(identical(other.supportsAudio, _this.supportsAudio) || other.supportsAudio == _this.supportsAudio));
}


@override
int get hashCode {
  final _this = this as MaximizedDevice;
  return Object.hash(runtimeType,_this.deviceId,_this.modelName,_this.isLive,_this.textureId,_this.screenSize,_this.supportsInteraction,_this.supportsDeviceActions,_this.supportsAudio);
}

@override
String toString() {
  final _this = this as MaximizedDevice;
  return 'MaximizedDevice(deviceId: ${_this.deviceId}, modelName: ${_this.modelName}, isLive: ${_this.isLive}, textureId: ${_this.textureId}, screenSize: ${_this.screenSize}, supportsInteraction: ${_this.supportsInteraction}, supportsDeviceActions: ${_this.supportsDeviceActions}, supportsAudio: ${_this.supportsAudio})';
}


}

/// @nodoc
abstract mixin class $MaximizedDeviceCopyWith<$Res>  {
  factory $MaximizedDeviceCopyWith(MaximizedDevice value, $Res Function(MaximizedDevice) _then) = _$MaximizedDeviceCopyWithImpl;
@useResult
$Res call({
 DeviceId deviceId, String modelName, bool isLive, NativeTextureId? textureId, DeviceScreenSize? screenSize, bool supportsInteraction, bool supportsDeviceActions, bool supportsAudio
});


$DeviceScreenSizeCopyWith<$Res>? get screenSize;

}
/// @nodoc
class _$MaximizedDeviceCopyWithImpl<$Res>
    implements $MaximizedDeviceCopyWith<$Res> {
  _$MaximizedDeviceCopyWithImpl(this._self, this._then);

  final MaximizedDevice _self;
  final $Res Function(MaximizedDevice) _then;

/// Create a copy of MaximizedDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? modelName = null,Object? isLive = null,Object? textureId = freezed,Object? screenSize = freezed,Object? supportsInteraction = null,Object? supportsDeviceActions = null,Object? supportsAudio = null,}) {
  return _then(MaximizedDevice(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,textureId: freezed == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId?,screenSize: freezed == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize?,supportsInteraction: null == supportsInteraction ? _self.supportsInteraction : supportsInteraction // ignore: cast_nullable_to_non_nullable
as bool,supportsDeviceActions: null == supportsDeviceActions ? _self.supportsDeviceActions : supportsDeviceActions // ignore: cast_nullable_to_non_nullable
as bool,supportsAudio: null == supportsAudio ? _self.supportsAudio : supportsAudio // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MaximizedDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceScreenSizeCopyWith<$Res>? get screenSize {
    if (_self.screenSize == null) {
    return null;
  }

  return $DeviceScreenSizeCopyWith<$Res>(_self.screenSize!, (value) {
    return _then(_self.copyWith(screenSize: value));
  });
}
}


/// Adds pattern-matching-related methods to [MaximizedDevice].
extension MaximizedDevicePatterns on MaximizedDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaximizedDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaximizedDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaximizedDevice value)  $default,){
final _that = this;
switch (_that) {
case _MaximizedDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaximizedDevice value)?  $default,){
final _that = this;
switch (_that) {
case _MaximizedDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceId deviceId,  String modelName,  bool isLive,  NativeTextureId? textureId,  DeviceScreenSize? screenSize,  bool supportsInteraction,  bool supportsDeviceActions,  bool supportsAudio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaximizedDevice() when $default != null:
return $default(_that.deviceId,_that.modelName,_that.isLive,_that.textureId,_that.screenSize,_that.supportsInteraction,_that.supportsDeviceActions,_that.supportsAudio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceId deviceId,  String modelName,  bool isLive,  NativeTextureId? textureId,  DeviceScreenSize? screenSize,  bool supportsInteraction,  bool supportsDeviceActions,  bool supportsAudio)  $default,) {final _that = this;
switch (_that) {
case _MaximizedDevice():
return $default(_that.deviceId,_that.modelName,_that.isLive,_that.textureId,_that.screenSize,_that.supportsInteraction,_that.supportsDeviceActions,_that.supportsAudio);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceId deviceId,  String modelName,  bool isLive,  NativeTextureId? textureId,  DeviceScreenSize? screenSize,  bool supportsInteraction,  bool supportsDeviceActions,  bool supportsAudio)?  $default,) {final _that = this;
switch (_that) {
case _MaximizedDevice() when $default != null:
return $default(_that.deviceId,_that.modelName,_that.isLive,_that.textureId,_that.screenSize,_that.supportsInteraction,_that.supportsDeviceActions,_that.supportsAudio);case _:
  return null;

}
}

}

/// @nodoc


class _MaximizedDevice implements MaximizedDevice {
  const _MaximizedDevice({required this.deviceId, required this.modelName, required this.isLive, required this.textureId, required this.screenSize, required this.supportsInteraction, required this.supportsDeviceActions, required this.supportsAudio});
  

@override final  DeviceId deviceId;
@override final  String modelName;
@override final  bool isLive;
@override final  NativeTextureId? textureId;
@override final  DeviceScreenSize? screenSize;
@override final  bool supportsInteraction;
@override final  bool supportsDeviceActions;
@override final  bool supportsAudio;

/// Create a copy of MaximizedDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaximizedDeviceCopyWith<_MaximizedDevice> get copyWith => __$MaximizedDeviceCopyWithImpl<_MaximizedDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaximizedDevice&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.textureId, textureId) || other.textureId == textureId)&&(identical(other.screenSize, screenSize) || other.screenSize == screenSize)&&(identical(other.supportsInteraction, supportsInteraction) || other.supportsInteraction == supportsInteraction)&&(identical(other.supportsDeviceActions, supportsDeviceActions) || other.supportsDeviceActions == supportsDeviceActions)&&(identical(other.supportsAudio, supportsAudio) || other.supportsAudio == supportsAudio));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,modelName,isLive,textureId,screenSize,supportsInteraction,supportsDeviceActions,supportsAudio);
}

@override
String toString() {
    return 'MaximizedDevice(deviceId: $deviceId, modelName: $modelName, isLive: $isLive, textureId: $textureId, screenSize: $screenSize, supportsInteraction: $supportsInteraction, supportsDeviceActions: $supportsDeviceActions, supportsAudio: $supportsAudio)';
}


}

/// @nodoc
abstract mixin class _$MaximizedDeviceCopyWith<$Res> implements $MaximizedDeviceCopyWith<$Res> {
  factory _$MaximizedDeviceCopyWith(_MaximizedDevice value, $Res Function(_MaximizedDevice) _then) = __$MaximizedDeviceCopyWithImpl;
@override @useResult
$Res call({
 DeviceId deviceId, String modelName, bool isLive, NativeTextureId? textureId, DeviceScreenSize? screenSize, bool supportsInteraction, bool supportsDeviceActions, bool supportsAudio
});


@override $DeviceScreenSizeCopyWith<$Res>? get screenSize;

}
/// @nodoc
class __$MaximizedDeviceCopyWithImpl<$Res>
    implements _$MaximizedDeviceCopyWith<$Res> {
  __$MaximizedDeviceCopyWithImpl(this._self, this._then);

  final _MaximizedDevice _self;
  final $Res Function(_MaximizedDevice) _then;

/// Create a copy of MaximizedDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? modelName = null,Object? isLive = null,Object? textureId = freezed,Object? screenSize = freezed,Object? supportsInteraction = null,Object? supportsDeviceActions = null,Object? supportsAudio = null,}) {
  return _then(_MaximizedDevice(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,textureId: freezed == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId?,screenSize: freezed == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize?,supportsInteraction: null == supportsInteraction ? _self.supportsInteraction : supportsInteraction // ignore: cast_nullable_to_non_nullable
as bool,supportsDeviceActions: null == supportsDeviceActions ? _self.supportsDeviceActions : supportsDeviceActions // ignore: cast_nullable_to_non_nullable
as bool,supportsAudio: null == supportsAudio ? _self.supportsAudio : supportsAudio // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MaximizedDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceScreenSizeCopyWith<$Res>? get screenSize {
    if (_self.screenSize == null) {
    return null;
  }

  return $DeviceScreenSizeCopyWith<$Res>(_self.screenSize!, (value) {
    return _then(_self.copyWith(screenSize: value));
  });
}
}

// dart format on
