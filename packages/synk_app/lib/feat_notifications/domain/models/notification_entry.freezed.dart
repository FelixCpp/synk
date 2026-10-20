// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationEntry {

 int get id; AppNotification get notification; int get count; Duration? get lifetime; Duration? get remaining;
/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationEntryCopyWith<NotificationEntry> get copyWith => _$NotificationEntryCopyWithImpl<NotificationEntry>(this as NotificationEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NotificationEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.notification, _this.notification) || other.notification == _this.notification)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.lifetime, _this.lifetime) || other.lifetime == _this.lifetime)&&(identical(other.remaining, _this.remaining) || other.remaining == _this.remaining));
}


@override
int get hashCode {
  final _this = this as NotificationEntry;
  return Object.hash(runtimeType,_this.id,_this.notification,_this.count,_this.lifetime,_this.remaining);
}

@override
String toString() {
  final _this = this as NotificationEntry;
  return 'NotificationEntry(id: ${_this.id}, notification: ${_this.notification}, count: ${_this.count}, lifetime: ${_this.lifetime}, remaining: ${_this.remaining})';
}


}

/// @nodoc
abstract mixin class $NotificationEntryCopyWith<$Res>  {
  factory $NotificationEntryCopyWith(NotificationEntry value, $Res Function(NotificationEntry) _then) = _$NotificationEntryCopyWithImpl;
@useResult
$Res call({
 int id, AppNotification notification, int count, Duration? lifetime, Duration? remaining
});


$AppNotificationCopyWith<$Res> get notification;

}
/// @nodoc
class _$NotificationEntryCopyWithImpl<$Res>
    implements $NotificationEntryCopyWith<$Res> {
  _$NotificationEntryCopyWithImpl(this._self, this._then);

  final NotificationEntry _self;
  final $Res Function(NotificationEntry) _then;

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? notification = null,Object? count = null,Object? lifetime = freezed,Object? remaining = freezed,}) {
  return _then(NotificationEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,notification: null == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as AppNotification,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,lifetime: freezed == lifetime ? _self.lifetime : lifetime // ignore: cast_nullable_to_non_nullable
as Duration?,remaining: freezed == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}
/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<$Res> get notification {
  
  return $AppNotificationCopyWith<$Res>(_self.notification, (value) {
    return _then(_self.copyWith(notification: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationEntry].
extension NotificationEntryPatterns on NotificationEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationEntry value)  $default,){
final _that = this;
switch (_that) {
case _NotificationEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationEntry value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  AppNotification notification,  int count,  Duration? lifetime,  Duration? remaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
return $default(_that.id,_that.notification,_that.count,_that.lifetime,_that.remaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  AppNotification notification,  int count,  Duration? lifetime,  Duration? remaining)  $default,) {final _that = this;
switch (_that) {
case _NotificationEntry():
return $default(_that.id,_that.notification,_that.count,_that.lifetime,_that.remaining);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  AppNotification notification,  int count,  Duration? lifetime,  Duration? remaining)?  $default,) {final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
return $default(_that.id,_that.notification,_that.count,_that.lifetime,_that.remaining);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationEntry extends NotificationEntry {
  const _NotificationEntry({required this.id, required this.notification, this.count = 1, this.lifetime, this.remaining}): super._();
  

@override final  int id;
@override final  AppNotification notification;
@override@JsonKey() final  int count;
@override final  Duration? lifetime;
@override final  Duration? remaining;

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationEntryCopyWith<_NotificationEntry> get copyWith => __$NotificationEntryCopyWithImpl<_NotificationEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.notification, notification) || other.notification == notification)&&(identical(other.count, count) || other.count == count)&&(identical(other.lifetime, lifetime) || other.lifetime == lifetime)&&(identical(other.remaining, remaining) || other.remaining == remaining));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,notification,count,lifetime,remaining);
}

@override
String toString() {
    return 'NotificationEntry(id: $id, notification: $notification, count: $count, lifetime: $lifetime, remaining: $remaining)';
}


}

/// @nodoc
abstract mixin class _$NotificationEntryCopyWith<$Res> implements $NotificationEntryCopyWith<$Res> {
  factory _$NotificationEntryCopyWith(_NotificationEntry value, $Res Function(_NotificationEntry) _then) = __$NotificationEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, AppNotification notification, int count, Duration? lifetime, Duration? remaining
});


@override $AppNotificationCopyWith<$Res> get notification;

}
/// @nodoc
class __$NotificationEntryCopyWithImpl<$Res>
    implements _$NotificationEntryCopyWith<$Res> {
  __$NotificationEntryCopyWithImpl(this._self, this._then);

  final _NotificationEntry _self;
  final $Res Function(_NotificationEntry) _then;

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? notification = null,Object? count = null,Object? lifetime = freezed,Object? remaining = freezed,}) {
  return _then(_NotificationEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,notification: null == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as AppNotification,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,lifetime: freezed == lifetime ? _self.lifetime : lifetime // ignore: cast_nullable_to_non_nullable
as Duration?,remaining: freezed == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<$Res> get notification {
  
  return $AppNotificationCopyWith<$Res>(_self.notification, (value) {
    return _then(_self.copyWith(notification: value));
  });
}
}

// dart format on
