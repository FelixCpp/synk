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

 List<CanvasDevice> get devices;
/// Create a copy of DeviceCanvasState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceCanvasStateCopyWith<DeviceCanvasState> get copyWith => _$DeviceCanvasStateCopyWithImpl<DeviceCanvasState>(this as DeviceCanvasState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceCanvasState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceCanvasState&&const DeepCollectionEquality().equals(other.devices, _this.devices));
}


@override
int get hashCode {
  final _this = this as DeviceCanvasState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.devices));
}

@override
String toString() {
  final _this = this as DeviceCanvasState;
  return 'DeviceCanvasState(devices: ${_this.devices})';
}


}

/// @nodoc
abstract mixin class $DeviceCanvasStateCopyWith<$Res>  {
  factory $DeviceCanvasStateCopyWith(DeviceCanvasState value, $Res Function(DeviceCanvasState) _then) = _$DeviceCanvasStateCopyWithImpl;
@useResult
$Res call({
 List<CanvasDevice> devices
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
@pragma('vm:prefer-inline') @override $Res call({Object? devices = null,}) {
  return _then(DeviceCanvasState(
devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<CanvasDevice>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CanvasDevice> devices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceCanvasState() when $default != null:
return $default(_that.devices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CanvasDevice> devices)  $default,) {final _that = this;
switch (_that) {
case _DeviceCanvasState():
return $default(_that.devices);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CanvasDevice> devices)?  $default,) {final _that = this;
switch (_that) {
case _DeviceCanvasState() when $default != null:
return $default(_that.devices);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceCanvasState implements DeviceCanvasState {
  const _DeviceCanvasState({required  List<CanvasDevice> devices}): _devices = devices;
  

 final  List<CanvasDevice> _devices;
@override List<CanvasDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}


/// Create a copy of DeviceCanvasState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceCanvasStateCopyWith<_DeviceCanvasState> get copyWith => __$DeviceCanvasStateCopyWithImpl<_DeviceCanvasState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceCanvasState&&const DeepCollectionEquality().equals(other.devices, _devices));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_devices));
}

@override
String toString() {
    return 'DeviceCanvasState(devices: $devices)';
}


}

/// @nodoc
abstract mixin class _$DeviceCanvasStateCopyWith<$Res> implements $DeviceCanvasStateCopyWith<$Res> {
  factory _$DeviceCanvasStateCopyWith(_DeviceCanvasState value, $Res Function(_DeviceCanvasState) _then) = __$DeviceCanvasStateCopyWithImpl;
@override @useResult
$Res call({
 List<CanvasDevice> devices
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
@override @pragma('vm:prefer-inline') $Res call({Object? devices = null,}) {
  return _then(_DeviceCanvasState(
devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<CanvasDevice>,
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSetup value)?  onSetup,TResult Function( _OnCaptureScreenshot value)?  onCaptureScreenshot,TResult Function( _OnPointerEvent value)?  onPointerEvent,TResult Function( _OnCloseDevice value)?  onCloseDevice,TResult Function( _OnKeyEvent value)?  onKeyEvent,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot(_that);case _OnPointerEvent() when onPointerEvent != null:
return onPointerEvent(_that);case _OnCloseDevice() when onCloseDevice != null:
return onCloseDevice(_that);case _OnKeyEvent() when onKeyEvent != null:
return onKeyEvent(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSetup value)  onSetup,required TResult Function( _OnCaptureScreenshot value)  onCaptureScreenshot,required TResult Function( _OnPointerEvent value)  onPointerEvent,required TResult Function( _OnCloseDevice value)  onCloseDevice,required TResult Function( _OnKeyEvent value)  onKeyEvent,}){
final _that = this;
switch (_that) {
case _OnSetup():
return onSetup(_that);case _OnCaptureScreenshot():
return onCaptureScreenshot(_that);case _OnPointerEvent():
return onPointerEvent(_that);case _OnCloseDevice():
return onCloseDevice(_that);case _OnKeyEvent():
return onKeyEvent(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSetup value)?  onSetup,TResult? Function( _OnCaptureScreenshot value)?  onCaptureScreenshot,TResult? Function( _OnPointerEvent value)?  onPointerEvent,TResult? Function( _OnCloseDevice value)?  onCloseDevice,TResult? Function( _OnKeyEvent value)?  onKeyEvent,}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot(_that);case _OnPointerEvent() when onPointerEvent != null:
return onPointerEvent(_that);case _OnCloseDevice() when onCloseDevice != null:
return onCloseDevice(_that);case _OnKeyEvent() when onKeyEvent != null:
return onKeyEvent(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onSetup,TResult Function( CanvasDevice device)?  onCaptureScreenshot,TResult Function( CanvasDevice device,  ScrcpyPointerEventType type,  double normalizedPointerX,  double normalizedPointerY)?  onPointerEvent,TResult Function( CanvasDevice device)?  onCloseDevice,TResult Function( CanvasDevice device,  KeyEvent event)?  onKeyEvent,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot(_that.device);case _OnPointerEvent() when onPointerEvent != null:
return onPointerEvent(_that.device,_that.type,_that.normalizedPointerX,_that.normalizedPointerY);case _OnCloseDevice() when onCloseDevice != null:
return onCloseDevice(_that.device);case _OnKeyEvent() when onKeyEvent != null:
return onKeyEvent(_that.device,_that.event);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onSetup,required TResult Function( CanvasDevice device)  onCaptureScreenshot,required TResult Function( CanvasDevice device,  ScrcpyPointerEventType type,  double normalizedPointerX,  double normalizedPointerY)  onPointerEvent,required TResult Function( CanvasDevice device)  onCloseDevice,required TResult Function( CanvasDevice device,  KeyEvent event)  onKeyEvent,}) {final _that = this;
switch (_that) {
case _OnSetup():
return onSetup();case _OnCaptureScreenshot():
return onCaptureScreenshot(_that.device);case _OnPointerEvent():
return onPointerEvent(_that.device,_that.type,_that.normalizedPointerX,_that.normalizedPointerY);case _OnCloseDevice():
return onCloseDevice(_that.device);case _OnKeyEvent():
return onKeyEvent(_that.device,_that.event);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onSetup,TResult? Function( CanvasDevice device)?  onCaptureScreenshot,TResult? Function( CanvasDevice device,  ScrcpyPointerEventType type,  double normalizedPointerX,  double normalizedPointerY)?  onPointerEvent,TResult? Function( CanvasDevice device)?  onCloseDevice,TResult? Function( CanvasDevice device,  KeyEvent event)?  onKeyEvent,}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot(_that.device);case _OnPointerEvent() when onPointerEvent != null:
return onPointerEvent(_that.device,_that.type,_that.normalizedPointerX,_that.normalizedPointerY);case _OnCloseDevice() when onCloseDevice != null:
return onCloseDevice(_that.device);case _OnKeyEvent() when onKeyEvent != null:
return onKeyEvent(_that.device,_that.event);case _:
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


class _OnPointerEvent implements DeviceCanvasEvent {
  const _OnPointerEvent({required this.device, required this.type, required this.normalizedPointerX, required this.normalizedPointerY});
  

 final  CanvasDevice device;
 final  ScrcpyPointerEventType type;
 final  double normalizedPointerX;
 final  double normalizedPointerY;

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnPointerEventCopyWith<_OnPointerEvent> get copyWith => __$OnPointerEventCopyWithImpl<_OnPointerEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnPointerEvent&&(identical(other.device, device) || other.device == device)&&(identical(other.type, type) || other.type == type)&&(identical(other.normalizedPointerX, normalizedPointerX) || other.normalizedPointerX == normalizedPointerX)&&(identical(other.normalizedPointerY, normalizedPointerY) || other.normalizedPointerY == normalizedPointerY));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,type,normalizedPointerX,normalizedPointerY);
}

@override
String toString() {
    return 'DeviceCanvasEvent.onPointerEvent(device: $device, type: $type, normalizedPointerX: $normalizedPointerX, normalizedPointerY: $normalizedPointerY)';
}


}

/// @nodoc
abstract mixin class _$OnPointerEventCopyWith<$Res> implements $DeviceCanvasEventCopyWith<$Res> {
  factory _$OnPointerEventCopyWith(_OnPointerEvent value, $Res Function(_OnPointerEvent) _then) = __$OnPointerEventCopyWithImpl;
@useResult
$Res call({
 CanvasDevice device, ScrcpyPointerEventType type, double normalizedPointerX, double normalizedPointerY
});


$CanvasDeviceCopyWith<$Res> get device;

}
/// @nodoc
class __$OnPointerEventCopyWithImpl<$Res>
    implements _$OnPointerEventCopyWith<$Res> {
  __$OnPointerEventCopyWithImpl(this._self, this._then);

  final _OnPointerEvent _self;
  final $Res Function(_OnPointerEvent) _then;

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? device = null,Object? type = null,Object? normalizedPointerX = null,Object? normalizedPointerY = null,}) {
  return _then(_OnPointerEvent(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as CanvasDevice,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ScrcpyPointerEventType,normalizedPointerX: null == normalizedPointerX ? _self.normalizedPointerX : normalizedPointerX // ignore: cast_nullable_to_non_nullable
as double,normalizedPointerY: null == normalizedPointerY ? _self.normalizedPointerY : normalizedPointerY // ignore: cast_nullable_to_non_nullable
as double,
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


class _OnCloseDevice implements DeviceCanvasEvent {
  const _OnCloseDevice(this.device);
  

 final  CanvasDevice device;

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnCloseDeviceCopyWith<_OnCloseDevice> get copyWith => __$OnCloseDeviceCopyWithImpl<_OnCloseDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnCloseDevice&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device);
}

@override
String toString() {
    return 'DeviceCanvasEvent.onCloseDevice(device: $device)';
}


}

/// @nodoc
abstract mixin class _$OnCloseDeviceCopyWith<$Res> implements $DeviceCanvasEventCopyWith<$Res> {
  factory _$OnCloseDeviceCopyWith(_OnCloseDevice value, $Res Function(_OnCloseDevice) _then) = __$OnCloseDeviceCopyWithImpl;
@useResult
$Res call({
 CanvasDevice device
});


$CanvasDeviceCopyWith<$Res> get device;

}
/// @nodoc
class __$OnCloseDeviceCopyWithImpl<$Res>
    implements _$OnCloseDeviceCopyWith<$Res> {
  __$OnCloseDeviceCopyWithImpl(this._self, this._then);

  final _OnCloseDevice _self;
  final $Res Function(_OnCloseDevice) _then;

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? device = null,}) {
  return _then(_OnCloseDevice(
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


class _OnKeyEvent implements DeviceCanvasEvent {
  const _OnKeyEvent({required this.device, required this.event});
  

 final  CanvasDevice device;
 final  KeyEvent event;

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnKeyEventCopyWith<_OnKeyEvent> get copyWith => __$OnKeyEventCopyWithImpl<_OnKeyEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnKeyEvent&&(identical(other.device, device) || other.device == device)&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,event);
}

@override
String toString() {
    return 'DeviceCanvasEvent.onKeyEvent(device: $device, event: $event)';
}


}

/// @nodoc
abstract mixin class _$OnKeyEventCopyWith<$Res> implements $DeviceCanvasEventCopyWith<$Res> {
  factory _$OnKeyEventCopyWith(_OnKeyEvent value, $Res Function(_OnKeyEvent) _then) = __$OnKeyEventCopyWithImpl;
@useResult
$Res call({
 CanvasDevice device, KeyEvent event
});


$CanvasDeviceCopyWith<$Res> get device;

}
/// @nodoc
class __$OnKeyEventCopyWithImpl<$Res>
    implements _$OnKeyEventCopyWith<$Res> {
  __$OnKeyEventCopyWithImpl(this._self, this._then);

  final _OnKeyEvent _self;
  final $Res Function(_OnKeyEvent) _then;

/// Create a copy of DeviceCanvasEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? device = null,Object? event = null,}) {
  return _then(_OnKeyEvent(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as CanvasDevice,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as KeyEvent,
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
