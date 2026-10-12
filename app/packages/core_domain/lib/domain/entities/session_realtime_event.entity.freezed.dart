// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_realtime_event.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionRealtimeEventEntity {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionRealtimeEventEntity);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionRealtimeEventEntity()';
}


}

/// @nodoc
class $SessionRealtimeEventEntityCopyWith<$Res>  {
$SessionRealtimeEventEntityCopyWith(SessionRealtimeEventEntity _, $Res Function(SessionRealtimeEventEntity) __);
}


/// Adds pattern-matching-related methods to [SessionRealtimeEventEntity].
extension SessionRealtimeEventEntityPatterns on SessionRealtimeEventEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SessionTranscriptSegmentEventEntity value)?  transcriptSegment,TResult Function( SessionCoachingSuggestionEventEntity value)?  coachingSuggestion,TResult Function( SessionCoachStatusEventEntity value)?  coachStatus,TResult Function( SessionStateEventEntity value)?  sessionState,TResult Function( SessionUnknownEventEntity value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SessionTranscriptSegmentEventEntity() when transcriptSegment != null:
return transcriptSegment(_that);case SessionCoachingSuggestionEventEntity() when coachingSuggestion != null:
return coachingSuggestion(_that);case SessionCoachStatusEventEntity() when coachStatus != null:
return coachStatus(_that);case SessionStateEventEntity() when sessionState != null:
return sessionState(_that);case SessionUnknownEventEntity() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SessionTranscriptSegmentEventEntity value)  transcriptSegment,required TResult Function( SessionCoachingSuggestionEventEntity value)  coachingSuggestion,required TResult Function( SessionCoachStatusEventEntity value)  coachStatus,required TResult Function( SessionStateEventEntity value)  sessionState,required TResult Function( SessionUnknownEventEntity value)  unknown,}){
final _that = this;
switch (_that) {
case SessionTranscriptSegmentEventEntity():
return transcriptSegment(_that);case SessionCoachingSuggestionEventEntity():
return coachingSuggestion(_that);case SessionCoachStatusEventEntity():
return coachStatus(_that);case SessionStateEventEntity():
return sessionState(_that);case SessionUnknownEventEntity():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SessionTranscriptSegmentEventEntity value)?  transcriptSegment,TResult? Function( SessionCoachingSuggestionEventEntity value)?  coachingSuggestion,TResult? Function( SessionCoachStatusEventEntity value)?  coachStatus,TResult? Function( SessionStateEventEntity value)?  sessionState,TResult? Function( SessionUnknownEventEntity value)?  unknown,}){
final _that = this;
switch (_that) {
case SessionTranscriptSegmentEventEntity() when transcriptSegment != null:
return transcriptSegment(_that);case SessionCoachingSuggestionEventEntity() when coachingSuggestion != null:
return coachingSuggestion(_that);case SessionCoachStatusEventEntity() when coachStatus != null:
return coachStatus(_that);case SessionStateEventEntity() when sessionState != null:
return sessionState(_that);case SessionUnknownEventEntity() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TranscriptSegmentEntity segment)?  transcriptSegment,TResult Function( CoachingSuggestionEntity suggestion)?  coachingSuggestion,TResult Function( CoachStatusEntity coachStatus)?  coachStatus,TResult Function( ConversationSessionEntity session)?  sessionState,TResult Function( String type,  Map<String, Object?> payload)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SessionTranscriptSegmentEventEntity() when transcriptSegment != null:
return transcriptSegment(_that.segment);case SessionCoachingSuggestionEventEntity() when coachingSuggestion != null:
return coachingSuggestion(_that.suggestion);case SessionCoachStatusEventEntity() when coachStatus != null:
return coachStatus(_that.coachStatus);case SessionStateEventEntity() when sessionState != null:
return sessionState(_that.session);case SessionUnknownEventEntity() when unknown != null:
return unknown(_that.type,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TranscriptSegmentEntity segment)  transcriptSegment,required TResult Function( CoachingSuggestionEntity suggestion)  coachingSuggestion,required TResult Function( CoachStatusEntity coachStatus)  coachStatus,required TResult Function( ConversationSessionEntity session)  sessionState,required TResult Function( String type,  Map<String, Object?> payload)  unknown,}) {final _that = this;
switch (_that) {
case SessionTranscriptSegmentEventEntity():
return transcriptSegment(_that.segment);case SessionCoachingSuggestionEventEntity():
return coachingSuggestion(_that.suggestion);case SessionCoachStatusEventEntity():
return coachStatus(_that.coachStatus);case SessionStateEventEntity():
return sessionState(_that.session);case SessionUnknownEventEntity():
return unknown(_that.type,_that.payload);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TranscriptSegmentEntity segment)?  transcriptSegment,TResult? Function( CoachingSuggestionEntity suggestion)?  coachingSuggestion,TResult? Function( CoachStatusEntity coachStatus)?  coachStatus,TResult? Function( ConversationSessionEntity session)?  sessionState,TResult? Function( String type,  Map<String, Object?> payload)?  unknown,}) {final _that = this;
switch (_that) {
case SessionTranscriptSegmentEventEntity() when transcriptSegment != null:
return transcriptSegment(_that.segment);case SessionCoachingSuggestionEventEntity() when coachingSuggestion != null:
return coachingSuggestion(_that.suggestion);case SessionCoachStatusEventEntity() when coachStatus != null:
return coachStatus(_that.coachStatus);case SessionStateEventEntity() when sessionState != null:
return sessionState(_that.session);case SessionUnknownEventEntity() when unknown != null:
return unknown(_that.type,_that.payload);case _:
  return null;

}
}

}

