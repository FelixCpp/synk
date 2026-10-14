// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SettingsEvent()';
}


}

/// @nodoc
class $SettingsEventCopyWith<$Res>  {
$SettingsEventCopyWith(SettingsEvent _, $Res Function(SettingsEvent) __);
}


/// Adds pattern-matching-related methods to [SettingsEvent].
extension SettingsEventPatterns on SettingsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSetup value)?  onSetup,TResult Function( _OnSave value)?  onSave,TResult Function( _OnRevealScreenCaptureSavePath value)?  onRevealScreenCaptureSavePath,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnSave() when onSave != null:
return onSave(_that);case _OnRevealScreenCaptureSavePath() when onRevealScreenCaptureSavePath != null:
return onRevealScreenCaptureSavePath(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSetup value)  onSetup,required TResult Function( _OnSave value)  onSave,required TResult Function( _OnRevealScreenCaptureSavePath value)  onRevealScreenCaptureSavePath,}){
final _that = this;
switch (_that) {
case _OnSetup():
return onSetup(_that);case _OnSave():
return onSave(_that);case _OnRevealScreenCaptureSavePath():
return onRevealScreenCaptureSavePath(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSetup value)?  onSetup,TResult? Function( _OnSave value)?  onSave,TResult? Function( _OnRevealScreenCaptureSavePath value)?  onRevealScreenCaptureSavePath,}){
final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup(_that);case _OnSave() when onSave != null:
return onSave(_that);case _OnRevealScreenCaptureSavePath() when onRevealScreenCaptureSavePath != null:
return onRevealScreenCaptureSavePath(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onSetup,TResult Function( Settings settings)?  onSave,TResult Function()?  onRevealScreenCaptureSavePath,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnSave() when onSave != null:
return onSave(_that.settings);case _OnRevealScreenCaptureSavePath() when onRevealScreenCaptureSavePath != null:
return onRevealScreenCaptureSavePath();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onSetup,required TResult Function( Settings settings)  onSave,required TResult Function()  onRevealScreenCaptureSavePath,}) {final _that = this;
switch (_that) {
case _OnSetup():
return onSetup();case _OnSave():
return onSave(_that.settings);case _OnRevealScreenCaptureSavePath():
return onRevealScreenCaptureSavePath();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onSetup,TResult? Function( Settings settings)?  onSave,TResult? Function()?  onRevealScreenCaptureSavePath,}) {final _that = this;
switch (_that) {
case _OnSetup() when onSetup != null:
return onSetup();case _OnSave() when onSave != null:
return onSave(_that.settings);case _OnRevealScreenCaptureSavePath() when onRevealScreenCaptureSavePath != null:
return onRevealScreenCaptureSavePath();case _:
  return null;

}
}

}

/// @nodoc


class _OnSetup implements SettingsEvent {
  const _OnSetup();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSetup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SettingsEvent.onSetup()';
}


}




/// @nodoc


class _OnSave implements SettingsEvent {
  const _OnSave(this.settings);
  

 final  Settings settings;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnSaveCopyWith<_OnSave> get copyWith => __$OnSaveCopyWithImpl<_OnSave>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSave&&(identical(other.settings, settings) || other.settings == settings));
}


@override
int get hashCode {
    return Object.hash(runtimeType,settings);
}

@override
String toString() {
    return 'SettingsEvent.onSave(settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$OnSaveCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory _$OnSaveCopyWith(_OnSave value, $Res Function(_OnSave) _then) = __$OnSaveCopyWithImpl;
@useResult
$Res call({
 Settings settings
});


$SettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$OnSaveCopyWithImpl<$Res>
    implements _$OnSaveCopyWith<$Res> {
  __$OnSaveCopyWithImpl(this._self, this._then);

  final _OnSave _self;
  final $Res Function(_OnSave) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? settings = null,}) {
  return _then(_OnSave(
null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Settings,
  ));
}

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsCopyWith<$Res> get settings {
  
  return $SettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

/// @nodoc


class _OnRevealScreenCaptureSavePath implements SettingsEvent {
  const _OnRevealScreenCaptureSavePath();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnRevealScreenCaptureSavePath);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SettingsEvent.onRevealScreenCaptureSavePath()';
}


}




// dart format on
