// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_pairing_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DevicePairingEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DevicePairingEvent()';
}


}

/// @nodoc
class $DevicePairingEventCopyWith<$Res>  {
$DevicePairingEventCopyWith(DevicePairingEvent _, $Res Function(DevicePairingEvent) __);
}


/// Adds pattern-matching-related methods to [DevicePairingEvent].
extension DevicePairingEventPatterns on DevicePairingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnStarted value)?  onStarted,TResult Function( _OnSubmitted value)?  onSubmitted,TResult Function( _OnConnectPortSubmitted value)?  onConnectPortSubmitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnStarted() when onStarted != null:
return onStarted(_that);case _OnSubmitted() when onSubmitted != null:
return onSubmitted(_that);case _OnConnectPortSubmitted() when onConnectPortSubmitted != null:
return onConnectPortSubmitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnStarted value)  onStarted,required TResult Function( _OnSubmitted value)  onSubmitted,required TResult Function( _OnConnectPortSubmitted value)  onConnectPortSubmitted,}){
final _that = this;
switch (_that) {
case _OnStarted():
return onStarted(_that);case _OnSubmitted():
return onSubmitted(_that);case _OnConnectPortSubmitted():
return onConnectPortSubmitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnStarted value)?  onStarted,TResult? Function( _OnSubmitted value)?  onSubmitted,TResult? Function( _OnConnectPortSubmitted value)?  onConnectPortSubmitted,}){
final _that = this;
switch (_that) {
case _OnStarted() when onStarted != null:
return onStarted(_that);case _OnSubmitted() when onSubmitted != null:
return onSubmitted(_that);case _OnConnectPortSubmitted() when onConnectPortSubmitted != null:
return onConnectPortSubmitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onStarted,TResult Function( String hostPort,  String pairingCode)?  onSubmitted,TResult Function( String port)?  onConnectPortSubmitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnStarted() when onStarted != null:
return onStarted();case _OnSubmitted() when onSubmitted != null:
return onSubmitted(_that.hostPort,_that.pairingCode);case _OnConnectPortSubmitted() when onConnectPortSubmitted != null:
return onConnectPortSubmitted(_that.port);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onStarted,required TResult Function( String hostPort,  String pairingCode)  onSubmitted,required TResult Function( String port)  onConnectPortSubmitted,}) {final _that = this;
switch (_that) {
case _OnStarted():
return onStarted();case _OnSubmitted():
return onSubmitted(_that.hostPort,_that.pairingCode);case _OnConnectPortSubmitted():
return onConnectPortSubmitted(_that.port);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onStarted,TResult? Function( String hostPort,  String pairingCode)?  onSubmitted,TResult? Function( String port)?  onConnectPortSubmitted,}) {final _that = this;
switch (_that) {
case _OnStarted() when onStarted != null:
return onStarted();case _OnSubmitted() when onSubmitted != null:
return onSubmitted(_that.hostPort,_that.pairingCode);case _OnConnectPortSubmitted() when onConnectPortSubmitted != null:
return onConnectPortSubmitted(_that.port);case _:
  return null;

}
}

}

/// @nodoc


class _OnStarted implements DevicePairingEvent {
  const _OnStarted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DevicePairingEvent.onStarted()';
}


}




/// @nodoc


class _OnSubmitted implements DevicePairingEvent {
  const _OnSubmitted({required this.hostPort, required this.pairingCode});
  

 final  String hostPort;
 final  String pairingCode;

/// Create a copy of DevicePairingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnSubmittedCopyWith<_OnSubmitted> get copyWith => __$OnSubmittedCopyWithImpl<_OnSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSubmitted&&(identical(other.hostPort, hostPort) || other.hostPort == hostPort)&&(identical(other.pairingCode, pairingCode) || other.pairingCode == pairingCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hostPort,pairingCode);
}

@override
String toString() {
    return 'DevicePairingEvent.onSubmitted(hostPort: $hostPort, pairingCode: $pairingCode)';
}


}

