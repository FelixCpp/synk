// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_frame_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceFrameEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceFrameEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceFrameEvent()';
}


}

/// @nodoc
class $DeviceFrameEventCopyWith<$Res>  {
$DeviceFrameEventCopyWith(DeviceFrameEvent _, $Res Function(DeviceFrameEvent) __);
}


/// Adds pattern-matching-related methods to [DeviceFrameEvent].
extension DeviceFrameEventPatterns on DeviceFrameEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSetup value)?  onSetup,TResult Function( _OnCaptureScreenshot value)?  onCaptureScreenshot,TResult Function( _OnToggleRecording value)?  onToggleRecording,TResult Function( _OnToggleAudioMute value)?  onToggleAudioMute,TResult Function( _OnPointerEvent value)?  onPointerEvent,TResult Function( _OnKeyEvent value)?  onKeyEvent,TResult Function( _OnFilesDropped value)?  onFilesDropped,TResult Function( _OnControlButtonPressed value)?  onControlButtonPressed,TResult Function( _OnInstallApk value)?  onInstallApk,TResult Function( _OnShareFile value)?  onShareFile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot(_that);case _OnToggleRecording() when onToggleRecording != null:
return onToggleRecording(_that);case _OnToggleAudioMute() when onToggleAudioMute != null:
return onToggleAudioMute(_that);case _OnPointerEvent() when onPointerEvent != null:
return onPointerEvent(_that);case _OnKeyEvent() when onKeyEvent != null:
return onKeyEvent(_that);case _OnFilesDropped() when onFilesDropped != null:
return onFilesDropped(_that);case _OnControlButtonPressed() when onControlButtonPressed != null:
return onControlButtonPressed(_that);case _OnInstallApk() when onInstallApk != null:
return onInstallApk(_that);case _OnShareFile() when onShareFile != null:
return onShareFile(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSetup value)  onSetup,required TResult Function( _OnCaptureScreenshot value)  onCaptureScreenshot,required TResult Function( _OnToggleRecording value)  onToggleRecording,required TResult Function( _OnToggleAudioMute value)  onToggleAudioMute,required TResult Function( _OnPointerEvent value)  onPointerEvent,required TResult Function( _OnKeyEvent value)  onKeyEvent,required TResult Function( _OnFilesDropped value)  onFilesDropped,required TResult Function( _OnControlButtonPressed value)  onControlButtonPressed,required TResult Function( _OnInstallApk value)  onInstallApk,required TResult Function( _OnShareFile value)  onShareFile,}){
final _that = this;
switch (_that) {
case _OnSetup():
return onSetup(_that);case _OnCaptureScreenshot():
return onCaptureScreenshot(_that);case _OnToggleRecording():
return onToggleRecording(_that);case _OnToggleAudioMute():
return onToggleAudioMute(_that);case _OnPointerEvent():
return onPointerEvent(_that);case _OnKeyEvent():
return onKeyEvent(_that);case _OnFilesDropped():
return onFilesDropped(_that);case _OnControlButtonPressed():
return onControlButtonPressed(_that);case _OnInstallApk():
return onInstallApk(_that);case _OnShareFile():
return onShareFile(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSetup value)?  onSetup,TResult? Function( _OnCaptureScreenshot value)?  onCaptureScreenshot,TResult? Function( _OnToggleRecording value)?  onToggleRecording,TResult? Function( _OnToggleAudioMute value)?  onToggleAudioMute,TResult? Function( _OnPointerEvent value)?  onPointerEvent,TResult? Function( _OnKeyEvent value)?  onKeyEvent,TResult? Function( _OnFilesDropped value)?  onFilesDropped,TResult? Function( _OnControlButtonPressed value)?  onControlButtonPressed,TResult? Function( _OnInstallApk value)?  onInstallApk,TResult? Function( _OnShareFile value)?  onShareFile,}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot(_that);case _OnToggleRecording() when onToggleRecording != null:
return onToggleRecording(_that);case _OnToggleAudioMute() when onToggleAudioMute != null:
return onToggleAudioMute(_that);case _OnPointerEvent() when onPointerEvent != null:
return onPointerEvent(_that);case _OnKeyEvent() when onKeyEvent != null:
return onKeyEvent(_that);case _OnFilesDropped() when onFilesDropped != null:
return onFilesDropped(_that);case _OnControlButtonPressed() when onControlButtonPressed != null:
return onControlButtonPressed(_that);case _OnInstallApk() when onInstallApk != null:
return onInstallApk(_that);case _OnShareFile() when onShareFile != null:
return onShareFile(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onSetup,TResult Function()?  onCaptureScreenshot,TResult Function()?  onToggleRecording,TResult Function()?  onToggleAudioMute,TResult Function( ScrcpyPointerEventType type,  double normalizedPointerX,  double normalizedPointerY)?  onPointerEvent,TResult Function( KeyEvent keyEvent)?  onKeyEvent,TResult Function( List<String> filepaths)?  onFilesDropped,TResult Function( ControlButtonType type)?  onControlButtonPressed,TResult Function()?  onInstallApk,TResult Function()?  onShareFile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot();case _OnToggleRecording() when onToggleRecording != null:
return onToggleRecording();case _OnToggleAudioMute() when onToggleAudioMute != null:
return onToggleAudioMute();case _OnPointerEvent() when onPointerEvent != null:
return onPointerEvent(_that.type,_that.normalizedPointerX,_that.normalizedPointerY);case _OnKeyEvent() when onKeyEvent != null:
return onKeyEvent(_that.keyEvent);case _OnFilesDropped() when onFilesDropped != null:
return onFilesDropped(_that.filepaths);case _OnControlButtonPressed() when onControlButtonPressed != null:
return onControlButtonPressed(_that.type);case _OnInstallApk() when onInstallApk != null:
return onInstallApk();case _OnShareFile() when onShareFile != null:
return onShareFile();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onSetup,required TResult Function()  onCaptureScreenshot,required TResult Function()  onToggleRecording,required TResult Function()  onToggleAudioMute,required TResult Function( ScrcpyPointerEventType type,  double normalizedPointerX,  double normalizedPointerY)  onPointerEvent,required TResult Function( KeyEvent keyEvent)  onKeyEvent,required TResult Function( List<String> filepaths)  onFilesDropped,required TResult Function( ControlButtonType type)  onControlButtonPressed,required TResult Function()  onInstallApk,required TResult Function()  onShareFile,}) {final _that = this;
switch (_that) {
case _OnSetup():
return onSetup();case _OnCaptureScreenshot():
return onCaptureScreenshot();case _OnToggleRecording():
return onToggleRecording();case _OnToggleAudioMute():
return onToggleAudioMute();case _OnPointerEvent():
return onPointerEvent(_that.type,_that.normalizedPointerX,_that.normalizedPointerY);case _OnKeyEvent():
return onKeyEvent(_that.keyEvent);case _OnFilesDropped():
return onFilesDropped(_that.filepaths);case _OnControlButtonPressed():
return onControlButtonPressed(_that.type);case _OnInstallApk():
return onInstallApk();case _OnShareFile():
return onShareFile();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onSetup,TResult? Function()?  onCaptureScreenshot,TResult? Function()?  onToggleRecording,TResult? Function()?  onToggleAudioMute,TResult? Function( ScrcpyPointerEventType type,  double normalizedPointerX,  double normalizedPointerY)?  onPointerEvent,TResult? Function( KeyEvent keyEvent)?  onKeyEvent,TResult? Function( List<String> filepaths)?  onFilesDropped,TResult? Function( ControlButtonType type)?  onControlButtonPressed,TResult? Function()?  onInstallApk,TResult? Function()?  onShareFile,}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnCaptureScreenshot() when onCaptureScreenshot != null:
return onCaptureScreenshot();case _OnToggleRecording() when onToggleRecording != null:
return onToggleRecording();case _OnToggleAudioMute() when onToggleAudioMute != null:
return onToggleAudioMute();case _OnPointerEvent() when onPointerEvent != null:
return onPointerEvent(_that.type,_that.normalizedPointerX,_that.normalizedPointerY);case _OnKeyEvent() when onKeyEvent != null:
return onKeyEvent(_that.keyEvent);case _OnFilesDropped() when onFilesDropped != null:
return onFilesDropped(_that.filepaths);case _OnControlButtonPressed() when onControlButtonPressed != null:
return onControlButtonPressed(_that.type);case _OnInstallApk() when onInstallApk != null:
return onInstallApk();case _OnShareFile() when onShareFile != null:
return onShareFile();case _:
  return null;

}
}

}

