// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_key_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceKeyEvent {

 LogicalKeyboardKey get key; DeviceKeyEventType get type; Set<DeviceKeyModifier> get modifiers;
/// Create a copy of DeviceKeyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceKeyEventCopyWith<DeviceKeyEvent> get copyWith => _$DeviceKeyEventCopyWithImpl<DeviceKeyEvent>(this as DeviceKeyEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceKeyEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceKeyEvent&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.modifiers, _this.modifiers));
}


@override
int get hashCode {
  final _this = this as DeviceKeyEvent;
  return Object.hash(runtimeType,_this.key,_this.type,const DeepCollectionEquality().hash(_this.modifiers));
}

@override
String toString() {
  final _this = this as DeviceKeyEvent;
  return 'DeviceKeyEvent(key: ${_this.key}, type: ${_this.type}, modifiers: ${_this.modifiers})';
}


}

/// @nodoc
abstract mixin class $DeviceKeyEventCopyWith<$Res>  {
  factory $DeviceKeyEventCopyWith(DeviceKeyEvent value, $Res Function(DeviceKeyEvent) _then) = _$DeviceKeyEventCopyWithImpl;
@useResult
$Res call({
 LogicalKeyboardKey key, DeviceKeyEventType type, Set<DeviceKeyModifier> modifiers
});




}
/// @nodoc
class _$DeviceKeyEventCopyWithImpl<$Res>
    implements $DeviceKeyEventCopyWith<$Res> {
  _$DeviceKeyEventCopyWithImpl(this._self, this._then);

  final DeviceKeyEvent _self;
  final $Res Function(DeviceKeyEvent) _then;

/// Create a copy of DeviceKeyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? type = null,Object? modifiers = null,}) {
  return _then(DeviceKeyEvent(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as LogicalKeyboardKey,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DeviceKeyEventType,modifiers: null == modifiers ? _self.modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as Set<DeviceKeyModifier>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceKeyEvent].
extension DeviceKeyEventPatterns on DeviceKeyEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceKeyEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceKeyEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceKeyEvent value)  $default,){
final _that = this;
switch (_that) {
case _DeviceKeyEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceKeyEvent value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceKeyEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LogicalKeyboardKey key,  DeviceKeyEventType type,  Set<DeviceKeyModifier> modifiers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceKeyEvent() when $default != null:
return $default(_that.key,_that.type,_that.modifiers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LogicalKeyboardKey key,  DeviceKeyEventType type,  Set<DeviceKeyModifier> modifiers)  $default,) {final _that = this;
switch (_that) {
case _DeviceKeyEvent():
return $default(_that.key,_that.type,_that.modifiers);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LogicalKeyboardKey key,  DeviceKeyEventType type,  Set<DeviceKeyModifier> modifiers)?  $default,) {final _that = this;
switch (_that) {
case _DeviceKeyEvent() when $default != null:
return $default(_that.key,_that.type,_that.modifiers);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceKeyEvent implements DeviceKeyEvent {
  const _DeviceKeyEvent({required this.key, required this.type, required  Set<DeviceKeyModifier> modifiers}): _modifiers = modifiers;
  

@override final  LogicalKeyboardKey key;
@override final  DeviceKeyEventType type;
 final  Set<DeviceKeyModifier> _modifiers;
@override Set<DeviceKeyModifier> get modifiers {
  if (_modifiers is EqualUnmodifiableSetView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_modifiers);
}


/// Create a copy of DeviceKeyEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceKeyEventCopyWith<_DeviceKeyEvent> get copyWith => __$DeviceKeyEventCopyWithImpl<_DeviceKeyEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceKeyEvent&&(identical(other.key, key) || other.key == key)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.modifiers, _modifiers));
}


@override
int get hashCode {
    return Object.hash(runtimeType,key,type,const DeepCollectionEquality().hash(_modifiers));
}

@override
String toString() {
    return 'DeviceKeyEvent(key: $key, type: $type, modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class _$DeviceKeyEventCopyWith<$Res> implements $DeviceKeyEventCopyWith<$Res> {
  factory _$DeviceKeyEventCopyWith(_DeviceKeyEvent value, $Res Function(_DeviceKeyEvent) _then) = __$DeviceKeyEventCopyWithImpl;
@override @useResult
$Res call({
 LogicalKeyboardKey key, DeviceKeyEventType type, Set<DeviceKeyModifier> modifiers
});




}
/// @nodoc
class __$DeviceKeyEventCopyWithImpl<$Res>
    implements _$DeviceKeyEventCopyWith<$Res> {
  __$DeviceKeyEventCopyWithImpl(this._self, this._then);

  final _DeviceKeyEvent _self;
  final $Res Function(_DeviceKeyEvent) _then;

/// Create a copy of DeviceKeyEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? type = null,Object? modifiers = null,}) {
  return _then(_DeviceKeyEvent(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as LogicalKeyboardKey,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DeviceKeyEventType,modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as Set<DeviceKeyModifier>,
  ));
}


}

// dart format on