/// @nodoc


class SessionTranscriptSegmentEventEntity implements SessionRealtimeEventEntity {
  const SessionTranscriptSegmentEventEntity(this.segment);
  

 final  TranscriptSegmentEntity segment;

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionTranscriptSegmentEventEntityCopyWith<SessionTranscriptSegmentEventEntity> get copyWith => _$SessionTranscriptSegmentEventEntityCopyWithImpl<SessionTranscriptSegmentEventEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionTranscriptSegmentEventEntity&&(identical(other.segment, segment) || other.segment == segment));
}


@override
int get hashCode => Object.hash(runtimeType,segment);

@override
String toString() {
  return 'SessionRealtimeEventEntity.transcriptSegment(segment: $segment)';
}


}

/// @nodoc
abstract mixin class $SessionTranscriptSegmentEventEntityCopyWith<$Res> implements $SessionRealtimeEventEntityCopyWith<$Res> {
  factory $SessionTranscriptSegmentEventEntityCopyWith(SessionTranscriptSegmentEventEntity value, $Res Function(SessionTranscriptSegmentEventEntity) _then) = _$SessionTranscriptSegmentEventEntityCopyWithImpl;
@useResult
$Res call({
 TranscriptSegmentEntity segment
});


$TranscriptSegmentEntityCopyWith<$Res> get segment;

}
/// @nodoc
class _$SessionTranscriptSegmentEventEntityCopyWithImpl<$Res>
    implements $SessionTranscriptSegmentEventEntityCopyWith<$Res> {
  _$SessionTranscriptSegmentEventEntityCopyWithImpl(this._self, this._then);

  final SessionTranscriptSegmentEventEntity _self;
  final $Res Function(SessionTranscriptSegmentEventEntity) _then;

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? segment = null,}) {
  return _then(SessionTranscriptSegmentEventEntity(
null == segment ? _self.segment : segment // ignore: cast_nullable_to_non_nullable
as TranscriptSegmentEntity,
  ));
}

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TranscriptSegmentEntityCopyWith<$Res> get segment {
  
  return $TranscriptSegmentEntityCopyWith<$Res>(_self.segment, (value) {
    return _then(_self.copyWith(segment: value));
  });
}
}

/// @nodoc


class SessionCoachingSuggestionEventEntity implements SessionRealtimeEventEntity {
  const SessionCoachingSuggestionEventEntity(this.suggestion);
  

 final  CoachingSuggestionEntity suggestion;

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCoachingSuggestionEventEntityCopyWith<SessionCoachingSuggestionEventEntity> get copyWith => _$SessionCoachingSuggestionEventEntityCopyWithImpl<SessionCoachingSuggestionEventEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionCoachingSuggestionEventEntity&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion));
}


@override
int get hashCode => Object.hash(runtimeType,suggestion);

@override
String toString() {
  return 'SessionRealtimeEventEntity.coachingSuggestion(suggestion: $suggestion)';
}


}

/// @nodoc
abstract mixin class $SessionCoachingSuggestionEventEntityCopyWith<$Res> implements $SessionRealtimeEventEntityCopyWith<$Res> {
  factory $SessionCoachingSuggestionEventEntityCopyWith(SessionCoachingSuggestionEventEntity value, $Res Function(SessionCoachingSuggestionEventEntity) _then) = _$SessionCoachingSuggestionEventEntityCopyWithImpl;
@useResult
$Res call({
 CoachingSuggestionEntity suggestion
});


$CoachingSuggestionEntityCopyWith<$Res> get suggestion;

}
/// @nodoc
class _$SessionCoachingSuggestionEventEntityCopyWithImpl<$Res>
    implements $SessionCoachingSuggestionEventEntityCopyWith<$Res> {
  _$SessionCoachingSuggestionEventEntityCopyWithImpl(this._self, this._then);

  final SessionCoachingSuggestionEventEntity _self;
  final $Res Function(SessionCoachingSuggestionEventEntity) _then;

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? suggestion = null,}) {
  return _then(SessionCoachingSuggestionEventEntity(
null == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as CoachingSuggestionEntity,
  ));
}

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingSuggestionEntityCopyWith<$Res> get suggestion {
  
  return $CoachingSuggestionEntityCopyWith<$Res>(_self.suggestion, (value) {
    return _then(_self.copyWith(suggestion: value));
  });
}
}

/// @nodoc


class SessionCoachStatusEventEntity implements SessionRealtimeEventEntity {
  const SessionCoachStatusEventEntity(this.coachStatus);
  

