// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adb_device_identity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdbDeviceIdentity {

 AdbSerialNumber get serialNumber; AndroidProduct? get product; AndroidModel? get model; AndroidDevice? get device;
/// Create a copy of AdbDeviceIdentity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdbDeviceIdentityCopyWith<AdbDeviceIdentity> get copyWith => _$AdbDeviceIdentityCopyWithImpl<AdbDeviceIdentity>(this as AdbDeviceIdentity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdbDeviceIdentity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdbDeviceIdentity&&(identical(other.serialNumber, _this.serialNumber) || other.serialNumber == _this.serialNumber)&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.device, _this.device) || other.device == _this.device));
}


@override
int get hashCode {
  final _this = this as AdbDeviceIdentity;
  return Object.hash(runtimeType,_this.serialNumber,_this.product,_this.model,_this.device);
}

@override
String toString() {
  final _this = this as AdbDeviceIdentity;
  return 'AdbDeviceIdentity(serialNumber: ${_this.serialNumber}, product: ${_this.product}, model: ${_this.model}, device: ${_this.device})';
}


}

/// @nodoc
abstract mixin class $AdbDeviceIdentityCopyWith<$Res>  {
  factory $AdbDeviceIdentityCopyWith(AdbDeviceIdentity value, $Res Function(AdbDeviceIdentity) _then) = _$AdbDeviceIdentityCopyWithImpl;
@useResult
$Res call({
 AdbSerialNumber serialNumber, AndroidProduct? product, AndroidModel? model, AndroidDevice? device
});




}
/// @nodoc
class _$AdbDeviceIdentityCopyWithImpl<$Res>
    implements $AdbDeviceIdentityCopyWith<$Res> {
  _$AdbDeviceIdentityCopyWithImpl(this._self, this._then);

  final AdbDeviceIdentity _self;
  final $Res Function(AdbDeviceIdentity) _then;

/// Create a copy of AdbDeviceIdentity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serialNumber = null,Object? product = freezed,Object? model = freezed,Object? device = freezed,}) {
  return _then(AdbDeviceIdentity(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as AdbSerialNumber,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as AndroidProduct?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as AndroidModel?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdbDeviceIdentity].
extension AdbDeviceIdentityPatterns on AdbDeviceIdentity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdbDeviceIdentity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdbDeviceIdentity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdbDeviceIdentity value)  $default,){
final _that = this;
switch (_that) {
case _AdbDeviceIdentity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdbDeviceIdentity value)?  $default,){
final _that = this;
switch (_that) {
case _AdbDeviceIdentity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AdbSerialNumber serialNumber,  AndroidProduct? product,  AndroidModel? model,  AndroidDevice? device)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdbDeviceIdentity() when $default != null:
return $default(_that.serialNumber,_that.product,_that.model,_that.device);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AdbSerialNumber serialNumber,  AndroidProduct? product,  AndroidModel? model,  AndroidDevice? device)  $default,) {final _that = this;
switch (_that) {
case _AdbDeviceIdentity():
return $default(_that.serialNumber,_that.product,_that.model,_that.device);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AdbSerialNumber serialNumber,  AndroidProduct? product,  AndroidModel? model,  AndroidDevice? device)?  $default,) {final _that = this;
switch (_that) {
case _AdbDeviceIdentity() when $default != null:
return $default(_that.serialNumber,_that.product,_that.model,_that.device);case _:
  return null;

}
}

}

/// @nodoc


class _AdbDeviceIdentity implements AdbDeviceIdentity {
  const _AdbDeviceIdentity({required this.serialNumber, required this.product, required this.model, required this.device});
  

@override final  AdbSerialNumber serialNumber;
@override final  AndroidProduct? product;
@override final  AndroidModel? model;
@override final  AndroidDevice? device;

/// Create a copy of AdbDeviceIdentity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdbDeviceIdentityCopyWith<_AdbDeviceIdentity> get copyWith => __$AdbDeviceIdentityCopyWithImpl<_AdbDeviceIdentity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdbDeviceIdentity&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.product, product) || other.product == product)&&(identical(other.model, model) || other.model == model)&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode {
    return Object.hash(runtimeType,serialNumber,product,model,device);
}

@override
String toString() {
    return 'AdbDeviceIdentity(serialNumber: $serialNumber, product: $product, model: $model, device: $device)';
}


}

/// @nodoc
abstract mixin class _$AdbDeviceIdentityCopyWith<$Res> implements $AdbDeviceIdentityCopyWith<$Res> {
  factory _$AdbDeviceIdentityCopyWith(_AdbDeviceIdentity value, $Res Function(_AdbDeviceIdentity) _then) = __$AdbDeviceIdentityCopyWithImpl;
@override @useResult
$Res call({
 AdbSerialNumber serialNumber, AndroidProduct? product, AndroidModel? model, AndroidDevice? device
});




}
/// @nodoc
class __$AdbDeviceIdentityCopyWithImpl<$Res>
    implements _$AdbDeviceIdentityCopyWith<$Res> {
  __$AdbDeviceIdentityCopyWithImpl(this._self, this._then);

  final _AdbDeviceIdentity _self;
  final $Res Function(_AdbDeviceIdentity) _then;

/// Create a copy of AdbDeviceIdentity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serialNumber = null,Object? product = freezed,Object? model = freezed,Object? device = freezed,}) {
  return _then(_AdbDeviceIdentity(
serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as AdbSerialNumber,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as AndroidProduct?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as AndroidModel?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as AndroidDevice?,
  ));
}


}

// dart format on
