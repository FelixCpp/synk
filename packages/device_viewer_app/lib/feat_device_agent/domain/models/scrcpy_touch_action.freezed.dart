// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scrcpy_touch_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScrcpyTouchAction {

 ScrcpyTouchId get id; double get normalizedTouchX; double get normalizedTouchY;
/// Create a copy of ScrcpyTouchAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScrcpyTouchActionCopyWith<ScrcpyTouchAction> get copyWith => _$ScrcpyTouchActionCopyWithImpl<ScrcpyTouchAction>(this as ScrcpyTouchAction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScrcpyTouchAction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScrcpyTouchAction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.normalizedTouchX, _this.normalizedTouchX) || other.normalizedTouchX == _this.normalizedTouchX)&&(identical(other.normalizedTouchY, _this.normalizedTouchY) || other.normalizedTouchY == _this.normalizedTouchY));
}


@override
int get hashCode {
  final _this = this as ScrcpyTouchAction;
  return Object.hash(runtimeType,_this.id,_this.normalizedTouchX,_this.normalizedTouchY);
}

@override
String toString() {
  final _this = this as ScrcpyTouchAction;
  return 'ScrcpyTouchAction(id: ${_this.id}, normalizedTouchX: ${_this.normalizedTouchX}, normalizedTouchY: ${_this.normalizedTouchY})';
}


}

/// @nodoc
abstract mixin class $ScrcpyTouchActionCopyWith<$Res>  {
  factory $ScrcpyTouchActionCopyWith(ScrcpyTouchAction value, $Res Function(ScrcpyTouchAction) _then) = _$ScrcpyTouchActionCopyWithImpl;
@useResult
$Res call({
 ScrcpyTouchId id, double normalizedTouchX, double normalizedTouchY
});




}
/// @nodoc
class _$ScrcpyTouchActionCopyWithImpl<$Res>
    implements $ScrcpyTouchActionCopyWith<$Res> {
  _$ScrcpyTouchActionCopyWithImpl(this._self, this._then);

  final ScrcpyTouchAction _self;
  final $Res Function(ScrcpyTouchAction) _then;

/// Create a copy of ScrcpyTouchAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? normalizedTouchX = null,Object? normalizedTouchY = null,}) {
  return _then(ScrcpyTouchAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as ScrcpyTouchId,normalizedTouchX: null == normalizedTouchX ? _self.normalizedTouchX : normalizedTouchX // ignore: cast_nullable_to_non_nullable
as double,normalizedTouchY: null == normalizedTouchY ? _self.normalizedTouchY : normalizedTouchY // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ScrcpyTouchAction].
extension ScrcpyTouchActionPatterns on ScrcpyTouchAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScrcpyTouchAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScrcpyTouchAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScrcpyTouchAction value)  $default,){
final _that = this;
switch (_that) {
case _ScrcpyTouchAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScrcpyTouchAction value)?  $default,){
final _that = this;
switch (_that) {
case _ScrcpyTouchAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScrcpyTouchId id,  double normalizedTouchX,  double normalizedTouchY)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScrcpyTouchAction() when $default != null:
return $default(_that.id,_that.normalizedTouchX,_that.normalizedTouchY);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScrcpyTouchId id,  double normalizedTouchX,  double normalizedTouchY)  $default,) {final _that = this;
switch (_that) {
case _ScrcpyTouchAction():
return $default(_that.id,_that.normalizedTouchX,_that.normalizedTouchY);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScrcpyTouchId id,  double normalizedTouchX,  double normalizedTouchY)?  $default,) {final _that = this;
switch (_that) {
case _ScrcpyTouchAction() when $default != null:
return $default(_that.id,_that.normalizedTouchX,_that.normalizedTouchY);case _:
  return null;

}
}

}

/// @nodoc


class _ScrcpyTouchAction implements ScrcpyTouchAction {
  const _ScrcpyTouchAction({required this.id, required this.normalizedTouchX, required this.normalizedTouchY});
  

@override final  ScrcpyTouchId id;
@override final  double normalizedTouchX;
@override final  double normalizedTouchY;

/// Create a copy of ScrcpyTouchAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScrcpyTouchActionCopyWith<_ScrcpyTouchAction> get copyWith => __$ScrcpyTouchActionCopyWithImpl<_ScrcpyTouchAction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScrcpyTouchAction&&(identical(other.id, id) || other.id == id)&&(identical(other.normalizedTouchX, normalizedTouchX) || other.normalizedTouchX == normalizedTouchX)&&(identical(other.normalizedTouchY, normalizedTouchY) || other.normalizedTouchY == normalizedTouchY));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,normalizedTouchX,normalizedTouchY);
}

@override
String toString() {
    return 'ScrcpyTouchAction(id: $id, normalizedTouchX: $normalizedTouchX, normalizedTouchY: $normalizedTouchY)';
}


}

/// @nodoc
abstract mixin class _$ScrcpyTouchActionCopyWith<$Res> implements $ScrcpyTouchActionCopyWith<$Res> {
  factory _$ScrcpyTouchActionCopyWith(_ScrcpyTouchAction value, $Res Function(_ScrcpyTouchAction) _then) = __$ScrcpyTouchActionCopyWithImpl;
@override @useResult
$Res call({
 ScrcpyTouchId id, double normalizedTouchX, double normalizedTouchY
});




}
/// @nodoc
class __$ScrcpyTouchActionCopyWithImpl<$Res>
    implements _$ScrcpyTouchActionCopyWith<$Res> {
  __$ScrcpyTouchActionCopyWithImpl(this._self, this._then);

  final _ScrcpyTouchAction _self;
  final $Res Function(_ScrcpyTouchAction) _then;

/// Create a copy of ScrcpyTouchAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? normalizedTouchX = null,Object? normalizedTouchY = null,}) {
  return _then(_ScrcpyTouchAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as ScrcpyTouchId,normalizedTouchX: null == normalizedTouchX ? _self.normalizedTouchX : normalizedTouchX // ignore: cast_nullable_to_non_nullable
as double,normalizedTouchY: null == normalizedTouchY ? _self.normalizedTouchY : normalizedTouchY // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