/// @nodoc


class _OnSetup implements DeviceFrameEvent {
  const _OnSetup();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSetup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceFrameEvent.onSetup()';
}


}




/// @nodoc


class _OnCaptureScreenshot implements DeviceFrameEvent {
  const _OnCaptureScreenshot();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnCaptureScreenshot);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceFrameEvent.onCaptureScreenshot()';
}


}




/// @nodoc


class _OnToggleRecording implements DeviceFrameEvent {
  const _OnToggleRecording();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnToggleRecording);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceFrameEvent.onToggleRecording()';
}


}




/// @nodoc


class _OnToggleAudioMute implements DeviceFrameEvent {
  const _OnToggleAudioMute();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnToggleAudioMute);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceFrameEvent.onToggleAudioMute()';
}


}




/// @nodoc


class _OnPointerEvent implements DeviceFrameEvent {
  const _OnPointerEvent(this.type, this.normalizedPointerX, this.normalizedPointerY);
  

 final  ScrcpyPointerEventType type;
 final  double normalizedPointerX;
 final  double normalizedPointerY;

/// Create a copy of DeviceFrameEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnPointerEventCopyWith<_OnPointerEvent> get copyWith => __$OnPointerEventCopyWithImpl<_OnPointerEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnPointerEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.normalizedPointerX, normalizedPointerX) || other.normalizedPointerX == normalizedPointerX)&&(identical(other.normalizedPointerY, normalizedPointerY) || other.normalizedPointerY == normalizedPointerY));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,normalizedPointerX,normalizedPointerY);
}

