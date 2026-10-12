// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coaching_suggestion.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoachingSuggestionEntity {

 String get id; String get sessionId; CoachingSuggestionKind get kind; String get text; String get rationale; List<CoachingSourceEntity> get sources; double get confidence; DateTime get createdAt; DateTime get expiresAt;
/// Create a copy of CoachingSuggestionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingSuggestionEntityCopyWith<CoachingSuggestionEntity> get copyWith => _$CoachingSuggestionEntityCopyWithImpl<CoachingSuggestionEntity>(this as CoachingSuggestionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingSuggestionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.text, text) || other.text == text)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,kind,text,rationale,const DeepCollectionEquality().hash(sources),confidence,createdAt,expiresAt);

@override
String toString() {
  return 'CoachingSuggestionEntity(id: $id, sessionId: $sessionId, kind: $kind, text: $text, rationale: $rationale, sources: $sources, confidence: $confidence, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $CoachingSuggestionEntityCopyWith<$Res>  {
  factory $CoachingSuggestionEntityCopyWith(CoachingSuggestionEntity value, $Res Function(CoachingSuggestionEntity) _then) = _$CoachingSuggestionEntityCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, CoachingSuggestionKind kind, String text, String rationale, List<CoachingSourceEntity> sources, double confidence, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class _$CoachingSuggestionEntityCopyWithImpl<$Res>
    implements $CoachingSuggestionEntityCopyWith<$Res> {
  _$CoachingSuggestionEntityCopyWithImpl(this._self, this._then);

  final CoachingSuggestionEntity _self;
  final $Res Function(CoachingSuggestionEntity) _then;

/// Create a copy of CoachingSuggestionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? kind = null,Object? text = null,Object? rationale = null,Object? sources = null,Object? confidence = null,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CoachingSuggestionKind,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceEntity>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachingSuggestionEntity].
extension CoachingSuggestionEntityPatterns on CoachingSuggestionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingSuggestionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingSuggestionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingSuggestionEntity value)  $default,){
final _that = this;
switch (_that) {
case _CoachingSuggestionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingSuggestionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingSuggestionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  CoachingSuggestionKind kind,  String text,  String rationale,  List<CoachingSourceEntity> sources,  double confidence,  DateTime createdAt,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingSuggestionEntity() when $default != null:
return $default(_that.id,_that.sessionId,_that.kind,_that.text,_that.rationale,_that.sources,_that.confidence,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  CoachingSuggestionKind kind,  String text,  String rationale,  List<CoachingSourceEntity> sources,  double confidence,  DateTime createdAt,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _CoachingSuggestionEntity():
return $default(_that.id,_that.sessionId,_that.kind,_that.text,_that.rationale,_that.sources,_that.confidence,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  CoachingSuggestionKind kind,  String text,  String rationale,  List<CoachingSourceEntity> sources,  double confidence,  DateTime createdAt,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _CoachingSuggestionEntity() when $default != null:
return $default(_that.id,_that.sessionId,_that.kind,_that.text,_that.rationale,_that.sources,_that.confidence,_that.createdAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _CoachingSuggestionEntity implements CoachingSuggestionEntity {
  const _CoachingSuggestionEntity({required this.id, required this.sessionId, required this.kind, required this.text, required this.rationale, required final  List<CoachingSourceEntity> sources, required this.confidence, required this.createdAt, required this.expiresAt}): _sources = sources;
  

@override final  String id;
@override final  String sessionId;
@override final  CoachingSuggestionKind kind;
@override final  String text;
@override final  String rationale;
 final  List<CoachingSourceEntity> _sources;
@override List<CoachingSourceEntity> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override final  double confidence;
@override final  DateTime createdAt;
@override final  DateTime expiresAt;

/// Create a copy of CoachingSuggestionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingSuggestionEntityCopyWith<_CoachingSuggestionEntity> get copyWith => __$CoachingSuggestionEntityCopyWithImpl<_CoachingSuggestionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingSuggestionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.text, text) || other.text == text)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,kind,text,rationale,const DeepCollectionEquality().hash(_sources),confidence,createdAt,expiresAt);

@override
String toString() {
  return 'CoachingSuggestionEntity(id: $id, sessionId: $sessionId, kind: $kind, text: $text, rationale: $rationale, sources: $sources, confidence: $confidence, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$CoachingSuggestionEntityCopyWith<$Res> implements $CoachingSuggestionEntityCopyWith<$Res> {
  factory _$CoachingSuggestionEntityCopyWith(_CoachingSuggestionEntity value, $Res Function(_CoachingSuggestionEntity) _then) = __$CoachingSuggestionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, CoachingSuggestionKind kind, String text, String rationale, List<CoachingSourceEntity> sources, double confidence, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class __$CoachingSuggestionEntityCopyWithImpl<$Res>
    implements _$CoachingSuggestionEntityCopyWith<$Res> {
  __$CoachingSuggestionEntityCopyWithImpl(this._self, this._then);

  final _CoachingSuggestionEntity _self;
  final $Res Function(_CoachingSuggestionEntity) _then;

/// Create a copy of CoachingSuggestionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? kind = null,Object? text = null,Object? rationale = null,Object? sources = null,Object? confidence = null,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_CoachingSuggestionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CoachingSuggestionKind,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceEntity>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
