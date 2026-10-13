// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scrcpy_key_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScrcpyKeyEvent {

 ScrcpyKeyCode get key; ScrcpyKeyEventType get type; ScrcpyKeyMetaState get metaState;
/// Create a copy of ScrcpyKeyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScrcpyKeyEventCopyWith<ScrcpyKeyEvent> get copyWith => _$ScrcpyKeyEventCopyWithImpl<ScrcpyKeyEvent>(this as ScrcpyKeyEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScrcpyKeyEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScrcpyKeyEvent&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.metaState, _this.metaState) || other.metaState == _this.metaState));
}


@override
int get hashCode {
  final _this = this as ScrcpyKeyEvent;
  return Object.hash(runtimeType,_this.key,_this.type,_this.metaState);
}

@override
String toString() {
  final _this = this as ScrcpyKeyEvent;
  return 'ScrcpyKeyEvent(key: ${_this.key}, type: ${_this.type}, metaState: ${_this.metaState})';
}


}

/// @nodoc
abstract mixin class $ScrcpyKeyEventCopyWith<$Res>  {
  factory $ScrcpyKeyEventCopyWith(ScrcpyKeyEvent value, $Res Function(ScrcpyKeyEvent) _then) = _$ScrcpyKeyEventCopyWithImpl;
@useResult
$Res call({
 ScrcpyKeyCode key, ScrcpyKeyEventType type, ScrcpyKeyMetaState metaState
});




}
/// @nodoc
class _$ScrcpyKeyEventCopyWithImpl<$Res>
    implements $ScrcpyKeyEventCopyWith<$Res> {
  _$ScrcpyKeyEventCopyWithImpl(this._self, this._then);

  final ScrcpyKeyEvent _self;
  final $Res Function(ScrcpyKeyEvent) _then;

/// Create a copy of ScrcpyKeyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? type = null,Object? metaState = null,}) {
  return _then(ScrcpyKeyEvent(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as ScrcpyKeyCode,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ScrcpyKeyEventType,metaState: null == metaState ? _self.metaState : metaState // ignore: cast_nullable_to_non_nullable
as ScrcpyKeyMetaState,
  ));
}

}


/// Adds pattern-matching-related methods to [ScrcpyKeyEvent].
extension ScrcpyKeyEventPatterns on ScrcpyKeyEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScrcpyKeyEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScrcpyKeyEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScrcpyKeyEvent value)  $default,){
final _that = this;
switch (_that) {
case _ScrcpyKeyEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScrcpyKeyEvent value)?  $default,){
final _that = this;
switch (_that) {
case _ScrcpyKeyEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScrcpyKeyCode key,  ScrcpyKeyEventType type,  ScrcpyKeyMetaState metaState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScrcpyKeyEvent() when $default != null:
return $default(_that.key,_that.type,_that.metaState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScrcpyKeyCode key,  ScrcpyKeyEventType type,  ScrcpyKeyMetaState metaState)  $default,) {final _that = this;
switch (_that) {
case _ScrcpyKeyEvent():
return $default(_that.key,_that.type,_that.metaState);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScrcpyKeyCode key,  ScrcpyKeyEventType type,  ScrcpyKeyMetaState metaState)?  $default,) {final _that = this;
switch (_that) {
case _ScrcpyKeyEvent() when $default != null:
return $default(_that.key,_that.type,_that.metaState);case _:
  return null;

}
}

}

/// @nodoc


class _ScrcpyKeyEvent implements ScrcpyKeyEvent {
  const _ScrcpyKeyEvent({required this.key, required this.type, required this.metaState});
  

@override final  ScrcpyKeyCode key;
@override final  ScrcpyKeyEventType type;
@override final  ScrcpyKeyMetaState metaState;

/// Create a copy of ScrcpyKeyEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScrcpyKeyEventCopyWith<_ScrcpyKeyEvent> get copyWith => __$ScrcpyKeyEventCopyWithImpl<_ScrcpyKeyEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScrcpyKeyEvent&&(identical(other.key, key) || other.key == key)&&(identical(other.type, type) || other.type == type)&&(identical(other.metaState, metaState) || other.metaState == metaState));
}


@override
int get hashCode {
    return Object.hash(runtimeType,key,type,metaState);
}

@override
String toString() {
    return 'ScrcpyKeyEvent(key: $key, type: $type, metaState: $metaState)';
}


}

/// @nodoc
abstract mixin class _$ScrcpyKeyEventCopyWith<$Res> implements $ScrcpyKeyEventCopyWith<$Res> {
  factory _$ScrcpyKeyEventCopyWith(_ScrcpyKeyEvent value, $Res Function(_ScrcpyKeyEvent) _then) = __$ScrcpyKeyEventCopyWithImpl;
@override @useResult
$Res call({
 ScrcpyKeyCode key, ScrcpyKeyEventType type, ScrcpyKeyMetaState metaState
});




}
/// @nodoc
class __$ScrcpyKeyEventCopyWithImpl<$Res>
    implements _$ScrcpyKeyEventCopyWith<$Res> {
  __$ScrcpyKeyEventCopyWithImpl(this._self, this._then);

  final _ScrcpyKeyEvent _self;
  final $Res Function(_ScrcpyKeyEvent) _then;

/// Create a copy of ScrcpyKeyEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? type = null,Object? metaState = null,}) {
  return _then(_ScrcpyKeyEvent(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as ScrcpyKeyCode,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ScrcpyKeyEventType,metaState: null == metaState ? _self.metaState : metaState // ignore: cast_nullable_to_non_nullable
as ScrcpyKeyMetaState,
  ));
}


}

// dart format on