/// @nodoc
abstract mixin class _$OnSubmittedCopyWith<$Res> implements $DevicePairingEventCopyWith<$Res> {
  factory _$OnSubmittedCopyWith(_OnSubmitted value, $Res Function(_OnSubmitted) _then) = __$OnSubmittedCopyWithImpl;
@useResult
$Res call({
 String hostPort, String pairingCode
});




}
/// @nodoc
class __$OnSubmittedCopyWithImpl<$Res>
    implements _$OnSubmittedCopyWith<$Res> {
  __$OnSubmittedCopyWithImpl(this._self, this._then);

  final _OnSubmitted _self;
  final $Res Function(_OnSubmitted) _then;

/// Create a copy of DevicePairingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hostPort = null,Object? pairingCode = null,}) {
  return _then(_OnSubmitted(
hostPort: null == hostPort ? _self.hostPort : hostPort // ignore: cast_nullable_to_non_nullable
as String,pairingCode: null == pairingCode ? _self.pairingCode : pairingCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _OnConnectPortSubmitted implements DevicePairingEvent {
  const _OnConnectPortSubmitted({required this.port});
  

 final  String port;

/// Create a copy of DevicePairingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnConnectPortSubmittedCopyWith<_OnConnectPortSubmitted> get copyWith => __$OnConnectPortSubmittedCopyWithImpl<_OnConnectPortSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnConnectPortSubmitted&&(identical(other.port, port) || other.port == port));
}


@override
int get hashCode {
    return Object.hash(runtimeType,port);
}

@override
String toString() {
    return 'DevicePairingEvent.onConnectPortSubmitted(port: $port)';
}


}

/// @nodoc
abstract mixin class _$OnConnectPortSubmittedCopyWith<$Res> implements $DevicePairingEventCopyWith<$Res> {
  factory _$OnConnectPortSubmittedCopyWith(_OnConnectPortSubmitted value, $Res Function(_OnConnectPortSubmitted) _then) = __$OnConnectPortSubmittedCopyWithImpl;
@useResult
$Res call({
 String port
});




}
/// @nodoc
class __$OnConnectPortSubmittedCopyWithImpl<$Res>
    implements _$OnConnectPortSubmittedCopyWith<$Res> {
  __$OnConnectPortSubmittedCopyWithImpl(this._self, this._then);

  final _OnConnectPortSubmitted _self;
  final $Res Function(_OnConnectPortSubmitted) _then;

/// Create a copy of DevicePairingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? port = null,}) {
  return _then(_OnConnectPortSubmitted(
port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DevicePairingState {

 DevicePairingStep get step; List<PairableDevice> get pairableDevices;
/// Create a copy of DevicePairingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevicePairingStateCopyWith<DevicePairingState> get copyWith => _$DevicePairingStateCopyWithImpl<DevicePairingState>(this as DevicePairingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DevicePairingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingState&&(identical(other.step, _this.step) || other.step == _this.step)&&const DeepCollectionEquality().equals(other.pairableDevices, _this.pairableDevices));
}


@override
int get hashCode {
  final _this = this as DevicePairingState;
  return Object.hash(runtimeType,_this.step,const DeepCollectionEquality().hash(_this.pairableDevices));
}

@override
String toString() {
  final _this = this as DevicePairingState;
  return 'DevicePairingState(step: ${_this.step}, pairableDevices: ${_this.pairableDevices})';
}


}

/// @nodoc
abstract mixin class $DevicePairingStateCopyWith<$Res>  {
  factory $DevicePairingStateCopyWith(DevicePairingState value, $Res Function(DevicePairingState) _then) = _$DevicePairingStateCopyWithImpl;
@useResult
$Res call({
 DevicePairingStep step, List<PairableDevice> pairableDevices
});


$DevicePairingStepCopyWith<$Res> get step;

}
/// @nodoc
class _$DevicePairingStateCopyWithImpl<$Res>
    implements $DevicePairingStateCopyWith<$Res> {
  _$DevicePairingStateCopyWithImpl(this._self, this._then);

  final DevicePairingState _self;
  final $Res Function(DevicePairingState) _then;

/// Create a copy of DevicePairingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? pairableDevices = null,}) {
  return _then(DevicePairingState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as DevicePairingStep,pairableDevices: null == pairableDevices ? _self.pairableDevices : pairableDevices // ignore: cast_nullable_to_non_nullable
as List<PairableDevice>,
  ));
}
/// Create a copy of DevicePairingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DevicePairingStepCopyWith<$Res> get step {
  
  return $DevicePairingStepCopyWith<$Res>(_self.step, (value) {
    return _then(_self.copyWith(step: value));
  });
}
}


/// Adds pattern-matching-related methods to [DevicePairingState].
extension DevicePairingStatePatterns on DevicePairingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DevicePairingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DevicePairingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DevicePairingState value)  $default,){
final _that = this;
switch (_that) {
case _DevicePairingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DevicePairingState value)?  $default,){
final _that = this;
switch (_that) {
case _DevicePairingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DevicePairingStep step,  List<PairableDevice> pairableDevices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DevicePairingState() when $default != null:
return $default(_that.step,_that.pairableDevices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DevicePairingStep step,  List<PairableDevice> pairableDevices)  $default,) {final _that = this;
switch (_that) {
case _DevicePairingState():
return $default(_that.step,_that.pairableDevices);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DevicePairingStep step,  List<PairableDevice> pairableDevices)?  $default,) {final _that = this;
switch (_that) {
case _DevicePairingState() when $default != null:
return $default(_that.step,_that.pairableDevices);case _:
  return null;

}
}

}

