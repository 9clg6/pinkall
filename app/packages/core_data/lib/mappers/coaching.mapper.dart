import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/call_outcome.remote.model.dart';
import 'package:core_data/model/remote/coach_preference.remote.model.dart';
import 'package:core_data/model/remote/coaching_feedback.remote.model.dart';
import 'package:core_data/model/remote/coaching_source.remote.model.dart';
import 'package:core_data/model/remote/coaching_suggestion.remote.model.dart';
import 'package:core_data/model/remote/objection_knowledge_entry.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Mapping extensions for [ObjectionKnowledgeEntryRemoteModel].
extension ObjectionKnowledgeEntryRemoteModelX
    on ObjectionKnowledgeEntryRemoteModel {
  /// Converts the remote objection to a domain entity.
  ObjectionKnowledgeEntryEntity toEntity() => ObjectionKnowledgeEntryEntity(
    id: id,
    category: category,
    text: text,
    reviewStatus: reviewStatus,
    origin: origin,
    occurrenceCount: occurrenceCount,
    firstSeenAt: firstSeenAt,
    lastSeenAt: lastSeenAt,
    responseContent: response?.content,
    responseSourceType: response?.sourceType,
    responseSourceName: response?.sourceName,
  );
}

/// Mapping extensions for [CoachPreferenceRemoteModel].
extension CoachPreferenceRemoteModelX on CoachPreferenceRemoteModel {
  /// Converts the remote preference to a domain entity.
  CoachPreferenceEntity toEntity() => CoachPreferenceEntity(
    defaultMode: enumFromWireName<CoachMode>(CoachMode.values, defaultMode),
    updatedAt: updatedAt,
  );
}

/// Mapping extensions for [CoachingSourceRemoteModel].
extension CoachingSourceRemoteModelX on CoachingSourceRemoteModel {
  /// Converts the remote source attribution to a domain entity.
  CoachingSourceEntity toEntity() => CoachingSourceEntity(
    id: id,
    title: title,
    author: author,
    url: url,
    locator: locator,
    evidenceLevel: enumFromWireName<CoachingEvidenceLevel>(
      CoachingEvidenceLevel.values,
      evidenceLevel,
    ),
  );
}

/// Mapping extensions for [CoachingSuggestionRemoteModel].
extension CoachingSuggestionRemoteModelX on CoachingSuggestionRemoteModel {
  /// Converts the remote suggestion to a domain entity.
  CoachingSuggestionEntity toEntity() => CoachingSuggestionEntity(
    id: id,
    sessionId: sessionId,
    kind: enumFromWireName<CoachingSuggestionKind>(
      CoachingSuggestionKind.values,
      kind,
    ),
    text: text,
    rationale: rationale,
    sources: sources
        .map((CoachingSourceRemoteModel model) => model.toEntity())
        .toList(growable: false),
    confidence: confidence,
    createdAt: createdAt,
    expiresAt: expiresAt,
  );
}

/// Mapping extensions for [CoachingFeedbackRemoteModel].
extension CoachingFeedbackRemoteModelX on CoachingFeedbackRemoteModel {
  /// Converts remote feedback to a domain entity.
  CoachingFeedbackEntity toEntity() => CoachingFeedbackEntity(
    id: id,
    sessionId: sessionId,
    suggestionId: suggestionId,
    value: enumFromWireName<SuggestionFeedbackValue>(
      SuggestionFeedbackValue.values,
      value,
    ),
    applied: applied,
    submittedAt: submittedAt,
    note: note,
  );
}

/// Mapping extensions for [CallOutcomeRemoteModel].
extension CallOutcomeRemoteModelX on CallOutcomeRemoteModel {
  /// Converts the remote outcome to a domain entity.
  CallOutcomeEntity toEntity() => CallOutcomeEntity(
    sessionId: sessionId,
    type: enumFromWireName<CallOutcomeType>(CallOutcomeType.values, type),
    recordedAt: recordedAt,
    note: note,
  );
}
