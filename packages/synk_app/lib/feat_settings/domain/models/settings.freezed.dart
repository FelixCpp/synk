// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Settings {

 ThemeMode get themeMode; String get screenCaptureSavePath; bool get showCapturePreview; bool get copyScreenshotToClipboard; bool get recordAudio; MirrorFrameRate get frameRate; MirrorQuality get quality; bool get turnDeviceScreenOff; bool get muteOnConnect; bool get syncClipboard; String? get customAdbPath;
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCopyWith<Settings> get copyWith => _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Settings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settings&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode)&&(identical(other.screenCaptureSavePath, _this.screenCaptureSavePath) || other.screenCaptureSavePath == _this.screenCaptureSavePath)&&(identical(other.showCapturePreview, _this.showCapturePreview) || other.showCapturePreview == _this.showCapturePreview)&&(identical(other.copyScreenshotToClipboard, _this.copyScreenshotToClipboard) || other.copyScreenshotToClipboard == _this.copyScreenshotToClipboard)&&(identical(other.recordAudio, _this.recordAudio) || other.recordAudio == _this.recordAudio)&&(identical(other.frameRate, _this.frameRate) || other.frameRate == _this.frameRate)&&(identical(other.quality, _this.quality) || other.quality == _this.quality)&&(identical(other.turnDeviceScreenOff, _this.turnDeviceScreenOff) || other.turnDeviceScreenOff == _this.turnDeviceScreenOff)&&(identical(other.muteOnConnect, _this.muteOnConnect) || other.muteOnConnect == _this.muteOnConnect)&&(identical(other.syncClipboard, _this.syncClipboard) || other.syncClipboard == _this.syncClipboard)&&(identical(other.customAdbPath, _this.customAdbPath) || other.customAdbPath == _this.customAdbPath));
}


@override
int get hashCode {
  final _this = this as Settings;
  return Object.hash(runtimeType,_this.themeMode,_this.screenCaptureSavePath,_this.showCapturePreview,_this.copyScreenshotToClipboard,_this.recordAudio,_this.frameRate,_this.quality,_this.turnDeviceScreenOff,_this.muteOnConnect,_this.syncClipboard,_this.customAdbPath);
}

