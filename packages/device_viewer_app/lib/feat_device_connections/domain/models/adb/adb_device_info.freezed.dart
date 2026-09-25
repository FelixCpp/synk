// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adb_device_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdbAgentDeviceInfo {

 String get model; String get manufacturer; String get androidVersion; int get sdkVersion;
/// Create a copy of AdbAgentDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbAgentDeviceInfoCopyWith<AdbAgentDeviceInfo> get copyWith => _$AdbAgentDeviceInfoCopyWithImpl<AdbAgentDeviceInfo>(this as AdbAgentDeviceInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbAgentDeviceInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbAgentDeviceInfo&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.manufacturer, _this.manufacturer) || other.manufacturer == _this.manufacturer)&&(identical(other.androidVersion, _this.androidVersion) || other.androidVersion == _this.androidVersion)&&(identical(other.sdkVersion, _this.sdkVersion) || other.sdkVersion == _this.sdkVersion));
}


@override
int get hashCode {
  final _this = this as AdbAgentDeviceInfo;
  return Object.hash(runtimeType,_this.model,_this.manufacturer,_this.androidVersion,_this.sdkVersion);
}

@override
String toString() {
  final _this = this as AdbAgentDeviceInfo;
  return 'AdbAgentDeviceInfo(model: ${_this.model}, manufacturer: ${_this.manufacturer}, androidVersion: ${_this.androidVersion}, sdkVersion: ${_this.sdkVersion})';
}


}

/// @nodoc
abstract mixin class $AdbAgentDeviceInfoCopyWith<$Res>  {
  factory $AdbAgentDeviceInfoCopyWith(AdbAgentDeviceInfo value, $Res Function(AdbAgentDeviceInfo) _then) = _$AdbAgentDeviceInfoCopyWithImpl;
@useResult
$Res call({
 String model, String manufacturer, String androidVersion, int sdkVersion
});




}
/// @nodoc
class _$AdbAgentDeviceInfoCopyWithImpl<$Res>
    implements $AdbAgentDeviceInfoCopyWith<$Res> {
  _$AdbAgentDeviceInfoCopyWithImpl(this._self, this._then);

  final AdbAgentDeviceInfo _self;
  final $Res Function(AdbAgentDeviceInfo) _then;

/// Create a copy of AdbAgentDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? manufacturer = null,Object? androidVersion = null,Object? sdkVersion = null,}) {
  return _then(AdbAgentDeviceInfo(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,androidVersion: null == androidVersion ? _self.androidVersion : androidVersion // ignore: cast_nullable_to_non_nullable
as String,sdkVersion: null == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdbAgentDeviceInfo].
extension AdbAgentDeviceInfoPatterns on AdbAgentDeviceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( AdbAgentDeviceInfoInitial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case AdbAgentDeviceInfoInitial() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( AdbAgentDeviceInfoInitial value)  $default,){
final _that = this;
switch (_that) {
case AdbAgentDeviceInfoInitial():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( AdbAgentDeviceInfoInitial value)?  $default,){
final _that = this;
switch (_that) {
case AdbAgentDeviceInfoInitial() when $default != null:
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
case AdbAgentDeviceInfoInitial() when $default != null:
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
case AdbAgentDeviceInfoInitial():
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
case AdbAgentDeviceInfoInitial() when $default != null:
return $default(_that.model,_that.manufacturer,_that.androidVersion,_that.sdkVersion);case _:
  return null;

}
}

}

/// @nodoc


class AdbAgentDeviceInfoInitial implements AdbAgentDeviceInfo {
  const AdbAgentDeviceInfoInitial({required this.model, required this.manufacturer, required this.androidVersion, required this.sdkVersion});
  

@override final  String model;
@override final  String manufacturer;
@override final  String androidVersion;
@override final  int sdkVersion;

/// Create a copy of AdbAgentDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbAgentDeviceInfoInitialCopyWith<AdbAgentDeviceInfoInitial> get copyWith => _$AdbAgentDeviceInfoInitialCopyWithImpl<AdbAgentDeviceInfoInitial>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbAgentDeviceInfoInitial&&(identical(other.model, model) || other.model == model)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.androidVersion, androidVersion) || other.androidVersion == androidVersion)&&(identical(other.sdkVersion, sdkVersion) || other.sdkVersion == sdkVersion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,model,manufacturer,androidVersion,sdkVersion);
}

@override
String toString() {
    return 'AdbAgentDeviceInfo(model: $model, manufacturer: $manufacturer, androidVersion: $androidVersion, sdkVersion: $sdkVersion)';
}


}

/// @nodoc
abstract mixin class $AdbAgentDeviceInfoInitialCopyWith<$Res> implements $AdbAgentDeviceInfoCopyWith<$Res> {
  factory $AdbAgentDeviceInfoInitialCopyWith(AdbAgentDeviceInfoInitial value, $Res Function(AdbAgentDeviceInfoInitial) _then) = _$AdbAgentDeviceInfoInitialCopyWithImpl;
@override @useResult
$Res call({
 String model, String manufacturer, String androidVersion, int sdkVersion
});




}
/// @nodoc
class _$AdbAgentDeviceInfoInitialCopyWithImpl<$Res>
    implements $AdbAgentDeviceInfoInitialCopyWith<$Res> {
  _$AdbAgentDeviceInfoInitialCopyWithImpl(this._self, this._then);

  final AdbAgentDeviceInfoInitial _self;
  final $Res Function(AdbAgentDeviceInfoInitial) _then;

/// Create a copy of AdbAgentDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? manufacturer = null,Object? androidVersion = null,Object? sdkVersion = null,}) {
  return _then(AdbAgentDeviceInfoInitial(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,androidVersion: null == androidVersion ? _self.androidVersion : androidVersion // ignore: cast_nullable_to_non_nullable
as String,sdkVersion: null == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
