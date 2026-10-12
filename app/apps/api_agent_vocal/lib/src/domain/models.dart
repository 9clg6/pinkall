import 'dart:convert';

import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';

/// Optional coaching behavior for one call session.
enum CoachMode {
  off,
  shadow,
  live;

  /// Parses a public API value.
  static CoachMode tryParse(String value) {
    return CoachMode.values.firstWhere(
      (CoachMode mode) => mode.name == value.trim().toLowerCase(),
      orElse: () => throw FormatException('Unknown coach mode: $value'),
    );
  }
}

/// Controls whether unreviewed catalogue cards may be exercised internally.
enum CoachReleaseChannel {
  strict('strict'),
  internalAlpha('internal_alpha');

  const CoachReleaseChannel(this.wireName);

  final String wireName;

  static bool isKnown(String value) => CoachReleaseChannel.values.any(
    (CoachReleaseChannel channel) => channel.wireName == value,
  );

  static CoachReleaseChannel parseOrStrict(String value) {
    return CoachReleaseChannel.values.firstWhere(
      (CoachReleaseChannel channel) => channel.wireName == value,
      orElse: () => CoachReleaseChannel.strict,
    );
  }
}

/// A Telnyx media direction, kept distinct from a human speaker role.
enum MediaTrack {
  inbound,
  outbound;

  /// Parses Telnyx's `inbound` or `outbound` media value.
  static MediaTrack parse(String value) {
    return switch (value.trim().toLowerCase()) {
      'inbound' || 'inbound_track' => MediaTrack.inbound,
      'outbound' || 'outbound_track' => MediaTrack.outbound,
      _ => throw FormatException('Unsupported Telnyx media track: $value'),
    };
  }
}

/// Human role derived from an explicit seller-track mapping on the session.
enum SpeakerRole { seller, prospect }

/// Lifecycle of a call transcription session.
enum SessionStatus {
  awaitingMedia,
  streaming,
  stopped,
  finalizing,
  finalized,
  failed,
}

/// Immutable transcript segment backed by an actual STT provider event.
final class TranscriptSegment {
  const TranscriptSegment({
    required this.id,
    required this.track,
    required this.speaker,
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
    required this.isFinal,
    required this.provider,
    required this.createdAt,
  });

  final String id;
  final MediaTrack track;
  final SpeakerRole speaker;
  final String text;
  final double startSeconds;
  final double endSeconds;
  final bool isFinal;
  final String provider;
  final DateTime createdAt;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'track': track.name,
      'speaker': speaker.name,
      'text': text,
      'start_seconds': startSeconds,
      'end_seconds': endSeconds,
      'is_final': isFinal,
      'provider': provider,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  Map<String, Object?> toClientJson({
    required String sessionId,
    required int sequence,
    required DateTime sessionStartedAt,
  }) {
    return <String, Object?>{
      ...toJson(),
      'session_id': sessionId,
      'sequence': sequence,
      'started_at': sessionStartedAt
          .add(Duration(microseconds: (startSeconds * 1000000).round()))
          .toUtc()
          .toIso8601String(),
      'ended_at': sessionStartedAt
          .add(Duration(microseconds: (endSeconds * 1000000).round()))
          .toUtc()
          .toIso8601String(),
      'confidence': null,
    };
  }
}

/// Public immutable snapshot of a POC session.
final class CallSessionSnapshot {
  const CallSessionSnapshot({
    required this.id,
    required this.callId,
    required this.destinationNumber,
    required this.contactId,
    required this.preparationMarkdown,
    required this.workspaceSalesContext,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.coachMode,
    required this.sellerTrack,
    required this.mediaToken,
    required this.telnyxStreamId,
    required this.telnyxCallControlId,
    required this.telnyxCallSessionId,
    required this.telnyxAgentCallControlId,
    required this.telnyxAgentCallSessionId,
    required this.telnyxPstnCallControlId,
    required this.telnyxPstnCallSessionId,
    required this.telnyxOutboundDialReserved,
    required this.mediaEncoding,
    required this.mediaSampleRate,
    required this.transcriptionAllowed,
    required this.transcriptionConsentMethod,
    required this.transcriptionConsentAt,
    required this.failure,
    required this.outcome,
    required this.startedAt,
    required this.endedAt,
    this.postCallGeneration,
  });

