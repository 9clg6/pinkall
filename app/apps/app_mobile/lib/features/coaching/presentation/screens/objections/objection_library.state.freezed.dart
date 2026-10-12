// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'objection_library.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ObjectionLibraryState {

 List<ObjectionKnowledgeEntryEntity> get entries; bool get isSaving;
/// Create a copy of ObjectionLibraryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectionLibraryStateCopyWith<ObjectionLibraryState> get copyWith => _$ObjectionLibraryStateCopyWithImpl<ObjectionLibraryState>(this as ObjectionLibraryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectionLibraryState&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(entries),isSaving);

@override
String toString() {
  return 'ObjectionLibraryState(entries: $entries, isSaving: $isSaving)';
}


}

/// @nodoc
abstract mixin class $ObjectionLibraryStateCopyWith<$Res>  {
  factory $ObjectionLibraryStateCopyWith(ObjectionLibraryState value, $Res Function(ObjectionLibraryState) _then) = _$ObjectionLibraryStateCopyWithImpl;
@useResult
$Res call({
 List<ObjectionKnowledgeEntryEntity> entries, bool isSaving
});




}
/// @nodoc
class _$ObjectionLibraryStateCopyWithImpl<$Res>
    implements $ObjectionLibraryStateCopyWith<$Res> {
  _$ObjectionLibraryStateCopyWithImpl(this._self, this._then);

  final ObjectionLibraryState _self;
  final $Res Function(ObjectionLibraryState) _then;

/// Create a copy of ObjectionLibraryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? isSaving = null,}) {
  return _then(_self.copyWith(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<ObjectionKnowledgeEntryEntity>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ObjectionLibraryState].
extension ObjectionLibraryStatePatterns on ObjectionLibraryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ObjectionLibraryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ObjectionLibraryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ObjectionLibraryState value)  $default,){
final _that = this;
switch (_that) {
case _ObjectionLibraryState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ObjectionLibraryState value)?  $default,){
final _that = this;
switch (_that) {
case _ObjectionLibraryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ObjectionKnowledgeEntryEntity> entries,  bool isSaving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ObjectionLibraryState() when $default != null:
return $default(_that.entries,_that.isSaving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ObjectionKnowledgeEntryEntity> entries,  bool isSaving)  $default,) {final _that = this;
switch (_that) {
case _ObjectionLibraryState():
return $default(_that.entries,_that.isSaving);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ObjectionKnowledgeEntryEntity> entries,  bool isSaving)?  $default,) {final _that = this;
switch (_that) {
case _ObjectionLibraryState() when $default != null:
return $default(_that.entries,_that.isSaving);case _:
  return null;

}
}

}

/// @nodoc


class _ObjectionLibraryState implements ObjectionLibraryState {
  const _ObjectionLibraryState({final  List<ObjectionKnowledgeEntryEntity> entries = const <ObjectionKnowledgeEntryEntity>[], this.isSaving = false}): _entries = entries;
  

 final  List<ObjectionKnowledgeEntryEntity> _entries;
@override@JsonKey() List<ObjectionKnowledgeEntryEntity> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  bool isSaving;

/// Create a copy of ObjectionLibraryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObjectionLibraryStateCopyWith<_ObjectionLibraryState> get copyWith => __$ObjectionLibraryStateCopyWithImpl<_ObjectionLibraryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ObjectionLibraryState&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),isSaving);

@override
String toString() {
  return 'ObjectionLibraryState(entries: $entries, isSaving: $isSaving)';
}


}

/// @nodoc
abstract mixin class _$ObjectionLibraryStateCopyWith<$Res> implements $ObjectionLibraryStateCopyWith<$Res> {
  factory _$ObjectionLibraryStateCopyWith(_ObjectionLibraryState value, $Res Function(_ObjectionLibraryState) _then) = __$ObjectionLibraryStateCopyWithImpl;
@override @useResult
$Res call({
 List<ObjectionKnowledgeEntryEntity> entries, bool isSaving
});




}
/// @nodoc
class __$ObjectionLibraryStateCopyWithImpl<$Res>
    implements _$ObjectionLibraryStateCopyWith<$Res> {
  __$ObjectionLibraryStateCopyWithImpl(this._self, this._then);

  final _ObjectionLibraryState _self;
  final $Res Function(_ObjectionLibraryState) _then;

/// Create a copy of ObjectionLibraryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? isSaving = null,}) {
  return _then(_ObjectionLibraryState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<ObjectionKnowledgeEntryEntity>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