/// @nodoc


class _DevicePairingState implements DevicePairingState {
  const _DevicePairingState({this.step = const DevicePairingStep.editing(),  List<PairableDevice> pairableDevices = const <PairableDevice>[]}): _pairableDevices = pairableDevices;
  

@override@JsonKey() final  DevicePairingStep step;
 final  List<PairableDevice> _pairableDevices;
@override@JsonKey() List<PairableDevice> get pairableDevices {
  if (_pairableDevices is EqualUnmodifiableListView) return _pairableDevices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pairableDevices);
}


/// Create a copy of DevicePairingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DevicePairingStateCopyWith<_DevicePairingState> get copyWith => __$DevicePairingStateCopyWithImpl<_DevicePairingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DevicePairingState&&(identical(other.step, step) || other.step == step)&&const DeepCollectionEquality().equals(other.pairableDevices, _pairableDevices));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,const DeepCollectionEquality().hash(_pairableDevices));
}

@override
String toString() {
    return 'DevicePairingState(step: $step, pairableDevices: $pairableDevices)';
}


}

/// @nodoc
abstract mixin class _$DevicePairingStateCopyWith<$Res> implements $DevicePairingStateCopyWith<$Res> {
  factory _$DevicePairingStateCopyWith(_DevicePairingState value, $Res Function(_DevicePairingState) _then) = __$DevicePairingStateCopyWithImpl;
@override @useResult
$Res call({
 DevicePairingStep step, List<PairableDevice> pairableDevices
});


@override $DevicePairingStepCopyWith<$Res> get step;

}
/// @nodoc
class __$DevicePairingStateCopyWithImpl<$Res>
    implements _$DevicePairingStateCopyWith<$Res> {
  __$DevicePairingStateCopyWithImpl(this._self, this._then);

  final _DevicePairingState _self;
  final $Res Function(_DevicePairingState) _then;

/// Create a copy of DevicePairingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? pairableDevices = null,}) {
  return _then(_DevicePairingState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as DevicePairingStep,pairableDevices: null == pairableDevices ? _self._pairableDevices : pairableDevices // ignore: cast_nullable_to_non_nullable
as List<PairableDevice>,
  ));
}

/// Create a copy of DevicePairingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DevicePairingStepCopyWith<$Res> get step {
  
  return $DevicePairingStepCopyWith<$Res>(_self.step, (value) {
    return _then(_self.copyWith(step: value));
  });
}
}

/// @nodoc
mixin _$DevicePairingStep {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingStep);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DevicePairingStep()';
}


}

/// @nodoc
class $DevicePairingStepCopyWith<$Res>  {
$DevicePairingStepCopyWith(DevicePairingStep _, $Res Function(DevicePairingStep) __);
}


