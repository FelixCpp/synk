// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scrcpy_pointer_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScrcpyPointerEvent {

 ScrcpyPointerEventType get type; double get normalizedPointerX; double get normalizedPointerY;
/// Create a copy of ScrcpyPointerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScrcpyPointerEventCopyWith<ScrcpyPointerEvent> get copyWith => _$ScrcpyPointerEventCopyWithImpl<ScrcpyPointerEvent>(this as ScrcpyPointerEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScrcpyPointerEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScrcpyPointerEvent&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.normalizedPointerX, _this.normalizedPointerX) || other.normalizedPointerX == _this.normalizedPointerX)&&(identical(other.normalizedPointerY, _this.normalizedPointerY) || other.normalizedPointerY == _this.normalizedPointerY));
}


@override
int get hashCode {
  final _this = this as ScrcpyPointerEvent;
  return Object.hash(runtimeType,_this.type,_this.normalizedPointerX,_this.normalizedPointerY);
}

@override
String toString() {
  final _this = this as ScrcpyPointerEvent;
  return 'ScrcpyPointerEvent(type: ${_this.type}, normalizedPointerX: ${_this.normalizedPointerX}, normalizedPointerY: ${_this.normalizedPointerY})';
}


}

/// @nodoc
abstract mixin class $ScrcpyPointerEventCopyWith<$Res>  {
  factory $ScrcpyPointerEventCopyWith(ScrcpyPointerEvent value, $Res Function(ScrcpyPointerEvent) _then) = _$ScrcpyPointerEventCopyWithImpl;
@useResult
$Res call({
 ScrcpyPointerEventType type, double normalizedPointerX, double normalizedPointerY
});




}
/// @nodoc
class _$ScrcpyPointerEventCopyWithImpl<$Res>
    implements $ScrcpyPointerEventCopyWith<$Res> {
  _$ScrcpyPointerEventCopyWithImpl(this._self, this._then);

  final ScrcpyPointerEvent _self;
  final $Res Function(ScrcpyPointerEvent) _then;

/// Create a copy of ScrcpyPointerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? normalizedPointerX = null,Object? normalizedPointerY = null,}) {
  return _then(ScrcpyPointerEvent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ScrcpyPointerEventType,normalizedPointerX: null == normalizedPointerX ? _self.normalizedPointerX : normalizedPointerX // ignore: cast_nullable_to_non_nullable
as double,normalizedPointerY: null == normalizedPointerY ? _self.normalizedPointerY : normalizedPointerY // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ScrcpyPointerEvent].
extension ScrcpyPointerEventPatterns on ScrcpyPointerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScrcpyPointerEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScrcpyPointerEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScrcpyPointerEvent value)  $default,){
final _that = this;
switch (_that) {
case _ScrcpyPointerEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScrcpyPointerEvent value)?  $default,){
final _that = this;
switch (_that) {
case _ScrcpyPointerEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScrcpyPointerEventType type,  double normalizedPointerX,  double normalizedPointerY)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScrcpyPointerEvent() when $default != null:
return $default(_that.type,_that.normalizedPointerX,_that.normalizedPointerY);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScrcpyPointerEventType type,  double normalizedPointerX,  double normalizedPointerY)  $default,) {final _that = this;
switch (_that) {
case _ScrcpyPointerEvent():
return $default(_that.type,_that.normalizedPointerX,_that.normalizedPointerY);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScrcpyPointerEventType type,  double normalizedPointerX,  double normalizedPointerY)?  $default,) {final _that = this;
switch (_that) {
case _ScrcpyPointerEvent() when $default != null:
return $default(_that.type,_that.normalizedPointerX,_that.normalizedPointerY);case _:
  return null;

}
}

}

/// @nodoc


class _ScrcpyPointerEvent implements ScrcpyPointerEvent {
  const _ScrcpyPointerEvent({required this.type, required this.normalizedPointerX, required this.normalizedPointerY});
  

@override final  ScrcpyPointerEventType type;
@override final  double normalizedPointerX;
@override final  double normalizedPointerY;

/// Create a copy of ScrcpyPointerEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScrcpyPointerEventCopyWith<_ScrcpyPointerEvent> get copyWith => __$ScrcpyPointerEventCopyWithImpl<_ScrcpyPointerEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScrcpyPointerEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.normalizedPointerX, normalizedPointerX) || other.normalizedPointerX == normalizedPointerX)&&(identical(other.normalizedPointerY, normalizedPointerY) || other.normalizedPointerY == normalizedPointerY));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,normalizedPointerX,normalizedPointerY);
}

@override
String toString() {
    return 'ScrcpyPointerEvent(type: $type, normalizedPointerX: $normalizedPointerX, normalizedPointerY: $normalizedPointerY)';
}


}

/// @nodoc
abstract mixin class _$ScrcpyPointerEventCopyWith<$Res> implements $ScrcpyPointerEventCopyWith<$Res> {
  factory _$ScrcpyPointerEventCopyWith(_ScrcpyPointerEvent value, $Res Function(_ScrcpyPointerEvent) _then) = __$ScrcpyPointerEventCopyWithImpl;
@override @useResult
$Res call({
 ScrcpyPointerEventType type, double normalizedPointerX, double normalizedPointerY
});




}
/// @nodoc
class __$ScrcpyPointerEventCopyWithImpl<$Res>
    implements _$ScrcpyPointerEventCopyWith<$Res> {
  __$ScrcpyPointerEventCopyWithImpl(this._self, this._then);

  final _ScrcpyPointerEvent _self;
  final $Res Function(_ScrcpyPointerEvent) _then;

/// Create a copy of ScrcpyPointerEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? normalizedPointerX = null,Object? normalizedPointerY = null,}) {
  return _then(_ScrcpyPointerEvent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ScrcpyPointerEventType,normalizedPointerX: null == normalizedPointerX ? _self.normalizedPointerX : normalizedPointerX // ignore: cast_nullable_to_non_nullable
as double,normalizedPointerY: null == normalizedPointerY ? _self.normalizedPointerY : normalizedPointerY // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
