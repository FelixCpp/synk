// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceConnection {

 PluggedDevice get device; NativeTextureId get textureId; DeviceScreenSize get screenSize; bool get supportsInteraction; Set<DeviceNavigation> get navigations; bool get supportsFileTransfer; bool get supportsAudio;
/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceConnectionCopyWith<DeviceConnection> get copyWith => _$DeviceConnectionCopyWithImpl<DeviceConnection>(this as DeviceConnection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceConnection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceConnection&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.textureId, _this.textureId) || other.textureId == _this.textureId)&&(identical(other.screenSize, _this.screenSize) || other.screenSize == _this.screenSize)&&(identical(other.supportsInteraction, _this.supportsInteraction) || other.supportsInteraction == _this.supportsInteraction)&&const DeepCollectionEquality().equals(other.navigations, _this.navigations)&&(identical(other.supportsFileTransfer, _this.supportsFileTransfer) || other.supportsFileTransfer == _this.supportsFileTransfer)&&(identical(other.supportsAudio, _this.supportsAudio) || other.supportsAudio == _this.supportsAudio));
}


@override
int get hashCode {
  final _this = this as DeviceConnection;
  return Object.hash(runtimeType,_this.device,_this.textureId,_this.screenSize,_this.supportsInteraction,const DeepCollectionEquality().hash(_this.navigations),_this.supportsFileTransfer,_this.supportsAudio);
}

@override
String toString() {
  final _this = this as DeviceConnection;
  return 'DeviceConnection(device: ${_this.device}, textureId: ${_this.textureId}, screenSize: ${_this.screenSize}, supportsInteraction: ${_this.supportsInteraction}, navigations: ${_this.navigations}, supportsFileTransfer: ${_this.supportsFileTransfer}, supportsAudio: ${_this.supportsAudio})';
}


}

