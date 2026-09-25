// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_canvas_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceCanvasState {

 List<CanvasDevice> get devices; Map<AndroidDeviceId, int> get mirrorTextureIds;
/// Create a copy of DeviceCanvasState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceCanvasStateCopyWith<DeviceCanvasState> get copyWith => _$DeviceCanvasStateCopyWithImpl<DeviceCanvasState>(this as DeviceCanvasState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceCanvasState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceCanvasState&&const DeepCollectionEquality().equals(other.devices, _this.devices)&&const DeepCollectionEquality().equals(other.mirrorTextureIds, _this.mirrorTextureIds));
}


@override
int get hashCode {
  final _this = this as DeviceCanvasState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.devices),const DeepCollectionEquality().hash(_this.mirrorTextureIds));
}

@override
String toString() {
  final _this = this as DeviceCanvasState;
  return 'DeviceCanvasState(devices: ${_this.devices}, mirrorTextureIds: ${_this.mirrorTextureIds})';
}


}

/// @nodoc
abstract mixin class $DeviceCanvasStateCopyWith<$Res>  {
  factory $DeviceCanvasStateCopyWith(DeviceCanvasState value, $Res Function(DeviceCanvasState) _then) = _$DeviceCanvasStateCopyWithImpl;
@useResult
$Res call({
 List<CanvasDevice> devices, Map<AndroidDeviceId, int> mirrorTextureIds
});




}
/// @nodoc
class _$DeviceCanvasStateCopyWithImpl<$Res>
    implements $DeviceCanvasStateCopyWith<$Res> {
  _$DeviceCanvasStateCopyWithImpl(this._self, this._then);

  final DeviceCanvasState _self;
  final $Res Function(DeviceCanvasState) _then;

/// Create a copy of DeviceCanvasState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? devices = null,Object? mirrorTextureIds = null,}) {
  return _then(DeviceCanvasState(
devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<CanvasDevice>,mirrorTextureIds: null == mirrorTextureIds ? _self.mirrorTextureIds : mirrorTextureIds // ignore: cast_nullable_to_non_nullable
as Map<AndroidDeviceId, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceCanvasState].
extension DeviceCanvasStatePatterns on DeviceCanvasState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceCanvasState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceCanvasState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceCanvasState value)  $default,){
final _that = this;
switch (_that) {
case _DeviceCanvasState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceCanvasState value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceCanvasState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CanvasDevice> devices,  Map<AndroidDeviceId, int> mirrorTextureIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceCanvasState() when $default != null:
return $default(_that.devices,_that.mirrorTextureIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CanvasDevice> devices,  Map<AndroidDeviceId, int> mirrorTextureIds)  $default,) {final _that = this;
switch (_that) {
case _DeviceCanvasState():
return $default(_that.devices,_that.mirrorTextureIds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CanvasDevice> devices,  Map<AndroidDeviceId, int> mirrorTextureIds)?  $default,) {final _that = this;
switch (_that) {
case _DeviceCanvasState() when $default != null:
return $default(_that.devices,_that.mirrorTextureIds);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceCanvasState implements DeviceCanvasState {
  const _DeviceCanvasState({required  List<CanvasDevice> devices, required  Map<AndroidDeviceId, int> mirrorTextureIds}): _devices = devices,_mirrorTextureIds = mirrorTextureIds;
  

 final  List<CanvasDevice> _devices;
@override List<CanvasDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}

 final  Map<AndroidDeviceId, int> _mirrorTextureIds;
@override Map<AndroidDeviceId, int> get mirrorTextureIds {
  if (_mirrorTextureIds is EqualUnmodifiableMapView) return _mirrorTextureIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_mirrorTextureIds);
}


/// Create a copy of DeviceCanvasState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceCanvasStateCopyWith<_DeviceCanvasState> get copyWith => __$DeviceCanvasStateCopyWithImpl<_DeviceCanvasState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceCanvasState&&const DeepCollectionEquality().equals(other.devices, _devices)&&const DeepCollectionEquality().equals(other.mirrorTextureIds, _mirrorTextureIds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_devices),const DeepCollectionEquality().hash(_mirrorTextureIds));
}

@override
String toString() {
    return 'DeviceCanvasState(devices: $devices, mirrorTextureIds: $mirrorTextureIds)';
}


}

/// @nodoc
abstract mixin class _$DeviceCanvasStateCopyWith<$Res> implements $DeviceCanvasStateCopyWith<$Res> {
  factory _$DeviceCanvasStateCopyWith(_DeviceCanvasState value, $Res Function(_DeviceCanvasState) _then) = __$DeviceCanvasStateCopyWithImpl;
@override @useResult
$Res call({
 List<CanvasDevice> devices, Map<AndroidDeviceId, int> mirrorTextureIds
});




}
/// @nodoc
class __$DeviceCanvasStateCopyWithImpl<$Res>
    implements _$DeviceCanvasStateCopyWith<$Res> {
  __$DeviceCanvasStateCopyWithImpl(this._self, this._then);

  final _DeviceCanvasState _self;
  final $Res Function(_DeviceCanvasState) _then;

/// Create a copy of DeviceCanvasState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? devices = null,Object? mirrorTextureIds = null,}) {
  return _then(_DeviceCanvasState(
devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<CanvasDevice>,mirrorTextureIds: null == mirrorTextureIds ? _self._mirrorTextureIds : mirrorTextureIds // ignore: cast_nullable_to_non_nullable
as Map<AndroidDeviceId, int>,
  ));
}


}

/// @nodoc
mixin _$DeviceCanvasEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceCanvasEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceCanvasEvent()';
}


}

