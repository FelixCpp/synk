// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_capture_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScreenCaptureEvent {

 String get filepath; DeviceScreenSize get screenSize; DeviceId get deviceId; String get modelName;
/// Create a copy of ScreenCaptureEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenCaptureEventCopyWith<ScreenCaptureEvent> get copyWith => _$ScreenCaptureEventCopyWithImpl<ScreenCaptureEvent>(this as ScreenCaptureEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScreenCaptureEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenCaptureEvent&&(identical(other.filepath, _this.filepath) || other.filepath == _this.filepath)&&(identical(other.screenSize, _this.screenSize) || other.screenSize == _this.screenSize)&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.modelName, _this.modelName) || other.modelName == _this.modelName));
}


@override
int get hashCode {
  final _this = this as ScreenCaptureEvent;
  return Object.hash(runtimeType,_this.filepath,_this.screenSize,_this.deviceId,_this.modelName);
}

@override
String toString() {
  final _this = this as ScreenCaptureEvent;
  return 'ScreenCaptureEvent(filepath: ${_this.filepath}, screenSize: ${_this.screenSize}, deviceId: ${_this.deviceId}, modelName: ${_this.modelName})';
}


}

/// @nodoc
abstract mixin class $ScreenCaptureEventCopyWith<$Res>  {
  factory $ScreenCaptureEventCopyWith(ScreenCaptureEvent value, $Res Function(ScreenCaptureEvent) _then) = _$ScreenCaptureEventCopyWithImpl;
@useResult
$Res call({
 String filepath, DeviceScreenSize screenSize, DeviceId deviceId, String modelName
});


$DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class _$ScreenCaptureEventCopyWithImpl<$Res>
    implements $ScreenCaptureEventCopyWith<$Res> {
  _$ScreenCaptureEventCopyWithImpl(this._self, this._then);

  final ScreenCaptureEvent _self;
  final $Res Function(ScreenCaptureEvent) _then;

/// Create a copy of ScreenCaptureEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filepath = null,Object? screenSize = null,Object? deviceId = null,Object? modelName = null,}) {
  return _then(_self.copyWith(
filepath: null == filepath ? _self.filepath : filepath // ignore: cast_nullable_to_non_nullable
as String,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of ScreenCaptureEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceScreenSizeCopyWith<$Res> get screenSize {
  
  return $DeviceScreenSizeCopyWith<$Res>(_self.screenSize, (value) {
    return _then(_self.copyWith(screenSize: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScreenCaptureEvent].
extension ScreenCaptureEventPatterns on ScreenCaptureEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Png value)?  png,TResult Function( _Video value)?  video,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Png() when png != null:
return png(_that);case _Video() when video != null:
return video(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Png value)  png,required TResult Function( _Video value)  video,}){
final _that = this;
switch (_that) {
case _Png():
return png(_that);case _Video():
return video(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Png value)?  png,TResult? Function( _Video value)?  video,}){
final _that = this;
switch (_that) {
case _Png() when png != null:
return png(_that);case _Video() when video != null:
return video(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Uint8List bytes,  String filepath,  DeviceScreenSize screenSize,  DeviceId deviceId,  String modelName)?  png,TResult Function( Uint8List? posterBytes,  String filepath,  DeviceScreenSize screenSize,  DeviceId deviceId,  String modelName)?  video,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Png() when png != null:
return png(_that.bytes,_that.filepath,_that.screenSize,_that.deviceId,_that.modelName);case _Video() when video != null:
return video(_that.posterBytes,_that.filepath,_that.screenSize,_that.deviceId,_that.modelName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Uint8List bytes,  String filepath,  DeviceScreenSize screenSize,  DeviceId deviceId,  String modelName)  png,required TResult Function( Uint8List? posterBytes,  String filepath,  DeviceScreenSize screenSize,  DeviceId deviceId,  String modelName)  video,}) {final _that = this;
switch (_that) {
case _Png():
return png(_that.bytes,_that.filepath,_that.screenSize,_that.deviceId,_that.modelName);case _Video():
return video(_that.posterBytes,_that.filepath,_that.screenSize,_that.deviceId,_that.modelName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Uint8List bytes,  String filepath,  DeviceScreenSize screenSize,  DeviceId deviceId,  String modelName)?  png,TResult? Function( Uint8List? posterBytes,  String filepath,  DeviceScreenSize screenSize,  DeviceId deviceId,  String modelName)?  video,}) {final _that = this;
switch (_that) {
case _Png() when png != null:
return png(_that.bytes,_that.filepath,_that.screenSize,_that.deviceId,_that.modelName);case _Video() when video != null:
return video(_that.posterBytes,_that.filepath,_that.screenSize,_that.deviceId,_that.modelName);case _:
  return null;

}
}

}

/// @nodoc


class _Png implements ScreenCaptureEvent {
  const _Png({required this.bytes, required this.filepath, required this.screenSize, required this.deviceId, required this.modelName});
  

 final  Uint8List bytes;
@override final  String filepath;
@override final  DeviceScreenSize screenSize;
@override final  DeviceId deviceId;
@override final  String modelName;

/// Create a copy of ScreenCaptureEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PngCopyWith<_Png> get copyWith => __$PngCopyWithImpl<_Png>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Png&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.filepath, filepath) || other.filepath == filepath)&&(identical(other.screenSize, screenSize) || other.screenSize == screenSize)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.modelName, modelName) || other.modelName == modelName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),filepath,screenSize,deviceId,modelName);
}

@override
String toString() {
    return 'ScreenCaptureEvent.png(bytes: $bytes, filepath: $filepath, screenSize: $screenSize, deviceId: $deviceId, modelName: $modelName)';
}


}

/// @nodoc
abstract mixin class _$PngCopyWith<$Res> implements $ScreenCaptureEventCopyWith<$Res> {
  factory _$PngCopyWith(_Png value, $Res Function(_Png) _then) = __$PngCopyWithImpl;
@override @useResult
$Res call({
 Uint8List bytes, String filepath, DeviceScreenSize screenSize, DeviceId deviceId, String modelName
});


@override $DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class __$PngCopyWithImpl<$Res>
    implements _$PngCopyWith<$Res> {
  __$PngCopyWithImpl(this._self, this._then);

  final _Png _self;
  final $Res Function(_Png) _then;

/// Create a copy of ScreenCaptureEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bytes = null,Object? filepath = null,Object? screenSize = null,Object? deviceId = null,Object? modelName = null,}) {
  return _then(_Png(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,filepath: null == filepath ? _self.filepath : filepath // ignore: cast_nullable_to_non_nullable
as String,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ScreenCaptureEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceScreenSizeCopyWith<$Res> get screenSize {
  
  return $DeviceScreenSizeCopyWith<$Res>(_self.screenSize, (value) {
    return _then(_self.copyWith(screenSize: value));
  });
}
}

/// @nodoc


class _Video implements ScreenCaptureEvent {
  const _Video({required this.posterBytes, required this.filepath, required this.screenSize, required this.deviceId, required this.modelName});
  

 final  Uint8List? posterBytes;
@override final  String filepath;
@override final  DeviceScreenSize screenSize;
@override final  DeviceId deviceId;
@override final  String modelName;

/// Create a copy of ScreenCaptureEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoCopyWith<_Video> get copyWith => __$VideoCopyWithImpl<_Video>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Video&&const DeepCollectionEquality().equals(other.posterBytes, posterBytes)&&(identical(other.filepath, filepath) || other.filepath == filepath)&&(identical(other.screenSize, screenSize) || other.screenSize == screenSize)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.modelName, modelName) || other.modelName == modelName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(posterBytes),filepath,screenSize,deviceId,modelName);
}

@override
String toString() {
    return 'ScreenCaptureEvent.video(posterBytes: $posterBytes, filepath: $filepath, screenSize: $screenSize, deviceId: $deviceId, modelName: $modelName)';
}


}

/// @nodoc
abstract mixin class _$VideoCopyWith<$Res> implements $ScreenCaptureEventCopyWith<$Res> {
  factory _$VideoCopyWith(_Video value, $Res Function(_Video) _then) = __$VideoCopyWithImpl;
@override @useResult
$Res call({
 Uint8List? posterBytes, String filepath, DeviceScreenSize screenSize, DeviceId deviceId, String modelName
});


@override $DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class __$VideoCopyWithImpl<$Res>
    implements _$VideoCopyWith<$Res> {
  __$VideoCopyWithImpl(this._self, this._then);

  final _Video _self;
  final $Res Function(_Video) _then;

/// Create a copy of ScreenCaptureEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posterBytes = freezed,Object? filepath = null,Object? screenSize = null,Object? deviceId = null,Object? modelName = null,}) {
  return _then(_Video(
posterBytes: freezed == posterBytes ? _self.posterBytes : posterBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,filepath: null == filepath ? _self.filepath : filepath // ignore: cast_nullable_to_non_nullable
as String,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ScreenCaptureEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceScreenSizeCopyWith<$Res> get screenSize {
  
  return $DeviceScreenSizeCopyWith<$Res>(_self.screenSize, (value) {
    return _then(_self.copyWith(screenSize: value));
  });
}
}

// dart format on
