// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sidebar_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SidebarDevice {

 AndroidDevice get device; bool get isConnected;
/// Create a copy of SidebarDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SidebarDeviceCopyWith<SidebarDevice> get copyWith => _$SidebarDeviceCopyWithImpl<SidebarDevice>(this as SidebarDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SidebarDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SidebarDevice&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.isConnected, _this.isConnected) || other.isConnected == _this.isConnected));
}


@override
int get hashCode {
  final _this = this as SidebarDevice;
  return Object.hash(runtimeType,_this.device,_this.isConnected);
}

@override
String toString() {
  final _this = this as SidebarDevice;
  return 'SidebarDevice(device: ${_this.device}, isConnected: ${_this.isConnected})';
}


}

/// @nodoc
abstract mixin class $SidebarDeviceCopyWith<$Res>  {
  factory $SidebarDeviceCopyWith(SidebarDevice value, $Res Function(SidebarDevice) _then) = _$SidebarDeviceCopyWithImpl;
@useResult
$Res call({
 AndroidDevice device, bool isConnected
});


$AndroidDeviceCopyWith<$Res> get device;

}
/// @nodoc
class _$SidebarDeviceCopyWithImpl<$Res>
    implements $SidebarDeviceCopyWith<$Res> {
  _$SidebarDeviceCopyWithImpl(this._self, this._then);

  final SidebarDevice _self;
  final $Res Function(SidebarDevice) _then;

/// Create a copy of SidebarDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? isConnected = null,}) {
  return _then(SidebarDevice(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SidebarDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AndroidDeviceCopyWith<$Res> get device {
  
  return $AndroidDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [SidebarDevice].
extension SidebarDevicePatterns on SidebarDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SidebarDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SidebarDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SidebarDevice value)  $default,){
final _that = this;
switch (_that) {
case _SidebarDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SidebarDevice value)?  $default,){
final _that = this;
switch (_that) {
case _SidebarDevice() when $default != null:
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
case _SidebarDevice() when $default != null:
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
case _SidebarDevice():
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
case _SidebarDevice() when $default != null:
return $default(_that.device,_that.isConnected);case _:
  return null;

}
}

}

/// @nodoc


class _SidebarDevice implements SidebarDevice {
  const _SidebarDevice({required this.device, required this.isConnected});
  

@override final  AndroidDevice device;
@override final  bool isConnected;

/// Create a copy of SidebarDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SidebarDeviceCopyWith<_SidebarDevice> get copyWith => __$SidebarDeviceCopyWithImpl<_SidebarDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SidebarDevice&&(identical(other.device, device) || other.device == device)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,isConnected);
}

@override
String toString() {
    return 'SidebarDevice(device: $device, isConnected: $isConnected)';
}


}

/// @nodoc
abstract mixin class _$SidebarDeviceCopyWith<$Res> implements $SidebarDeviceCopyWith<$Res> {
  factory _$SidebarDeviceCopyWith(_SidebarDevice value, $Res Function(_SidebarDevice) _then) = __$SidebarDeviceCopyWithImpl;
@override @useResult
$Res call({
 AndroidDevice device, bool isConnected
});


@override $AndroidDeviceCopyWith<$Res> get device;

}
/// @nodoc
class __$SidebarDeviceCopyWithImpl<$Res>
    implements _$SidebarDeviceCopyWith<$Res> {
  __$SidebarDeviceCopyWithImpl(this._self, this._then);

  final _SidebarDevice _self;
  final $Res Function(_SidebarDevice) _then;

/// Create a copy of SidebarDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? isConnected = null,}) {
  return _then(_SidebarDevice(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SidebarDevice
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