/// @nodoc
class $DeviceCanvasEventCopyWith<$Res>  {
$DeviceCanvasEventCopyWith(DeviceCanvasEvent _, $Res Function(DeviceCanvasEvent) __);
}


/// Adds pattern-matching-related methods to [DeviceCanvasEvent].
extension DeviceCanvasEventPatterns on DeviceCanvasEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSetup value)?  onSetup,TResult Function( _OnCaptureScreenshot value)?  onCaptureScreenshot,TResult Function( _OnToggleScreenMirror value)?  onToggleScreenMirror,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot(_that);case _OnToggleScreenMirror() when onToggleScreenMirror != null:
return onToggleScreenMirror(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSetup value)  onSetup,required TResult Function( _OnCaptureScreenshot value)  onCaptureScreenshot,required TResult Function( _OnToggleScreenMirror value)  onToggleScreenMirror,}){
final _that = this;
switch (_that) {
case _OnSetup():
return onSetup(_that);case _OnCaptureScreenshot():
return onCaptureScreenshot(_that);case _OnToggleScreenMirror():
return onToggleScreenMirror(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSetup value)?  onSetup,TResult? Function( _OnCaptureScreenshot value)?  onCaptureScreenshot,TResult? Function( _OnToggleScreenMirror value)?  onToggleScreenMirror,}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot(_that);case _OnToggleScreenMirror() when onToggleScreenMirror != null:
return onToggleScreenMirror(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onSetup,TResult Function( CanvasDevice device)?  onCaptureScreenshot,TResult Function( CanvasDevice device)?  onToggleScreenMirror,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot(_that.device);case _OnToggleScreenMirror() when onToggleScreenMirror != null:
return onToggleScreenMirror(_that.device);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onSetup,required TResult Function( CanvasDevice device)  onCaptureScreenshot,required TResult Function( CanvasDevice device)  onToggleScreenMirror,}) {final _that = this;
switch (_that) {
case _OnSetup():
return onSetup();case _OnCaptureScreenshot():
return onCaptureScreenshot(_that.device);case _OnToggleScreenMirror():
return onToggleScreenMirror(_that.device);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onSetup,TResult? Function( CanvasDevice device)?  onCaptureScreenshot,TResult? Function( CanvasDevice device)?  onToggleScreenMirror,}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot(_that.device);case _OnToggleScreenMirror() when onToggleScreenMirror != null:
return onToggleScreenMirror(_that.device);case _:
  return null;

}
}

}

/// @nodoc


class _OnSetup implements DeviceCanvasEvent {
  const _OnSetup();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSetup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceCanvasEvent.onSetup()';
}


}




/// @nodoc


class _OnCaptureScreenshot implements DeviceCanvasEvent {
  const _OnCaptureScreenshot(this.device);
  

 final  CanvasDevice device;

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnCaptureScreenshotCopyWith<_OnCaptureScreenshot> get copyWith => __$OnCaptureScreenshotCopyWithImpl<_OnCaptureScreenshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnCaptureScreenshot&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device);
}

@override
String toString() {
    return 'DeviceCanvasEvent.onCaptureScreenshot(device: $device)';
}


}

/// @nodoc
abstract mixin class _$OnCaptureScreenshotCopyWith<$Res> implements $DeviceCanvasEventCopyWith<$Res> {
  factory _$OnCaptureScreenshotCopyWith(_OnCaptureScreenshot value, $Res Function(_OnCaptureScreenshot) _then) = __$OnCaptureScreenshotCopyWithImpl;
@useResult
$Res call({
 CanvasDevice device
});


$CanvasDeviceCopyWith<$Res> get device;

}
/// @nodoc
class __$OnCaptureScreenshotCopyWithImpl<$Res>
    implements _$OnCaptureScreenshotCopyWith<$Res> {
  __$OnCaptureScreenshotCopyWithImpl(this._self, this._then);

  final _OnCaptureScreenshot _self;
  final $Res Function(_OnCaptureScreenshot) _then;

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? device = null,}) {
  return _then(_OnCaptureScreenshot(
null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as CanvasDevice,
  ));
}

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CanvasDeviceCopyWith<$Res> get device {
  
  return $CanvasDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

/// @nodoc


class _OnToggleScreenMirror implements DeviceCanvasEvent {
  const _OnToggleScreenMirror(this.device);
  

 final  CanvasDevice device;

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnToggleScreenMirrorCopyWith<_OnToggleScreenMirror> get copyWith => __$OnToggleScreenMirrorCopyWithImpl<_OnToggleScreenMirror>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnToggleScreenMirror&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device);
}

@override
String toString() {
    return 'DeviceCanvasEvent.onToggleScreenMirror(device: $device)';
}


}

/// @nodoc
abstract mixin class _$OnToggleScreenMirrorCopyWith<$Res> implements $DeviceCanvasEventCopyWith<$Res> {
  factory _$OnToggleScreenMirrorCopyWith(_OnToggleScreenMirror value, $Res Function(_OnToggleScreenMirror) _then) = __$OnToggleScreenMirrorCopyWithImpl;
@useResult
$Res call({
 CanvasDevice device
});


$CanvasDeviceCopyWith<$Res> get device;

}
/// @nodoc
class __$OnToggleScreenMirrorCopyWithImpl<$Res>
    implements _$OnToggleScreenMirrorCopyWith<$Res> {
  __$OnToggleScreenMirrorCopyWithImpl(this._self, this._then);

  final _OnToggleScreenMirror _self;
  final $Res Function(_OnToggleScreenMirror) _then;

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? device = null,}) {
  return _then(_OnToggleScreenMirror(
null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as CanvasDevice,
  ));
}

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CanvasDeviceCopyWith<$Res> get device {
  
  return $CanvasDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

// dart format on
