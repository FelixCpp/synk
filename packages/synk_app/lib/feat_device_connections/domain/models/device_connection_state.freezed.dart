// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_connection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceConnectionState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceConnectionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceConnectionState()';
}


}

/// @nodoc
class $DeviceConnectionStateCopyWith<$Res>  {
$DeviceConnectionStateCopyWith(DeviceConnectionState _, $Res Function(DeviceConnectionState) __);
}


/// Adds pattern-matching-related methods to [DeviceConnectionState].
extension DeviceConnectionStatePatterns on DeviceConnectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ConnectionStateDisconnected value)?  disconnected,TResult Function( ConnectionStateConnecting value)?  connecting,TResult Function( ConnectionStateConnected value)?  connected,TResult Function( ConnectionStateFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ConnectionStateDisconnected() when disconnected != null:
return disconnected(_that);case ConnectionStateConnecting() when connecting != null:
return connecting(_that);case ConnectionStateConnected() when connected != null:
return connected(_that);case ConnectionStateFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ConnectionStateDisconnected value)  disconnected,required TResult Function( ConnectionStateConnecting value)  connecting,required TResult Function( ConnectionStateConnected value)  connected,required TResult Function( ConnectionStateFailed value)  failed,}){
final _that = this;
switch (_that) {
case ConnectionStateDisconnected():
return disconnected(_that);case ConnectionStateConnecting():
return connecting(_that);case ConnectionStateConnected():
return connected(_that);case ConnectionStateFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ConnectionStateDisconnected value)?  disconnected,TResult? Function( ConnectionStateConnecting value)?  connecting,TResult? Function( ConnectionStateConnected value)?  connected,TResult? Function( ConnectionStateFailed value)?  failed,}){
final _that = this;
switch (_that) {
case ConnectionStateDisconnected() when disconnected != null:
return disconnected(_that);case ConnectionStateConnecting() when connecting != null:
return connecting(_that);case ConnectionStateConnected() when connected != null:
return connected(_that);case ConnectionStateFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  disconnected,TResult Function()?  connecting,TResult Function()?  connected,TResult Function( ConnectionFailure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ConnectionStateDisconnected() when disconnected != null:
return disconnected();case ConnectionStateConnecting() when connecting != null:
return connecting();case ConnectionStateConnected() when connected != null:
return connected();case ConnectionStateFailed() when failed != null:
return failed(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  disconnected,required TResult Function()  connecting,required TResult Function()  connected,required TResult Function( ConnectionFailure failure)  failed,}) {final _that = this;
switch (_that) {
case ConnectionStateDisconnected():
return disconnected();case ConnectionStateConnecting():
return connecting();case ConnectionStateConnected():
return connected();case ConnectionStateFailed():
return failed(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  disconnected,TResult? Function()?  connecting,TResult? Function()?  connected,TResult? Function( ConnectionFailure failure)?  failed,}) {final _that = this;
switch (_that) {
case ConnectionStateDisconnected() when disconnected != null:
return disconnected();case ConnectionStateConnecting() when connecting != null:
return connecting();case ConnectionStateConnected() when connected != null:
return connected();case ConnectionStateFailed() when failed != null:
return failed(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ConnectionStateDisconnected implements DeviceConnectionState {
  const ConnectionStateDisconnected();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionStateDisconnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceConnectionState.disconnected()';
}


}




/// @nodoc


class ConnectionStateConnecting implements DeviceConnectionState {
  const ConnectionStateConnecting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionStateConnecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceConnectionState.connecting()';
}


}




/// @nodoc


class ConnectionStateConnected implements DeviceConnectionState {
  const ConnectionStateConnected();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionStateConnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceConnectionState.connected()';
}


}




/// @nodoc


class ConnectionStateFailed implements DeviceConnectionState {
  const ConnectionStateFailed({required this.failure});
  

 final  ConnectionFailure failure;

/// Create a copy of DeviceConnectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionStateFailedCopyWith<ConnectionStateFailed> get copyWith => _$ConnectionStateFailedCopyWithImpl<ConnectionStateFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionStateFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'DeviceConnectionState.failed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ConnectionStateFailedCopyWith<$Res> implements $DeviceConnectionStateCopyWith<$Res> {
  factory $ConnectionStateFailedCopyWith(ConnectionStateFailed value, $Res Function(ConnectionStateFailed) _then) = _$ConnectionStateFailedCopyWithImpl;
@useResult
$Res call({
 ConnectionFailure failure
});




}
/// @nodoc
class _$ConnectionStateFailedCopyWithImpl<$Res>
    implements $ConnectionStateFailedCopyWith<$Res> {
  _$ConnectionStateFailedCopyWithImpl(this._self, this._then);

  final ConnectionStateFailed _self;
  final $Res Function(ConnectionStateFailed) _then;

/// Create a copy of DeviceConnectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ConnectionStateFailed(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ConnectionFailure,
  ));
}


}

// dart format on