@override
String toString() {
  final _this = this as Settings;
  return 'Settings(themeMode: ${_this.themeMode}, screenCaptureSavePath: ${_this.screenCaptureSavePath}, showCapturePreview: ${_this.showCapturePreview}, copyScreenshotToClipboard: ${_this.copyScreenshotToClipboard}, recordAudio: ${_this.recordAudio}, frameRate: ${_this.frameRate}, quality: ${_this.quality}, turnDeviceScreenOff: ${_this.turnDeviceScreenOff}, muteOnConnect: ${_this.muteOnConnect}, syncClipboard: ${_this.syncClipboard}, customAdbPath: ${_this.customAdbPath})';
}


}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res>  {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) = _$SettingsCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode, String screenCaptureSavePath, bool showCapturePreview, bool copyScreenshotToClipboard, bool recordAudio, MirrorFrameRate frameRate, MirrorQuality quality, bool turnDeviceScreenOff, bool muteOnConnect, bool syncClipboard, String? customAdbPath
});




}
/// @nodoc
class _$SettingsCopyWithImpl<$Res>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? screenCaptureSavePath = null,Object? showCapturePreview = null,Object? copyScreenshotToClipboard = null,Object? recordAudio = null,Object? frameRate = null,Object? quality = null,Object? turnDeviceScreenOff = null,Object? muteOnConnect = null,Object? syncClipboard = null,Object? customAdbPath = freezed,}) {
  return _then(Settings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,screenCaptureSavePath: null == screenCaptureSavePath ? _self.screenCaptureSavePath : screenCaptureSavePath // ignore: cast_nullable_to_non_nullable
as String,showCapturePreview: null == showCapturePreview ? _self.showCapturePreview : showCapturePreview // ignore: cast_nullable_to_non_nullable
as bool,copyScreenshotToClipboard: null == copyScreenshotToClipboard ? _self.copyScreenshotToClipboard : copyScreenshotToClipboard // ignore: cast_nullable_to_non_nullable
as bool,recordAudio: null == recordAudio ? _self.recordAudio : recordAudio // ignore: cast_nullable_to_non_nullable
as bool,frameRate: null == frameRate ? _self.frameRate : frameRate // ignore: cast_nullable_to_non_nullable
as MirrorFrameRate,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as MirrorQuality,turnDeviceScreenOff: null == turnDeviceScreenOff ? _self.turnDeviceScreenOff : turnDeviceScreenOff // ignore: cast_nullable_to_non_nullable
as bool,muteOnConnect: null == muteOnConnect ? _self.muteOnConnect : muteOnConnect // ignore: cast_nullable_to_non_nullable
as bool,syncClipboard: null == syncClipboard ? _self.syncClipboard : syncClipboard // ignore: cast_nullable_to_non_nullable
as bool,customAdbPath: freezed == customAdbPath ? _self.customAdbPath : customAdbPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Settings].
extension SettingsPatterns on Settings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settings value)  $default,){
final _that = this;
switch (_that) {
case _Settings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settings value)?  $default,){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeMode themeMode,  String screenCaptureSavePath,  bool showCapturePreview,  bool copyScreenshotToClipboard,  bool recordAudio,  MirrorFrameRate frameRate,  MirrorQuality quality,  bool turnDeviceScreenOff,  bool muteOnConnect,  bool syncClipboard,  String? customAdbPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.themeMode,_that.screenCaptureSavePath,_that.showCapturePreview,_that.copyScreenshotToClipboard,_that.recordAudio,_that.frameRate,_that.quality,_that.turnDeviceScreenOff,_that.muteOnConnect,_that.syncClipboard,_that.customAdbPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeMode themeMode,  String screenCaptureSavePath,  bool showCapturePreview,  bool copyScreenshotToClipboard,  bool recordAudio,  MirrorFrameRate frameRate,  MirrorQuality quality,  bool turnDeviceScreenOff,  bool muteOnConnect,  bool syncClipboard,  String? customAdbPath)  $default,) {final _that = this;
switch (_that) {
case _Settings():
return $default(_that.themeMode,_that.screenCaptureSavePath,_that.showCapturePreview,_that.copyScreenshotToClipboard,_that.recordAudio,_that.frameRate,_that.quality,_that.turnDeviceScreenOff,_that.muteOnConnect,_that.syncClipboard,_that.customAdbPath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeMode themeMode,  String screenCaptureSavePath,  bool showCapturePreview,  bool copyScreenshotToClipboard,  bool recordAudio,  MirrorFrameRate frameRate,  MirrorQuality quality,  bool turnDeviceScreenOff,  bool muteOnConnect,  bool syncClipboard,  String? customAdbPath)?  $default,) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.themeMode,_that.screenCaptureSavePath,_that.showCapturePreview,_that.copyScreenshotToClipboard,_that.recordAudio,_that.frameRate,_that.quality,_that.turnDeviceScreenOff,_that.muteOnConnect,_that.syncClipboard,_that.customAdbPath);case _:
  return null;

}
}

}

/// @nodoc


