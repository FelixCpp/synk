// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_capture_preview_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScreenCapturePreviewEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenCapturePreviewEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScreenCapturePreviewEvent()';
}


}

/// @nodoc
class $ScreenCapturePreviewEventCopyWith<$Res>  {
$ScreenCapturePreviewEventCopyWith(ScreenCapturePreviewEvent _, $Res Function(ScreenCapturePreviewEvent) __);
}


/// Adds pattern-matching-related methods to [ScreenCapturePreviewEvent].
extension ScreenCapturePreviewEventPatterns on ScreenCapturePreviewEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSetup value)?  onSetup,TResult Function( _OnPreviewPressed value)?  onPreviewPressed,TResult Function( _OnPreviewDismissed value)?  onPreviewDismissed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnPreviewPressed() when onPreviewPressed != null:
return onPreviewPressed(_that);case _OnPreviewDismissed() when onPreviewDismissed != null:
return onPreviewDismissed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSetup value)  onSetup,required TResult Function( _OnPreviewPressed value)  onPreviewPressed,required TResult Function( _OnPreviewDismissed value)  onPreviewDismissed,}){
final _that = this;
switch (_that) {
case _OnSetup():
return onSetup(_that);case _OnPreviewPressed():
return onPreviewPressed(_that);case _OnPreviewDismissed():
return onPreviewDismissed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSetup value)?  onSetup,TResult? Function( _OnPreviewPressed value)?  onPreviewPressed,TResult? Function( _OnPreviewDismissed value)?  onPreviewDismissed,}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnPreviewPressed() when onPreviewPressed != null:
return onPreviewPressed(_that);case _OnPreviewDismissed() when onPreviewDismissed != null:
return onPreviewDismissed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onSetup,TResult Function( ScreenCaptureEvent capture)?  onPreviewPressed,TResult Function( ScreenCaptureEvent capture)?  onPreviewDismissed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnPreviewPressed() when onPreviewPressed != null:
return onPreviewPressed(_that.capture);case _OnPreviewDismissed() when onPreviewDismissed != null:
return onPreviewDismissed(_that.capture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onSetup,required TResult Function( ScreenCaptureEvent capture)  onPreviewPressed,required TResult Function( ScreenCaptureEvent capture)  onPreviewDismissed,}) {final _that = this;
switch (_that) {
case _OnSetup():
return onSetup();case _OnPreviewPressed():
return onPreviewPressed(_that.capture);case _OnPreviewDismissed():
return onPreviewDismissed(_that.capture);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onSetup,TResult? Function( ScreenCaptureEvent capture)?  onPreviewPressed,TResult? Function( ScreenCaptureEvent capture)?  onPreviewDismissed,}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnPreviewPressed() when onPreviewPressed != null:
return onPreviewPressed(_that.capture);case _OnPreviewDismissed() when onPreviewDismissed != null:
return onPreviewDismissed(_that.capture);case _:
  return null;

}
}

}

/// @nodoc


class _OnSetup implements ScreenCapturePreviewEvent {
  const _OnSetup();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSetup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScreenCapturePreviewEvent.onSetup()';
}


}




/// @nodoc


class _OnPreviewPressed implements ScreenCapturePreviewEvent {
  const _OnPreviewPressed(this.capture);
  

 final  ScreenCaptureEvent capture;

/// Create a copy of ScreenCapturePreviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnPreviewPressedCopyWith<_OnPreviewPressed> get copyWith => __$OnPreviewPressedCopyWithImpl<_OnPreviewPressed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnPreviewPressed&&(identical(other.capture, capture) || other.capture == capture));
}


@override
int get hashCode {
    return Object.hash(runtimeType,capture);
}

@override
String toString() {
    return 'ScreenCapturePreviewEvent.onPreviewPressed(capture: $capture)';
}


}

