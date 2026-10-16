// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_version_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppVersionState {

 AppVersion get currentAppVersion; NewerAppVersion? get newerAppVersion; bool get isUpdating; double? get downloadProgress;
/// Create a copy of AppVersionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppVersionStateCopyWith<AppVersionState> get copyWith => _$AppVersionStateCopyWithImpl<AppVersionState>(this as AppVersionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppVersionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppVersionState&&(identical(other.currentAppVersion, _this.currentAppVersion) || other.currentAppVersion == _this.currentAppVersion)&&(identical(other.newerAppVersion, _this.newerAppVersion) || other.newerAppVersion == _this.newerAppVersion)&&(identical(other.isUpdating, _this.isUpdating) || other.isUpdating == _this.isUpdating)&&(identical(other.downloadProgress, _this.downloadProgress) || other.downloadProgress == _this.downloadProgress));
}


@override
int get hashCode {
  final _this = this as AppVersionState;
  return Object.hash(runtimeType,_this.currentAppVersion,_this.newerAppVersion,_this.isUpdating,_this.downloadProgress);
}

@override
String toString() {
  final _this = this as AppVersionState;
  return 'AppVersionState(currentAppVersion: ${_this.currentAppVersion}, newerAppVersion: ${_this.newerAppVersion}, isUpdating: ${_this.isUpdating}, downloadProgress: ${_this.downloadProgress})';
}


}

