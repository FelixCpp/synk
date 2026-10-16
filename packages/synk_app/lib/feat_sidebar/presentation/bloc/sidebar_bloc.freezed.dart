// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sidebar_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SidebarState {

 List<SidebarDevice> get devices;
/// Create a copy of SidebarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SidebarStateCopyWith<SidebarState> get copyWith => _$SidebarStateCopyWithImpl<SidebarState>(this as SidebarState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SidebarState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SidebarState&&const DeepCollectionEquality().equals(other.devices, _this.devices));
}


@override
int get hashCode {
  final _this = this as SidebarState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.devices));
}

@override
String toString() {
  final _this = this as SidebarState;
  return 'SidebarState(devices: ${_this.devices})';
}


}

/// @nodoc
abstract mixin class $SidebarStateCopyWith<$Res>  {
  factory $SidebarStateCopyWith(SidebarState value, $Res Function(SidebarState) _then) = _$SidebarStateCopyWithImpl;
@useResult
$Res call({
 List<SidebarDevice> devices
});




}
/// @nodoc
class _$SidebarStateCopyWithImpl<$Res>
    implements $SidebarStateCopyWith<$Res> {
  _$SidebarStateCopyWithImpl(this._self, this._then);

  final SidebarState _self;
  final $Res Function(SidebarState) _then;

/// Create a copy of SidebarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? devices = null,}) {
  return _then(SidebarState(
devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<SidebarDevice>,
  ));
}

}


/// Adds pattern-matching-related methods to [SidebarState].
extension SidebarStatePatterns on SidebarState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SidebarState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SidebarState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SidebarState value)  $default,){
final _that = this;
switch (_that) {
case _SidebarState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SidebarState value)?  $default,){
final _that = this;
switch (_that) {
case _SidebarState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SidebarDevice> devices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SidebarState() when $default != null:
return $default(_that.devices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SidebarDevice> devices)  $default,) {final _that = this;
switch (_that) {
case _SidebarState():
return $default(_that.devices);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SidebarDevice> devices)?  $default,) {final _that = this;
switch (_that) {
case _SidebarState() when $default != null:
return $default(_that.devices);case _:
  return null;

}
}

}

/// @nodoc


class _SidebarState implements SidebarState {
  const _SidebarState({required  List<SidebarDevice> devices}): _devices = devices;
  

 final  List<SidebarDevice> _devices;
@override List<SidebarDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}


/// Create a copy of SidebarState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SidebarStateCopyWith<_SidebarState> get copyWith => __$SidebarStateCopyWithImpl<_SidebarState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SidebarState&&const DeepCollectionEquality().equals(other.devices, _devices));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_devices));
}

@override
String toString() {
    return 'SidebarState(devices: $devices)';
}


}

/// @nodoc
abstract mixin class _$SidebarStateCopyWith<$Res> implements $SidebarStateCopyWith<$Res> {
  factory _$SidebarStateCopyWith(_SidebarState value, $Res Function(_SidebarState) _then) = __$SidebarStateCopyWithImpl;
@override @useResult
$Res call({
 List<SidebarDevice> devices
});




}
/// @nodoc
class __$SidebarStateCopyWithImpl<$Res>
    implements _$SidebarStateCopyWith<$Res> {
  __$SidebarStateCopyWithImpl(this._self, this._then);

  final _SidebarState _self;
  final $Res Function(_SidebarState) _then;

/// Create a copy of SidebarState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? devices = null,}) {
  return _then(_SidebarState(
devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<SidebarDevice>,
  ));
}


}

/// @nodoc
mixin _$SidebarEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SidebarEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarEvent()';
}


}

/// @nodoc
class $SidebarEventCopyWith<$Res>  {
$SidebarEventCopyWith(SidebarEvent _, $Res Function(SidebarEvent) __);
}


/// Adds pattern-matching-related methods to [SidebarEvent].
extension SidebarEventPatterns on SidebarEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSetup value)?  onSetup,TResult Function( _OnConnect value)?  onConnect,TResult Function( _OnOpenCameraPrivacySettings value)?  onOpenCameraPrivacySettings,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnConnect() when onConnect != null:
return onConnect(_that);case _OnOpenCameraPrivacySettings() when onOpenCameraPrivacySettings != null:
return onOpenCameraPrivacySettings(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSetup value)  onSetup,required TResult Function( _OnConnect value)  onConnect,required TResult Function( _OnOpenCameraPrivacySettings value)  onOpenCameraPrivacySettings,}){
final _that = this;
switch (_that) {
case _OnSetup():
return onSetup(_that);case _OnConnect():
return onConnect(_that);case _OnOpenCameraPrivacySettings():
return onOpenCameraPrivacySettings(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSetup value)?  onSetup,TResult? Function( _OnConnect value)?  onConnect,TResult? Function( _OnOpenCameraPrivacySettings value)?  onOpenCameraPrivacySettings,}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnConnect() when onConnect != null:
return onConnect(_that);case _OnOpenCameraPrivacySettings() when onOpenCameraPrivacySettings != null:
return onOpenCameraPrivacySettings(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onSetup,TResult Function( PluggedDevice device)?  onConnect,TResult Function()?  onOpenCameraPrivacySettings,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnConnect() when onConnect != null:
return onConnect(_that.device);case _OnOpenCameraPrivacySettings() when onOpenCameraPrivacySettings != null:
return onOpenCameraPrivacySettings();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onSetup,required TResult Function( PluggedDevice device)  onConnect,required TResult Function()  onOpenCameraPrivacySettings,}) {final _that = this;
switch (_that) {
case _OnSetup():
return onSetup();case _OnConnect():
return onConnect(_that.device);case _OnOpenCameraPrivacySettings():
return onOpenCameraPrivacySettings();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onSetup,TResult? Function( PluggedDevice device)?  onConnect,TResult? Function()?  onOpenCameraPrivacySettings,}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnConnect() when onConnect != null:
return onConnect(_that.device);case _OnOpenCameraPrivacySettings() when onOpenCameraPrivacySettings != null:
return onOpenCameraPrivacySettings();case _:
  return null;

}
}

}

/// @nodoc


class _OnSetup implements SidebarEvent {
  const _OnSetup();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSetup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarEvent.onSetup()';
}


}




/// @nodoc


class _OnConnect implements SidebarEvent {
  const _OnConnect(this.device);
  

 final  PluggedDevice device;

/// Create a copy of SidebarEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnConnectCopyWith<_OnConnect> get copyWith => __$OnConnectCopyWithImpl<_OnConnect>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnConnect&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device);
}

@override
String toString() {
    return 'SidebarEvent.onConnect(device: $device)';
}


}

/// @nodoc
abstract mixin class _$OnConnectCopyWith<$Res> implements $SidebarEventCopyWith<$Res> {
  factory _$OnConnectCopyWith(_OnConnect value, $Res Function(_OnConnect) _then) = __$OnConnectCopyWithImpl;
@useResult
$Res call({
 PluggedDevice device
});




}
/// @nodoc
class __$OnConnectCopyWithImpl<$Res>
    implements _$OnConnectCopyWith<$Res> {
  __$OnConnectCopyWithImpl(this._self, this._then);

  final _OnConnect _self;
  final $Res Function(_OnConnect) _then;

/// Create a copy of SidebarEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? device = null,}) {
  return _then(_OnConnect(
null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PluggedDevice,
  ));
}


}

/// @nodoc


class _OnOpenCameraPrivacySettings implements SidebarEvent {
  const _OnOpenCameraPrivacySettings();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnOpenCameraPrivacySettings);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarEvent.onOpenCameraPrivacySettings()';
}


}




// dart format on