/// @nodoc
abstract mixin class $DeviceConnectionCopyWith<$Res>  {
  factory $DeviceConnectionCopyWith(DeviceConnection value, $Res Function(DeviceConnection) _then) = _$DeviceConnectionCopyWithImpl;
@useResult
$Res call({
 PluggedDevice device, NativeTextureId textureId, DeviceScreenSize screenSize, bool supportsInteraction, Set<DeviceNavigation> navigations, bool supportsFileTransfer, bool supportsAudio
});


$DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class _$DeviceConnectionCopyWithImpl<$Res>
    implements $DeviceConnectionCopyWith<$Res> {
  _$DeviceConnectionCopyWithImpl(this._self, this._then);

  final DeviceConnection _self;
  final $Res Function(DeviceConnection) _then;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? textureId = null,Object? screenSize = null,Object? supportsInteraction = null,Object? navigations = null,Object? supportsFileTransfer = null,Object? supportsAudio = null,}) {
  return _then(DeviceConnection(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PluggedDevice,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,supportsInteraction: null == supportsInteraction ? _self.supportsInteraction : supportsInteraction // ignore: cast_nullable_to_non_nullable
as bool,navigations: null == navigations ? _self.navigations : navigations // ignore: cast_nullable_to_non_nullable
as Set<DeviceNavigation>,supportsFileTransfer: null == supportsFileTransfer ? _self.supportsFileTransfer : supportsFileTransfer // ignore: cast_nullable_to_non_nullable
as bool,supportsAudio: null == supportsAudio ? _self.supportsAudio : supportsAudio // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceScreenSizeCopyWith<$Res> get screenSize {
  
  return $DeviceScreenSizeCopyWith<$Res>(_self.screenSize, (value) {
    return _then(_self.copyWith(screenSize: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeviceConnection].
extension DeviceConnectionPatterns on DeviceConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceConnection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceConnection value)  $default,){
final _that = this;
switch (_that) {
case _DeviceConnection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceConnection value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceConnection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PluggedDevice device,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction,  Set<DeviceNavigation> navigations,  bool supportsFileTransfer,  bool supportsAudio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceConnection() when $default != null:
return $default(_that.device,_that.textureId,_that.screenSize,_that.supportsInteraction,_that.navigations,_that.supportsFileTransfer,_that.supportsAudio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PluggedDevice device,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction,  Set<DeviceNavigation> navigations,  bool supportsFileTransfer,  bool supportsAudio)  $default,) {final _that = this;
switch (_that) {
case _DeviceConnection():
return $default(_that.device,_that.textureId,_that.screenSize,_that.supportsInteraction,_that.navigations,_that.supportsFileTransfer,_that.supportsAudio);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PluggedDevice device,  NativeTextureId textureId,  DeviceScreenSize screenSize,  bool supportsInteraction,  Set<DeviceNavigation> navigations,  bool supportsFileTransfer,  bool supportsAudio)?  $default,) {final _that = this;
switch (_that) {
case _DeviceConnection() when $default != null:
return $default(_that.device,_that.textureId,_that.screenSize,_that.supportsInteraction,_that.navigations,_that.supportsFileTransfer,_that.supportsAudio);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceConnection implements DeviceConnection {
  const _DeviceConnection({required this.device, required this.textureId, required this.screenSize, required this.supportsInteraction, required  Set<DeviceNavigation> navigations, required this.supportsFileTransfer, required this.supportsAudio}): _navigations = navigations;
  

@override final  PluggedDevice device;
@override final  NativeTextureId textureId;
@override final  DeviceScreenSize screenSize;
@override final  bool supportsInteraction;
 final  Set<DeviceNavigation> _navigations;
@override Set<DeviceNavigation> get navigations {
  if (_navigations is EqualUnmodifiableSetView) return _navigations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_navigations);
}

@override final  bool supportsFileTransfer;
@override final  bool supportsAudio;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceConnectionCopyWith<_DeviceConnection> get copyWith => __$DeviceConnectionCopyWithImpl<_DeviceConnection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceConnection&&(identical(other.device, device) || other.device == device)&&(identical(other.textureId, textureId) || other.textureId == textureId)&&(identical(other.screenSize, screenSize) || other.screenSize == screenSize)&&(identical(other.supportsInteraction, supportsInteraction) || other.supportsInteraction == supportsInteraction)&&const DeepCollectionEquality().equals(other.navigations, _navigations)&&(identical(other.supportsFileTransfer, supportsFileTransfer) || other.supportsFileTransfer == supportsFileTransfer)&&(identical(other.supportsAudio, supportsAudio) || other.supportsAudio == supportsAudio));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,textureId,screenSize,supportsInteraction,const DeepCollectionEquality().hash(_navigations),supportsFileTransfer,supportsAudio);
}

@override
String toString() {
    return 'DeviceConnection(device: $device, textureId: $textureId, screenSize: $screenSize, supportsInteraction: $supportsInteraction, navigations: $navigations, supportsFileTransfer: $supportsFileTransfer, supportsAudio: $supportsAudio)';
}


}

/// @nodoc
abstract mixin class _$DeviceConnectionCopyWith<$Res> implements $DeviceConnectionCopyWith<$Res> {
  factory _$DeviceConnectionCopyWith(_DeviceConnection value, $Res Function(_DeviceConnection) _then) = __$DeviceConnectionCopyWithImpl;
@override @useResult
$Res call({
 PluggedDevice device, NativeTextureId textureId, DeviceScreenSize screenSize, bool supportsInteraction, Set<DeviceNavigation> navigations, bool supportsFileTransfer, bool supportsAudio
});


@override $DeviceScreenSizeCopyWith<$Res> get screenSize;

}
/// @nodoc
class __$DeviceConnectionCopyWithImpl<$Res>
    implements _$DeviceConnectionCopyWith<$Res> {
  __$DeviceConnectionCopyWithImpl(this._self, this._then);

  final _DeviceConnection _self;
  final $Res Function(_DeviceConnection) _then;

/// Create a copy of DeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? textureId = null,Object? screenSize = null,Object? supportsInteraction = null,Object? navigations = null,Object? supportsFileTransfer = null,Object? supportsAudio = null,}) {
  return _then(_DeviceConnection(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PluggedDevice,textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as NativeTextureId,screenSize: null == screenSize ? _self.screenSize : screenSize // ignore: cast_nullable_to_non_nullable
as DeviceScreenSize,supportsInteraction: null == supportsInteraction ? _self.supportsInteraction : supportsInteraction // ignore: cast_nullable_to_non_nullable
as bool,navigations: null == navigations ? _self._navigations : navigations // ignore: cast_nullable_to_non_nullable
as Set<DeviceNavigation>,supportsFileTransfer: null == supportsFileTransfer ? _self.supportsFileTransfer : supportsFileTransfer // ignore: cast_nullable_to_non_nullable
as bool,supportsAudio: null == supportsAudio ? _self.supportsAudio : supportsAudio // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DeviceConnection
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
