// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_screen_size.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceScreenSize {

 int get width; int get height;
/// Create a copy of DeviceScreenSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceScreenSizeCopyWith<DeviceScreenSize> get copyWith => _$DeviceScreenSizeCopyWithImpl<DeviceScreenSize>(this as DeviceScreenSize, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceScreenSize;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceScreenSize&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height));
}


@override
int get hashCode {
  final _this = this as DeviceScreenSize;
  return Object.hash(runtimeType,_this.width,_this.height);
}

@override
String toString() {
  final _this = this as DeviceScreenSize;
  return 'DeviceScreenSize(width: ${_this.width}, height: ${_this.height})';
}


}

/// @nodoc
abstract mixin class $DeviceScreenSizeCopyWith<$Res>  {
  factory $DeviceScreenSizeCopyWith(DeviceScreenSize value, $Res Function(DeviceScreenSize) _then) = _$DeviceScreenSizeCopyWithImpl;
@useResult
$Res call({
 int width, int height
});




}
/// @nodoc
class _$DeviceScreenSizeCopyWithImpl<$Res>
    implements $DeviceScreenSizeCopyWith<$Res> {
  _$DeviceScreenSizeCopyWithImpl(this._self, this._then);

  final DeviceScreenSize _self;
  final $Res Function(DeviceScreenSize) _then;

/// Create a copy of DeviceScreenSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,}) {
  return _then(DeviceScreenSize(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceScreenSize].
extension DeviceScreenSizePatterns on DeviceScreenSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceScreenSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceScreenSize() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceScreenSize value)  $default,){
final _that = this;
switch (_that) {
case _DeviceScreenSize():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceScreenSize value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceScreenSize() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int width,  int height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceScreenSize() when $default != null:
return $default(_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int width,  int height)  $default,) {final _that = this;
switch (_that) {
case _DeviceScreenSize():
return $default(_that.width,_that.height);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int width,  int height)?  $default,) {final _that = this;
switch (_that) {
case _DeviceScreenSize() when $default != null:
return $default(_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceScreenSize implements DeviceScreenSize {
  const _DeviceScreenSize({required this.width, required this.height});
  

@override final  int width;
@override final  int height;

/// Create a copy of DeviceScreenSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceScreenSizeCopyWith<_DeviceScreenSize> get copyWith => __$DeviceScreenSizeCopyWithImpl<_DeviceScreenSize>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceScreenSize&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode {
    return Object.hash(runtimeType,width,height);
}

@override
String toString() {
    return 'DeviceScreenSize(width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$DeviceScreenSizeCopyWith<$Res> implements $DeviceScreenSizeCopyWith<$Res> {
  factory _$DeviceScreenSizeCopyWith(_DeviceScreenSize value, $Res Function(_DeviceScreenSize) _then) = __$DeviceScreenSizeCopyWithImpl;
@override @useResult
$Res call({
 int width, int height
});




}
/// @nodoc
class __$DeviceScreenSizeCopyWithImpl<$Res>
    implements _$DeviceScreenSizeCopyWith<$Res> {
  __$DeviceScreenSizeCopyWithImpl(this._self, this._then);

  final _DeviceScreenSize _self;
  final $Res Function(_DeviceScreenSize) _then;

/// Create a copy of DeviceScreenSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,}) {
  return _then(_DeviceScreenSize(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
