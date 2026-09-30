// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adb_pair_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdbPairResult {

 bool get success; String get message;
/// Create a copy of AdbPairResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbPairResultCopyWith<AdbPairResult> get copyWith => _$AdbPairResultCopyWithImpl<AdbPairResult>(this as AdbPairResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbPairResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbPairResult&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message));
}


@override
int get hashCode {
  final _this = this as AdbPairResult;
  return Object.hash(runtimeType,_this.success,_this.message);
}

@override
String toString() {
  final _this = this as AdbPairResult;
  return 'AdbPairResult(success: ${_this.success}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $AdbPairResultCopyWith<$Res>  {
  factory $AdbPairResultCopyWith(AdbPairResult value, $Res Function(AdbPairResult) _then) = _$AdbPairResultCopyWithImpl;
@useResult
$Res call({
 bool success, String message
});




}
/// @nodoc
class _$AdbPairResultCopyWithImpl<$Res>
    implements $AdbPairResultCopyWith<$Res> {
  _$AdbPairResultCopyWithImpl(this._self, this._then);

  final AdbPairResult _self;
  final $Res Function(AdbPairResult) _then;

/// Create a copy of AdbPairResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,}) {
  return _then(AdbPairResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdbPairResult].
extension AdbPairResultPatterns on AdbPairResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdbPairResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdbPairResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdbPairResult value)  $default,){
final _that = this;
switch (_that) {
case _AdbPairResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdbPairResult value)?  $default,){
final _that = this;
switch (_that) {
case _AdbPairResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdbPairResult() when $default != null:
return $default(_that.success,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message)  $default,) {final _that = this;
switch (_that) {
case _AdbPairResult():
return $default(_that.success,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message)?  $default,) {final _that = this;
switch (_that) {
case _AdbPairResult() when $default != null:
return $default(_that.success,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _AdbPairResult implements AdbPairResult {
  const _AdbPairResult({required this.success, required this.message});
  

@override final  bool success;
@override final  String message;

/// Create a copy of AdbPairResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdbPairResultCopyWith<_AdbPairResult> get copyWith => __$AdbPairResultCopyWithImpl<_AdbPairResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdbPairResult&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,success,message);
}

@override
String toString() {
    return 'AdbPairResult(success: $success, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AdbPairResultCopyWith<$Res> implements $AdbPairResultCopyWith<$Res> {
  factory _$AdbPairResultCopyWith(_AdbPairResult value, $Res Function(_AdbPairResult) _then) = __$AdbPairResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message
});




}
/// @nodoc
class __$AdbPairResultCopyWithImpl<$Res>
    implements _$AdbPairResultCopyWith<$Res> {
  __$AdbPairResultCopyWithImpl(this._self, this._then);

  final _AdbPairResult _self;
  final $Res Function(_AdbPairResult) _then;

/// Create a copy of AdbPairResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,}) {
  return _then(_AdbPairResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
