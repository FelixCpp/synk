// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'newer_app_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewerAppVersion {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NewerAppVersion);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'NewerAppVersion()';
}


}

/// @nodoc
class $NewerAppVersionCopyWith<$Res>  {
$NewerAppVersionCopyWith(NewerAppVersion _, $Res Function(NewerAppVersion) __);
}


/// Adds pattern-matching-related methods to [NewerAppVersion].
extension NewerAppVersionPatterns on NewerAppVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _UpToDate value)?  upToDate,TResult Function( _Available value)?  updateAvailable,TResult Function( _FailedToFetch value)?  failedToFetch,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpToDate() when upToDate != null:
return upToDate(_that);case _Available() when updateAvailable != null:
return updateAvailable(_that);case _FailedToFetch() when failedToFetch != null:
return failedToFetch(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _UpToDate value)  upToDate,required TResult Function( _Available value)  updateAvailable,required TResult Function( _FailedToFetch value)  failedToFetch,}){
final _that = this;
switch (_that) {
case _UpToDate():
return upToDate(_that);case _Available():
return updateAvailable(_that);case _FailedToFetch():
return failedToFetch(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _UpToDate value)?  upToDate,TResult? Function( _Available value)?  updateAvailable,TResult? Function( _FailedToFetch value)?  failedToFetch,}){
final _that = this;
switch (_that) {
case _UpToDate() when upToDate != null:
return upToDate(_that);case _Available() when updateAvailable != null:
return updateAvailable(_that);case _FailedToFetch() when failedToFetch != null:
return failedToFetch(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  upToDate,TResult Function( String version)?  updateAvailable,TResult Function()?  failedToFetch,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpToDate() when upToDate != null:
return upToDate();case _Available() when updateAvailable != null:
return updateAvailable(_that.version);case _FailedToFetch() when failedToFetch != null:
return failedToFetch();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  upToDate,required TResult Function( String version)  updateAvailable,required TResult Function()  failedToFetch,}) {final _that = this;
switch (_that) {
case _UpToDate():
return upToDate();case _Available():
return updateAvailable(_that.version);case _FailedToFetch():
return failedToFetch();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  upToDate,TResult? Function( String version)?  updateAvailable,TResult? Function()?  failedToFetch,}) {final _that = this;
switch (_that) {
case _UpToDate() when upToDate != null:
return upToDate();case _Available() when updateAvailable != null:
return updateAvailable(_that.version);case _FailedToFetch() when failedToFetch != null:
return failedToFetch();case _:
  return null;

}
}

}

/// @nodoc


class _UpToDate implements NewerAppVersion {
  const _UpToDate();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpToDate);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'NewerAppVersion.upToDate()';
}


}




/// @nodoc


class _Available implements NewerAppVersion {
  const _Available(this.version);
  

 final  String version;

/// Create a copy of NewerAppVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailableCopyWith<_Available> get copyWith => __$AvailableCopyWithImpl<_Available>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Available&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode {
    return Object.hash(runtimeType,version);
}

@override
String toString() {
    return 'NewerAppVersion.updateAvailable(version: $version)';
}


}

/// @nodoc
abstract mixin class _$AvailableCopyWith<$Res> implements $NewerAppVersionCopyWith<$Res> {
  factory _$AvailableCopyWith(_Available value, $Res Function(_Available) _then) = __$AvailableCopyWithImpl;
@useResult
$Res call({
 String version
});




}
/// @nodoc
class __$AvailableCopyWithImpl<$Res>
    implements _$AvailableCopyWith<$Res> {
  __$AvailableCopyWithImpl(this._self, this._then);

  final _Available _self;
  final $Res Function(_Available) _then;

/// Create a copy of NewerAppVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? version = null,}) {
  return _then(_Available(
null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _FailedToFetch implements NewerAppVersion {
  const _FailedToFetch();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FailedToFetch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'NewerAppVersion.failedToFetch()';
}


}




// dart format on