/// Adds pattern-matching-related methods to [DevicePairingStep].
extension DevicePairingStepPatterns on DevicePairingStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DevicePairingEditing value)?  editing,TResult Function( DevicePairingPairing value)?  pairing,TResult Function( DevicePairingConnectPortNeeded value)?  connectPortNeeded,TResult Function( DevicePairingConnecting value)?  connecting,TResult Function( DevicePairingConnected value)?  connected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DevicePairingEditing() when editing != null:
return editing(_that);case DevicePairingPairing() when pairing != null:
return pairing(_that);case DevicePairingConnectPortNeeded() when connectPortNeeded != null:
return connectPortNeeded(_that);case DevicePairingConnecting() when connecting != null:
return connecting(_that);case DevicePairingConnected() when connected != null:
return connected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DevicePairingEditing value)  editing,required TResult Function( DevicePairingPairing value)  pairing,required TResult Function( DevicePairingConnectPortNeeded value)  connectPortNeeded,required TResult Function( DevicePairingConnecting value)  connecting,required TResult Function( DevicePairingConnected value)  connected,}){
final _that = this;
switch (_that) {
case DevicePairingEditing():
return editing(_that);case DevicePairingPairing():
return pairing(_that);case DevicePairingConnectPortNeeded():
return connectPortNeeded(_that);case DevicePairingConnecting():
return connecting(_that);case DevicePairingConnected():
return connected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DevicePairingEditing value)?  editing,TResult? Function( DevicePairingPairing value)?  pairing,TResult? Function( DevicePairingConnectPortNeeded value)?  connectPortNeeded,TResult? Function( DevicePairingConnecting value)?  connecting,TResult? Function( DevicePairingConnected value)?  connected,}){
final _that = this;
switch (_that) {
case DevicePairingEditing() when editing != null:
return editing(_that);case DevicePairingPairing() when pairing != null:
return pairing(_that);case DevicePairingConnectPortNeeded() when connectPortNeeded != null:
return connectPortNeeded(_that);case DevicePairingConnecting() when connecting != null:
return connecting(_that);case DevicePairingConnected() when connected != null:
return connected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? error)?  editing,TResult Function()?  pairing,TResult Function( String host,  String? error)?  connectPortNeeded,TResult Function( String host)?  connecting,TResult Function()?  connected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DevicePairingEditing() when editing != null:
return editing(_that.error);case DevicePairingPairing() when pairing != null:
return pairing();case DevicePairingConnectPortNeeded() when connectPortNeeded != null:
return connectPortNeeded(_that.host,_that.error);case DevicePairingConnecting() when connecting != null:
return connecting(_that.host);case DevicePairingConnected() when connected != null:
return connected();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? error)  editing,required TResult Function()  pairing,required TResult Function( String host,  String? error)  connectPortNeeded,required TResult Function( String host)  connecting,required TResult Function()  connected,}) {final _that = this;
switch (_that) {
case DevicePairingEditing():
return editing(_that.error);case DevicePairingPairing():
return pairing();case DevicePairingConnectPortNeeded():
return connectPortNeeded(_that.host,_that.error);case DevicePairingConnecting():
return connecting(_that.host);case DevicePairingConnected():
return connected();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? error)?  editing,TResult? Function()?  pairing,TResult? Function( String host,  String? error)?  connectPortNeeded,TResult? Function( String host)?  connecting,TResult? Function()?  connected,}) {final _that = this;
switch (_that) {
case DevicePairingEditing() when editing != null:
return editing(_that.error);case DevicePairingPairing() when pairing != null:
return pairing();case DevicePairingConnectPortNeeded() when connectPortNeeded != null:
return connectPortNeeded(_that.host,_that.error);case DevicePairingConnecting() when connecting != null:
return connecting(_that.host);case DevicePairingConnected() when connected != null:
return connected();case _:
  return null;

}
}

}

/// @nodoc


class DevicePairingEditing implements DevicePairingStep {
  const DevicePairingEditing({this.error});
  

 final  String? error;

/// Create a copy of DevicePairingStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevicePairingEditingCopyWith<DevicePairingEditing> get copyWith => _$DevicePairingEditingCopyWithImpl<DevicePairingEditing>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingEditing&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,error);
}

@override
String toString() {
    return 'DevicePairingStep.editing(error: $error)';
}


}