class _Settings extends Settings {
  const _Settings({required this.themeMode, required this.screenCaptureSavePath, required this.showCapturePreview, required this.copyScreenshotToClipboard, required this.recordAudio, required this.frameRate, required this.quality, required this.turnDeviceScreenOff, required this.muteOnConnect, required this.syncClipboard, required this.customAdbPath}): super._();
  

@override final  ThemeMode themeMode;
@override final  String screenCaptureSavePath;
@override final  bool showCapturePreview;
@override final  bool copyScreenshotToClipboard;
@override final  bool recordAudio;
@override final  MirrorFrameRate frameRate;
@override final  MirrorQuality quality;
@override final  bool turnDeviceScreenOff;
@override final  bool muteOnConnect;
@override final  bool syncClipboard;
@override final  String? customAdbPath;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCopyWith<_Settings> get copyWith => __$SettingsCopyWithImpl<_Settings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.screenCaptureSavePath, screenCaptureSavePath) || other.screenCaptureSavePath == screenCaptureSavePath)&&(identical(other.showCapturePreview, showCapturePreview) || other.showCapturePreview == showCapturePreview)&&(identical(other.copyScreenshotToClipboard, copyScreenshotToClipboard) || other.copyScreenshotToClipboard == copyScreenshotToClipboard)&&(identical(other.recordAudio, recordAudio) || other.recordAudio == recordAudio)&&(identical(other.frameRate, frameRate) || other.frameRate == frameRate)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.turnDeviceScreenOff, turnDeviceScreenOff) || other.turnDeviceScreenOff == turnDeviceScreenOff)&&(identical(other.muteOnConnect, muteOnConnect) || other.muteOnConnect == muteOnConnect)&&(identical(other.syncClipboard, syncClipboard) || other.syncClipboard == syncClipboard)&&(identical(other.customAdbPath, customAdbPath) || other.customAdbPath == customAdbPath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,themeMode,screenCaptureSavePath,showCapturePreview,copyScreenshotToClipboard,recordAudio,frameRate,quality,turnDeviceScreenOff,muteOnConnect,syncClipboard,customAdbPath);
}

@override
String toString() {
    return 'Settings(themeMode: $themeMode, screenCaptureSavePath: $screenCaptureSavePath, showCapturePreview: $showCapturePreview, copyScreenshotToClipboard: $copyScreenshotToClipboard, recordAudio: $recordAudio, frameRate: $frameRate, quality: $quality, turnDeviceScreenOff: $turnDeviceScreenOff, muteOnConnect: $muteOnConnect, syncClipboard: $syncClipboard, customAdbPath: $customAdbPath)';
}


}

/// @nodoc
abstract mixin class _$SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) _then) = __$SettingsCopyWithImpl;
@override @useResult
$Res call({
 ThemeMode themeMode, String screenCaptureSavePath, bool showCapturePreview, bool copyScreenshotToClipboard, bool recordAudio, MirrorFrameRate frameRate, MirrorQuality quality, bool turnDeviceScreenOff, bool muteOnConnect, bool syncClipboard, String? customAdbPath
});




}
/// @nodoc
class __$SettingsCopyWithImpl<$Res>
    implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(this._self, this._then);

  final _Settings _self;
  final $Res Function(_Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? screenCaptureSavePath = null,Object? showCapturePreview = null,Object? copyScreenshotToClipboard = null,Object? recordAudio = null,Object? frameRate = null,Object? quality = null,Object? turnDeviceScreenOff = null,Object? muteOnConnect = null,Object? syncClipboard = null,Object? customAdbPath = freezed,}) {
  return _then(_Settings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,screenCaptureSavePath: null == screenCaptureSavePath ? _self.screenCaptureSavePath : screenCaptureSavePath // ignore: cast_nullable_to_non_nullable
as String,showCapturePreview: null == showCapturePreview ? _self.showCapturePreview : showCapturePreview // ignore: cast_nullable_to_non_nullable
as bool,copyScreenshotToClipboard: null == copyScreenshotToClipboard ? _self.copyScreenshotToClipboard : copyScreenshotToClipboard // ignore: cast_nullable_to_non_nullable
as bool,recordAudio: null == recordAudio ? _self.recordAudio : recordAudio // ignore: cast_nullable_to_non_nullable
as bool,frameRate: null == frameRate ? _self.frameRate : frameRate // ignore: cast_nullable_to_non_nullable
as MirrorFrameRate,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as MirrorQuality,turnDeviceScreenOff: null == turnDeviceScreenOff ? _self.turnDeviceScreenOff : turnDeviceScreenOff // ignore: cast_nullable_to_non_nullable
as bool,muteOnConnect: null == muteOnConnect ? _self.muteOnConnect : muteOnConnect // ignore: cast_nullable_to_non_nullable
as bool,syncClipboard: null == syncClipboard ? _self.syncClipboard : syncClipboard // ignore: cast_nullable_to_non_nullable
as bool,customAdbPath: freezed == customAdbPath ? _self.customAdbPath : customAdbPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
