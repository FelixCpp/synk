// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_stack.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationStack {

 List<NotificationEntry> get entries;
/// Create a copy of NotificationStack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationStackCopyWith<NotificationStack> get copyWith => _$NotificationStackCopyWithImpl<NotificationStack>(this as NotificationStack, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NotificationStack;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationStack&&const DeepCollectionEquality().equals(other.entries, _this.entries));
}


@override
int get hashCode {
  final _this = this as NotificationStack;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries));
}

@override
String toString() {
  final _this = this as NotificationStack;
  return 'NotificationStack(entries: ${_this.entries})';
}


}

/// @nodoc
abstract mixin class $NotificationStackCopyWith<$Res>  {
  factory $NotificationStackCopyWith(NotificationStack value, $Res Function(NotificationStack) _then) = _$NotificationStackCopyWithImpl;
@useResult
$Res call({
 List<NotificationEntry> entries
});




}
/// @nodoc
class _$NotificationStackCopyWithImpl<$Res>
    implements $NotificationStackCopyWith<$Res> {
  _$NotificationStackCopyWithImpl(this._self, this._then);

  final NotificationStack _self;
  final $Res Function(NotificationStack) _then;

/// Create a copy of NotificationStack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,}) {
  return _then(NotificationStack(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<NotificationEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationStack].
extension NotificationStackPatterns on NotificationStack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationStack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationStack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationStack value)  $default,){
final _that = this;
switch (_that) {
case _NotificationStack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationStack value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationStack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NotificationEntry> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationStack() when $default != null:
return $default(_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NotificationEntry> entries)  $default,) {final _that = this;
switch (_that) {
case _NotificationStack():
return $default(_that.entries);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NotificationEntry> entries)?  $default,) {final _that = this;
switch (_that) {
case _NotificationStack() when $default != null:
return $default(_that.entries);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationStack extends NotificationStack {
  const _NotificationStack({required  List<NotificationEntry> entries}): _entries = entries,super._();
  

 final  List<NotificationEntry> _entries;
@override List<NotificationEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of NotificationStack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationStackCopyWith<_NotificationStack> get copyWith => __$NotificationStackCopyWithImpl<_NotificationStack>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationStack&&const DeepCollectionEquality().equals(other.entries, _entries));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries));
}

@override
String toString() {
    return 'NotificationStack(entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$NotificationStackCopyWith<$Res> implements $NotificationStackCopyWith<$Res> {
  factory _$NotificationStackCopyWith(_NotificationStack value, $Res Function(_NotificationStack) _then) = __$NotificationStackCopyWithImpl;
@override @useResult
$Res call({
 List<NotificationEntry> entries
});




}
/// @nodoc
class __$NotificationStackCopyWithImpl<$Res>
    implements _$NotificationStackCopyWith<$Res> {
  __$NotificationStackCopyWithImpl(this._self, this._then);

  final _NotificationStack _self;
  final $Res Function(_NotificationStack) _then;

/// Create a copy of NotificationStack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,}) {
  return _then(_NotificationStack(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<NotificationEntry>,
  ));
}


}

// dart format on
