// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scrcpy_key_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScrcpyKeyAction {

 int get keyCode; int get metaState;
/// Create a copy of ScrcpyKeyAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScrcpyKeyActionCopyWith<ScrcpyKeyAction> get copyWith => _$ScrcpyKeyActionCopyWithImpl<ScrcpyKeyAction>(this as ScrcpyKeyAction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScrcpyKeyAction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScrcpyKeyAction&&(identical(other.keyCode, _this.keyCode) || other.keyCode == _this.keyCode)&&(identical(other.metaState, _this.metaState) || other.metaState == _this.metaState));
}


@override
int get hashCode {
  final _this = this as ScrcpyKeyAction;
  return Object.hash(runtimeType,_this.keyCode,_this.metaState);
}

@override
String toString() {
  final _this = this as ScrcpyKeyAction;
  return 'ScrcpyKeyAction(keyCode: ${_this.keyCode}, metaState: ${_this.metaState})';
}


}

/// @nodoc
abstract mixin class $ScrcpyKeyActionCopyWith<$Res>  {
  factory $ScrcpyKeyActionCopyWith(ScrcpyKeyAction value, $Res Function(ScrcpyKeyAction) _then) = _$ScrcpyKeyActionCopyWithImpl;
@useResult
$Res call({
 int keyCode, int metaState
});




}
/// @nodoc
class _$ScrcpyKeyActionCopyWithImpl<$Res>
    implements $ScrcpyKeyActionCopyWith<$Res> {
  _$ScrcpyKeyActionCopyWithImpl(this._self, this._then);

  final ScrcpyKeyAction _self;
  final $Res Function(ScrcpyKeyAction) _then;

/// Create a copy of ScrcpyKeyAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyCode = null,Object? metaState = null,}) {
  return _then(_self.copyWith(
keyCode: null == keyCode ? _self.keyCode : keyCode // ignore: cast_nullable_to_non_nullable
as int,metaState: null == metaState ? _self.metaState : metaState // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScrcpyKeyAction].
extension ScrcpyKeyActionPatterns on ScrcpyKeyAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ScrcpyKeyDownAction value)?  down,TResult Function( _ScrcpyKeyRepeatAction value)?  repeat,TResult Function( _ScrcpyKeyUpAction value)?  up,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScrcpyKeyDownAction() when down != null:
return down(_that);case _ScrcpyKeyRepeatAction() when repeat != null:
return repeat(_that);case _ScrcpyKeyUpAction() when up != null:
return up(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ScrcpyKeyDownAction value)  down,required TResult Function( _ScrcpyKeyRepeatAction value)  repeat,required TResult Function( _ScrcpyKeyUpAction value)  up,}){
final _that = this;
switch (_that) {
case _ScrcpyKeyDownAction():
return down(_that);case _ScrcpyKeyRepeatAction():
return repeat(_that);case _ScrcpyKeyUpAction():
return up(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ScrcpyKeyDownAction value)?  down,TResult? Function( _ScrcpyKeyRepeatAction value)?  repeat,TResult? Function( _ScrcpyKeyUpAction value)?  up,}){
final _that = this;
switch (_that) {
case _ScrcpyKeyDownAction() when down != null:
return down(_that);case _ScrcpyKeyRepeatAction() when repeat != null:
return repeat(_that);case _ScrcpyKeyUpAction() when up != null:
return up(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int keyCode,  int metaState)?  down,TResult Function( int keyCode,  int repeat,  int metaState)?  repeat,TResult Function( int keyCode,  int metaState)?  up,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScrcpyKeyDownAction() when down != null:
return down(_that.keyCode,_that.metaState);case _ScrcpyKeyRepeatAction() when repeat != null:
return repeat(_that.keyCode,_that.repeat,_that.metaState);case _ScrcpyKeyUpAction() when up != null:
return up(_that.keyCode,_that.metaState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int keyCode,  int metaState)  down,required TResult Function( int keyCode,  int repeat,  int metaState)  repeat,required TResult Function( int keyCode,  int metaState)  up,}) {final _that = this;
switch (_that) {
case _ScrcpyKeyDownAction():
return down(_that.keyCode,_that.metaState);case _ScrcpyKeyRepeatAction():
return repeat(_that.keyCode,_that.repeat,_that.metaState);case _ScrcpyKeyUpAction():
return up(_that.keyCode,_that.metaState);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int keyCode,  int metaState)?  down,TResult? Function( int keyCode,  int repeat,  int metaState)?  repeat,TResult? Function( int keyCode,  int metaState)?  up,}) {final _that = this;
switch (_that) {
case _ScrcpyKeyDownAction() when down != null:
return down(_that.keyCode,_that.metaState);case _ScrcpyKeyRepeatAction() when repeat != null:
return repeat(_that.keyCode,_that.repeat,_that.metaState);case _ScrcpyKeyUpAction() when up != null:
return up(_that.keyCode,_that.metaState);case _:
  return null;

}
}

}

/// @nodoc


class _ScrcpyKeyDownAction implements ScrcpyKeyAction {
  const _ScrcpyKeyDownAction({required this.keyCode, required this.metaState});
  

@override final  int keyCode;
@override final  int metaState;

/// Create a copy of ScrcpyKeyAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScrcpyKeyDownActionCopyWith<_ScrcpyKeyDownAction> get copyWith => __$ScrcpyKeyDownActionCopyWithImpl<_ScrcpyKeyDownAction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScrcpyKeyDownAction&&(identical(other.keyCode, keyCode) || other.keyCode == keyCode)&&(identical(other.metaState, metaState) || other.metaState == metaState));
}