@override
String toString() {
    return 'DeviceFrameEvent.onPointerEvent(type: $type, normalizedPointerX: $normalizedPointerX, normalizedPointerY: $normalizedPointerY)';
}


}

/// @nodoc
abstract mixin class _$OnPointerEventCopyWith<$Res> implements $DeviceFrameEventCopyWith<$Res> {
  factory _$OnPointerEventCopyWith(_OnPointerEvent value, $Res Function(_OnPointerEvent) _then) = __$OnPointerEventCopyWithImpl;
@useResult
$Res call({
 ScrcpyPointerEventType type, double normalizedPointerX, double normalizedPointerY
});




}
/// @nodoc
class __$OnPointerEventCopyWithImpl<$Res>
    implements _$OnPointerEventCopyWith<$Res> {
  __$OnPointerEventCopyWithImpl(this._self, this._then);

  final _OnPointerEvent _self;
  final $Res Function(_OnPointerEvent) _then;

/// Create a copy of DeviceFrameEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,Object? normalizedPointerX = null,Object? normalizedPointerY = null,}) {
  return _then(_OnPointerEvent(
null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ScrcpyPointerEventType,null == normalizedPointerX ? _self.normalizedPointerX : normalizedPointerX // ignore: cast_nullable_to_non_nullable
as double,null == normalizedPointerY ? _self.normalizedPointerY : normalizedPointerY // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _OnKeyEvent implements DeviceFrameEvent {
  const _OnKeyEvent(this.keyEvent);
  

 final  KeyEvent keyEvent;

/// Create a copy of DeviceFrameEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnKeyEventCopyWith<_OnKeyEvent> get copyWith => __$OnKeyEventCopyWithImpl<_OnKeyEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnKeyEvent&&(identical(other.keyEvent, keyEvent) || other.keyEvent == keyEvent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,keyEvent);
}

@override
String toString() {
    return 'DeviceFrameEvent.onKeyEvent(keyEvent: $keyEvent)';
}


}

/// @nodoc
abstract mixin class _$OnKeyEventCopyWith<$Res> implements $DeviceFrameEventCopyWith<$Res> {
  factory _$OnKeyEventCopyWith(_OnKeyEvent value, $Res Function(_OnKeyEvent) _then) = __$OnKeyEventCopyWithImpl;
@useResult
$Res call({
 KeyEvent keyEvent
});




}
/// @nodoc
class __$OnKeyEventCopyWithImpl<$Res>
    implements _$OnKeyEventCopyWith<$Res> {
  __$OnKeyEventCopyWithImpl(this._self, this._then);

  final _OnKeyEvent _self;
  final $Res Function(_OnKeyEvent) _then;

/// Create a copy of DeviceFrameEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? keyEvent = null,}) {
  return _then(_OnKeyEvent(
null == keyEvent ? _self.keyEvent : keyEvent // ignore: cast_nullable_to_non_nullable
as KeyEvent,
  ));
}


}

/// @nodoc


class _OnFilesDropped implements DeviceFrameEvent {
  const _OnFilesDropped( List<String> filepaths): _filepaths = filepaths;
  

