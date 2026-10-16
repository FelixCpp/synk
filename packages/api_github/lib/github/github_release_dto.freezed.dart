// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_release_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GitHubReleaseDto {

@JsonKey(name: 'tag_name') String get tagName;@JsonKey(name: 'html_url', fromJson: Uri.parse) Uri get htmlUrl;@JsonKey(name: 'assets') List<GitHubAssetDto> get assets;
/// Create a copy of GitHubReleaseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GitHubReleaseDtoCopyWith<GitHubReleaseDto> get copyWith => _$GitHubReleaseDtoCopyWithImpl<GitHubReleaseDto>(this as GitHubReleaseDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GitHubReleaseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GitHubReleaseDto&&(identical(other.tagName, _this.tagName) || other.tagName == _this.tagName)&&(identical(other.htmlUrl, _this.htmlUrl) || other.htmlUrl == _this.htmlUrl)&&const DeepCollectionEquality().equals(other.assets, _this.assets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GitHubReleaseDto;
  return Object.hash(runtimeType,_this.tagName,_this.htmlUrl,const DeepCollectionEquality().hash(_this.assets));
}

@override
String toString() {
  final _this = this as GitHubReleaseDto;
  return 'GitHubReleaseDto(tagName: ${_this.tagName}, htmlUrl: ${_this.htmlUrl}, assets: ${_this.assets})';
}


}

/// @nodoc
abstract mixin class $GitHubReleaseDtoCopyWith<$Res>  {
  factory $GitHubReleaseDtoCopyWith(GitHubReleaseDto value, $Res Function(GitHubReleaseDto) _then) = _$GitHubReleaseDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tag_name') String tagName,@JsonKey(name: 'html_url', fromJson: Uri.parse) Uri htmlUrl,@JsonKey(name: 'assets') List<GitHubAssetDto> assets
});




}
/// @nodoc
class _$GitHubReleaseDtoCopyWithImpl<$Res>
    implements $GitHubReleaseDtoCopyWith<$Res> {
  _$GitHubReleaseDtoCopyWithImpl(this._self, this._then);

  final GitHubReleaseDto _self;
  final $Res Function(GitHubReleaseDto) _then;

/// Create a copy of GitHubReleaseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagName = null,Object? htmlUrl = null,Object? assets = null,}) {
  return _then(GitHubReleaseDto(
tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,htmlUrl: null == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as Uri,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<GitHubAssetDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [GitHubReleaseDto].
extension GitHubReleaseDtoPatterns on GitHubReleaseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GitHubReleaseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GitHubReleaseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GitHubReleaseDto value)  $default,){
final _that = this;
switch (_that) {
case _GitHubReleaseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GitHubReleaseDto value)?  $default,){
final _that = this;
switch (_that) {
case _GitHubReleaseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tag_name')  String tagName, @JsonKey(name: 'html_url', fromJson: Uri.parse)  Uri htmlUrl, @JsonKey(name: 'assets')  List<GitHubAssetDto> assets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GitHubReleaseDto() when $default != null:
return $default(_that.tagName,_that.htmlUrl,_that.assets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tag_name')  String tagName, @JsonKey(name: 'html_url', fromJson: Uri.parse)  Uri htmlUrl, @JsonKey(name: 'assets')  List<GitHubAssetDto> assets)  $default,) {final _that = this;
switch (_that) {
case _GitHubReleaseDto():
return $default(_that.tagName,_that.htmlUrl,_that.assets);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tag_name')  String tagName, @JsonKey(name: 'html_url', fromJson: Uri.parse)  Uri htmlUrl, @JsonKey(name: 'assets')  List<GitHubAssetDto> assets)?  $default,) {final _that = this;
switch (_that) {
case _GitHubReleaseDto() when $default != null:
return $default(_that.tagName,_that.htmlUrl,_that.assets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _GitHubReleaseDto implements GitHubReleaseDto {
  const _GitHubReleaseDto({@JsonKey(name: 'tag_name') required this.tagName, @JsonKey(name: 'html_url', fromJson: Uri.parse) required this.htmlUrl, @JsonKey(name: 'assets') required  List<GitHubAssetDto> assets}): _assets = assets;
  factory _GitHubReleaseDto.fromJson(Map<String, dynamic> json) => _$GitHubReleaseDtoFromJson(json);

@override@JsonKey(name: 'tag_name') final  String tagName;
@override@JsonKey(name: 'html_url', fromJson: Uri.parse) final  Uri htmlUrl;
 final  List<GitHubAssetDto> _assets;
@override@JsonKey(name: 'assets') List<GitHubAssetDto> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}


/// Create a copy of GitHubReleaseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GitHubReleaseDtoCopyWith<_GitHubReleaseDto> get copyWith => __$GitHubReleaseDtoCopyWithImpl<_GitHubReleaseDto>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GitHubReleaseDto&&(identical(other.tagName, tagName) || other.tagName == tagName)&&(identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl)&&const DeepCollectionEquality().equals(other.assets, _assets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tagName,htmlUrl,const DeepCollectionEquality().hash(_assets));
}

@override
String toString() {
    return 'GitHubReleaseDto(tagName: $tagName, htmlUrl: $htmlUrl, assets: $assets)';
}


}

/// @nodoc
abstract mixin class _$GitHubReleaseDtoCopyWith<$Res> implements $GitHubReleaseDtoCopyWith<$Res> {
  factory _$GitHubReleaseDtoCopyWith(_GitHubReleaseDto value, $Res Function(_GitHubReleaseDto) _then) = __$GitHubReleaseDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tag_name') String tagName,@JsonKey(name: 'html_url', fromJson: Uri.parse) Uri htmlUrl,@JsonKey(name: 'assets') List<GitHubAssetDto> assets
});




}
/// @nodoc
class __$GitHubReleaseDtoCopyWithImpl<$Res>
    implements _$GitHubReleaseDtoCopyWith<$Res> {
  __$GitHubReleaseDtoCopyWithImpl(this._self, this._then);

  final _GitHubReleaseDto _self;
  final $Res Function(_GitHubReleaseDto) _then;

/// Create a copy of GitHubReleaseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagName = null,Object? htmlUrl = null,Object? assets = null,}) {
  return _then(_GitHubReleaseDto(
tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,htmlUrl: null == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as Uri,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<GitHubAssetDto>,
  ));
}


}


/// @nodoc
mixin _$GitHubAssetDto {

@JsonKey(name: 'name') String get name;@JsonKey(name: 'browser_download_url', fromJson: Uri.parse) Uri get downloadUrl;
/// Create a copy of GitHubAssetDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GitHubAssetDtoCopyWith<GitHubAssetDto> get copyWith => _$GitHubAssetDtoCopyWithImpl<GitHubAssetDto>(this as GitHubAssetDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GitHubAssetDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GitHubAssetDto&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.downloadUrl, _this.downloadUrl) || other.downloadUrl == _this.downloadUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GitHubAssetDto;
  return Object.hash(runtimeType,_this.name,_this.downloadUrl);
}

@override
String toString() {
  final _this = this as GitHubAssetDto;
  return 'GitHubAssetDto(name: ${_this.name}, downloadUrl: ${_this.downloadUrl})';
}


}

/// @nodoc
abstract mixin class $GitHubAssetDtoCopyWith<$Res>  {
  factory $GitHubAssetDtoCopyWith(GitHubAssetDto value, $Res Function(GitHubAssetDto) _then) = _$GitHubAssetDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'browser_download_url', fromJson: Uri.parse) Uri downloadUrl
});




}
/// @nodoc
class _$GitHubAssetDtoCopyWithImpl<$Res>
    implements $GitHubAssetDtoCopyWith<$Res> {
  _$GitHubAssetDtoCopyWithImpl(this._self, this._then);

  final GitHubAssetDto _self;
  final $Res Function(GitHubAssetDto) _then;

/// Create a copy of GitHubAssetDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? downloadUrl = null,}) {
  return _then(GitHubAssetDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}

}