/// @nodoc
abstract mixin class _$OnPreviewPressedCopyWith<$Res> implements $ScreenCapturePreviewEventCopyWith<$Res> {
  factory _$OnPreviewPressedCopyWith(_OnPreviewPressed value, $Res Function(_OnPreviewPressed) _then) = __$OnPreviewPressedCopyWithImpl;
@useResult
$Res call({
 ScreenCaptureEvent capture
});


$ScreenCaptureEventCopyWith<$Res> get capture;

}
/// @nodoc
class __$OnPreviewPressedCopyWithImpl<$Res>
    implements _$OnPreviewPressedCopyWith<$Res> {
  __$OnPreviewPressedCopyWithImpl(this._self, this._then);

  final _OnPreviewPressed _self;
  final $Res Function(_OnPreviewPressed) _then;

/// Create a copy of ScreenCapturePreviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? capture = null,}) {
  return _then(_OnPreviewPressed(
null == capture ? _self.capture : capture // ignore: cast_nullable_to_non_nullable
as ScreenCaptureEvent,
  ));
}

/// Create a copy of ScreenCapturePreviewEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenCaptureEventCopyWith<$Res> get capture {
  
  return $ScreenCaptureEventCopyWith<$Res>(_self.capture, (value) {
    return _then(_self.copyWith(capture: value));
  });
}
}

/// @nodoc


class _OnPreviewDismissed implements ScreenCapturePreviewEvent {
  const _OnPreviewDismissed(this.capture);
  

 final  ScreenCaptureEvent capture;

/// Create a copy of ScreenCapturePreviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnPreviewDismissedCopyWith<_OnPreviewDismissed> get copyWith => __$OnPreviewDismissedCopyWithImpl<_OnPreviewDismissed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnPreviewDismissed&&(identical(other.capture, capture) || other.capture == capture));
}


@override
int get hashCode {
    return Object.hash(runtimeType,capture);
}

@override
String toString() {
    return 'ScreenCapturePreviewEvent.onPreviewDismissed(capture: $capture)';
}


}

/// @nodoc
abstract mixin class _$OnPreviewDismissedCopyWith<$Res> implements $ScreenCapturePreviewEventCopyWith<$Res> {
  factory _$OnPreviewDismissedCopyWith(_OnPreviewDismissed value, $Res Function(_OnPreviewDismissed) _then) = __$OnPreviewDismissedCopyWithImpl;
@useResult
$Res call({
 ScreenCaptureEvent capture
});


$ScreenCaptureEventCopyWith<$Res> get capture;

}
/// @nodoc
class __$OnPreviewDismissedCopyWithImpl<$Res>
    implements _$OnPreviewDismissedCopyWith<$Res> {
  __$OnPreviewDismissedCopyWithImpl(this._self, this._then);

  final _OnPreviewDismissed _self;
  final $Res Function(_OnPreviewDismissed) _then;

/// Create a copy of ScreenCapturePreviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? capture = null,}) {
  return _then(_OnPreviewDismissed(
null == capture ? _self.capture : capture // ignore: cast_nullable_to_non_nullable
as ScreenCaptureEvent,
  ));
}

/// Create a copy of ScreenCapturePreviewEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenCaptureEventCopyWith<$Res> get capture {
  
  return $ScreenCaptureEventCopyWith<$Res>(_self.capture, (value) {
    return _then(_self.copyWith(capture: value));
  });
}
}

/// @nodoc
mixin _$ScreenCapturePreviewState {

 List<ScreenCaptureEvent> get captures;
/// Create a copy of ScreenCapturePreviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenCapturePreviewStateCopyWith<ScreenCapturePreviewState> get copyWith => _$ScreenCapturePreviewStateCopyWithImpl<ScreenCapturePreviewState>(this as ScreenCapturePreviewState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScreenCapturePreviewState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenCapturePreviewState&&const DeepCollectionEquality().equals(other.captures, _this.captures));
}


@override
int get hashCode {
  final _this = this as ScreenCapturePreviewState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.captures));
}

