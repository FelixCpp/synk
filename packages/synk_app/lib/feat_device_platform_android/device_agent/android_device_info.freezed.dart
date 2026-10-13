// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'android_device_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AndroidDeviceInfo {

 String get model; String get manufacturer; String get androidVersion; int get sdkVersion;
/// Create a copy of AndroidDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AndroidDeviceInfoCopyWith<AndroidDeviceInfo> get copyWith => _$AndroidDeviceInfoCopyWithImpl<AndroidDeviceInfo>(this as AndroidDeviceInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AndroidDeviceInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AndroidDeviceInfo&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.manufacturer, _this.manufacturer) || other.manufacturer == _this.manufacturer)&&(identical(other.androidVersion, _this.androidVersion) || other.androidVersion == _this.androidVersion)&&(identical(other.sdkVersion, _this.sdkVersion) || other.sdkVersion == _this.sdkVersion));
}


@override
int get hashCode {
  final _this = this as AndroidDeviceInfo;
  return Object.hash(runtimeType,_this.model,_this.manufacturer,_this.androidVersion,_this.sdkVersion);
}

@override
String toString() {
  final _this = this as AndroidDeviceInfo;
  return 'AndroidDeviceInfo(model: ${_this.model}, manufacturer: ${_this.manufacturer}, androidVersion: ${_this.androidVersion}, sdkVersion: ${_this.sdkVersion})';
}


}

/// @nodoc
abstract mixin class $AndroidDeviceInfoCopyWith<$Res>  {
  factory $AndroidDeviceInfoCopyWith(AndroidDeviceInfo value, $Res Function(AndroidDeviceInfo) _then) = _$AndroidDeviceInfoCopyWithImpl;
@useResult
$Res call({
 String model, String manufacturer, String androidVersion, int sdkVersion
});




}
/// @nodoc
class _$AndroidDeviceInfoCopyWithImpl<$Res>
    implements $AndroidDeviceInfoCopyWith<$Res> {
  _$AndroidDeviceInfoCopyWithImpl(this._self, this._then);

  final AndroidDeviceInfo _self;
  final $Res Function(AndroidDeviceInfo) _then;

/// Create a copy of AndroidDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? manufacturer = null,Object? androidVersion = null,Object? sdkVersion = null,}) {
  return _then(AndroidDeviceInfo(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,androidVersion: null == androidVersion ? _self.androidVersion : androidVersion // ignore: cast_nullable_to_non_nullable
as String,sdkVersion: null == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AndroidDeviceInfo].
extension AndroidDeviceInfoPatterns on AndroidDeviceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AndroidDeviceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AndroidDeviceInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AndroidDeviceInfo value)  $default,){
final _that = this;
switch (_that) {
case _AndroidDeviceInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AndroidDeviceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AndroidDeviceInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String model,  String manufacturer,  String androidVersion,  int sdkVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AndroidDeviceInfo() when $default != null:
return $default(_that.model,_that.manufacturer,_that.androidVersion,_that.sdkVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String model,  String manufacturer,  String androidVersion,  int sdkVersion)  $default,) {final _that = this;
switch (_that) {
case _AndroidDeviceInfo():
return $default(_that.model,_that.manufacturer,_that.androidVersion,_that.sdkVersion);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String model,  String manufacturer,  String androidVersion,  int sdkVersion)?  $default,) {final _that = this;
switch (_that) {
case _AndroidDeviceInfo() when $default != null:
return $default(_that.model,_that.manufacturer,_that.androidVersion,_that.sdkVersion);case _:
  return null;

}
}

}

/// @nodoc


class _AndroidDeviceInfo implements AndroidDeviceInfo {
  const _AndroidDeviceInfo({required this.model, required this.manufacturer, required this.androidVersion, required this.sdkVersion});
  

@override final  String model;
@override final  String manufacturer;
@override final  String androidVersion;
@override final  int sdkVersion;

/// Create a copy of AndroidDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AndroidDeviceInfoCopyWith<_AndroidDeviceInfo> get copyWith => __$AndroidDeviceInfoCopyWithImpl<_AndroidDeviceInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AndroidDeviceInfo&&(identical(other.model, model) || other.model == model)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.androidVersion, androidVersion) || other.androidVersion == androidVersion)&&(identical(other.sdkVersion, sdkVersion) || other.sdkVersion == sdkVersion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,model,manufacturer,androidVersion,sdkVersion);
}

@override
String toString() {
    return 'AndroidDeviceInfo(model: $model, manufacturer: $manufacturer, androidVersion: $androidVersion, sdkVersion: $sdkVersion)';
}


}

/// @nodoc
abstract mixin class _$AndroidDeviceInfoCopyWith<$Res> implements $AndroidDeviceInfoCopyWith<$Res> {
  factory _$AndroidDeviceInfoCopyWith(_AndroidDeviceInfo value, $Res Function(_AndroidDeviceInfo) _then) = __$AndroidDeviceInfoCopyWithImpl;
@override @useResult
$Res call({
 String model, String manufacturer, String androidVersion, int sdkVersion
});




}
/// @nodoc
class __$AndroidDeviceInfoCopyWithImpl<$Res>
    implements _$AndroidDeviceInfoCopyWith<$Res> {
  __$AndroidDeviceInfoCopyWithImpl(this._self, this._then);

  final _AndroidDeviceInfo _self;
  final $Res Function(_AndroidDeviceInfo) _then;

/// Create a copy of AndroidDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? manufacturer = null,Object? androidVersion = null,Object? sdkVersion = null,}) {
  return _then(_AndroidDeviceInfo(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,androidVersion: null == androidVersion ? _self.androidVersion : androidVersion // ignore: cast_nullable_to_non_nullable
as String,sdkVersion: null == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