 final  List<String> _filepaths;
 List<String> get filepaths {
  if (_filepaths is EqualUnmodifiableListView) return _filepaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filepaths);
}


/// Create a copy of DeviceFrameEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnFilesDroppedCopyWith<_OnFilesDropped> get copyWith => __$OnFilesDroppedCopyWithImpl<_OnFilesDropped>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnFilesDropped&&const DeepCollectionEquality().equals(other.filepaths, _filepaths));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_filepaths));
}

@override
String toString() {
    return 'DeviceFrameEvent.onFilesDropped(filepaths: $filepaths)';
}


}

/// @nodoc
abstract mixin class _$OnFilesDroppedCopyWith<$Res> implements $DeviceFrameEventCopyWith<$Res> {
  factory _$OnFilesDroppedCopyWith(_OnFilesDropped value, $Res Function(_OnFilesDropped) _then) = __$OnFilesDroppedCopyWithImpl;
@useResult
$Res call({
 List<String> filepaths
});




}
/// @nodoc
class __$OnFilesDroppedCopyWithImpl<$Res>
    implements _$OnFilesDroppedCopyWith<$Res> {
  __$OnFilesDroppedCopyWithImpl(this._self, this._then);

  final _OnFilesDropped _self;
  final $Res Function(_OnFilesDropped) _then;

/// Create a copy of DeviceFrameEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filepaths = null,}) {
  return _then(_OnFilesDropped(
null == filepaths ? _self._filepaths : filepaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class _OnControlButtonPressed implements DeviceFrameEvent {
  const _OnControlButtonPressed(this.type);
  

 final  ControlButtonType type;

/// Create a copy of DeviceFrameEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnControlButtonPressedCopyWith<_OnControlButtonPressed> get copyWith => __$OnControlButtonPressedCopyWithImpl<_OnControlButtonPressed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnControlButtonPressed&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type);
}

@override
String toString() {
    return 'DeviceFrameEvent.onControlButtonPressed(type: $type)';
}


}

/// @nodoc
abstract mixin class _$OnControlButtonPressedCopyWith<$Res> implements $DeviceFrameEventCopyWith<$Res> {
  factory _$OnControlButtonPressedCopyWith(_OnControlButtonPressed value, $Res Function(_OnControlButtonPressed) _then) = __$OnControlButtonPressedCopyWithImpl;
@useResult
$Res call({
 ControlButtonType type
});




}
/// @nodoc
class __$OnControlButtonPressedCopyWithImpl<$Res>
    implements _$OnControlButtonPressedCopyWith<$Res> {
  __$OnControlButtonPressedCopyWithImpl(this._self, this._then);

  final _OnControlButtonPressed _self;
  final $Res Function(_OnControlButtonPressed) _then;

/// Create a copy of DeviceFrameEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_OnControlButtonPressed(
null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ControlButtonType,
  ));
}


}

/// @nodoc


class _OnInstallApk implements DeviceFrameEvent {
  const _OnInstallApk();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnInstallApk);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceFrameEvent.onInstallApk()';
}


}




/// @nodoc


class _OnShareFile implements DeviceFrameEvent {
  const _OnShareFile();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnShareFile);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceFrameEvent.onShareFile()';
}


}




/// @nodoc
mixin _$DeviceFrameState {

 bool get isProcessingDroppedFiles; bool get isRecording; bool get isAudioMuted;
/// Create a copy of DeviceFrameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceFrameStateCopyWith<DeviceFrameState> get copyWith => _$DeviceFrameStateCopyWithImpl<DeviceFrameState>(this as DeviceFrameState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceFrameState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceFrameState&&(identical(other.isProcessingDroppedFiles, _this.isProcessingDroppedFiles) || other.isProcessingDroppedFiles == _this.isProcessingDroppedFiles)&&(identical(other.isRecording, _this.isRecording) || other.isRecording == _this.isRecording)&&(identical(other.isAudioMuted, _this.isAudioMuted) || other.isAudioMuted == _this.isAudioMuted));
}


@override
int get hashCode {
  final _this = this as DeviceFrameState;
  return Object.hash(runtimeType,_this.isProcessingDroppedFiles,_this.isRecording,_this.isAudioMuted);
}

@override
String toString() {
  final _this = this as DeviceFrameState;
  return 'DeviceFrameState(isProcessingDroppedFiles: ${_this.isProcessingDroppedFiles}, isRecording: ${_this.isRecording}, isAudioMuted: ${_this.isAudioMuted})';
}


}

