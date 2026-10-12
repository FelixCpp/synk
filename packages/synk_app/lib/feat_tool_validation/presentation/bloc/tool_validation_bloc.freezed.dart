// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool_validation_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ToolValidationEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ToolValidationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ToolValidationEvent()';
}


}

/// @nodoc
class $ToolValidationEventCopyWith<$Res>  {
$ToolValidationEventCopyWith(ToolValidationEvent _, $Res Function(ToolValidationEvent) __);
}


/// Adds pattern-matching-related methods to [ToolValidationEvent].
extension ToolValidationEventPatterns on ToolValidationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnValidate value)?  onValidate,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnValidate() when onValidate != null:
return onValidate(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnValidate value)  onValidate,}){
final _that = this;
switch (_that) {
case _OnValidate():
return onValidate(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnValidate value)?  onValidate,}){
final _that = this;
switch (_that) {
case _OnValidate() when onValidate != null:
return onValidate(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onValidate,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnValidate() when onValidate != null:
return onValidate();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onValidate,}) {final _that = this;
switch (_that) {
case _OnValidate():
return onValidate();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onValidate,}) {final _that = this;
switch (_that) {
case _OnValidate() when onValidate != null:
return onValidate();case _:
  return null;

}
}

}

/// @nodoc


class _OnValidate implements ToolValidationEvent {
  const _OnValidate();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnValidate);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ToolValidationEvent.onValidate()';
}


}




/// @nodoc
mixin _$ToolValidationState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ToolValidationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ToolValidationState()';
}


}

/// @nodoc
class $ToolValidationStateCopyWith<$Res>  {
$ToolValidationStateCopyWith(ToolValidationState _, $Res Function(ToolValidationState) __);
}


/// Adds pattern-matching-related methods to [ToolValidationState].
extension ToolValidationStatePatterns on ToolValidationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ToolValidationLoading value)?  loading,TResult Function( _ToolsUnavailable value)?  toolsUnavailable,TResult Function( _ToolsAvailable value)?  toolsAvailable,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ToolValidationLoading() when loading != null:
return loading(_that);case _ToolsUnavailable() when toolsUnavailable != null:
return toolsUnavailable(_that);case _ToolsAvailable() when toolsAvailable != null:
return toolsAvailable(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ToolValidationLoading value)  loading,required TResult Function( _ToolsUnavailable value)  toolsUnavailable,required TResult Function( _ToolsAvailable value)  toolsAvailable,}){
final _that = this;
switch (_that) {
case _ToolValidationLoading():
return loading(_that);case _ToolsUnavailable():
return toolsUnavailable(_that);case _ToolsAvailable():
return toolsAvailable(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ToolValidationLoading value)?  loading,TResult? Function( _ToolsUnavailable value)?  toolsUnavailable,TResult? Function( _ToolsAvailable value)?  toolsAvailable,}){
final _that = this;
switch (_that) {
case _ToolValidationLoading() when loading != null:
return loading(_that);case _ToolsUnavailable() when toolsUnavailable != null:
return toolsUnavailable(_that);case _ToolsAvailable() when toolsAvailable != null:
return toolsAvailable(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<ToolIssue> issues)?  toolsUnavailable,TResult Function( List<ToolIssue> warnings)?  toolsAvailable,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ToolValidationLoading() when loading != null:
return loading();case _ToolsUnavailable() when toolsUnavailable != null:
return toolsUnavailable(_that.issues);case _ToolsAvailable() when toolsAvailable != null:
return toolsAvailable(_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<ToolIssue> issues)  toolsUnavailable,required TResult Function( List<ToolIssue> warnings)  toolsAvailable,}) {final _that = this;
switch (_that) {
case _ToolValidationLoading():
return loading();case _ToolsUnavailable():
return toolsUnavailable(_that.issues);case _ToolsAvailable():
return toolsAvailable(_that.warnings);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<ToolIssue> issues)?  toolsUnavailable,TResult? Function( List<ToolIssue> warnings)?  toolsAvailable,}) {final _that = this;
switch (_that) {
case _ToolValidationLoading() when loading != null:
return loading();case _ToolsUnavailable() when toolsUnavailable != null:
return toolsUnavailable(_that.issues);case _ToolsAvailable() when toolsAvailable != null:
return toolsAvailable(_that.warnings);case _:
  return null;

}
}

}

/// @nodoc


class _ToolValidationLoading implements ToolValidationState {
  const _ToolValidationLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToolValidationLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ToolValidationState.loading()';
}


}




/// @nodoc


class _ToolsUnavailable implements ToolValidationState {
  const _ToolsUnavailable({required  List<ToolIssue> issues}): _issues = issues;
  

 final  List<ToolIssue> _issues;
 List<ToolIssue> get issues {
  if (_issues is EqualUnmodifiableListView) return _issues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_issues);
}


/// Create a copy of ToolValidationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToolsUnavailableCopyWith<_ToolsUnavailable> get copyWith => __$ToolsUnavailableCopyWithImpl<_ToolsUnavailable>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToolsUnavailable&&const DeepCollectionEquality().equals(other.issues, _issues));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_issues));
}

@override
String toString() {
    return 'ToolValidationState.toolsUnavailable(issues: $issues)';
}


}

/// @nodoc
abstract mixin class _$ToolsUnavailableCopyWith<$Res> implements $ToolValidationStateCopyWith<$Res> {
  factory _$ToolsUnavailableCopyWith(_ToolsUnavailable value, $Res Function(_ToolsUnavailable) _then) = __$ToolsUnavailableCopyWithImpl;
@useResult
$Res call({
 List<ToolIssue> issues
});




}
/// @nodoc
class __$ToolsUnavailableCopyWithImpl<$Res>
    implements _$ToolsUnavailableCopyWith<$Res> {
  __$ToolsUnavailableCopyWithImpl(this._self, this._then);

  final _ToolsUnavailable _self;
  final $Res Function(_ToolsUnavailable) _then;

/// Create a copy of ToolValidationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? issues = null,}) {
  return _then(_ToolsUnavailable(
issues: null == issues ? _self._issues : issues // ignore: cast_nullable_to_non_nullable
as List<ToolIssue>,
  ));
}


}

/// @nodoc


class _ToolsAvailable implements ToolValidationState {
  const _ToolsAvailable({required  List<ToolIssue> warnings}): _warnings = warnings;
  

 final  List<ToolIssue> _warnings;
 List<ToolIssue> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of ToolValidationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToolsAvailableCopyWith<_ToolsAvailable> get copyWith => __$ToolsAvailableCopyWithImpl<_ToolsAvailable>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToolsAvailable&&const DeepCollectionEquality().equals(other.warnings, _warnings));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_warnings));
}

@override
String toString() {
    return 'ToolValidationState.toolsAvailable(warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$ToolsAvailableCopyWith<$Res> implements $ToolValidationStateCopyWith<$Res> {
  factory _$ToolsAvailableCopyWith(_ToolsAvailable value, $Res Function(_ToolsAvailable) _then) = __$ToolsAvailableCopyWithImpl;
@useResult
$Res call({
 List<ToolIssue> warnings
});




}
/// @nodoc
class __$ToolsAvailableCopyWithImpl<$Res>
    implements _$ToolsAvailableCopyWith<$Res> {
  __$ToolsAvailableCopyWithImpl(this._self, this._then);

  final _ToolsAvailable _self;
  final $Res Function(_ToolsAvailable) _then;

/// Create a copy of ToolValidationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? warnings = null,}) {
  return _then(_ToolsAvailable(
warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<ToolIssue>,
  ));
}


}

// dart format on
