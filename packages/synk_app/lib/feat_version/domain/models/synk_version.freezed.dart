// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'synk_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SynkVersion {

 String get appName; String get packageName; String get version; String get buildNumber;
/// Create a copy of SynkVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SynkVersionCopyWith<SynkVersion> get copyWith => _$SynkVersionCopyWithImpl<SynkVersion>(this as SynkVersion, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SynkVersion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SynkVersion&&(identical(other.appName, _this.appName) || other.appName == _this.appName)&&(identical(other.packageName, _this.packageName) || other.packageName == _this.packageName)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.buildNumber, _this.buildNumber) || other.buildNumber == _this.buildNumber));
}


@override
int get hashCode {
  final _this = this as SynkVersion;
  return Object.hash(runtimeType,_this.appName,_this.packageName,_this.version,_this.buildNumber);
}

@override
String toString() {
  final _this = this as SynkVersion;
  return 'SynkVersion(appName: ${_this.appName}, packageName: ${_this.packageName}, version: ${_this.version}, buildNumber: ${_this.buildNumber})';
}


}

/// @nodoc
abstract mixin class $SynkVersionCopyWith<$Res>  {
  factory $SynkVersionCopyWith(SynkVersion value, $Res Function(SynkVersion) _then) = _$SynkVersionCopyWithImpl;
@useResult
$Res call({
 String appName, String packageName, String version, String buildNumber
});




}
/// @nodoc
class _$SynkVersionCopyWithImpl<$Res>
    implements $SynkVersionCopyWith<$Res> {
  _$SynkVersionCopyWithImpl(this._self, this._then);

  final SynkVersion _self;
  final $Res Function(SynkVersion) _then;

/// Create a copy of SynkVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appName = null,Object? packageName = null,Object? version = null,Object? buildNumber = null,}) {
  return _then(SynkVersion(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,buildNumber: null == buildNumber ? _self.buildNumber : buildNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SynkVersion].
extension SynkVersionPatterns on SynkVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SynkVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SynkVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SynkVersion value)  $default,){
final _that = this;
switch (_that) {
case _SynkVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SynkVersion value)?  $default,){
final _that = this;
switch (_that) {
case _SynkVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appName,  String packageName,  String version,  String buildNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SynkVersion() when $default != null:
return $default(_that.appName,_that.packageName,_that.version,_that.buildNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appName,  String packageName,  String version,  String buildNumber)  $default,) {final _that = this;
switch (_that) {
case _SynkVersion():
return $default(_that.appName,_that.packageName,_that.version,_that.buildNumber);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appName,  String packageName,  String version,  String buildNumber)?  $default,) {final _that = this;
switch (_that) {
case _SynkVersion() when $default != null:
return $default(_that.appName,_that.packageName,_that.version,_that.buildNumber);case _:
  return null;

}
}

}

/// @nodoc


class _SynkVersion implements SynkVersion {
  const _SynkVersion({required this.appName, required this.packageName, required this.version, required this.buildNumber});
  

@override final  String appName;
@override final  String packageName;
@override final  String version;
@override final  String buildNumber;

/// Create a copy of SynkVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SynkVersionCopyWith<_SynkVersion> get copyWith => __$SynkVersionCopyWithImpl<_SynkVersion>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SynkVersion&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.version, version) || other.version == version)&&(identical(other.buildNumber, buildNumber) || other.buildNumber == buildNumber));
}


@override
int get hashCode {
    return Object.hash(runtimeType,appName,packageName,version,buildNumber);
}

@override
String toString() {
    return 'SynkVersion(appName: $appName, packageName: $packageName, version: $version, buildNumber: $buildNumber)';
}


}

/// @nodoc
abstract mixin class _$SynkVersionCopyWith<$Res> implements $SynkVersionCopyWith<$Res> {
  factory _$SynkVersionCopyWith(_SynkVersion value, $Res Function(_SynkVersion) _then) = __$SynkVersionCopyWithImpl;
@override @useResult
$Res call({
 String appName, String packageName, String version, String buildNumber
});




}
/// @nodoc
class __$SynkVersionCopyWithImpl<$Res>
    implements _$SynkVersionCopyWith<$Res> {
  __$SynkVersionCopyWithImpl(this._self, this._then);

  final _SynkVersion _self;
  final $Res Function(_SynkVersion) _then;

/// Create a copy of SynkVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appName = null,Object? packageName = null,Object? version = null,Object? buildNumber = null,}) {
  return _then(_SynkVersion(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,buildNumber: null == buildNumber ? _self.buildNumber : buildNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
