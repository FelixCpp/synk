// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_mode_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThemeModeState {

 ThemeMode get themeMode;
/// Create a copy of ThemeModeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeModeStateCopyWith<ThemeModeState> get copyWith => _$ThemeModeStateCopyWithImpl<ThemeModeState>(this as ThemeModeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ThemeModeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeModeState&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode));
}


@override
int get hashCode {
  final _this = this as ThemeModeState;
  return Object.hash(runtimeType,_this.themeMode);
}

@override
String toString() {
  final _this = this as ThemeModeState;
  return 'ThemeModeState(themeMode: ${_this.themeMode})';
}


}

/// @nodoc
abstract mixin class $ThemeModeStateCopyWith<$Res>  {
  factory $ThemeModeStateCopyWith(ThemeModeState value, $Res Function(ThemeModeState) _then) = _$ThemeModeStateCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode
});




}
/// @nodoc
class _$ThemeModeStateCopyWithImpl<$Res>
    implements $ThemeModeStateCopyWith<$Res> {
  _$ThemeModeStateCopyWithImpl(this._self, this._then);

  final ThemeModeState _self;
  final $Res Function(ThemeModeState) _then;

/// Create a copy of ThemeModeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,}) {
  return _then(ThemeModeState(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}

}


/// Adds pattern-matching-related methods to [ThemeModeState].
extension ThemeModeStatePatterns on ThemeModeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThemeModeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThemeModeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThemeModeState value)  $default,){
final _that = this;
switch (_that) {
case _ThemeModeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThemeModeState value)?  $default,){
final _that = this;
switch (_that) {
case _ThemeModeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeMode themeMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThemeModeState() when $default != null:
return $default(_that.themeMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeMode themeMode)  $default,) {final _that = this;
switch (_that) {
case _ThemeModeState():
return $default(_that.themeMode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeMode themeMode)?  $default,) {final _that = this;
switch (_that) {
case _ThemeModeState() when $default != null:
return $default(_that.themeMode);case _:
  return null;

}
}

}

/// @nodoc


class _ThemeModeState implements ThemeModeState {
  const _ThemeModeState({required this.themeMode});
  

@override final  ThemeMode themeMode;

/// Create a copy of ThemeModeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThemeModeStateCopyWith<_ThemeModeState> get copyWith => __$ThemeModeStateCopyWithImpl<_ThemeModeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThemeModeState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,themeMode);
}

@override
String toString() {
    return 'ThemeModeState(themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class _$ThemeModeStateCopyWith<$Res> implements $ThemeModeStateCopyWith<$Res> {
  factory _$ThemeModeStateCopyWith(_ThemeModeState value, $Res Function(_ThemeModeState) _then) = __$ThemeModeStateCopyWithImpl;
@override @useResult
$Res call({
 ThemeMode themeMode
});




}
/// @nodoc
class __$ThemeModeStateCopyWithImpl<$Res>
    implements _$ThemeModeStateCopyWith<$Res> {
  __$ThemeModeStateCopyWithImpl(this._self, this._then);

  final _ThemeModeState _self;
  final $Res Function(_ThemeModeState) _then;

/// Create a copy of ThemeModeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,}) {
  return _then(_ThemeModeState(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

/// @nodoc
mixin _$ThemeModeEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeModeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ThemeModeEvent()';
}


}

/// @nodoc
class $ThemeModeEventCopyWith<$Res>  {
$ThemeModeEventCopyWith(ThemeModeEvent _, $Res Function(ThemeModeEvent) __);
}


/// Adds pattern-matching-related methods to [ThemeModeEvent].
extension ThemeModeEventPatterns on ThemeModeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSetup value)?  onSetup,TResult Function( _OnToggleThemeMode value)?  onToggleThemeMode,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnToggleThemeMode() when onToggleThemeMode != null:
return onToggleThemeMode(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSetup value)  onSetup,required TResult Function( _OnToggleThemeMode value)  onToggleThemeMode,}){
final _that = this;
switch (_that) {
case _OnSetup():
return onSetup(_that);case _OnToggleThemeMode():
return onToggleThemeMode(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSetup value)?  onSetup,TResult? Function( _OnToggleThemeMode value)?  onToggleThemeMode,}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnToggleThemeMode() when onToggleThemeMode != null:
return onToggleThemeMode(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onSetup,TResult Function()?  onToggleThemeMode,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnToggleThemeMode() when onToggleThemeMode != null:
return onToggleThemeMode();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onSetup,required TResult Function()  onToggleThemeMode,}) {final _that = this;
switch (_that) {
case _OnSetup():
return onSetup();case _OnToggleThemeMode():
return onToggleThemeMode();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onSetup,TResult? Function()?  onToggleThemeMode,}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnToggleThemeMode() when onToggleThemeMode != null:
return onToggleThemeMode();case _:
  return null;

}
}

}

/// @nodoc


class _OnSetup implements ThemeModeEvent {
  const _OnSetup();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSetup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ThemeModeEvent.onSetup()';
}


}




/// @nodoc


class _OnToggleThemeMode implements ThemeModeEvent {
  const _OnToggleThemeMode();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnToggleThemeMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ThemeModeEvent.onToggleThemeMode()';
}


}




// dart format on
