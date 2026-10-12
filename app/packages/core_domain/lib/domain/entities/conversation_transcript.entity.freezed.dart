// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_transcript.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConversationTranscriptEntity {

 String get sessionId; List<TranscriptSegmentEntity> get segments; DateTime get finalizedAt; String? get languageCode;
/// Create a copy of ConversationTranscriptEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationTranscriptEntityCopyWith<ConversationTranscriptEntity> get copyWith => _$ConversationTranscriptEntityCopyWithImpl<ConversationTranscriptEntity>(this as ConversationTranscriptEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationTranscriptEntity&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&const DeepCollectionEquality().equals(other.segments, segments)&&(identical(other.finalizedAt, finalizedAt) || other.finalizedAt == finalizedAt)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,const DeepCollectionEquality().hash(segments),finalizedAt,languageCode);

@override
String toString() {
  return 'ConversationTranscriptEntity(sessionId: $sessionId, segments: $segments, finalizedAt: $finalizedAt, languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class $ConversationTranscriptEntityCopyWith<$Res>  {
  factory $ConversationTranscriptEntityCopyWith(ConversationTranscriptEntity value, $Res Function(ConversationTranscriptEntity) _then) = _$ConversationTranscriptEntityCopyWithImpl;
@useResult
$Res call({
 String sessionId, List<TranscriptSegmentEntity> segments, DateTime finalizedAt, String? languageCode
});




}
/// @nodoc
class _$ConversationTranscriptEntityCopyWithImpl<$Res>
    implements $ConversationTranscriptEntityCopyWith<$Res> {
  _$ConversationTranscriptEntityCopyWithImpl(this._self, this._then);

  final ConversationTranscriptEntity _self;
  final $Res Function(ConversationTranscriptEntity) _then;

/// Create a copy of ConversationTranscriptEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? segments = null,Object? finalizedAt = null,Object? languageCode = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegmentEntity>,finalizedAt: null == finalizedAt ? _self.finalizedAt : finalizedAt // ignore: cast_nullable_to_non_nullable
as DateTime,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationTranscriptEntity].
extension ConversationTranscriptEntityPatterns on ConversationTranscriptEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationTranscriptEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationTranscriptEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationTranscriptEntity value)  $default,){
final _that = this;
switch (_that) {
case _ConversationTranscriptEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationTranscriptEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationTranscriptEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  List<TranscriptSegmentEntity> segments,  DateTime finalizedAt,  String? languageCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationTranscriptEntity() when $default != null:
return $default(_that.sessionId,_that.segments,_that.finalizedAt,_that.languageCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  List<TranscriptSegmentEntity> segments,  DateTime finalizedAt,  String? languageCode)  $default,) {final _that = this;
switch (_that) {
case _ConversationTranscriptEntity():
return $default(_that.sessionId,_that.segments,_that.finalizedAt,_that.languageCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  List<TranscriptSegmentEntity> segments,  DateTime finalizedAt,  String? languageCode)?  $default,) {final _that = this;
switch (_that) {
case _ConversationTranscriptEntity() when $default != null:
return $default(_that.sessionId,_that.segments,_that.finalizedAt,_that.languageCode);case _:
  return null;

}
}

}

/// @nodoc


class _ConversationTranscriptEntity implements ConversationTranscriptEntity {
  const _ConversationTranscriptEntity({required this.sessionId, required final  List<TranscriptSegmentEntity> segments, required this.finalizedAt, this.languageCode}): _segments = segments;
  

@override final  String sessionId;
 final  List<TranscriptSegmentEntity> _segments;
@override List<TranscriptSegmentEntity> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}

@override final  DateTime finalizedAt;
@override final  String? languageCode;

/// Create a copy of ConversationTranscriptEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationTranscriptEntityCopyWith<_ConversationTranscriptEntity> get copyWith => __$ConversationTranscriptEntityCopyWithImpl<_ConversationTranscriptEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationTranscriptEntity&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&const DeepCollectionEquality().equals(other._segments, _segments)&&(identical(other.finalizedAt, finalizedAt) || other.finalizedAt == finalizedAt)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,const DeepCollectionEquality().hash(_segments),finalizedAt,languageCode);

@override
String toString() {
  return 'ConversationTranscriptEntity(sessionId: $sessionId, segments: $segments, finalizedAt: $finalizedAt, languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class _$ConversationTranscriptEntityCopyWith<$Res> implements $ConversationTranscriptEntityCopyWith<$Res> {
  factory _$ConversationTranscriptEntityCopyWith(_ConversationTranscriptEntity value, $Res Function(_ConversationTranscriptEntity) _then) = __$ConversationTranscriptEntityCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, List<TranscriptSegmentEntity> segments, DateTime finalizedAt, String? languageCode
});




}
/// @nodoc
class __$ConversationTranscriptEntityCopyWithImpl<$Res>
    implements _$ConversationTranscriptEntityCopyWith<$Res> {
  __$ConversationTranscriptEntityCopyWithImpl(this._self, this._then);

  final _ConversationTranscriptEntity _self;
  final $Res Function(_ConversationTranscriptEntity) _then;

/// Create a copy of ConversationTranscriptEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? segments = null,Object? finalizedAt = null,Object? languageCode = freezed,}) {
  return _then(_ConversationTranscriptEntity(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegmentEntity>,finalizedAt: null == finalizedAt ? _self.finalizedAt : finalizedAt // ignore: cast_nullable_to_non_nullable
as DateTime,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
