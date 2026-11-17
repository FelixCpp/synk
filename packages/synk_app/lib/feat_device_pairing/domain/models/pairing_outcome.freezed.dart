// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pairing_outcome.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PairingOutcome {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingOutcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PairingOutcome()';
}


}

/// @nodoc
class $PairingOutcomeCopyWith<$Res>  {
$PairingOutcomeCopyWith(PairingOutcome _, $Res Function(PairingOutcome) __);
}


/// Adds pattern-matching-related methods to [PairingOutcome].
extension PairingOutcomePatterns on PairingOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PairingConnected value)?  connected,TResult Function( PairingConnectPortResolved value)?  connectPortResolved,TResult Function( PairingConnectPortUnknown value)?  connectPortUnknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PairingConnected() when connected != null:
return connected(_that);case PairingConnectPortResolved() when connectPortResolved != null:
return connectPortResolved(_that);case PairingConnectPortUnknown() when connectPortUnknown != null:
return connectPortUnknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PairingConnected value)  connected,required TResult Function( PairingConnectPortResolved value)  connectPortResolved,required TResult Function( PairingConnectPortUnknown value)  connectPortUnknown,}){
final _that = this;
switch (_that) {
case PairingConnected():
return connected(_that);case PairingConnectPortResolved():
return connectPortResolved(_that);case PairingConnectPortUnknown():
return connectPortUnknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PairingConnected value)?  connected,TResult? Function( PairingConnectPortResolved value)?  connectPortResolved,TResult? Function( PairingConnectPortUnknown value)?  connectPortUnknown,}){
final _that = this;
switch (_that) {
case PairingConnected() when connected != null:
return connected(_that);case PairingConnectPortResolved() when connectPortResolved != null:
return connectPortResolved(_that);case PairingConnectPortUnknown() when connectPortUnknown != null:
return connectPortUnknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  connected,TResult Function( int port)?  connectPortResolved,TResult Function()?  connectPortUnknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PairingConnected() when connected != null:
return connected();case PairingConnectPortResolved() when connectPortResolved != null:
return connectPortResolved(_that.port);case PairingConnectPortUnknown() when connectPortUnknown != null:
return connectPortUnknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  connected,required TResult Function( int port)  connectPortResolved,required TResult Function()  connectPortUnknown,}) {final _that = this;
switch (_that) {
case PairingConnected():
return connected();case PairingConnectPortResolved():
return connectPortResolved(_that.port);case PairingConnectPortUnknown():
return connectPortUnknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  connected,TResult? Function( int port)?  connectPortResolved,TResult? Function()?  connectPortUnknown,}) {final _that = this;
switch (_that) {
case PairingConnected() when connected != null:
return connected();case PairingConnectPortResolved() when connectPortResolved != null:
return connectPortResolved(_that.port);case PairingConnectPortUnknown() when connectPortUnknown != null:
return connectPortUnknown();case _:
  return null;

}
}

}

/// @nodoc


class PairingConnected implements PairingOutcome {
  const PairingConnected();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingConnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PairingOutcome.connected()';
}


}




/// @nodoc


class PairingConnectPortResolved implements PairingOutcome {
  const PairingConnectPortResolved(this.port);
  

 final  int port;

/// Create a copy of PairingOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairingConnectPortResolvedCopyWith<PairingConnectPortResolved> get copyWith => _$PairingConnectPortResolvedCopyWithImpl<PairingConnectPortResolved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingConnectPortResolved&&(identical(other.port, port) || other.port == port));
}


@override
int get hashCode {
    return Object.hash(runtimeType,port);
}

@override
String toString() {
    return 'PairingOutcome.connectPortResolved(port: $port)';
}


}

/// @nodoc
abstract mixin class $PairingConnectPortResolvedCopyWith<$Res> implements $PairingOutcomeCopyWith<$Res> {
  factory $PairingConnectPortResolvedCopyWith(PairingConnectPortResolved value, $Res Function(PairingConnectPortResolved) _then) = _$PairingConnectPortResolvedCopyWithImpl;
@useResult
$Res call({
 int port
});




}
/// @nodoc
class _$PairingConnectPortResolvedCopyWithImpl<$Res>
    implements $PairingConnectPortResolvedCopyWith<$Res> {
  _$PairingConnectPortResolvedCopyWithImpl(this._self, this._then);

  final PairingConnectPortResolved _self;
  final $Res Function(PairingConnectPortResolved) _then;

/// Create a copy of PairingOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? port = null,}) {
  return _then(PairingConnectPortResolved(
null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PairingConnectPortUnknown implements PairingOutcome {
  const PairingConnectPortUnknown();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingConnectPortUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PairingOutcome.connectPortUnknown()';
}


}




// dart format on