@override
String toString() {
  final _this = this as ScreenCapturePreviewState;
  return 'ScreenCapturePreviewState(captures: ${_this.captures})';
}


}

/// @nodoc
abstract mixin class $ScreenCapturePreviewStateCopyWith<$Res>  {
  factory $ScreenCapturePreviewStateCopyWith(ScreenCapturePreviewState value, $Res Function(ScreenCapturePreviewState) _then) = _$ScreenCapturePreviewStateCopyWithImpl;
@useResult
$Res call({
 List<ScreenCaptureEvent> captures
});




}
/// @nodoc
class _$ScreenCapturePreviewStateCopyWithImpl<$Res>
    implements $ScreenCapturePreviewStateCopyWith<$Res> {
  _$ScreenCapturePreviewStateCopyWithImpl(this._self, this._then);

  final ScreenCapturePreviewState _self;
  final $Res Function(ScreenCapturePreviewState) _then;

/// Create a copy of ScreenCapturePreviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? captures = null,}) {
  return _then(ScreenCapturePreviewState(
captures: null == captures ? _self.captures : captures // ignore: cast_nullable_to_non_nullable
as List<ScreenCaptureEvent>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenCapturePreviewState].
extension ScreenCapturePreviewStatePatterns on ScreenCapturePreviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenCapturePreviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenCapturePreviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenCapturePreviewState value)  $default,){
final _that = this;
switch (_that) {
case _ScreenCapturePreviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenCapturePreviewState value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenCapturePreviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ScreenCaptureEvent> captures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenCapturePreviewState() when $default != null:
return $default(_that.captures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ScreenCaptureEvent> captures)  $default,) {final _that = this;
switch (_that) {
case _ScreenCapturePreviewState():
return $default(_that.captures);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ScreenCaptureEvent> captures)?  $default,) {final _that = this;
switch (_that) {
case _ScreenCapturePreviewState() when $default != null:
return $default(_that.captures);case _:
  return null;

}
}

}

/// @nodoc


class _ScreenCapturePreviewState extends ScreenCapturePreviewState {
  const _ScreenCapturePreviewState({required  List<ScreenCaptureEvent> captures}): _captures = captures,super._();
  

 final  List<ScreenCaptureEvent> _captures;
@override List<ScreenCaptureEvent> get captures {
  if (_captures is EqualUnmodifiableListView) return _captures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_captures);
}


/// Create a copy of ScreenCapturePreviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenCapturePreviewStateCopyWith<_ScreenCapturePreviewState> get copyWith => __$ScreenCapturePreviewStateCopyWithImpl<_ScreenCapturePreviewState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenCapturePreviewState&&const DeepCollectionEquality().equals(other.captures, _captures));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_captures));
}

@override
String toString() {
    return 'ScreenCapturePreviewState(captures: $captures)';
}


}

/// @nodoc
abstract mixin class _$ScreenCapturePreviewStateCopyWith<$Res> implements $ScreenCapturePreviewStateCopyWith<$Res> {
  factory _$ScreenCapturePreviewStateCopyWith(_ScreenCapturePreviewState value, $Res Function(_ScreenCapturePreviewState) _then) = __$ScreenCapturePreviewStateCopyWithImpl;
@override @useResult
$Res call({
 List<ScreenCaptureEvent> captures
});




}
/// @nodoc
class __$ScreenCapturePreviewStateCopyWithImpl<$Res>
    implements _$ScreenCapturePreviewStateCopyWith<$Res> {
  __$ScreenCapturePreviewStateCopyWithImpl(this._self, this._then);

  final _ScreenCapturePreviewState _self;
  final $Res Function(_ScreenCapturePreviewState) _then;

/// Create a copy of ScreenCapturePreviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? captures = null,}) {
  return _then(_ScreenCapturePreviewState(
captures: null == captures ? _self._captures : captures // ignore: cast_nullable_to_non_nullable
as List<ScreenCaptureEvent>,
  ));
}


}

// dart format on
