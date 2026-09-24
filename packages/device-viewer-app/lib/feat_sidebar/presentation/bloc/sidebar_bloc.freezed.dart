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

 List<AdbDevice> get adbDevices;
/// Create a copy of SidebarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SidebarStateCopyWith<SidebarState> get copyWith => _$SidebarStateCopyWithImpl<SidebarState>(this as SidebarState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SidebarState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SidebarState&&const DeepCollectionEquality().equals(other.adbDevices, _this.adbDevices));
}


@override
int get hashCode {
  final _this = this as SidebarState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.adbDevices));
}

@override
String toString() {
  final _this = this as SidebarState;
  return 'SidebarState(adbDevices: ${_this.adbDevices})';
}


}

/// @nodoc
abstract mixin class $SidebarStateCopyWith<$Res>  {
  factory $SidebarStateCopyWith(SidebarState value, $Res Function(SidebarState) _then) = _$SidebarStateCopyWithImpl;
@useResult
$Res call({
 List<AdbDevice> adbDevices
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
@pragma('vm:prefer-inline') @override $Res call({Object? adbDevices = null,}) {
  return _then(SidebarState(
adbDevices: null == adbDevices ? _self.adbDevices : adbDevices // ignore: cast_nullable_to_non_nullable
as List<AdbDevice>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdbDevice> adbDevices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SidebarState() when $default != null:
return $default(_that.adbDevices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdbDevice> adbDevices)  $default,) {final _that = this;
switch (_that) {
case _SidebarState():
return $default(_that.adbDevices);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdbDevice> adbDevices)?  $default,) {final _that = this;
switch (_that) {
case _SidebarState() when $default != null:
return $default(_that.adbDevices);case _:
  return null;

}
}

}

/// @nodoc


class _SidebarState implements SidebarState {
  const _SidebarState({required  List<AdbDevice> adbDevices}): _adbDevices = adbDevices;
  

 final  List<AdbDevice> _adbDevices;
@override List<AdbDevice> get adbDevices {
  if (_adbDevices is EqualUnmodifiableListView) return _adbDevices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_adbDevices);
}


/// Create a copy of SidebarState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SidebarStateCopyWith<_SidebarState> get copyWith => __$SidebarStateCopyWithImpl<_SidebarState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SidebarState&&const DeepCollectionEquality().equals(other.adbDevices, _adbDevices));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_adbDevices));
}

@override
String toString() {
    return 'SidebarState(adbDevices: $adbDevices)';
}


}

/// @nodoc
abstract mixin class _$SidebarStateCopyWith<$Res> implements $SidebarStateCopyWith<$Res> {
  factory _$SidebarStateCopyWith(_SidebarState value, $Res Function(_SidebarState) _then) = __$SidebarStateCopyWithImpl;
@override @useResult
$Res call({
 List<AdbDevice> adbDevices
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
@override @pragma('vm:prefer-inline') $Res call({Object? adbDevices = null,}) {
  return _then(_SidebarState(
adbDevices: null == adbDevices ? _self._adbDevices : adbDevices // ignore: cast_nullable_to_non_nullable
as List<AdbDevice>,
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSetup value)?  onSetup,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSetup value)  onSetup,}){
final _that = this;
switch (_that) {
case _OnSetup():
return onSetup(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSetup value)?  onSetup,}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onSetup,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onSetup,}) {final _that = this;
switch (_that) {
case _OnSetup():
return onSetup();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onSetup,}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _:
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




// dart format on
