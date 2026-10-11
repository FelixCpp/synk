// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plugged_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PluggedDevice {

 DeviceId get id; String get modelName;
/// Create a copy of PluggedDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PluggedDeviceCopyWith<PluggedDevice> get copyWith => _$PluggedDeviceCopyWithImpl<PluggedDevice>(this as PluggedDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PluggedDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PluggedDevice&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.modelName, _this.modelName) || other.modelName == _this.modelName));
}


@override
int get hashCode {
  final _this = this as PluggedDevice;
  return Object.hash(runtimeType,_this.id,_this.modelName);
}

@override
String toString() {
  final _this = this as PluggedDevice;
  return 'PluggedDevice(id: ${_this.id}, modelName: ${_this.modelName})';
}


}

/// @nodoc
abstract mixin class $PluggedDeviceCopyWith<$Res>  {
  factory $PluggedDeviceCopyWith(PluggedDevice value, $Res Function(PluggedDevice) _then) = _$PluggedDeviceCopyWithImpl;
@useResult
$Res call({
 DeviceId id, String modelName
});




}
/// @nodoc
class _$PluggedDeviceCopyWithImpl<$Res>
    implements $PluggedDeviceCopyWith<$Res> {
  _$PluggedDeviceCopyWithImpl(this._self, this._then);

  final PluggedDevice _self;
  final $Res Function(PluggedDevice) _then;

/// Create a copy of PluggedDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? modelName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PluggedDevice].
extension PluggedDevicePatterns on PluggedDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AndroidDevice value)?  android,TResult Function( IosDevice value)?  ios,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AndroidDevice() when android != null:
return android(_that);case IosDevice() when ios != null:
return ios(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AndroidDevice value)  android,required TResult Function( IosDevice value)  ios,}){
final _that = this;
switch (_that) {
case AndroidDevice():
return android(_that);case IosDevice():
return ios(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AndroidDevice value)?  android,TResult? Function( IosDevice value)?  ios,}){
final _that = this;
switch (_that) {
case AndroidDevice() when android != null:
return android(_that);case IosDevice() when ios != null:
return ios(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DeviceId id,  String modelName,  AndroidDeviceState state,  AndroidDeviceConnection connection)?  android,TResult Function( DeviceId id,  String modelName)?  ios,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AndroidDevice() when android != null:
return android(_that.id,_that.modelName,_that.state,_that.connection);case IosDevice() when ios != null:
return ios(_that.id,_that.modelName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DeviceId id,  String modelName,  AndroidDeviceState state,  AndroidDeviceConnection connection)  android,required TResult Function( DeviceId id,  String modelName)  ios,}) {final _that = this;
switch (_that) {
case AndroidDevice():
return android(_that.id,_that.modelName,_that.state,_that.connection);case IosDevice():
return ios(_that.id,_that.modelName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DeviceId id,  String modelName,  AndroidDeviceState state,  AndroidDeviceConnection connection)?  android,TResult? Function( DeviceId id,  String modelName)?  ios,}) {final _that = this;
switch (_that) {
case AndroidDevice() when android != null:
return android(_that.id,_that.modelName,_that.state,_that.connection);case IosDevice() when ios != null:
return ios(_that.id,_that.modelName);case _:
  return null;

}
}

}

/// @nodoc


class AndroidDevice extends PluggedDevice {
  const AndroidDevice({required this.id, required this.modelName, required this.state, required this.connection}): super._();
  

@override final  DeviceId id;
@override final  String modelName;
 final  AndroidDeviceState state;
 final  AndroidDeviceConnection connection;

/// Create a copy of PluggedDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AndroidDeviceCopyWith<AndroidDevice> get copyWith => _$AndroidDeviceCopyWithImpl<AndroidDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AndroidDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.state, state) || other.state == state)&&(identical(other.connection, connection) || other.connection == connection));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,modelName,state,connection);
}

@override
String toString() {
    return 'PluggedDevice.android(id: $id, modelName: $modelName, state: $state, connection: $connection)';
}


}

/// @nodoc
abstract mixin class $AndroidDeviceCopyWith<$Res> implements $PluggedDeviceCopyWith<$Res> {
  factory $AndroidDeviceCopyWith(AndroidDevice value, $Res Function(AndroidDevice) _then) = _$AndroidDeviceCopyWithImpl;
@override @useResult
$Res call({
 DeviceId id, String modelName, AndroidDeviceState state, AndroidDeviceConnection connection
});




}
/// @nodoc
class _$AndroidDeviceCopyWithImpl<$Res>
    implements $AndroidDeviceCopyWith<$Res> {
  _$AndroidDeviceCopyWithImpl(this._self, this._then);

  final AndroidDevice _self;
  final $Res Function(AndroidDevice) _then;

/// Create a copy of PluggedDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? modelName = null,Object? state = null,Object? connection = null,}) {
  return _then(AndroidDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AndroidDeviceState,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as AndroidDeviceConnection,
  ));
}


}

/// @nodoc


class IosDevice extends PluggedDevice {
  const IosDevice({required this.id, required this.modelName}): super._();
  

@override final  DeviceId id;
@override final  String modelName;

/// Create a copy of PluggedDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IosDeviceCopyWith<IosDevice> get copyWith => _$IosDeviceCopyWithImpl<IosDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is IosDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.modelName, modelName) || other.modelName == modelName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,modelName);
}

@override
String toString() {
    return 'PluggedDevice.ios(id: $id, modelName: $modelName)';
}


}

/// @nodoc
abstract mixin class $IosDeviceCopyWith<$Res> implements $PluggedDeviceCopyWith<$Res> {
  factory $IosDeviceCopyWith(IosDevice value, $Res Function(IosDevice) _then) = _$IosDeviceCopyWithImpl;
@override @useResult
$Res call({
 DeviceId id, String modelName
});




}
/// @nodoc
class _$IosDeviceCopyWithImpl<$Res>
    implements $IosDeviceCopyWith<$Res> {
  _$IosDeviceCopyWithImpl(this._self, this._then);

  final IosDevice _self;
  final $Res Function(IosDevice) _then;

/// Create a copy of PluggedDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? modelName = null,}) {
  return _then(IosDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as DeviceId,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