/// Adds pattern-matching-related methods to [GitHubAssetDto].
extension GitHubAssetDtoPatterns on GitHubAssetDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GitHubAssetDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GitHubAssetDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GitHubAssetDto value)  $default,){
final _that = this;
switch (_that) {
case _GitHubAssetDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GitHubAssetDto value)?  $default,){
final _that = this;
switch (_that) {
case _GitHubAssetDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'browser_download_url', fromJson: Uri.parse)  Uri downloadUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GitHubAssetDto() when $default != null:
return $default(_that.name,_that.downloadUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'browser_download_url', fromJson: Uri.parse)  Uri downloadUrl)  $default,) {final _that = this;
switch (_that) {
case _GitHubAssetDto():
return $default(_that.name,_that.downloadUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'browser_download_url', fromJson: Uri.parse)  Uri downloadUrl)?  $default,) {final _that = this;
switch (_that) {
case _GitHubAssetDto() when $default != null:
return $default(_that.name,_that.downloadUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _GitHubAssetDto implements GitHubAssetDto {
  const _GitHubAssetDto({@JsonKey(name: 'name') required this.name, @JsonKey(name: 'browser_download_url', fromJson: Uri.parse) required this.downloadUrl});
  factory _GitHubAssetDto.fromJson(Map<String, dynamic> json) => _$GitHubAssetDtoFromJson(json);

@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'browser_download_url', fromJson: Uri.parse) final  Uri downloadUrl;

/// Create a copy of GitHubAssetDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GitHubAssetDtoCopyWith<_GitHubAssetDto> get copyWith => __$GitHubAssetDtoCopyWithImpl<_GitHubAssetDto>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GitHubAssetDto&&(identical(other.name, name) || other.name == name)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,downloadUrl);
}

@override
String toString() {
    return 'GitHubAssetDto(name: $name, downloadUrl: $downloadUrl)';
}


}

/// @nodoc
abstract mixin class _$GitHubAssetDtoCopyWith<$Res> implements $GitHubAssetDtoCopyWith<$Res> {
  factory _$GitHubAssetDtoCopyWith(_GitHubAssetDto value, $Res Function(_GitHubAssetDto) _then) = __$GitHubAssetDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'browser_download_url', fromJson: Uri.parse) Uri downloadUrl
});




}
/// @nodoc
class __$GitHubAssetDtoCopyWithImpl<$Res>
    implements _$GitHubAssetDtoCopyWith<$Res> {
  __$GitHubAssetDtoCopyWithImpl(this._self, this._then);

  final _GitHubAssetDto _self;
  final $Res Function(_GitHubAssetDto) _then;

/// Create a copy of GitHubAssetDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? downloadUrl = null,}) {
  return _then(_GitHubAssetDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}


}

// dart format on
