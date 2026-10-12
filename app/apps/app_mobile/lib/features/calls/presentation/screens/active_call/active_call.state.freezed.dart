// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_call.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActiveCallState {

 CallStateEntity get session; ConversationSessionEntity get processingSession; bool get isCompanion; Duration get elapsed; List<TranscriptSegmentEntity> get transcript; CoachingSuggestionEntity? get suggestion; CoachAnalysisStatus get coachAnalysisStatus; CoachAnalysisOutcome? get coachAnalysisOutcome; ConversationTranscriptEntity? get finalTranscript; CallDebriefEntity? get debrief; bool get supportsAudioDeviceSelection; List<AudioDeviceEntity> get audioDevices; String? get selectedAudioInputId; String? get selectedAudioOutputId; bool get isLoadingAudioDevices; bool get isOperating; String? get operationFailure; String? get realtimeFailure; String? get finalizationMessage;
/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveCallStateCopyWith<ActiveCallState> get copyWith => _$ActiveCallStateCopyWithImpl<ActiveCallState>(this as ActiveCallState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveCallState&&(identical(other.session, session) || other.session == session)&&(identical(other.processingSession, processingSession) || other.processingSession == processingSession)&&(identical(other.isCompanion, isCompanion) || other.isCompanion == isCompanion)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&const DeepCollectionEquality().equals(other.transcript, transcript)&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion)&&(identical(other.coachAnalysisStatus, coachAnalysisStatus) || other.coachAnalysisStatus == coachAnalysisStatus)&&(identical(other.coachAnalysisOutcome, coachAnalysisOutcome) || other.coachAnalysisOutcome == coachAnalysisOutcome)&&(identical(other.finalTranscript, finalTranscript) || other.finalTranscript == finalTranscript)&&(identical(other.debrief, debrief) || other.debrief == debrief)&&(identical(other.supportsAudioDeviceSelection, supportsAudioDeviceSelection) || other.supportsAudioDeviceSelection == supportsAudioDeviceSelection)&&const DeepCollectionEquality().equals(other.audioDevices, audioDevices)&&(identical(other.selectedAudioInputId, selectedAudioInputId) || other.selectedAudioInputId == selectedAudioInputId)&&(identical(other.selectedAudioOutputId, selectedAudioOutputId) || other.selectedAudioOutputId == selectedAudioOutputId)&&(identical(other.isLoadingAudioDevices, isLoadingAudioDevices) || other.isLoadingAudioDevices == isLoadingAudioDevices)&&(identical(other.isOperating, isOperating) || other.isOperating == isOperating)&&(identical(other.operationFailure, operationFailure) || other.operationFailure == operationFailure)&&(identical(other.realtimeFailure, realtimeFailure) || other.realtimeFailure == realtimeFailure)&&(identical(other.finalizationMessage, finalizationMessage) || other.finalizationMessage == finalizationMessage));
}


@override
int get hashCode => Object.hashAll([runtimeType,session,processingSession,isCompanion,elapsed,const DeepCollectionEquality().hash(transcript),suggestion,coachAnalysisStatus,coachAnalysisOutcome,finalTranscript,debrief,supportsAudioDeviceSelection,const DeepCollectionEquality().hash(audioDevices),selectedAudioInputId,selectedAudioOutputId,isLoadingAudioDevices,isOperating,operationFailure,realtimeFailure,finalizationMessage]);

@override
String toString() {
  return 'ActiveCallState(session: $session, processingSession: $processingSession, isCompanion: $isCompanion, elapsed: $elapsed, transcript: $transcript, suggestion: $suggestion, coachAnalysisStatus: $coachAnalysisStatus, coachAnalysisOutcome: $coachAnalysisOutcome, finalTranscript: $finalTranscript, debrief: $debrief, supportsAudioDeviceSelection: $supportsAudioDeviceSelection, audioDevices: $audioDevices, selectedAudioInputId: $selectedAudioInputId, selectedAudioOutputId: $selectedAudioOutputId, isLoadingAudioDevices: $isLoadingAudioDevices, isOperating: $isOperating, operationFailure: $operationFailure, realtimeFailure: $realtimeFailure, finalizationMessage: $finalizationMessage)';
}


}