/// @nodoc
abstract mixin class $AppVersionStateCopyWith<$Res>  {
  factory $AppVersionStateCopyWith(AppVersionState value, $Res Function(AppVersionState) _then) = _$AppVersionStateCopyWithImpl;
@useResult
$Res call({
 AppVersion currentAppVersion, NewerAppVersion? newerAppVersion, bool isUpdating, double? downloadProgress
});


$AppVersionCopyWith<$Res> get currentAppVersion;$NewerAppVersionCopyWith<$Res>? get newerAppVersion;

}
/// @nodoc
class _$AppVersionStateCopyWithImpl<$Res>
    implements $AppVersionStateCopyWith<$Res> {
  _$AppVersionStateCopyWithImpl(this._self, this._then);

  final AppVersionState _self;
  final $Res Function(AppVersionState) _then;

/// Create a copy of AppVersionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentAppVersion = null,Object? newerAppVersion = freezed,Object? isUpdating = null,Object? downloadProgress = freezed,}) {
  return _then(AppVersionState(
currentAppVersion: null == currentAppVersion ? _self.currentAppVersion : currentAppVersion // ignore: cast_nullable_to_non_nullable
as AppVersion,newerAppVersion: freezed == newerAppVersion ? _self.newerAppVersion : newerAppVersion // ignore: cast_nullable_to_non_nullable
as NewerAppVersion?,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,downloadProgress: freezed == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of AppVersionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppVersionCopyWith<$Res> get currentAppVersion {
  
  return $AppVersionCopyWith<$Res>(_self.currentAppVersion, (value) {
    return _then(_self.copyWith(currentAppVersion: value));
  });
}/// Create a copy of AppVersionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewerAppVersionCopyWith<$Res>? get newerAppVersion {
    if (_self.newerAppVersion == null) {
    return null;
  }

  return $NewerAppVersionCopyWith<$Res>(_self.newerAppVersion!, (value) {
    return _then(_self.copyWith(newerAppVersion: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppVersionState].
extension AppVersionStatePatterns on AppVersionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppVersionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppVersionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppVersionState value)  $default,){
final _that = this;
switch (_that) {
case _AppVersionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppVersionState value)?  $default,){
final _that = this;
switch (_that) {
case _AppVersionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppVersion currentAppVersion,  NewerAppVersion? newerAppVersion,  bool isUpdating,  double? downloadProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppVersionState() when $default != null:
return $default(_that.currentAppVersion,_that.newerAppVersion,_that.isUpdating,_that.downloadProgress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppVersion currentAppVersion,  NewerAppVersion? newerAppVersion,  bool isUpdating,  double? downloadProgress)  $default,) {final _that = this;
switch (_that) {
case _AppVersionState():
return $default(_that.currentAppVersion,_that.newerAppVersion,_that.isUpdating,_that.downloadProgress);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppVersion currentAppVersion,  NewerAppVersion? newerAppVersion,  bool isUpdating,  double? downloadProgress)?  $default,) {final _that = this;
switch (_that) {
case _AppVersionState() when $default != null:
return $default(_that.currentAppVersion,_that.newerAppVersion,_that.isUpdating,_that.downloadProgress);case _:
  return null;

}
}

}

/// @nodoc


class _AppVersionState implements AppVersionState {
  const _AppVersionState({required this.currentAppVersion, required this.newerAppVersion, required this.isUpdating, required this.downloadProgress});
  

@override final  AppVersion currentAppVersion;
@override final  NewerAppVersion? newerAppVersion;
@override final  bool isUpdating;
@override final  double? downloadProgress;

/// Create a copy of AppVersionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppVersionStateCopyWith<_AppVersionState> get copyWith => __$AppVersionStateCopyWithImpl<_AppVersionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppVersionState&&(identical(other.currentAppVersion, currentAppVersion) || other.currentAppVersion == currentAppVersion)&&(identical(other.newerAppVersion, newerAppVersion) || other.newerAppVersion == newerAppVersion)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currentAppVersion,newerAppVersion,isUpdating,downloadProgress);
}

@override
String toString() {
    return 'AppVersionState(currentAppVersion: $currentAppVersion, newerAppVersion: $newerAppVersion, isUpdating: $isUpdating, downloadProgress: $downloadProgress)';
}


}

/// @nodoc
abstract mixin class _$AppVersionStateCopyWith<$Res> implements $AppVersionStateCopyWith<$Res> {
  factory _$AppVersionStateCopyWith(_AppVersionState value, $Res Function(_AppVersionState) _then) = __$AppVersionStateCopyWithImpl;
@override @useResult
$Res call({
 AppVersion currentAppVersion, NewerAppVersion? newerAppVersion, bool isUpdating, double? downloadProgress
});


@override $AppVersionCopyWith<$Res> get currentAppVersion;@override $NewerAppVersionCopyWith<$Res>? get newerAppVersion;

}
/// @nodoc
class __$AppVersionStateCopyWithImpl<$Res>
    implements _$AppVersionStateCopyWith<$Res> {
  __$AppVersionStateCopyWithImpl(this._self, this._then);

  final _AppVersionState _self;
  final $Res Function(_AppVersionState) _then;

/// Create a copy of AppVersionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentAppVersion = null,Object? newerAppVersion = freezed,Object? isUpdating = null,Object? downloadProgress = freezed,}) {
  return _then(_AppVersionState(
currentAppVersion: null == currentAppVersion ? _self.currentAppVersion : currentAppVersion // ignore: cast_nullable_to_non_nullable
as AppVersion,newerAppVersion: freezed == newerAppVersion ? _self.newerAppVersion : newerAppVersion // ignore: cast_nullable_to_non_nullable
as NewerAppVersion?,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,downloadProgress: freezed == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of AppVersionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppVersionCopyWith<$Res> get currentAppVersion {
  
  return $AppVersionCopyWith<$Res>(_self.currentAppVersion, (value) {
    return _then(_self.copyWith(currentAppVersion: value));
  });
}/// Create a copy of AppVersionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewerAppVersionCopyWith<$Res>? get newerAppVersion {
    if (_self.newerAppVersion == null) {
    return null;
  }

  return $NewerAppVersionCopyWith<$Res>(_self.newerAppVersion!, (value) {
    return _then(_self.copyWith(newerAppVersion: value));
  });
}
}

/// @nodoc
mixin _$AppVersionEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AppVersionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppVersionEvent()';
}


}

/// @nodoc
class $AppVersionEventCopyWith<$Res>  {
$AppVersionEventCopyWith(AppVersionEvent _, $Res Function(AppVersionEvent) __);
}


/// Adds pattern-matching-related methods to [AppVersionEvent].
extension AppVersionEventPatterns on AppVersionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnCheckForUpdates value)?  onCheckForUpdates,TResult Function( _OnUpdate value)?  onUpdate,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnCheckForUpdates() when onCheckForUpdates != null:
return onCheckForUpdates(_that);case _OnUpdate() when onUpdate != null:
return onUpdate(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnCheckForUpdates value)  onCheckForUpdates,required TResult Function( _OnUpdate value)  onUpdate,}){
final _that = this;
switch (_that) {
case _OnCheckForUpdates():
return onCheckForUpdates(_that);case _OnUpdate():
return onUpdate(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnCheckForUpdates value)?  onCheckForUpdates,TResult? Function( _OnUpdate value)?  onUpdate,}){
final _that = this;
switch (_that) {
case _OnCheckForUpdates() when onCheckForUpdates != null:
return onCheckForUpdates(_that);case _OnUpdate() when onUpdate != null:
return onUpdate(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  onCheckForUpdates,TResult Function()?  onUpdate,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnCheckForUpdates() when onCheckForUpdates != null:
return onCheckForUpdates();case _OnUpdate() when onUpdate != null:
return onUpdate();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  onCheckForUpdates,required TResult Function()  onUpdate,}) {final _that = this;
switch (_that) {
case _OnCheckForUpdates():
return onCheckForUpdates();case _OnUpdate():
return onUpdate();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  onCheckForUpdates,TResult? Function()?  onUpdate,}) {final _that = this;
switch (_that) {
case _OnCheckForUpdates() when onCheckForUpdates != null:
return onCheckForUpdates();case _OnUpdate() when onUpdate != null:
return onUpdate();case _:
  return null;

}
}

}

/// @nodoc


class _OnCheckForUpdates implements AppVersionEvent {
  const _OnCheckForUpdates();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnCheckForUpdates);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppVersionEvent.onCheckForUpdates()';
}


}




/// @nodoc


class _OnUpdate implements AppVersionEvent {
  const _OnUpdate();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnUpdate);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppVersionEvent.onUpdate()';
}


}




// dart format on