  final String id;
  final String callId;
  final String destinationNumber;
  final String? contactId;
  final String? preparationMarkdown;
  final WorkspaceSalesContext? workspaceSalesContext;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SessionStatus status;
  final CoachMode coachMode;
  final MediaTrack sellerTrack;
  final String mediaToken;
  final String? telnyxStreamId;
  final String? telnyxCallControlId;
  final String? telnyxCallSessionId;
  final String? telnyxAgentCallControlId;
  final String? telnyxAgentCallSessionId;
  final String? telnyxPstnCallControlId;
  final String? telnyxPstnCallSessionId;
  final bool telnyxOutboundDialReserved;
  final String? mediaEncoding;
  final int? mediaSampleRate;
  final bool transcriptionAllowed;
  final String? transcriptionConsentMethod;
  final DateTime? transcriptionConsentAt;
  final String? failure;
  final String? outcome;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final PostCallGenerationSnapshot? postCallGeneration;

  SpeakerRole speakerFor(MediaTrack track) {
    return track == sellerTrack ? SpeakerRole.seller : SpeakerRole.prospect;
  }

  Map<String, Object?> toJson({bool includeMediaCredentials = false}) {
    return <String, Object?>{
      'id': id,
      'call_id': callId,
      'destination_number': destinationNumber,
      'contact_id': contactId,
      'preparation_markdown': preparationMarkdown,
      'workspace_sales_context_revision': workspaceSalesContext?.revision,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'status': _wireSessionStatus(status),
      'internal_status': status.name,
      'coach_mode': coachMode.name,
      'seller_track': sellerTrack.name,
      if (includeMediaCredentials) 'media_token': mediaToken,
      'telnyx_stream_id': telnyxStreamId,
      'telnyx_call_control_id': telnyxCallControlId,
      'telnyx_call_session_id': telnyxCallSessionId,
      'telnyx_agent_call_control_id': telnyxAgentCallControlId,
      'telnyx_agent_call_session_id': telnyxAgentCallSessionId,
      'telnyx_pstn_call_control_id': telnyxPstnCallControlId,
      'telnyx_pstn_call_session_id': telnyxPstnCallSessionId,
      'telnyx_outbound_dial_reserved': telnyxOutboundDialReserved,
      'media_encoding': mediaEncoding,
      'media_sample_rate': mediaSampleRate,
      'transcription_allowed': transcriptionAllowed,
      'transcription_consent_acknowledged': transcriptionAllowed,
      'transcription_consent_method': transcriptionConsentMethod,
      'transcription_consent_at': transcriptionConsentAt
          ?.toUtc()
          .toIso8601String(),
      'failure': failure,
      'failure_reason': failure,
      'outcome': outcome,
      'started_at': startedAt?.toUtc().toIso8601String(),
      'ended_at': endedAt?.toUtc().toIso8601String(),
      'debrief_generation': postCallGeneration?.toJson(),
    };
  }

  static String _wireSessionStatus(SessionStatus status) {
    return switch (status) {
      SessionStatus.awaitingMedia => 'created',
      SessionStatus.streaming || SessionStatus.stopped => 'active',
      SessionStatus.finalizing => 'finalizing',
      SessionStatus.finalized => 'completed',
      SessionStatus.failed => 'failed',
    };
  }
}

/// An event sent to authenticated Pinkall clients.
final class ClientEvent {
  const ClientEvent({
    required this.type,
    required this.sessionId,
    required this.at,
    required this.data,
  });

  final String type;
  final String sessionId;
  final DateTime at;
  final Map<String, Object?> data;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'type': type,
      'session_id': sessionId,
      'at': at.toUtc().toIso8601String(),
      'data': data,
      'payload': data,
    };
  }

  String encode() => jsonEncode(toJson());
}

/// A real contact imported or created by an API caller.
final class ContactRecord {
  const ContactRecord({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.company,
    required this.email,
    required this.metadata,
    required this.createdAt,
  });

  final String id;
  final String phoneNumber;
  final String? name;
  final String? company;
  final String? email;
  final Map<String, Object?> metadata;
  final DateTime createdAt;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'phone_number': phoneNumber,
      'name': name,
      'company': company,
      'email': email,
      'metadata': metadata,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}

