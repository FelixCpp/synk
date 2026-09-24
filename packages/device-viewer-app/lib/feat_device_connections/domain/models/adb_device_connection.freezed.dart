// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adb_device_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdbDeviceConnection {

 List<AndroidDevice> get connectedDevices;
/// Create a copy of AdbDeviceConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbDeviceConnectionCopyWith<AdbDeviceConnection> get copyWith => _$AdbDeviceConnectionCopyWithImpl<AdbDeviceConnection>(this as AdbDeviceConnection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbDeviceConnection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbDeviceConnection&&const DeepCollectionEquality().equals(other.connectedDevices, _this.connectedDevices));
}


@override
int get hashCode {
  final _this = this as AdbDeviceConnection;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.connectedDevices));
}

@override
String toString() {
  final _this = this as AdbDeviceConnection;
  return 'AdbDeviceConnection(connectedDevices: ${_this.connectedDevices})';
}


}

/// @nodoc
abstract mixin class $AdbDeviceConnectionCopyWith<$Res>  {
  factory $AdbDeviceConnectionCopyWith(AdbDeviceConnection value, $Res Function(AdbDeviceConnection) _then) = _$AdbDeviceConnectionCopyWithImpl;
@useResult
$Res call({
 List<AndroidDevice> connectedDevices
});




}
/// @nodoc
class _$AdbDeviceConnectionCopyWithImpl<$Res>
    implements $AdbDeviceConnectionCopyWith<$Res> {
  _$AdbDeviceConnectionCopyWithImpl(this._self, this._then);

  final AdbDeviceConnection _self;
  final $Res Function(AdbDeviceConnection) _then;

/// Create a copy of AdbDeviceConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connectedDevices = null,}) {
  return _then(AdbDeviceConnection(
connectedDevices: null == connectedDevices ? _self.connectedDevices : connectedDevices // ignore: cast_nullable_to_non_nullable
as List<AndroidDevice>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdbDeviceConnection].
extension AdbDeviceConnectionPatterns on AdbDeviceConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdbDeviceConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdbDeviceConnection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdbDeviceConnection value)  $default,){
final _that = this;
switch (_that) {
case _AdbDeviceConnection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdbDeviceConnection value)?  $default,){
final _that = this;
switch (_that) {
case _AdbDeviceConnection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AndroidDevice> connectedDevices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdbDeviceConnection() when $default != null:
return $default(_that.connectedDevices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AndroidDevice> connectedDevices)  $default,) {final _that = this;
switch (_that) {
case _AdbDeviceConnection():
return $default(_that.connectedDevices);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AndroidDevice> connectedDevices)?  $default,) {final _that = this;
switch (_that) {
case _AdbDeviceConnection() when $default != null:
return $default(_that.connectedDevices);case _:
  return null;

}
}

}

/// @nodoc


class _AdbDeviceConnection implements AdbDeviceConnection {
  const _AdbDeviceConnection({required  List<AndroidDevice> connectedDevices}): _connectedDevices = connectedDevices;
  

 final  List<AndroidDevice> _connectedDevices;
@override List<AndroidDevice> get connectedDevices {
  if (_connectedDevices is EqualUnmodifiableListView) return _connectedDevices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connectedDevices);
}


/// Create a copy of AdbDeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdbDeviceConnectionCopyWith<_AdbDeviceConnection> get copyWith => __$AdbDeviceConnectionCopyWithImpl<_AdbDeviceConnection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdbDeviceConnection&&const DeepCollectionEquality().equals(other.connectedDevices, _connectedDevices));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_connectedDevices));
}

@override
String toString() {
    return 'AdbDeviceConnection(connectedDevices: $connectedDevices)';
}


}

/// @nodoc
abstract mixin class _$AdbDeviceConnectionCopyWith<$Res> implements $AdbDeviceConnectionCopyWith<$Res> {
  factory _$AdbDeviceConnectionCopyWith(_AdbDeviceConnection value, $Res Function(_AdbDeviceConnection) _then) = __$AdbDeviceConnectionCopyWithImpl;
@override @useResult
$Res call({
 List<AndroidDevice> connectedDevices
});




}
/// @nodoc
class __$AdbDeviceConnectionCopyWithImpl<$Res>
    implements _$AdbDeviceConnectionCopyWith<$Res> {
  __$AdbDeviceConnectionCopyWithImpl(this._self, this._then);

  final _AdbDeviceConnection _self;
  final $Res Function(_AdbDeviceConnection) _then;

/// Create a copy of AdbDeviceConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectedDevices = null,}) {
  return _then(_AdbDeviceConnection(
connectedDevices: null == connectedDevices ? _self._connectedDevices : connectedDevices // ignore: cast_nullable_to_non_nullable
as List<AndroidDevice>,
  ));
}


}

// dart format on
