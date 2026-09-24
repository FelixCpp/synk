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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSetup value)?  onSetup,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSetup value)  onSetup,}){
final _that = this;
switch (_that) {
case _OnSetup():
return onSetup(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSetup value)?  onSetup,}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onSetup,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onSetup,}) {final _that = this;
switch (_that) {
case _OnSetup():
return onSetup();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onSetup,}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _:
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




// dart format on
