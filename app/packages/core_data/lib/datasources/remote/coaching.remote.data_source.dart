import 'package:core_data/model/remote/call_outcome.remote.model.dart';
import 'package:core_data/model/remote/coach_preference.remote.model.dart';
import 'package:core_data/model/remote/coaching_feedback.remote.model.dart';
import 'package:core_data/model/remote/objection_knowledge_entry.remote.model.dart';

/// Remote source for coach preferences, feedback, and call outcomes.
abstract interface class CoachingRemoteDataSource {
  /// Lists objection knowledge entries.
  Future<ObjectionKnowledgeListRemoteModel> listObjections();

  /// Creates or updates a custom objection response.
  Future<ObjectionKnowledgeEntryRemoteModel> createCustomObjection(
    Map<String, dynamic> body,
  );

  /// Retrieves the authenticated user's coach preference.
  Future<CoachPreferenceRemoteModel> getPreference();

  /// Updates the authenticated user's coach preference.
  Future<CoachPreferenceRemoteModel> updatePreference(
    Map<String, dynamic> body,
  );

  /// Persists coaching suggestion feedback.
  Future<CoachingFeedbackRemoteModel> submitFeedback(Map<String, dynamic> body);

  /// Persists the commercial outcome of one call session.
  Future<CallOutcomeRemoteModel> recordOutcome(
    String sessionId,
    Map<String, dynamic> body,
  );
}