 final  CoachStatusEntity coachStatus;

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCoachStatusEventEntityCopyWith<SessionCoachStatusEventEntity> get copyWith => _$SessionCoachStatusEventEntityCopyWithImpl<SessionCoachStatusEventEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionCoachStatusEventEntity&&(identical(other.coachStatus, coachStatus) || other.coachStatus == coachStatus));
}


@override
int get hashCode => Object.hash(runtimeType,coachStatus);

@override
String toString() {
  return 'SessionRealtimeEventEntity.coachStatus(coachStatus: $coachStatus)';
}


}

/// @nodoc
abstract mixin class $SessionCoachStatusEventEntityCopyWith<$Res> implements $SessionRealtimeEventEntityCopyWith<$Res> {
  factory $SessionCoachStatusEventEntityCopyWith(SessionCoachStatusEventEntity value, $Res Function(SessionCoachStatusEventEntity) _then) = _$SessionCoachStatusEventEntityCopyWithImpl;
@useResult
$Res call({
 CoachStatusEntity coachStatus
});


$CoachStatusEntityCopyWith<$Res> get coachStatus;

}
/// @nodoc
class _$SessionCoachStatusEventEntityCopyWithImpl<$Res>
    implements $SessionCoachStatusEventEntityCopyWith<$Res> {
  _$SessionCoachStatusEventEntityCopyWithImpl(this._self, this._then);

  final SessionCoachStatusEventEntity _self;
  final $Res Function(SessionCoachStatusEventEntity) _then;

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? coachStatus = null,}) {
  return _then(SessionCoachStatusEventEntity(
null == coachStatus ? _self.coachStatus : coachStatus // ignore: cast_nullable_to_non_nullable
as CoachStatusEntity,
  ));
}

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachStatusEntityCopyWith<$Res> get coachStatus {
  
  return $CoachStatusEntityCopyWith<$Res>(_self.coachStatus, (value) {
    return _then(_self.copyWith(coachStatus: value));
  });
}
}

/// @nodoc


class SessionStateEventEntity implements SessionRealtimeEventEntity {
  const SessionStateEventEntity(this.session);
  

 final  ConversationSessionEntity session;

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionStateEventEntityCopyWith<SessionStateEventEntity> get copyWith => _$SessionStateEventEntityCopyWithImpl<SessionStateEventEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionStateEventEntity&&(identical(other.session, session) || other.session == session));
}


@override
int get hashCode => Object.hash(runtimeType,session);

@override
String toString() {
  return 'SessionRealtimeEventEntity.sessionState(session: $session)';
}


}

/// @nodoc
abstract mixin class $SessionStateEventEntityCopyWith<$Res> implements $SessionRealtimeEventEntityCopyWith<$Res> {
  factory $SessionStateEventEntityCopyWith(SessionStateEventEntity value, $Res Function(SessionStateEventEntity) _then) = _$SessionStateEventEntityCopyWithImpl;
@useResult
$Res call({
 ConversationSessionEntity session
});


$ConversationSessionEntityCopyWith<$Res> get session;

}
/// @nodoc
class _$SessionStateEventEntityCopyWithImpl<$Res>
    implements $SessionStateEventEntityCopyWith<$Res> {
  _$SessionStateEventEntityCopyWithImpl(this._self, this._then);

  final SessionStateEventEntity _self;
  final $Res Function(SessionStateEventEntity) _then;

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,}) {
  return _then(SessionStateEventEntity(
null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as ConversationSessionEntity,
  ));
}

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationSessionEntityCopyWith<$Res> get session {
  
  return $ConversationSessionEntityCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

/// @nodoc


class SessionUnknownEventEntity implements SessionRealtimeEventEntity {
  const SessionUnknownEventEntity({required this.type, required final  Map<String, Object?> payload}): _payload = payload;
  

 final  String type;
 final  Map<String, Object?> _payload;
 Map<String, Object?> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}


/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionUnknownEventEntityCopyWith<SessionUnknownEventEntity> get copyWith => _$SessionUnknownEventEntityCopyWithImpl<SessionUnknownEventEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionUnknownEventEntity&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._payload, _payload));
}


@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_payload));

@override
String toString() {
  return 'SessionRealtimeEventEntity.unknown(type: $type, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $SessionUnknownEventEntityCopyWith<$Res> implements $SessionRealtimeEventEntityCopyWith<$Res> {
  factory $SessionUnknownEventEntityCopyWith(SessionUnknownEventEntity value, $Res Function(SessionUnknownEventEntity) _then) = _$SessionUnknownEventEntityCopyWithImpl;
@useResult
$Res call({
 String type, Map<String, Object?> payload
});




}
/// @nodoc
class _$SessionUnknownEventEntityCopyWithImpl<$Res>
    implements $SessionUnknownEventEntityCopyWith<$Res> {
  _$SessionUnknownEventEntityCopyWithImpl(this._self, this._then);

  final SessionUnknownEventEntity _self;
  final $Res Function(SessionUnknownEventEntity) _then;

/// Create a copy of SessionRealtimeEventEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,Object? payload = null,}) {
  return _then(SessionUnknownEventEntity(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
