// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sidebar_device_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SidebarDeviceState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SidebarDeviceState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarDeviceState()';
}


}

/// @nodoc
class $SidebarDeviceStateCopyWith<$Res>  {
$SidebarDeviceStateCopyWith(SidebarDeviceState _, $Res Function(SidebarDeviceState) __);
}


/// Adds pattern-matching-related methods to [SidebarDeviceState].
extension SidebarDeviceStatePatterns on SidebarDeviceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SidebarDeviceDisconnected value)?  disconnected,TResult Function( SidebarDeviceConnecting value)?  connecting,TResult Function( SidebarDeviceConnected value)?  connected,TResult Function( SidebarDeviceFailedToConnect value)?  failedToConnect,TResult Function( SidebarDeviceUnableToConnect value)?  unableToConnect,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SidebarDeviceDisconnected() when disconnected != null:
return disconnected(_that);case SidebarDeviceConnecting() when connecting != null:
return connecting(_that);case SidebarDeviceConnected() when connected != null:
return connected(_that);case SidebarDeviceFailedToConnect() when failedToConnect != null:
return failedToConnect(_that);case SidebarDeviceUnableToConnect() when unableToConnect != null:
return unableToConnect(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SidebarDeviceDisconnected value)  disconnected,required TResult Function( SidebarDeviceConnecting value)  connecting,required TResult Function( SidebarDeviceConnected value)  connected,required TResult Function( SidebarDeviceFailedToConnect value)  failedToConnect,required TResult Function( SidebarDeviceUnableToConnect value)  unableToConnect,}){
final _that = this;
switch (_that) {
case SidebarDeviceDisconnected():
return disconnected(_that);case SidebarDeviceConnecting():
return connecting(_that);case SidebarDeviceConnected():
return connected(_that);case SidebarDeviceFailedToConnect():
return failedToConnect(_that);case SidebarDeviceUnableToConnect():
return unableToConnect(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SidebarDeviceDisconnected value)?  disconnected,TResult? Function( SidebarDeviceConnecting value)?  connecting,TResult? Function( SidebarDeviceConnected value)?  connected,TResult? Function( SidebarDeviceFailedToConnect value)?  failedToConnect,TResult? Function( SidebarDeviceUnableToConnect value)?  unableToConnect,}){
final _that = this;
switch (_that) {
case SidebarDeviceDisconnected() when disconnected != null:
return disconnected(_that);case SidebarDeviceConnecting() when connecting != null:
return connecting(_that);case SidebarDeviceConnected() when connected != null:
return connected(_that);case SidebarDeviceFailedToConnect() when failedToConnect != null:
return failedToConnect(_that);case SidebarDeviceUnableToConnect() when unableToConnect != null:
return unableToConnect(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  disconnected,TResult Function()?  connecting,TResult Function()?  connected,TResult Function( ConnectionFailure failure)?  failedToConnect,TResult Function()?  unableToConnect,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SidebarDeviceDisconnected() when disconnected != null:
return disconnected();case SidebarDeviceConnecting() when connecting != null:
return connecting();case SidebarDeviceConnected() when connected != null:
return connected();case SidebarDeviceFailedToConnect() when failedToConnect != null:
return failedToConnect(_that.failure);case SidebarDeviceUnableToConnect() when unableToConnect != null:
return unableToConnect();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  disconnected,required TResult Function()  connecting,required TResult Function()  connected,required TResult Function( ConnectionFailure failure)  failedToConnect,required TResult Function()  unableToConnect,}) {final _that = this;
switch (_that) {
case SidebarDeviceDisconnected():
return disconnected();case SidebarDeviceConnecting():
return connecting();case SidebarDeviceConnected():
return connected();case SidebarDeviceFailedToConnect():
return failedToConnect(_that.failure);case SidebarDeviceUnableToConnect():
return unableToConnect();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  disconnected,TResult? Function()?  connecting,TResult? Function()?  connected,TResult? Function( ConnectionFailure failure)?  failedToConnect,TResult? Function()?  unableToConnect,}) {final _that = this;
switch (_that) {
case SidebarDeviceDisconnected() when disconnected != null:
return disconnected();case SidebarDeviceConnecting() when connecting != null:
return connecting();case SidebarDeviceConnected() when connected != null:
return connected();case SidebarDeviceFailedToConnect() when failedToConnect != null:
return failedToConnect(_that.failure);case SidebarDeviceUnableToConnect() when unableToConnect != null:
return unableToConnect();case _:
  return null;

}
}

}

/// @nodoc


class SidebarDeviceDisconnected implements SidebarDeviceState {
  const SidebarDeviceDisconnected();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SidebarDeviceDisconnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarDeviceState.disconnected()';
}


}




/// @nodoc


class SidebarDeviceConnecting implements SidebarDeviceState {
  const SidebarDeviceConnecting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SidebarDeviceConnecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarDeviceState.connecting()';
}


}




/// @nodoc


class SidebarDeviceConnected implements SidebarDeviceState {
  const SidebarDeviceConnected();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SidebarDeviceConnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarDeviceState.connected()';
}


}




/// @nodoc


class SidebarDeviceFailedToConnect implements SidebarDeviceState {
  const SidebarDeviceFailedToConnect({required this.failure});
  

 final  ConnectionFailure failure;

/// Create a copy of SidebarDeviceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SidebarDeviceFailedToConnectCopyWith<SidebarDeviceFailedToConnect> get copyWith => _$SidebarDeviceFailedToConnectCopyWithImpl<SidebarDeviceFailedToConnect>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SidebarDeviceFailedToConnect&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'SidebarDeviceState.failedToConnect(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SidebarDeviceFailedToConnectCopyWith<$Res> implements $SidebarDeviceStateCopyWith<$Res> {
  factory $SidebarDeviceFailedToConnectCopyWith(SidebarDeviceFailedToConnect value, $Res Function(SidebarDeviceFailedToConnect) _then) = _$SidebarDeviceFailedToConnectCopyWithImpl;
@useResult
$Res call({
 ConnectionFailure failure
});




}
/// @nodoc
class _$SidebarDeviceFailedToConnectCopyWithImpl<$Res>
    implements $SidebarDeviceFailedToConnectCopyWith<$Res> {
  _$SidebarDeviceFailedToConnectCopyWithImpl(this._self, this._then);

  final SidebarDeviceFailedToConnect _self;
  final $Res Function(SidebarDeviceFailedToConnect) _then;

/// Create a copy of SidebarDeviceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(SidebarDeviceFailedToConnect(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ConnectionFailure,
  ));
}


}

/// @nodoc


class SidebarDeviceUnableToConnect implements SidebarDeviceState {
  const SidebarDeviceUnableToConnect();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SidebarDeviceUnableToConnect);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarDeviceState.unableToConnect()';
}


}




// dart format on
