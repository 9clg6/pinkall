import 'package:core_domain/core_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_call.state.freezed.dart';

/// Immutable presentation state for one real Telnyx call.
@Freezed(copyWith: true)
abstract class ActiveCallState with _$ActiveCallState {
  /// Creates an active call state.
  const factory ActiveCallState({
    required CallStateEntity session,
    required ConversationSessionEntity processingSession,
    required bool isCompanion,
    required Duration elapsed,
    required List<TranscriptSegmentEntity> transcript,
    required CoachingSuggestionEntity? suggestion,
    @Default(CoachAnalysisStatus.listening)
    CoachAnalysisStatus coachAnalysisStatus,
    CoachAnalysisOutcome? coachAnalysisOutcome,
    required ConversationTranscriptEntity? finalTranscript,
    required CallDebriefEntity? debrief,
    @Default(false) bool supportsAudioDeviceSelection,
    @Default(<AudioDeviceEntity>[]) List<AudioDeviceEntity> audioDevices,
    String? selectedAudioInputId,
    String? selectedAudioOutputId,
    @Default(false) bool isLoadingAudioDevices,
    required bool isOperating,
    required String? operationFailure,
    required String? realtimeFailure,
    required String? finalizationMessage,
  }) = _ActiveCallState;

  /// Creates the initial state for [session].
  factory ActiveCallState.initial(
    CallStateEntity session,
    ConversationSessionEntity processingSession, {
    bool isCompanion = false,
    bool supportsAudioDeviceSelection = false,
  }) => ActiveCallState(
    session: session,
    processingSession: processingSession,
    isCompanion: isCompanion,
    elapsed: Duration.zero,
    transcript: const <TranscriptSegmentEntity>[],
    suggestion: null,
    finalTranscript: null,
    debrief: null,
    supportsAudioDeviceSelection: supportsAudioDeviceSelection,
    isOperating: false,
    operationFailure: null,
    realtimeFailure: null,
    finalizationMessage: null,
  );
}
