// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maximized_device_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MaximizedDeviceState {

 MaximizedDevice get device; bool get isGone;
/// Create a copy of MaximizedDeviceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaximizedDeviceStateCopyWith<MaximizedDeviceState> get copyWith => _$MaximizedDeviceStateCopyWithImpl<MaximizedDeviceState>(this as MaximizedDeviceState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MaximizedDeviceState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaximizedDeviceState&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.isGone, _this.isGone) || other.isGone == _this.isGone));
}


@override
int get hashCode {
  final _this = this as MaximizedDeviceState;
  return Object.hash(runtimeType,_this.device,_this.isGone);
}

@override
String toString() {
  final _this = this as MaximizedDeviceState;
  return 'MaximizedDeviceState(device: ${_this.device}, isGone: ${_this.isGone})';
}


}

/// @nodoc
abstract mixin class $MaximizedDeviceStateCopyWith<$Res>  {
  factory $MaximizedDeviceStateCopyWith(MaximizedDeviceState value, $Res Function(MaximizedDeviceState) _then) = _$MaximizedDeviceStateCopyWithImpl;
@useResult
$Res call({
 MaximizedDevice device, bool isGone
});


$MaximizedDeviceCopyWith<$Res> get device;

}
/// @nodoc
class _$MaximizedDeviceStateCopyWithImpl<$Res>
    implements $MaximizedDeviceStateCopyWith<$Res> {
  _$MaximizedDeviceStateCopyWithImpl(this._self, this._then);

  final MaximizedDeviceState _self;
  final $Res Function(MaximizedDeviceState) _then;

/// Create a copy of MaximizedDeviceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? isGone = null,}) {
  return _then(MaximizedDeviceState(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as MaximizedDevice,isGone: null == isGone ? _self.isGone : isGone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MaximizedDeviceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaximizedDeviceCopyWith<$Res> get device {
  
  return $MaximizedDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [MaximizedDeviceState].
extension MaximizedDeviceStatePatterns on MaximizedDeviceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaximizedDeviceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaximizedDeviceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaximizedDeviceState value)  $default,){
final _that = this;
switch (_that) {
case _MaximizedDeviceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaximizedDeviceState value)?  $default,){
final _that = this;
switch (_that) {
case _MaximizedDeviceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MaximizedDevice device,  bool isGone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaximizedDeviceState() when $default != null:
return $default(_that.device,_that.isGone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MaximizedDevice device,  bool isGone)  $default,) {final _that = this;
switch (_that) {
case _MaximizedDeviceState():
return $default(_that.device,_that.isGone);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MaximizedDevice device,  bool isGone)?  $default,) {final _that = this;
switch (_that) {
case _MaximizedDeviceState() when $default != null:
return $default(_that.device,_that.isGone);case _:
  return null;

}
}

}

/// @nodoc


class _MaximizedDeviceState implements MaximizedDeviceState {
  const _MaximizedDeviceState({required this.device, required this.isGone});
  

@override final  MaximizedDevice device;
@override final  bool isGone;

/// Create a copy of MaximizedDeviceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaximizedDeviceStateCopyWith<_MaximizedDeviceState> get copyWith => __$MaximizedDeviceStateCopyWithImpl<_MaximizedDeviceState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaximizedDeviceState&&(identical(other.device, device) || other.device == device)&&(identical(other.isGone, isGone) || other.isGone == isGone));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,isGone);
}

@override
String toString() {
    return 'MaximizedDeviceState(device: $device, isGone: $isGone)';
}


}

/// @nodoc
abstract mixin class _$MaximizedDeviceStateCopyWith<$Res> implements $MaximizedDeviceStateCopyWith<$Res> {
  factory _$MaximizedDeviceStateCopyWith(_MaximizedDeviceState value, $Res Function(_MaximizedDeviceState) _then) = __$MaximizedDeviceStateCopyWithImpl;
@override @useResult
$Res call({
 MaximizedDevice device, bool isGone
});


@override $MaximizedDeviceCopyWith<$Res> get device;

}
/// @nodoc
class __$MaximizedDeviceStateCopyWithImpl<$Res>
    implements _$MaximizedDeviceStateCopyWith<$Res> {
  __$MaximizedDeviceStateCopyWithImpl(this._self, this._then);

  final _MaximizedDeviceState _self;
  final $Res Function(_MaximizedDeviceState) _then;

/// Create a copy of MaximizedDeviceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? isGone = null,}) {
  return _then(_MaximizedDeviceState(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as MaximizedDevice,isGone: null == isGone ? _self.isGone : isGone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MaximizedDeviceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaximizedDeviceCopyWith<$Res> get device {
  
  return $MaximizedDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

/// @nodoc
mixin _$MaximizedDeviceEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MaximizedDeviceEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MaximizedDeviceEvent()';
}


}

/// @nodoc
class $MaximizedDeviceEventCopyWith<$Res>  {
$MaximizedDeviceEventCopyWith(MaximizedDeviceEvent _, $Res Function(MaximizedDeviceEvent) __);
}


/// Adds pattern-matching-related methods to [MaximizedDeviceEvent].
extension MaximizedDeviceEventPatterns on MaximizedDeviceEvent {
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


class _OnSetup implements MaximizedDeviceEvent {
  const _OnSetup();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSetup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MaximizedDeviceEvent.onSetup()';
}


}




// dart format on