/// @nodoc
abstract mixin class $DevicePairingEditingCopyWith<$Res> implements $DevicePairingStepCopyWith<$Res> {
  factory $DevicePairingEditingCopyWith(DevicePairingEditing value, $Res Function(DevicePairingEditing) _then) = _$DevicePairingEditingCopyWithImpl;
@useResult
$Res call({
 String? error
});




}
/// @nodoc
class _$DevicePairingEditingCopyWithImpl<$Res>
    implements $DevicePairingEditingCopyWith<$Res> {
  _$DevicePairingEditingCopyWithImpl(this._self, this._then);

  final DevicePairingEditing _self;
  final $Res Function(DevicePairingEditing) _then;

/// Create a copy of DevicePairingStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(DevicePairingEditing(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DevicePairingPairing implements DevicePairingStep {
  const DevicePairingPairing();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingPairing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DevicePairingStep.pairing()';
}


}




/// @nodoc


class DevicePairingConnectPortNeeded implements DevicePairingStep {
  const DevicePairingConnectPortNeeded({required this.host, this.error});
  

 final  String host;
 final  String? error;

/// Create a copy of DevicePairingStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevicePairingConnectPortNeededCopyWith<DevicePairingConnectPortNeeded> get copyWith => _$DevicePairingConnectPortNeededCopyWithImpl<DevicePairingConnectPortNeeded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingConnectPortNeeded&&(identical(other.host, host) || other.host == host)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,host,error);
}

@override
String toString() {
    return 'DevicePairingStep.connectPortNeeded(host: $host, error: $error)';
}


}

/// @nodoc
abstract mixin class $DevicePairingConnectPortNeededCopyWith<$Res> implements $DevicePairingStepCopyWith<$Res> {
  factory $DevicePairingConnectPortNeededCopyWith(DevicePairingConnectPortNeeded value, $Res Function(DevicePairingConnectPortNeeded) _then) = _$DevicePairingConnectPortNeededCopyWithImpl;
@useResult
$Res call({
 String host, String? error
});




}
/// @nodoc
class _$DevicePairingConnectPortNeededCopyWithImpl<$Res>
    implements $DevicePairingConnectPortNeededCopyWith<$Res> {
  _$DevicePairingConnectPortNeededCopyWithImpl(this._self, this._then);

  final DevicePairingConnectPortNeeded _self;
  final $Res Function(DevicePairingConnectPortNeeded) _then;

/// Create a copy of DevicePairingStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? host = null,Object? error = freezed,}) {
  return _then(DevicePairingConnectPortNeeded(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DevicePairingConnecting implements DevicePairingStep {
  const DevicePairingConnecting({required this.host});
  

 final  String host;

/// Create a copy of DevicePairingStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevicePairingConnectingCopyWith<DevicePairingConnecting> get copyWith => _$DevicePairingConnectingCopyWithImpl<DevicePairingConnecting>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingConnecting&&(identical(other.host, host) || other.host == host));
}


@override
int get hashCode {
    return Object.hash(runtimeType,host);
}

@override
String toString() {
    return 'DevicePairingStep.connecting(host: $host)';
}


}

/// @nodoc
abstract mixin class $DevicePairingConnectingCopyWith<$Res> implements $DevicePairingStepCopyWith<$Res> {
  factory $DevicePairingConnectingCopyWith(DevicePairingConnecting value, $Res Function(DevicePairingConnecting) _then) = _$DevicePairingConnectingCopyWithImpl;
@useResult
$Res call({
 String host
});




}
/// @nodoc
class _$DevicePairingConnectingCopyWithImpl<$Res>
    implements $DevicePairingConnectingCopyWith<$Res> {
  _$DevicePairingConnectingCopyWithImpl(this._self, this._then);

  final DevicePairingConnecting _self;
  final $Res Function(DevicePairingConnecting) _then;

/// Create a copy of DevicePairingStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? host = null,}) {
  return _then(DevicePairingConnecting(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DevicePairingConnected implements DevicePairingStep {
  const DevicePairingConnected();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingConnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DevicePairingStep.connected()';
}


}




// dart format on
