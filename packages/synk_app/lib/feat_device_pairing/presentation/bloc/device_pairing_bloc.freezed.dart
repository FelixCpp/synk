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

 String get hostPort; String get pairingCode;
/// Create a copy of DevicePairingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevicePairingEventCopyWith<DevicePairingEvent> get copyWith => _$DevicePairingEventCopyWithImpl<DevicePairingEvent>(this as DevicePairingEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DevicePairingEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingEvent&&(identical(other.hostPort, _this.hostPort) || other.hostPort == _this.hostPort)&&(identical(other.pairingCode, _this.pairingCode) || other.pairingCode == _this.pairingCode));
}


@override
int get hashCode {
  final _this = this as DevicePairingEvent;
  return Object.hash(runtimeType,_this.hostPort,_this.pairingCode);
}

@override
String toString() {
  final _this = this as DevicePairingEvent;
  return 'DevicePairingEvent(hostPort: ${_this.hostPort}, pairingCode: ${_this.pairingCode})';
}


}

/// @nodoc
abstract mixin class $DevicePairingEventCopyWith<$Res>  {
  factory $DevicePairingEventCopyWith(DevicePairingEvent value, $Res Function(DevicePairingEvent) _then) = _$DevicePairingEventCopyWithImpl;
@useResult
$Res call({
 String hostPort, String pairingCode
});




}
/// @nodoc
class _$DevicePairingEventCopyWithImpl<$Res>
    implements $DevicePairingEventCopyWith<$Res> {
  _$DevicePairingEventCopyWithImpl(this._self, this._then);

  final DevicePairingEvent _self;
  final $Res Function(DevicePairingEvent) _then;

/// Create a copy of DevicePairingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostPort = null,Object? pairingCode = null,}) {
  return _then(DevicePairingEvent.onSubmitted(
hostPort: null == hostPort ? _self.hostPort : hostPort // ignore: cast_nullable_to_non_nullable
as String,pairingCode: null == pairingCode ? _self.pairingCode : pairingCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSubmitted value)?  onSubmitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSubmitted() when onSubmitted != null:
return onSubmitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSubmitted value)  onSubmitted,}){
final _that = this;
switch (_that) {
case _OnSubmitted():
return onSubmitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSubmitted value)?  onSubmitted,}){
final _that = this;
switch (_that) {
case _OnSubmitted() when onSubmitted != null:
return onSubmitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String hostPort,  String pairingCode)?  onSubmitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSubmitted() when onSubmitted != null:
return onSubmitted(_that.hostPort,_that.pairingCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String hostPort,  String pairingCode)  onSubmitted,}) {final _that = this;
switch (_that) {
case _OnSubmitted():
return onSubmitted(_that.hostPort,_that.pairingCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String hostPort,  String pairingCode)?  onSubmitted,}) {final _that = this;
switch (_that) {
case _OnSubmitted() when onSubmitted != null:
return onSubmitted(_that.hostPort,_that.pairingCode);case _:
  return null;

}
}

}

/// @nodoc


class _OnSubmitted implements DevicePairingEvent {
  const _OnSubmitted({required this.hostPort, required this.pairingCode});
  

@override final  String hostPort;
@override final  String pairingCode;

/// Create a copy of DevicePairingEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
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
@override @useResult
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
@override @pragma('vm:prefer-inline') $Res call({Object? hostPort = null,Object? pairingCode = null,}) {
  return _then(_OnSubmitted(
hostPort: null == hostPort ? _self.hostPort : hostPort // ignore: cast_nullable_to_non_nullable
as String,pairingCode: null == pairingCode ? _self.pairingCode : pairingCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DevicePairingState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DevicePairingState()';
}


}

/// @nodoc
class $DevicePairingStateCopyWith<$Res>  {
$DevicePairingStateCopyWith(DevicePairingState _, $Res Function(DevicePairingState) __);
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DevicePairingEditing value)?  editing,TResult Function( DevicePairingPairing value)?  pairing,TResult Function( DevicePairingPaired value)?  paired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DevicePairingEditing() when editing != null:
return editing(_that);case DevicePairingPairing() when pairing != null:
return pairing(_that);case DevicePairingPaired() when paired != null:
return paired(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DevicePairingEditing value)  editing,required TResult Function( DevicePairingPairing value)  pairing,required TResult Function( DevicePairingPaired value)  paired,}){
final _that = this;
switch (_that) {
case DevicePairingEditing():
return editing(_that);case DevicePairingPairing():
return pairing(_that);case DevicePairingPaired():
return paired(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DevicePairingEditing value)?  editing,TResult? Function( DevicePairingPairing value)?  pairing,TResult? Function( DevicePairingPaired value)?  paired,}){
final _that = this;
switch (_that) {
case DevicePairingEditing() when editing != null:
return editing(_that);case DevicePairingPairing() when pairing != null:
return pairing(_that);case DevicePairingPaired() when paired != null:
return paired(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? error)?  editing,TResult Function()?  pairing,TResult Function()?  paired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DevicePairingEditing() when editing != null:
return editing(_that.error);case DevicePairingPairing() when pairing != null:
return pairing();case DevicePairingPaired() when paired != null:
return paired();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? error)  editing,required TResult Function()  pairing,required TResult Function()  paired,}) {final _that = this;
switch (_that) {
case DevicePairingEditing():
return editing(_that.error);case DevicePairingPairing():
return pairing();case DevicePairingPaired():
return paired();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? error)?  editing,TResult? Function()?  pairing,TResult? Function()?  paired,}) {final _that = this;
switch (_that) {
case DevicePairingEditing() when editing != null:
return editing(_that.error);case DevicePairingPairing() when pairing != null:
return pairing();case DevicePairingPaired() when paired != null:
return paired();case _:
  return null;

}
}

}

/// @nodoc


class DevicePairingEditing implements DevicePairingState {
  const DevicePairingEditing({this.error});
  

 final  String? error;

/// Create a copy of DevicePairingState
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
    return 'DevicePairingState.editing(error: $error)';
}


}

/// @nodoc
abstract mixin class $DevicePairingEditingCopyWith<$Res> implements $DevicePairingStateCopyWith<$Res> {
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

/// Create a copy of DevicePairingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(DevicePairingEditing(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DevicePairingPairing implements DevicePairingState {
  const DevicePairingPairing();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingPairing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DevicePairingState.pairing()';
}


}




/// @nodoc


class DevicePairingPaired implements DevicePairingState {
  const DevicePairingPaired();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePairingPaired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DevicePairingState.paired()';
}


}




// dart format on
