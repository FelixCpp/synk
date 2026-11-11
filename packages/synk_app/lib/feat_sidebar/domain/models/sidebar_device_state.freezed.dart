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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Disconnected value)?  disconnected,TResult Function( _Connecting value)?  connecting,TResult Function( _Connected value)?  connected,TResult Function( _FailedToConnect value)?  failedToConnect,TResult Function( _UnableToConnect value)?  unableToConnect,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Disconnected() when disconnected != null:
return disconnected(_that);case _Connecting() when connecting != null:
return connecting(_that);case _Connected() when connected != null:
return connected(_that);case _FailedToConnect() when failedToConnect != null:
return failedToConnect(_that);case _UnableToConnect() when unableToConnect != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Disconnected value)  disconnected,required TResult Function( _Connecting value)  connecting,required TResult Function( _Connected value)  connected,required TResult Function( _FailedToConnect value)  failedToConnect,required TResult Function( _UnableToConnect value)  unableToConnect,}){
final _that = this;
switch (_that) {
case _Disconnected():
return disconnected(_that);case _Connecting():
return connecting(_that);case _Connected():
return connected(_that);case _FailedToConnect():
return failedToConnect(_that);case _UnableToConnect():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Disconnected value)?  disconnected,TResult? Function( _Connecting value)?  connecting,TResult? Function( _Connected value)?  connected,TResult? Function( _FailedToConnect value)?  failedToConnect,TResult? Function( _UnableToConnect value)?  unableToConnect,}){
final _that = this;
switch (_that) {
case _Disconnected() when disconnected != null:
return disconnected(_that);case _Connecting() when connecting != null:
return connecting(_that);case _Connected() when connected != null:
return connected(_that);case _FailedToConnect() when failedToConnect != null:
return failedToConnect(_that);case _UnableToConnect() when unableToConnect != null:
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
case _Disconnected() when disconnected != null:
return disconnected();case _Connecting() when connecting != null:
return connecting();case _Connected() when connected != null:
return connected();case _FailedToConnect() when failedToConnect != null:
return failedToConnect(_that.failure);case _UnableToConnect() when unableToConnect != null:
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
case _Disconnected():
return disconnected();case _Connecting():
return connecting();case _Connected():
return connected();case _FailedToConnect():
return failedToConnect(_that.failure);case _UnableToConnect():
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
case _Disconnected() when disconnected != null:
return disconnected();case _Connecting() when connecting != null:
return connecting();case _Connected() when connected != null:
return connected();case _FailedToConnect() when failedToConnect != null:
return failedToConnect(_that.failure);case _UnableToConnect() when unableToConnect != null:
return unableToConnect();case _:
  return null;

}
}

}

/// @nodoc


class _Disconnected implements SidebarDeviceState {
  const _Disconnected();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Disconnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarDeviceState.disconnected()';
}


}




/// @nodoc


class _Connecting implements SidebarDeviceState {
  const _Connecting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Connecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarDeviceState.connecting()';
}


}




/// @nodoc


class _Connected implements SidebarDeviceState {
  const _Connected();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Connected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarDeviceState.connected()';
}


}




/// @nodoc


class _FailedToConnect implements SidebarDeviceState {
  const _FailedToConnect({required this.failure});
  

 final  ConnectionFailure failure;

/// Create a copy of SidebarDeviceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailedToConnectCopyWith<_FailedToConnect> get copyWith => __$FailedToConnectCopyWithImpl<_FailedToConnect>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FailedToConnect&&(identical(other.failure, failure) || other.failure == failure));
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
abstract mixin class _$FailedToConnectCopyWith<$Res> implements $SidebarDeviceStateCopyWith<$Res> {
  factory _$FailedToConnectCopyWith(_FailedToConnect value, $Res Function(_FailedToConnect) _then) = __$FailedToConnectCopyWithImpl;
@useResult
$Res call({
 ConnectionFailure failure
});




}
/// @nodoc
class __$FailedToConnectCopyWithImpl<$Res>
    implements _$FailedToConnectCopyWith<$Res> {
  __$FailedToConnectCopyWithImpl(this._self, this._then);

  final _FailedToConnect _self;
  final $Res Function(_FailedToConnect) _then;

/// Create a copy of SidebarDeviceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_FailedToConnect(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ConnectionFailure,
  ));
}


}

/// @nodoc


class _UnableToConnect implements SidebarDeviceState {
  const _UnableToConnect();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnableToConnect);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SidebarDeviceState.unableToConnect()';
}


}




// dart format on
