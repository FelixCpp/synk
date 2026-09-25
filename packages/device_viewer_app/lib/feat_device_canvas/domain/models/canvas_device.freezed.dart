// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canvas_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CanvasDevice {

 AndroidDevice get device; bool get isConnected;
/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CanvasDeviceCopyWith<CanvasDevice> get copyWith => _$CanvasDeviceCopyWithImpl<CanvasDevice>(this as CanvasDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CanvasDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CanvasDevice&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.isConnected, _this.isConnected) || other.isConnected == _this.isConnected));
}


@override
int get hashCode {
  final _this = this as CanvasDevice;
  return Object.hash(runtimeType,_this.device,_this.isConnected);
}

@override
String toString() {
  final _this = this as CanvasDevice;
  return 'CanvasDevice(device: ${_this.device}, isConnected: ${_this.isConnected})';
}


}

/// @nodoc
abstract mixin class $CanvasDeviceCopyWith<$Res>  {
  factory $CanvasDeviceCopyWith(CanvasDevice value, $Res Function(CanvasDevice) _then) = _$CanvasDeviceCopyWithImpl;
@useResult
$Res call({
 AndroidDevice device, bool isConnected
});


$AndroidDeviceCopyWith<$Res> get device;

}
/// @nodoc
class _$CanvasDeviceCopyWithImpl<$Res>
    implements $CanvasDeviceCopyWith<$Res> {
  _$CanvasDeviceCopyWithImpl(this._self, this._then);

  final CanvasDevice _self;
  final $Res Function(CanvasDevice) _then;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? isConnected = null,}) {
  return _then(CanvasDevice(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceCopyWith<$Res> get device {
  
  return $AndroidDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [CanvasDevice].
extension CanvasDevicePatterns on CanvasDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CanvasDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CanvasDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CanvasDevice value)  $default,){
final _that = this;
switch (_that) {
case _CanvasDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CanvasDevice value)?  $default,){
final _that = this;
switch (_that) {
case _CanvasDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AndroidDevice device,  bool isConnected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CanvasDevice() when $default != null:
return $default(_that.device,_that.isConnected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AndroidDevice device,  bool isConnected)  $default,) {final _that = this;
switch (_that) {
case _CanvasDevice():
return $default(_that.device,_that.isConnected);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AndroidDevice device,  bool isConnected)?  $default,) {final _that = this;
switch (_that) {
case _CanvasDevice() when $default != null:
return $default(_that.device,_that.isConnected);case _:
  return null;

}
}

}

/// @nodoc


class _CanvasDevice implements CanvasDevice {
  const _CanvasDevice({required this.device, required this.isConnected});
  

@override final  AndroidDevice device;
@override final  bool isConnected;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CanvasDeviceCopyWith<_CanvasDevice> get copyWith => __$CanvasDeviceCopyWithImpl<_CanvasDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CanvasDevice&&(identical(other.device, device) || other.device == device)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,isConnected);
}

@override
String toString() {
    return 'CanvasDevice(device: $device, isConnected: $isConnected)';
}


}

/// @nodoc
abstract mixin class _$CanvasDeviceCopyWith<$Res> implements $CanvasDeviceCopyWith<$Res> {
  factory _$CanvasDeviceCopyWith(_CanvasDevice value, $Res Function(_CanvasDevice) _then) = __$CanvasDeviceCopyWithImpl;
@override @useResult
$Res call({
 AndroidDevice device, bool isConnected
});


@override $AndroidDeviceCopyWith<$Res> get device;

}
/// @nodoc
class __$CanvasDeviceCopyWithImpl<$Res>
    implements _$CanvasDeviceCopyWith<$Res> {
  __$CanvasDeviceCopyWithImpl(this._self, this._then);

  final _CanvasDevice _self;
  final $Res Function(_CanvasDevice) _then;

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? isConnected = null,}) {
  return _then(_CanvasDevice(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CanvasDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceCopyWith<$Res> get device {
  
  return $AndroidDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

// dart format on