/// @nodoc
abstract mixin class $DeviceFrameStateCopyWith<$Res>  {
  factory $DeviceFrameStateCopyWith(DeviceFrameState value, $Res Function(DeviceFrameState) _then) = _$DeviceFrameStateCopyWithImpl;
@useResult
$Res call({
 bool isProcessingDroppedFiles, bool isRecording, bool isAudioMuted
});




}
/// @nodoc
class _$DeviceFrameStateCopyWithImpl<$Res>
    implements $DeviceFrameStateCopyWith<$Res> {
  _$DeviceFrameStateCopyWithImpl(this._self, this._then);

  final DeviceFrameState _self;
  final $Res Function(DeviceFrameState) _then;

/// Create a copy of DeviceFrameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isProcessingDroppedFiles = null,Object? isRecording = null,Object? isAudioMuted = null,}) {
  return _then(DeviceFrameState(
isProcessingDroppedFiles: null == isProcessingDroppedFiles ? _self.isProcessingDroppedFiles : isProcessingDroppedFiles // ignore: cast_nullable_to_non_nullable
as bool,isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,isAudioMuted: null == isAudioMuted ? _self.isAudioMuted : isAudioMuted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceFrameState].
extension DeviceFrameStatePatterns on DeviceFrameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceFrameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceFrameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceFrameState value)  $default,){
final _that = this;
switch (_that) {
case _DeviceFrameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceFrameState value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceFrameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isProcessingDroppedFiles,  bool isRecording,  bool isAudioMuted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceFrameState() when $default != null:
return $default(_that.isProcessingDroppedFiles,_that.isRecording,_that.isAudioMuted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isProcessingDroppedFiles,  bool isRecording,  bool isAudioMuted)  $default,) {final _that = this;
switch (_that) {
case _DeviceFrameState():
return $default(_that.isProcessingDroppedFiles,_that.isRecording,_that.isAudioMuted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isProcessingDroppedFiles,  bool isRecording,  bool isAudioMuted)?  $default,) {final _that = this;
switch (_that) {
case _DeviceFrameState() when $default != null:
return $default(_that.isProcessingDroppedFiles,_that.isRecording,_that.isAudioMuted);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceFrameState implements DeviceFrameState {
  const _DeviceFrameState({required this.isProcessingDroppedFiles, required this.isRecording, required this.isAudioMuted});
  

@override final  bool isProcessingDroppedFiles;
@override final  bool isRecording;
@override final  bool isAudioMuted;

/// Create a copy of DeviceFrameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceFrameStateCopyWith<_DeviceFrameState> get copyWith => __$DeviceFrameStateCopyWithImpl<_DeviceFrameState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceFrameState&&(identical(other.isProcessingDroppedFiles, isProcessingDroppedFiles) || other.isProcessingDroppedFiles == isProcessingDroppedFiles)&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&(identical(other.isAudioMuted, isAudioMuted) || other.isAudioMuted == isAudioMuted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isProcessingDroppedFiles,isRecording,isAudioMuted);
}

@override
String toString() {
    return 'DeviceFrameState(isProcessingDroppedFiles: $isProcessingDroppedFiles, isRecording: $isRecording, isAudioMuted: $isAudioMuted)';
}


}

/// @nodoc
abstract mixin class _$DeviceFrameStateCopyWith<$Res> implements $DeviceFrameStateCopyWith<$Res> {
  factory _$DeviceFrameStateCopyWith(_DeviceFrameState value, $Res Function(_DeviceFrameState) _then) = __$DeviceFrameStateCopyWithImpl;
@override @useResult
$Res call({
 bool isProcessingDroppedFiles, bool isRecording, bool isAudioMuted
});




}
/// @nodoc
class __$DeviceFrameStateCopyWithImpl<$Res>
    implements _$DeviceFrameStateCopyWith<$Res> {
  __$DeviceFrameStateCopyWithImpl(this._self, this._then);

  final _DeviceFrameState _self;
  final $Res Function(_DeviceFrameState) _then;

/// Create a copy of DeviceFrameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isProcessingDroppedFiles = null,Object? isRecording = null,Object? isAudioMuted = null,}) {
  return _then(_DeviceFrameState(
isProcessingDroppedFiles: null == isProcessingDroppedFiles ? _self.isProcessingDroppedFiles : isProcessingDroppedFiles // ignore: cast_nullable_to_non_nullable
as bool,isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,isAudioMuted: null == isAudioMuted ? _self.isAudioMuted : isAudioMuted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
