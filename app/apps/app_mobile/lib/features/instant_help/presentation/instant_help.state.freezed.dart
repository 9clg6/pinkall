// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instant_help.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InstantHelpState {

 InstantHelpStage get stage; ExternalConversationSessionEntity? get externalSession; Duration get elapsed; List<TranscriptSegmentEntity> get transcript; CoachingSuggestionEntity? get suggestion; CoachAnalysisStatus get coachAnalysisStatus; CoachAnalysisOutcome? get coachAnalysisOutcome; bool get microphoneDetected; bool get systemAudioDetected; String? get errorMessage;
/// Create a copy of InstantHelpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstantHelpStateCopyWith<InstantHelpState> get copyWith => _$InstantHelpStateCopyWithImpl<InstantHelpState>(this as InstantHelpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstantHelpState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.externalSession, externalSession) || other.externalSession == externalSession)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&const DeepCollectionEquality().equals(other.transcript, transcript)&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion)&&(identical(other.coachAnalysisStatus, coachAnalysisStatus) || other.coachAnalysisStatus == coachAnalysisStatus)&&(identical(other.coachAnalysisOutcome, coachAnalysisOutcome) || other.coachAnalysisOutcome == coachAnalysisOutcome)&&(identical(other.microphoneDetected, microphoneDetected) || other.microphoneDetected == microphoneDetected)&&(identical(other.systemAudioDetected, systemAudioDetected) || other.systemAudioDetected == systemAudioDetected)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,stage,externalSession,elapsed,const DeepCollectionEquality().hash(transcript),suggestion,coachAnalysisStatus,coachAnalysisOutcome,microphoneDetected,systemAudioDetected,errorMessage);

@override
String toString() {
  return 'InstantHelpState(stage: $stage, externalSession: $externalSession, elapsed: $elapsed, transcript: $transcript, suggestion: $suggestion, coachAnalysisStatus: $coachAnalysisStatus, coachAnalysisOutcome: $coachAnalysisOutcome, microphoneDetected: $microphoneDetected, systemAudioDetected: $systemAudioDetected, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $InstantHelpStateCopyWith<$Res>  {
  factory $InstantHelpStateCopyWith(InstantHelpState value, $Res Function(InstantHelpState) _then) = _$InstantHelpStateCopyWithImpl;
@useResult
$Res call({
 InstantHelpStage stage, ExternalConversationSessionEntity? externalSession, Duration elapsed, List<TranscriptSegmentEntity> transcript, CoachingSuggestionEntity? suggestion, CoachAnalysisStatus coachAnalysisStatus, CoachAnalysisOutcome? coachAnalysisOutcome, bool microphoneDetected, bool systemAudioDetected, String? errorMessage
});


$ExternalConversationSessionEntityCopyWith<$Res>? get externalSession;$CoachingSuggestionEntityCopyWith<$Res>? get suggestion;

}
/// @nodoc
class _$InstantHelpStateCopyWithImpl<$Res>
    implements $InstantHelpStateCopyWith<$Res> {
  _$InstantHelpStateCopyWithImpl(this._self, this._then);

  final InstantHelpState _self;
  final $Res Function(InstantHelpState) _then;

/// Create a copy of InstantHelpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? externalSession = freezed,Object? elapsed = null,Object? transcript = null,Object? suggestion = freezed,Object? coachAnalysisStatus = null,Object? coachAnalysisOutcome = freezed,Object? microphoneDetected = null,Object? systemAudioDetected = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as InstantHelpStage,externalSession: freezed == externalSession ? _self.externalSession : externalSession // ignore: cast_nullable_to_non_nullable
as ExternalConversationSessionEntity?,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegmentEntity>,suggestion: freezed == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as CoachingSuggestionEntity?,coachAnalysisStatus: null == coachAnalysisStatus ? _self.coachAnalysisStatus : coachAnalysisStatus // ignore: cast_nullable_to_non_nullable
as CoachAnalysisStatus,coachAnalysisOutcome: freezed == coachAnalysisOutcome ? _self.coachAnalysisOutcome : coachAnalysisOutcome // ignore: cast_nullable_to_non_nullable
as CoachAnalysisOutcome?,microphoneDetected: null == microphoneDetected ? _self.microphoneDetected : microphoneDetected // ignore: cast_nullable_to_non_nullable
as bool,systemAudioDetected: null == systemAudioDetected ? _self.systemAudioDetected : systemAudioDetected // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of InstantHelpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExternalConversationSessionEntityCopyWith<$Res>? get externalSession {
    if (_self.externalSession == null) {
    return null;
  }

  return $ExternalConversationSessionEntityCopyWith<$Res>(_self.externalSession!, (value) {
    return _then(_self.copyWith(externalSession: value));
  });
}/// Create a copy of InstantHelpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingSuggestionEntityCopyWith<$Res>? get suggestion {
    if (_self.suggestion == null) {
    return null;
  }

  return $CoachingSuggestionEntityCopyWith<$Res>(_self.suggestion!, (value) {
    return _then(_self.copyWith(suggestion: value));
  });
}
}