@override
int get hashCode {
    return Object.hash(runtimeType,keyCode,metaState);
}

@override
String toString() {
    return 'ScrcpyKeyAction.down(keyCode: $keyCode, metaState: $metaState)';
}


}

/// @nodoc
abstract mixin class _$ScrcpyKeyDownActionCopyWith<$Res> implements $ScrcpyKeyActionCopyWith<$Res> {
  factory _$ScrcpyKeyDownActionCopyWith(_ScrcpyKeyDownAction value, $Res Function(_ScrcpyKeyDownAction) _then) = __$ScrcpyKeyDownActionCopyWithImpl;
@override @useResult
$Res call({
 int keyCode, int metaState
});




}
/// @nodoc
class __$ScrcpyKeyDownActionCopyWithImpl<$Res>
    implements _$ScrcpyKeyDownActionCopyWith<$Res> {
  __$ScrcpyKeyDownActionCopyWithImpl(this._self, this._then);

  final _ScrcpyKeyDownAction _self;
  final $Res Function(_ScrcpyKeyDownAction) _then;

/// Create a copy of ScrcpyKeyAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyCode = null,Object? metaState = null,}) {
  return _then(_ScrcpyKeyDownAction(
keyCode: null == keyCode ? _self.keyCode : keyCode // ignore: cast_nullable_to_non_nullable
as int,metaState: null == metaState ? _self.metaState : metaState // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ScrcpyKeyRepeatAction implements ScrcpyKeyAction {
  const _ScrcpyKeyRepeatAction({required this.keyCode, required this.repeat, required this.metaState});
  

@override final  int keyCode;
 final  int repeat;
@override final  int metaState;

/// Create a copy of ScrcpyKeyAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScrcpyKeyRepeatActionCopyWith<_ScrcpyKeyRepeatAction> get copyWith => __$ScrcpyKeyRepeatActionCopyWithImpl<_ScrcpyKeyRepeatAction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScrcpyKeyRepeatAction&&(identical(other.keyCode, keyCode) || other.keyCode == keyCode)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&(identical(other.metaState, metaState) || other.metaState == metaState));
}


@override
int get hashCode {
    return Object.hash(runtimeType,keyCode,repeat,metaState);
}

@override
String toString() {
    return 'ScrcpyKeyAction.repeat(keyCode: $keyCode, repeat: $repeat, metaState: $metaState)';
}


}

/// @nodoc
abstract mixin class _$ScrcpyKeyRepeatActionCopyWith<$Res> implements $ScrcpyKeyActionCopyWith<$Res> {
  factory _$ScrcpyKeyRepeatActionCopyWith(_ScrcpyKeyRepeatAction value, $Res Function(_ScrcpyKeyRepeatAction) _then) = __$ScrcpyKeyRepeatActionCopyWithImpl;
@override @useResult
$Res call({
 int keyCode, int repeat, int metaState
});




}
/// @nodoc
class __$ScrcpyKeyRepeatActionCopyWithImpl<$Res>
    implements _$ScrcpyKeyRepeatActionCopyWith<$Res> {
  __$ScrcpyKeyRepeatActionCopyWithImpl(this._self, this._then);

  final _ScrcpyKeyRepeatAction _self;
  final $Res Function(_ScrcpyKeyRepeatAction) _then;

/// Create a copy of ScrcpyKeyAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyCode = null,Object? repeat = null,Object? metaState = null,}) {
  return _then(_ScrcpyKeyRepeatAction(
keyCode: null == keyCode ? _self.keyCode : keyCode // ignore: cast_nullable_to_non_nullable
as int,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as int,metaState: null == metaState ? _self.metaState : metaState // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ScrcpyKeyUpAction implements ScrcpyKeyAction {
  const _ScrcpyKeyUpAction({required this.keyCode, required this.metaState});
  

@override final  int keyCode;
@override final  int metaState;

/// Create a copy of ScrcpyKeyAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScrcpyKeyUpActionCopyWith<_ScrcpyKeyUpAction> get copyWith => __$ScrcpyKeyUpActionCopyWithImpl<_ScrcpyKeyUpAction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScrcpyKeyUpAction&&(identical(other.keyCode, keyCode) || other.keyCode == keyCode)&&(identical(other.metaState, metaState) || other.metaState == metaState));
}


@override
int get hashCode {
    return Object.hash(runtimeType,keyCode,metaState);
}

@override
String toString() {
    return 'ScrcpyKeyAction.up(keyCode: $keyCode, metaState: $metaState)';
}


}

/// @nodoc
abstract mixin class _$ScrcpyKeyUpActionCopyWith<$Res> implements $ScrcpyKeyActionCopyWith<$Res> {
  factory _$ScrcpyKeyUpActionCopyWith(_ScrcpyKeyUpAction value, $Res Function(_ScrcpyKeyUpAction) _then) = __$ScrcpyKeyUpActionCopyWithImpl;
@override @useResult
$Res call({
 int keyCode, int metaState
});




}
/// @nodoc
class __$ScrcpyKeyUpActionCopyWithImpl<$Res>
    implements _$ScrcpyKeyUpActionCopyWith<$Res> {
  __$ScrcpyKeyUpActionCopyWithImpl(this._self, this._then);

  final _ScrcpyKeyUpAction _self;
  final $Res Function(_ScrcpyKeyUpAction) _then;

/// Create a copy of ScrcpyKeyAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyCode = null,Object? metaState = null,}) {
  return _then(_ScrcpyKeyUpAction(
keyCode: null == keyCode ? _self.keyCode : keyCode // ignore: cast_nullable_to_non_nullable
as int,metaState: null == metaState ? _self.metaState : metaState // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
