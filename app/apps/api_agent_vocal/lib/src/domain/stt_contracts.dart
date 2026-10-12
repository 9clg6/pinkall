import 'package:api_agent_vocal/src/domain/models.dart';

/// PCM input format accepted by a speech-to-text provider session.
final class SttAudioFormat {
  const SttAudioFormat({required this.encoding, required this.sampleRate});

  final String encoding;
  final int sampleRate;
}

/// Provider-neutral live transcription event.
sealed class SttEvent {
  const SttEvent();
}

/// Incremental text that may still change and must not be treated as final.
final class SttTextDelta extends SttEvent {
  const SttTextDelta(this.text);

  final String text;
}

/// A provider-detected likely turn end that may still be resumed.
///
/// Applications may start speculative work from this full transcript
/// snapshot, but must not expose its result until the matching stable segment
/// is received.
final class SttEagerTurnEnd extends SttEvent {
  const SttEagerTurnEnd({
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
    this.providerTurnId,
  });

  final String text;
  final double startSeconds;
  final double endSeconds;
  final String? providerTurnId;
}

/// Invalidates speculative work because speech resumed for the same turn.
final class SttTurnResumed extends SttEvent {
  const SttTurnResumed({this.providerTurnId});

  final String? providerTurnId;
}

/// A stable provider segment with real audio timing.
final class SttSegment extends SttEvent {
  const SttSegment({
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
    this.isTurnEnd = false,
    this.providerTurnId,
  });

  final String text;
  final double startSeconds;
  final double endSeconds;

  /// Whether the provider has semantically confirmed the end of this turn.
  ///
  /// Segment-only providers leave this false and the application applies its
  /// provider-neutral silence fallback. Turn-aware providers can set it to
  /// commit the turn immediately without leaking a provider event type here.
  final bool isTurnEnd;
  final String? providerTurnId;
}

/// Provider completion event containing its final track-level text.
final class SttDone extends SttEvent {
  const SttDone(this.text);

  final String text;
}

/// Explicit provider failure; it never carries fabricated transcript text.
final class SttFailure extends SttEvent {
  const SttFailure(this.message);

  final String message;
}

/// Provider-neutral, text-free telemetry for a semantic turn-state event.
///
/// This deliberately excludes transcript text and provider request IDs so it
/// can be forwarded to application diagnostics without leaking call content
/// or credentials.
final class SttTurnTelemetry extends SttEvent {
  const SttTurnTelemetry({
    required this.event,
    this.turnIndex,
    this.sequenceId,
    this.audioWindowStart,
    this.audioWindowEnd,
    this.endOfTurnConfidence,
  });

  final String event;
  final int? turnIndex;
  final int? sequenceId;
  final double? audioWindowStart;
  final double? audioWindowEnd;
  final double? endOfTurnConfidence;
}

/// One live provider connection for exactly one Telnyx track.
abstract interface class RealtimeSttSession {
  Stream<SttEvent> get events;

  Future<void> addAudio(List<int> pcmBytes);

  Future<void> close();
}

/// A batch transcript from actual recorded PCM audio.
final class BatchTranscript {
  const BatchTranscript({
    required this.text,
    required this.language,
    required this.segments,
    required this.provider,
  });

  final String text;
  final String? language;
  final List<BatchTranscriptSegment> segments;
  final String provider;
}

/// One timestamped segment returned by batch transcription.
final class BatchTranscriptSegment {
  const BatchTranscriptSegment({
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
  });

  final String text;
  final double startSeconds;
  final double endSeconds;
}

/// Replaceable STT provider boundary used by the application layer.
abstract interface class SttProvider {
  String get name;

  bool get isConfigured;

  /// Whether realtime sessions emit authoritative semantic turn boundaries.
  ///
  /// The application keeps interim text provisional until such a provider
  /// emits [SttSegment.isTurnEnd]. Providers without this capability continue
  /// to use the short silence fallback.
  bool get providesSemanticTurnBoundaries;

  Future<RealtimeSttSession> openRealtimeSession({
    required MediaTrack track,
    required SttAudioFormat audioFormat,
  });

  Future<BatchTranscript> transcribeFinal({
    required List<int> pcmBytes,
    required SttAudioFormat audioFormat,
    required String fileName,
  });
}

/// Used only when configuration is absent; every call fails explicitly.
final class UnavailableSttProvider implements SttProvider {
  const UnavailableSttProvider(this.reason);

  final String reason;

  @override
  bool get isConfigured => false;

  @override
  bool get providesSemanticTurnBoundaries => false;

  @override
  String get name => 'unavailable';

  @override
  Future<RealtimeSttSession> openRealtimeSession({
    required MediaTrack track,
    required SttAudioFormat audioFormat,
  }) {
    throw StateError(reason);
  }

  @override
  Future<BatchTranscript> transcribeFinal({
    required List<int> pcmBytes,
    required SttAudioFormat audioFormat,
    required String fileName,
  }) {
    throw StateError(reason);
  }
}