/// Adds pattern-matching-related methods to [InstantHelpState].
extension InstantHelpStatePatterns on InstantHelpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstantHelpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstantHelpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstantHelpState value)  $default,){
final _that = this;
switch (_that) {
case _InstantHelpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstantHelpState value)?  $default,){
final _that = this;
switch (_that) {
case _InstantHelpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InstantHelpStage stage,  ExternalConversationSessionEntity? externalSession,  Duration elapsed,  List<TranscriptSegmentEntity> transcript,  CoachingSuggestionEntity? suggestion,  CoachAnalysisStatus coachAnalysisStatus,  CoachAnalysisOutcome? coachAnalysisOutcome,  bool microphoneDetected,  bool systemAudioDetected,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstantHelpState() when $default != null:
return $default(_that.stage,_that.externalSession,_that.elapsed,_that.transcript,_that.suggestion,_that.coachAnalysisStatus,_that.coachAnalysisOutcome,_that.microphoneDetected,_that.systemAudioDetected,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InstantHelpStage stage,  ExternalConversationSessionEntity? externalSession,  Duration elapsed,  List<TranscriptSegmentEntity> transcript,  CoachingSuggestionEntity? suggestion,  CoachAnalysisStatus coachAnalysisStatus,  CoachAnalysisOutcome? coachAnalysisOutcome,  bool microphoneDetected,  bool systemAudioDetected,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _InstantHelpState():
return $default(_that.stage,_that.externalSession,_that.elapsed,_that.transcript,_that.suggestion,_that.coachAnalysisStatus,_that.coachAnalysisOutcome,_that.microphoneDetected,_that.systemAudioDetected,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InstantHelpStage stage,  ExternalConversationSessionEntity? externalSession,  Duration elapsed,  List<TranscriptSegmentEntity> transcript,  CoachingSuggestionEntity? suggestion,  CoachAnalysisStatus coachAnalysisStatus,  CoachAnalysisOutcome? coachAnalysisOutcome,  bool microphoneDetected,  bool systemAudioDetected,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _InstantHelpState() when $default != null:
return $default(_that.stage,_that.externalSession,_that.elapsed,_that.transcript,_that.suggestion,_that.coachAnalysisStatus,_that.coachAnalysisOutcome,_that.microphoneDetected,_that.systemAudioDetected,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _InstantHelpState implements InstantHelpState {
  const _InstantHelpState({this.stage = InstantHelpStage.preparing, this.externalSession, this.elapsed = Duration.zero, final  List<TranscriptSegmentEntity> transcript = const <TranscriptSegmentEntity>[], this.suggestion, this.coachAnalysisStatus = CoachAnalysisStatus.listening, this.coachAnalysisOutcome, this.microphoneDetected = false, this.systemAudioDetected = false, this.errorMessage}): _transcript = transcript;
  

@override@JsonKey() final  InstantHelpStage stage;
@override final  ExternalConversationSessionEntity? externalSession;
@override@JsonKey() final  Duration elapsed;
 final  List<TranscriptSegmentEntity> _transcript;
@override@JsonKey() List<TranscriptSegmentEntity> get transcript {
  if (_transcript is EqualUnmodifiableListView) return _transcript;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transcript);
}

@override final  CoachingSuggestionEntity? suggestion;
@override@JsonKey() final  CoachAnalysisStatus coachAnalysisStatus;
@override final  CoachAnalysisOutcome? coachAnalysisOutcome;
@override@JsonKey() final  bool microphoneDetected;
@override@JsonKey() final  bool systemAudioDetected;
@override final  String? errorMessage;

/// Create a copy of InstantHelpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstantHelpStateCopyWith<_InstantHelpState> get copyWith => __$InstantHelpStateCopyWithImpl<_InstantHelpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstantHelpState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.externalSession, externalSession) || other.externalSession == externalSession)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&const DeepCollectionEquality().equals(other._transcript, _transcript)&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion)&&(identical(other.coachAnalysisStatus, coachAnalysisStatus) || other.coachAnalysisStatus == coachAnalysisStatus)&&(identical(other.coachAnalysisOutcome, coachAnalysisOutcome) || other.coachAnalysisOutcome == coachAnalysisOutcome)&&(identical(other.microphoneDetected, microphoneDetected) || other.microphoneDetected == microphoneDetected)&&(identical(other.systemAudioDetected, systemAudioDetected) || other.systemAudioDetected == systemAudioDetected)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,stage,externalSession,elapsed,const DeepCollectionEquality().hash(_transcript),suggestion,coachAnalysisStatus,coachAnalysisOutcome,microphoneDetected,systemAudioDetected,errorMessage);

@override
String toString() {
  return 'InstantHelpState(stage: $stage, externalSession: $externalSession, elapsed: $elapsed, transcript: $transcript, suggestion: $suggestion, coachAnalysisStatus: $coachAnalysisStatus, coachAnalysisOutcome: $coachAnalysisOutcome, microphoneDetected: $microphoneDetected, systemAudioDetected: $systemAudioDetected, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$InstantHelpStateCopyWith<$Res> implements $InstantHelpStateCopyWith<$Res> {
  factory _$InstantHelpStateCopyWith(_InstantHelpState value, $Res Function(_InstantHelpState) _then) = __$InstantHelpStateCopyWithImpl;
@override @useResult
$Res call({
 InstantHelpStage stage, ExternalConversationSessionEntity? externalSession, Duration elapsed, List<TranscriptSegmentEntity> transcript, CoachingSuggestionEntity? suggestion, CoachAnalysisStatus coachAnalysisStatus, CoachAnalysisOutcome? coachAnalysisOutcome, bool microphoneDetected, bool systemAudioDetected, String? errorMessage
});


@override $ExternalConversationSessionEntityCopyWith<$Res>? get externalSession;@override $CoachingSuggestionEntityCopyWith<$Res>? get suggestion;

}
/// @nodoc
class __$InstantHelpStateCopyWithImpl<$Res>
    implements _$InstantHelpStateCopyWith<$Res> {
  __$InstantHelpStateCopyWithImpl(this._self, this._then);

  final _InstantHelpState _self;
  final $Res Function(_InstantHelpState) _then;

/// Create a copy of InstantHelpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? externalSession = freezed,Object? elapsed = null,Object? transcript = null,Object? suggestion = freezed,Object? coachAnalysisStatus = null,Object? coachAnalysisOutcome = freezed,Object? microphoneDetected = null,Object? systemAudioDetected = null,Object? errorMessage = freezed,}) {
  return _then(_InstantHelpState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as InstantHelpStage,externalSession: freezed == externalSession ? _self.externalSession : externalSession // ignore: cast_nullable_to_non_nullable
as ExternalConversationSessionEntity?,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,transcript: null == transcript ? _self._transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegmentEntity>,suggestion: freezed == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as CoachingSuggestionEntity?,coachAnalysisStatus: null == coachAnalysisStatus ? _self.coachAnalysisStatus : coachAnalysisStatus // ignore: cast_nullable_to_non_nullable
as CoachAnalysisStatus,coachAnalysisOutcome: freezed == coachAnalysisOutcome ? _self.coachAnalysisOutcome : coachAnalysisOutcome // ignore: cast_nullable_to_non_nullable
as CoachAnalysisOutcome?,microphoneDetected: null == microphoneDetected ? _self.microphoneDetected : microphoneDetected // ignore: cast_nullable_to_non_nullable
as bool,systemAudioDetected: null == systemAudioDetected ? _self.systemAudioDetected : systemAudioDetected // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of InstantHelpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExternalConversationSessionEntityCopyWith<$Res>? get externalSession {
    if (_self.externalSession == null) {
    return null;
  }

  return $ExternalConversationSessionEntityCopyWith<$Res>(_self.externalSession!, (value) {
    return _then(_self.copyWith(externalSession: value));
  });
}/// Create a copy of InstantHelpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingSuggestionEntityCopyWith<$Res>? get suggestion {
    if (_self.suggestion == null) {
    return null;
  }

  return $CoachingSuggestionEntityCopyWith<$Res>(_self.suggestion!, (value) {
    return _then(_self.copyWith(suggestion: value));
  });
}
}

// dart format on