/// @nodoc
abstract mixin class $ActiveCallStateCopyWith<$Res>  {
  factory $ActiveCallStateCopyWith(ActiveCallState value, $Res Function(ActiveCallState) _then) = _$ActiveCallStateCopyWithImpl;
@useResult
$Res call({
 CallStateEntity session, ConversationSessionEntity processingSession, bool isCompanion, Duration elapsed, List<TranscriptSegmentEntity> transcript, CoachingSuggestionEntity? suggestion, CoachAnalysisStatus coachAnalysisStatus, CoachAnalysisOutcome? coachAnalysisOutcome, ConversationTranscriptEntity? finalTranscript, CallDebriefEntity? debrief, bool supportsAudioDeviceSelection, List<AudioDeviceEntity> audioDevices, String? selectedAudioInputId, String? selectedAudioOutputId, bool isLoadingAudioDevices, bool isOperating, String? operationFailure, String? realtimeFailure, String? finalizationMessage
});


$CallStateEntityCopyWith<$Res> get session;$ConversationSessionEntityCopyWith<$Res> get processingSession;$CoachingSuggestionEntityCopyWith<$Res>? get suggestion;$ConversationTranscriptEntityCopyWith<$Res>? get finalTranscript;$CallDebriefEntityCopyWith<$Res>? get debrief;

}
/// @nodoc
class _$ActiveCallStateCopyWithImpl<$Res>
    implements $ActiveCallStateCopyWith<$Res> {
  _$ActiveCallStateCopyWithImpl(this._self, this._then);

  final ActiveCallState _self;
  final $Res Function(ActiveCallState) _then;

/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? processingSession = null,Object? isCompanion = null,Object? elapsed = null,Object? transcript = null,Object? suggestion = freezed,Object? coachAnalysisStatus = null,Object? coachAnalysisOutcome = freezed,Object? finalTranscript = freezed,Object? debrief = freezed,Object? supportsAudioDeviceSelection = null,Object? audioDevices = null,Object? selectedAudioInputId = freezed,Object? selectedAudioOutputId = freezed,Object? isLoadingAudioDevices = null,Object? isOperating = null,Object? operationFailure = freezed,Object? realtimeFailure = freezed,Object? finalizationMessage = freezed,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as CallStateEntity,processingSession: null == processingSession ? _self.processingSession : processingSession // ignore: cast_nullable_to_non_nullable
as ConversationSessionEntity,isCompanion: null == isCompanion ? _self.isCompanion : isCompanion // ignore: cast_nullable_to_non_nullable
as bool,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegmentEntity>,suggestion: freezed == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as CoachingSuggestionEntity?,coachAnalysisStatus: null == coachAnalysisStatus ? _self.coachAnalysisStatus : coachAnalysisStatus // ignore: cast_nullable_to_non_nullable
as CoachAnalysisStatus,coachAnalysisOutcome: freezed == coachAnalysisOutcome ? _self.coachAnalysisOutcome : coachAnalysisOutcome // ignore: cast_nullable_to_non_nullable
as CoachAnalysisOutcome?,finalTranscript: freezed == finalTranscript ? _self.finalTranscript : finalTranscript // ignore: cast_nullable_to_non_nullable
as ConversationTranscriptEntity?,debrief: freezed == debrief ? _self.debrief : debrief // ignore: cast_nullable_to_non_nullable
as CallDebriefEntity?,supportsAudioDeviceSelection: null == supportsAudioDeviceSelection ? _self.supportsAudioDeviceSelection : supportsAudioDeviceSelection // ignore: cast_nullable_to_non_nullable
as bool,audioDevices: null == audioDevices ? _self.audioDevices : audioDevices // ignore: cast_nullable_to_non_nullable
as List<AudioDeviceEntity>,selectedAudioInputId: freezed == selectedAudioInputId ? _self.selectedAudioInputId : selectedAudioInputId // ignore: cast_nullable_to_non_nullable
as String?,selectedAudioOutputId: freezed == selectedAudioOutputId ? _self.selectedAudioOutputId : selectedAudioOutputId // ignore: cast_nullable_to_non_nullable
as String?,isLoadingAudioDevices: null == isLoadingAudioDevices ? _self.isLoadingAudioDevices : isLoadingAudioDevices // ignore: cast_nullable_to_non_nullable
as bool,isOperating: null == isOperating ? _self.isOperating : isOperating // ignore: cast_nullable_to_non_nullable
as bool,operationFailure: freezed == operationFailure ? _self.operationFailure : operationFailure // ignore: cast_nullable_to_non_nullable
as String?,realtimeFailure: freezed == realtimeFailure ? _self.realtimeFailure : realtimeFailure // ignore: cast_nullable_to_non_nullable
as String?,finalizationMessage: freezed == finalizationMessage ? _self.finalizationMessage : finalizationMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallStateEntityCopyWith<$Res> get session {
  
  return $CallStateEntityCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationSessionEntityCopyWith<$Res> get processingSession {
  
  return $ConversationSessionEntityCopyWith<$Res>(_self.processingSession, (value) {
    return _then(_self.copyWith(processingSession: value));
  });
}/// Create a copy of ActiveCallState
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
}/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationTranscriptEntityCopyWith<$Res>? get finalTranscript {
    if (_self.finalTranscript == null) {
    return null;
  }

  return $ConversationTranscriptEntityCopyWith<$Res>(_self.finalTranscript!, (value) {
    return _then(_self.copyWith(finalTranscript: value));
  });
}/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallDebriefEntityCopyWith<$Res>? get debrief {
    if (_self.debrief == null) {
    return null;
  }

  return $CallDebriefEntityCopyWith<$Res>(_self.debrief!, (value) {
    return _then(_self.copyWith(debrief: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActiveCallState].
extension ActiveCallStatePatterns on ActiveCallState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveCallState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveCallState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveCallState value)  $default,){
final _that = this;
switch (_that) {
case _ActiveCallState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveCallState value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveCallState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CallStateEntity session,  ConversationSessionEntity processingSession,  bool isCompanion,  Duration elapsed,  List<TranscriptSegmentEntity> transcript,  CoachingSuggestionEntity? suggestion,  CoachAnalysisStatus coachAnalysisStatus,  CoachAnalysisOutcome? coachAnalysisOutcome,  ConversationTranscriptEntity? finalTranscript,  CallDebriefEntity? debrief,  bool supportsAudioDeviceSelection,  List<AudioDeviceEntity> audioDevices,  String? selectedAudioInputId,  String? selectedAudioOutputId,  bool isLoadingAudioDevices,  bool isOperating,  String? operationFailure,  String? realtimeFailure,  String? finalizationMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveCallState() when $default != null:
return $default(_that.session,_that.processingSession,_that.isCompanion,_that.elapsed,_that.transcript,_that.suggestion,_that.coachAnalysisStatus,_that.coachAnalysisOutcome,_that.finalTranscript,_that.debrief,_that.supportsAudioDeviceSelection,_that.audioDevices,_that.selectedAudioInputId,_that.selectedAudioOutputId,_that.isLoadingAudioDevices,_that.isOperating,_that.operationFailure,_that.realtimeFailure,_that.finalizationMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CallStateEntity session,  ConversationSessionEntity processingSession,  bool isCompanion,  Duration elapsed,  List<TranscriptSegmentEntity> transcript,  CoachingSuggestionEntity? suggestion,  CoachAnalysisStatus coachAnalysisStatus,  CoachAnalysisOutcome? coachAnalysisOutcome,  ConversationTranscriptEntity? finalTranscript,  CallDebriefEntity? debrief,  bool supportsAudioDeviceSelection,  List<AudioDeviceEntity> audioDevices,  String? selectedAudioInputId,  String? selectedAudioOutputId,  bool isLoadingAudioDevices,  bool isOperating,  String? operationFailure,  String? realtimeFailure,  String? finalizationMessage)  $default,) {final _that = this;
switch (_that) {
case _ActiveCallState():
return $default(_that.session,_that.processingSession,_that.isCompanion,_that.elapsed,_that.transcript,_that.suggestion,_that.coachAnalysisStatus,_that.coachAnalysisOutcome,_that.finalTranscript,_that.debrief,_that.supportsAudioDeviceSelection,_that.audioDevices,_that.selectedAudioInputId,_that.selectedAudioOutputId,_that.isLoadingAudioDevices,_that.isOperating,_that.operationFailure,_that.realtimeFailure,_that.finalizationMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CallStateEntity session,  ConversationSessionEntity processingSession,  bool isCompanion,  Duration elapsed,  List<TranscriptSegmentEntity> transcript,  CoachingSuggestionEntity? suggestion,  CoachAnalysisStatus coachAnalysisStatus,  CoachAnalysisOutcome? coachAnalysisOutcome,  ConversationTranscriptEntity? finalTranscript,  CallDebriefEntity? debrief,  bool supportsAudioDeviceSelection,  List<AudioDeviceEntity> audioDevices,  String? selectedAudioInputId,  String? selectedAudioOutputId,  bool isLoadingAudioDevices,  bool isOperating,  String? operationFailure,  String? realtimeFailure,  String? finalizationMessage)?  $default,) {final _that = this;
switch (_that) {
case _ActiveCallState() when $default != null:
return $default(_that.session,_that.processingSession,_that.isCompanion,_that.elapsed,_that.transcript,_that.suggestion,_that.coachAnalysisStatus,_that.coachAnalysisOutcome,_that.finalTranscript,_that.debrief,_that.supportsAudioDeviceSelection,_that.audioDevices,_that.selectedAudioInputId,_that.selectedAudioOutputId,_that.isLoadingAudioDevices,_that.isOperating,_that.operationFailure,_that.realtimeFailure,_that.finalizationMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ActiveCallState implements ActiveCallState {
  const _ActiveCallState({required this.session, required this.processingSession, required this.isCompanion, required this.elapsed, required final  List<TranscriptSegmentEntity> transcript, required this.suggestion, this.coachAnalysisStatus = CoachAnalysisStatus.listening, this.coachAnalysisOutcome, required this.finalTranscript, required this.debrief, this.supportsAudioDeviceSelection = false, final  List<AudioDeviceEntity> audioDevices = const <AudioDeviceEntity>[], this.selectedAudioInputId, this.selectedAudioOutputId, this.isLoadingAudioDevices = false, required this.isOperating, required this.operationFailure, required this.realtimeFailure, required this.finalizationMessage}): _transcript = transcript,_audioDevices = audioDevices;
  

@override final  CallStateEntity session;
@override final  ConversationSessionEntity processingSession;
@override final  bool isCompanion;
@override final  Duration elapsed;
 final  List<TranscriptSegmentEntity> _transcript;
@override List<TranscriptSegmentEntity> get transcript {
  if (_transcript is EqualUnmodifiableListView) return _transcript;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transcript);
}

@override final  CoachingSuggestionEntity? suggestion;
@override@JsonKey() final  CoachAnalysisStatus coachAnalysisStatus;
@override final  CoachAnalysisOutcome? coachAnalysisOutcome;
@override final  ConversationTranscriptEntity? finalTranscript;
@override final  CallDebriefEntity? debrief;
@override@JsonKey() final  bool supportsAudioDeviceSelection;
 final  List<AudioDeviceEntity> _audioDevices;
@override@JsonKey() List<AudioDeviceEntity> get audioDevices {
  if (_audioDevices is EqualUnmodifiableListView) return _audioDevices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_audioDevices);
}

@override final  String? selectedAudioInputId;
@override final  String? selectedAudioOutputId;
@override@JsonKey() final  bool isLoadingAudioDevices;
@override final  bool isOperating;
@override final  String? operationFailure;
@override final  String? realtimeFailure;
@override final  String? finalizationMessage;

/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveCallStateCopyWith<_ActiveCallState> get copyWith => __$ActiveCallStateCopyWithImpl<_ActiveCallState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveCallState&&(identical(other.session, session) || other.session == session)&&(identical(other.processingSession, processingSession) || other.processingSession == processingSession)&&(identical(other.isCompanion, isCompanion) || other.isCompanion == isCompanion)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&const DeepCollectionEquality().equals(other._transcript, _transcript)&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion)&&(identical(other.coachAnalysisStatus, coachAnalysisStatus) || other.coachAnalysisStatus == coachAnalysisStatus)&&(identical(other.coachAnalysisOutcome, coachAnalysisOutcome) || other.coachAnalysisOutcome == coachAnalysisOutcome)&&(identical(other.finalTranscript, finalTranscript) || other.finalTranscript == finalTranscript)&&(identical(other.debrief, debrief) || other.debrief == debrief)&&(identical(other.supportsAudioDeviceSelection, supportsAudioDeviceSelection) || other.supportsAudioDeviceSelection == supportsAudioDeviceSelection)&&const DeepCollectionEquality().equals(other._audioDevices, _audioDevices)&&(identical(other.selectedAudioInputId, selectedAudioInputId) || other.selectedAudioInputId == selectedAudioInputId)&&(identical(other.selectedAudioOutputId, selectedAudioOutputId) || other.selectedAudioOutputId == selectedAudioOutputId)&&(identical(other.isLoadingAudioDevices, isLoadingAudioDevices) || other.isLoadingAudioDevices == isLoadingAudioDevices)&&(identical(other.isOperating, isOperating) || other.isOperating == isOperating)&&(identical(other.operationFailure, operationFailure) || other.operationFailure == operationFailure)&&(identical(other.realtimeFailure, realtimeFailure) || other.realtimeFailure == realtimeFailure)&&(identical(other.finalizationMessage, finalizationMessage) || other.finalizationMessage == finalizationMessage));
}


@override
int get hashCode => Object.hashAll([runtimeType,session,processingSession,isCompanion,elapsed,const DeepCollectionEquality().hash(_transcript),suggestion,coachAnalysisStatus,coachAnalysisOutcome,finalTranscript,debrief,supportsAudioDeviceSelection,const DeepCollectionEquality().hash(_audioDevices),selectedAudioInputId,selectedAudioOutputId,isLoadingAudioDevices,isOperating,operationFailure,realtimeFailure,finalizationMessage]);

@override
String toString() {
  return 'ActiveCallState(session: $session, processingSession: $processingSession, isCompanion: $isCompanion, elapsed: $elapsed, transcript: $transcript, suggestion: $suggestion, coachAnalysisStatus: $coachAnalysisStatus, coachAnalysisOutcome: $coachAnalysisOutcome, finalTranscript: $finalTranscript, debrief: $debrief, supportsAudioDeviceSelection: $supportsAudioDeviceSelection, audioDevices: $audioDevices, selectedAudioInputId: $selectedAudioInputId, selectedAudioOutputId: $selectedAudioOutputId, isLoadingAudioDevices: $isLoadingAudioDevices, isOperating: $isOperating, operationFailure: $operationFailure, realtimeFailure: $realtimeFailure, finalizationMessage: $finalizationMessage)';
}


}

/// @nodoc
abstract mixin class _$ActiveCallStateCopyWith<$Res> implements $ActiveCallStateCopyWith<$Res> {
  factory _$ActiveCallStateCopyWith(_ActiveCallState value, $Res Function(_ActiveCallState) _then) = __$ActiveCallStateCopyWithImpl;
@override @useResult
$Res call({
 CallStateEntity session, ConversationSessionEntity processingSession, bool isCompanion, Duration elapsed, List<TranscriptSegmentEntity> transcript, CoachingSuggestionEntity? suggestion, CoachAnalysisStatus coachAnalysisStatus, CoachAnalysisOutcome? coachAnalysisOutcome, ConversationTranscriptEntity? finalTranscript, CallDebriefEntity? debrief, bool supportsAudioDeviceSelection, List<AudioDeviceEntity> audioDevices, String? selectedAudioInputId, String? selectedAudioOutputId, bool isLoadingAudioDevices, bool isOperating, String? operationFailure, String? realtimeFailure, String? finalizationMessage
});


@override $CallStateEntityCopyWith<$Res> get session;@override $ConversationSessionEntityCopyWith<$Res> get processingSession;@override $CoachingSuggestionEntityCopyWith<$Res>? get suggestion;@override $ConversationTranscriptEntityCopyWith<$Res>? get finalTranscript;@override $CallDebriefEntityCopyWith<$Res>? get debrief;

}
/// @nodoc
class __$ActiveCallStateCopyWithImpl<$Res>
    implements _$ActiveCallStateCopyWith<$Res> {
  __$ActiveCallStateCopyWithImpl(this._self, this._then);

  final _ActiveCallState _self;
  final $Res Function(_ActiveCallState) _then;

/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? processingSession = null,Object? isCompanion = null,Object? elapsed = null,Object? transcript = null,Object? suggestion = freezed,Object? coachAnalysisStatus = null,Object? coachAnalysisOutcome = freezed,Object? finalTranscript = freezed,Object? debrief = freezed,Object? supportsAudioDeviceSelection = null,Object? audioDevices = null,Object? selectedAudioInputId = freezed,Object? selectedAudioOutputId = freezed,Object? isLoadingAudioDevices = null,Object? isOperating = null,Object? operationFailure = freezed,Object? realtimeFailure = freezed,Object? finalizationMessage = freezed,}) {
  return _then(_ActiveCallState(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as CallStateEntity,processingSession: null == processingSession ? _self.processingSession : processingSession // ignore: cast_nullable_to_non_nullable
as ConversationSessionEntity,isCompanion: null == isCompanion ? _self.isCompanion : isCompanion // ignore: cast_nullable_to_non_nullable
as bool,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,transcript: null == transcript ? _self._transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegmentEntity>,suggestion: freezed == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as CoachingSuggestionEntity?,coachAnalysisStatus: null == coachAnalysisStatus ? _self.coachAnalysisStatus : coachAnalysisStatus // ignore: cast_nullable_to_non_nullable
as CoachAnalysisStatus,coachAnalysisOutcome: freezed == coachAnalysisOutcome ? _self.coachAnalysisOutcome : coachAnalysisOutcome // ignore: cast_nullable_to_non_nullable
as CoachAnalysisOutcome?,finalTranscript: freezed == finalTranscript ? _self.finalTranscript : finalTranscript // ignore: cast_nullable_to_non_nullable
as ConversationTranscriptEntity?,debrief: freezed == debrief ? _self.debrief : debrief // ignore: cast_nullable_to_non_nullable
as CallDebriefEntity?,supportsAudioDeviceSelection: null == supportsAudioDeviceSelection ? _self.supportsAudioDeviceSelection : supportsAudioDeviceSelection // ignore: cast_nullable_to_non_nullable
as bool,audioDevices: null == audioDevices ? _self._audioDevices : audioDevices // ignore: cast_nullable_to_non_nullable
as List<AudioDeviceEntity>,selectedAudioInputId: freezed == selectedAudioInputId ? _self.selectedAudioInputId : selectedAudioInputId // ignore: cast_nullable_to_non_nullable
as String?,selectedAudioOutputId: freezed == selectedAudioOutputId ? _self.selectedAudioOutputId : selectedAudioOutputId // ignore: cast_nullable_to_non_nullable
as String?,isLoadingAudioDevices: null == isLoadingAudioDevices ? _self.isLoadingAudioDevices : isLoadingAudioDevices // ignore: cast_nullable_to_non_nullable
as bool,isOperating: null == isOperating ? _self.isOperating : isOperating // ignore: cast_nullable_to_non_nullable
as bool,operationFailure: freezed == operationFailure ? _self.operationFailure : operationFailure // ignore: cast_nullable_to_non_nullable
as String?,realtimeFailure: freezed == realtimeFailure ? _self.realtimeFailure : realtimeFailure // ignore: cast_nullable_to_non_nullable
as String?,finalizationMessage: freezed == finalizationMessage ? _self.finalizationMessage : finalizationMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallStateEntityCopyWith<$Res> get session {
  
  return $CallStateEntityCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationSessionEntityCopyWith<$Res> get processingSession {
  
  return $ConversationSessionEntityCopyWith<$Res>(_self.processingSession, (value) {
    return _then(_self.copyWith(processingSession: value));
  });
}/// Create a copy of ActiveCallState
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
}/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationTranscriptEntityCopyWith<$Res>? get finalTranscript {
    if (_self.finalTranscript == null) {
    return null;
  }

  return $ConversationTranscriptEntityCopyWith<$Res>(_self.finalTranscript!, (value) {
    return _then(_self.copyWith(finalTranscript: value));
  });
}/// Create a copy of ActiveCallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallDebriefEntityCopyWith<$Res>? get debrief {
    if (_self.debrief == null) {
    return null;
  }

  return $CallDebriefEntityCopyWith<$Res>(_self.debrief!, (value) {
    return _then(_self.copyWith(debrief: value));
  });
}
}

// dart format on
