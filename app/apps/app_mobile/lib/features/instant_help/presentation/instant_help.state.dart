import 'package:core_domain/core_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'instant_help.state.freezed.dart';

/// Visible phases of one macOS Instant Help capture.
enum InstantHelpStage {
  /// Configuration is editable and no audio is captured.
  preparing,

  /// The backend, media sockets and native capture are connecting.
  starting,

  /// Both audio tracks are captured and uploaded.
  live,

  /// Native audio is stopped and the backend is starting reconciliation.
  stopping,

  /// Capture could not start or was interrupted.
  failed,
}

/// Immutable presentation state for external macOS conversations.
@freezed
abstract class InstantHelpState with _$InstantHelpState {
  /// Creates the complete Instant Help state.
  const factory InstantHelpState({
    @Default(InstantHelpStage.preparing) InstantHelpStage stage,
    ExternalConversationSessionEntity? externalSession,
    @Default(Duration.zero) Duration elapsed,
    @Default(<TranscriptSegmentEntity>[])
    List<TranscriptSegmentEntity> transcript,
    CoachingSuggestionEntity? suggestion,
    @Default(CoachAnalysisStatus.listening)
    CoachAnalysisStatus coachAnalysisStatus,
    CoachAnalysisOutcome? coachAnalysisOutcome,
    @Default(false) bool microphoneDetected,
    @Default(false) bool systemAudioDetected,
    String? errorMessage,
  }) = _InstantHelpState;
}

/// Convenient state-derived properties used by the view.
extension InstantHelpStateX on InstantHelpState {
  /// Whether native audio is actively captured and uploaded.
  bool get isLive => stage == InstantHelpStage.live;

  /// Whether the coach currently receives eligible transcript turns.
  bool get isCoachEnabled =>
      externalSession?.session.coachMode == CoachMode.live;
}
