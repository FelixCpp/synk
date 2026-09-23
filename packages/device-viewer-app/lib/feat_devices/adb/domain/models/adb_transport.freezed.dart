// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adb_transport.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdbTransport {

 AdbTransportType get type; AdbTransportId? get id;
/// Create a copy of AdbTransport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbTransportCopyWith<AdbTransport> get copyWith => _$AdbTransportCopyWithImpl<AdbTransport>(this as AdbTransport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbTransport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbTransport&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.id, _this.id) || other.id == _this.id));
}


@override
int get hashCode {
  final _this = this as AdbTransport;
  return Object.hash(runtimeType,_this.type,_this.id);
}

@override
String toString() {
  final _this = this as AdbTransport;
  return 'AdbTransport(type: ${_this.type}, id: ${_this.id})';
}


}

/// @nodoc
abstract mixin class $AdbTransportCopyWith<$Res>  {
  factory $AdbTransportCopyWith(AdbTransport value, $Res Function(AdbTransport) _then) = _$AdbTransportCopyWithImpl;
@useResult
$Res call({
 AdbTransportType type, AdbTransportId? id
});




}
/// @nodoc
class _$AdbTransportCopyWithImpl<$Res>
    implements $AdbTransportCopyWith<$Res> {
  _$AdbTransportCopyWithImpl(this._self, this._then);

  final AdbTransport _self;
  final $Res Function(AdbTransport) _then;

/// Create a copy of AdbTransport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? id = freezed,}) {
  return _then(AdbTransport(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AdbTransportType,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as AdbTransportId?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdbTransport].
extension AdbTransportPatterns on AdbTransport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdbTransport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdbTransport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdbTransport value)  $default,){
final _that = this;
switch (_that) {
case _AdbTransport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdbTransport value)?  $default,){
final _that = this;
switch (_that) {
case _AdbTransport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AdbTransportType type,  AdbTransportId? id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdbTransport() when $default != null:
return $default(_that.type,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AdbTransportType type,  AdbTransportId? id)  $default,) {final _that = this;
switch (_that) {
case _AdbTransport():
return $default(_that.type,_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AdbTransportType type,  AdbTransportId? id)?  $default,) {final _that = this;
switch (_that) {
case _AdbTransport() when $default != null:
return $default(_that.type,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _AdbTransport implements AdbTransport {
  const _AdbTransport({required this.type, required this.id});
  

@override final  AdbTransportType type;
@override final  AdbTransportId? id;

/// Create a copy of AdbTransport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdbTransportCopyWith<_AdbTransport> get copyWith => __$AdbTransportCopyWithImpl<_AdbTransport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdbTransport&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,id);
}

@override
String toString() {
    return 'AdbTransport(type: $type, id: $id)';
}


}

/// @nodoc
abstract mixin class _$AdbTransportCopyWith<$Res> implements $AdbTransportCopyWith<$Res> {
  factory _$AdbTransportCopyWith(_AdbTransport value, $Res Function(_AdbTransport) _then) = __$AdbTransportCopyWithImpl;
@override @useResult
$Res call({
 AdbTransportType type, AdbTransportId? id
});




}
/// @nodoc
class __$AdbTransportCopyWithImpl<$Res>
    implements _$AdbTransportCopyWith<$Res> {
  __$AdbTransportCopyWithImpl(this._self, this._then);

  final _AdbTransport _self;
  final $Res Function(_AdbTransport) _then;

/// Create a copy of AdbTransport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? id = freezed,}) {
  return _then(_AdbTransport(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AdbTransportType,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as AdbTransportId?,
  ));
}


}

// dart format on
