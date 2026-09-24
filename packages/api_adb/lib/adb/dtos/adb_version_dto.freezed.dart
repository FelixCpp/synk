// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adb_version_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdbVersionDto {

 int get major; int get minor; int get patch; int get build;
/// Create a copy of AdbVersionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbVersionDtoCopyWith<AdbVersionDto> get copyWith => _$AdbVersionDtoCopyWithImpl<AdbVersionDto>(this as AdbVersionDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbVersionDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbVersionDto&&(identical(other.major, _this.major) || other.major == _this.major)&&(identical(other.minor, _this.minor) || other.minor == _this.minor)&&(identical(other.patch, _this.patch) || other.patch == _this.patch)&&(identical(other.build, _this.build) || other.build == _this.build));
}


@override
int get hashCode {
  final _this = this as AdbVersionDto;
  return Object.hash(runtimeType,_this.major,_this.minor,_this.patch,_this.build);
}

@override
String toString() {
  final _this = this as AdbVersionDto;
  return 'AdbVersionDto(major: ${_this.major}, minor: ${_this.minor}, patch: ${_this.patch}, build: ${_this.build})';
}


}

/// @nodoc
abstract mixin class $AdbVersionDtoCopyWith<$Res>  {
  factory $AdbVersionDtoCopyWith(AdbVersionDto value, $Res Function(AdbVersionDto) _then) = _$AdbVersionDtoCopyWithImpl;
@useResult
$Res call({
 int major, int minor, int patch, int build
});




}
/// @nodoc
class _$AdbVersionDtoCopyWithImpl<$Res>
    implements $AdbVersionDtoCopyWith<$Res> {
  _$AdbVersionDtoCopyWithImpl(this._self, this._then);

  final AdbVersionDto _self;
  final $Res Function(AdbVersionDto) _then;

/// Create a copy of AdbVersionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? major = null,Object? minor = null,Object? patch = null,Object? build = null,}) {
  return _then(AdbVersionDto(
major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as int,minor: null == minor ? _self.minor : minor // ignore: cast_nullable_to_non_nullable
as int,patch: null == patch ? _self.patch : patch // ignore: cast_nullable_to_non_nullable
as int,build: null == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdbVersionDto].
extension AdbVersionDtoPatterns on AdbVersionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdbVersionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdbVersionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdbVersionDto value)  $default,){
final _that = this;
switch (_that) {
case _AdbVersionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdbVersionDto value)?  $default,){
final _that = this;
switch (_that) {
case _AdbVersionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int major,  int minor,  int patch,  int build)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdbVersionDto() when $default != null:
return $default(_that.major,_that.minor,_that.patch,_that.build);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int major,  int minor,  int patch,  int build)  $default,) {final _that = this;
switch (_that) {
case _AdbVersionDto():
return $default(_that.major,_that.minor,_that.patch,_that.build);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int major,  int minor,  int patch,  int build)?  $default,) {final _that = this;
switch (_that) {
case _AdbVersionDto() when $default != null:
return $default(_that.major,_that.minor,_that.patch,_that.build);case _:
  return null;

}
}

}

/// @nodoc


class _AdbVersionDto implements AdbVersionDto {
  const _AdbVersionDto({required this.major, required this.minor, required this.patch, required this.build});
  

@override final  int major;
@override final  int minor;
@override final  int patch;
@override final  int build;

/// Create a copy of AdbVersionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdbVersionDtoCopyWith<_AdbVersionDto> get copyWith => __$AdbVersionDtoCopyWithImpl<_AdbVersionDto>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdbVersionDto&&(identical(other.major, major) || other.major == major)&&(identical(other.minor, minor) || other.minor == minor)&&(identical(other.patch, patch) || other.patch == patch)&&(identical(other.build, build) || other.build == build));
}


@override
int get hashCode {
    return Object.hash(runtimeType,major,minor,patch,build);
}

@override
String toString() {
    return 'AdbVersionDto(major: $major, minor: $minor, patch: $patch, build: $build)';
}


}

/// @nodoc
abstract mixin class _$AdbVersionDtoCopyWith<$Res> implements $AdbVersionDtoCopyWith<$Res> {
  factory _$AdbVersionDtoCopyWith(_AdbVersionDto value, $Res Function(_AdbVersionDto) _then) = __$AdbVersionDtoCopyWithImpl;
@override @useResult
$Res call({
 int major, int minor, int patch, int build
});




}
/// @nodoc
class __$AdbVersionDtoCopyWithImpl<$Res>
    implements _$AdbVersionDtoCopyWith<$Res> {
  __$AdbVersionDtoCopyWithImpl(this._self, this._then);

  final _AdbVersionDto _self;
  final $Res Function(_AdbVersionDto) _then;

/// Create a copy of AdbVersionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? major = null,Object? minor = null,Object? patch = null,Object? build = null,}) {
  return _then(_AdbVersionDto(
major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as int,minor: null == minor ? _self.minor : minor // ignore: cast_nullable_to_non_nullable
as int,patch: null == patch ? _self.patch : patch // ignore: cast_nullable_to_non_nullable
as int,build: null == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