/// Public evidence source attached to a curated coaching recommendation.
final class CoachSource {
  const CoachSource({
    required this.id,
    required this.title,
    required this.evidenceLevel,
    required this.author,
    required this.url,
    required this.locator,
  });

  final String id;
  final String title;
  final String evidenceLevel;
  final String? author;
  final String? url;
  final String? locator;

  CoachSource withLocator(String? value) {
    return CoachSource(
      id: id,
      title: title,
      evidenceLevel: evidenceLevel,
      author: author,
      url: url,
      locator: value ?? locator,
    );
  }

  /// Exact client-facing `CoachingSourceRemoteModel` shape.
  Map<String, Object?> toClientJson() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'evidence_level': evidenceLevel,
      'author': author,
      'url': url,
      'locator': locator,
    };
  }
}

/// A curated coaching card loaded from the configured repository catalogue.
final class CoachRecommendation {
  const CoachRecommendation({
    required this.id,
    required this.status,
    required this.message,
    required this.sourceIds,
    required this.sources,
    required this.triggers,
    required this.raw,
  });

  final String id;
  final String status;
  final String message;
  final List<String> sourceIds;
  final List<CoachSource> sources;
  final List<String> triggers;
  final Map<String, Object?> raw;

  Map<String, Object?> toPromptJson() {
    final Object? rawConfidence = raw['confidence'];
    final Object? evidenceConfidence = rawConfidence is Map<Object?, Object?>
        ? rawConfidence['evidence']
        : null;
    return <String, Object?>{
      'id': id,
      'message': message,
      'source_ids': sourceIds,
      'claim_ids': raw['claim_ids'],
      'trigger': raw['trigger'],
      'triggers': raw['triggers'],
      'contexts': raw['contexts'],
      'requires': raw['requires'],
      'excluded_when': raw['excluded_when'],
      'observation_template': raw['observation_template'],
      'hypothesis': raw['hypothesis'],
      'action': raw['action'],
      'trust_level': raw['custom_user_response'] == true
          ? 'untrusted_user_authored_response'
          : 'reviewed_catalogue',
      'confidence': <String, Object?>{
        if (evidenceConfidence is num) 'evidence': evidenceConfidence,
      },
    };
  }
}

/// A model's selection of one already-curated card.
final class CoachSelection {
  const CoachSelection({
    required this.recommendationId,
    required this.rationale,
    required this.confidence,
    required this.contextMatch,
    this.evidenceSegmentIds = const <String>[],
    this.reasonCode = 'selected',
    this.triggerSignal,
  });

  final String? recommendationId;
  final String rationale;
  final double confidence;
  final double contextMatch;
  final List<String> evidenceSegmentIds;
  final String reasonCode;
  final String? triggerSignal;

  /// Provider-returned diagnostic metadata that is safe to write to logs.
  ///
  /// Rationale and transcript evidence are deliberately excluded because they
  /// may contain customer speech or user-provided preparation context.
  Map<String, Object?> toSafeDiagnosticJson({
    Set<String> allowedRecommendationIds = const <String>{},
  }) {
    final String? safeRecommendationId = recommendationId == null
        ? null
        : allowedRecommendationIds.contains(recommendationId)
        ? recommendationId
        : 'unknown';
    return <String, Object?>{
      'selected': recommendationId != null,
      'recommendation_id': safeRecommendationId,
    };
  }
}

/// Runtime counters for product instrumentation, not billing records.
final class CoachingMetricsSnapshot {
  const CoachingMetricsSnapshot({
    required this.generatedShadow,
    required this.exposures,
    required this.feedbackCount,
    required this.usefulCount,
    required this.usedCount,
    required this.outcomes,
    this.storage = 'in_memory_non_durable',
  });

  final int generatedShadow;
  final int exposures;
  final int feedbackCount;
  final int usefulCount;
  final int usedCount;
  final Map<String, int> outcomes;
  final String storage;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'generated_shadow': generatedShadow,
      'exposures': exposures,
      'feedback_count': feedbackCount,
      'useful_count': usefulCount,
      'used_count': usedCount,
      'useful_rate': feedbackCount == 0 ? null : usefulCount / feedbackCount,
      'use_rate': exposures == 0 ? null : usedCount / exposures,
      'outcomes': outcomes,
      'storage': storage,
    };
  }
}
