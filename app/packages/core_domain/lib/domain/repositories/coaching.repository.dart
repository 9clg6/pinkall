import 'package:core_domain/domain/entities/call_outcome.entity.dart';
import 'package:core_domain/domain/entities/coach_preference.entity.dart';
import 'package:core_domain/domain/entities/coaching_feedback.entity.dart';
import 'package:core_domain/domain/entities/objection_knowledge_entry.entity.dart';
import 'package:core_domain/domain/params/create_custom_objection.param.dart';
import 'package:core_domain/domain/params/record_call_outcome.param.dart';
import 'package:core_domain/domain/params/submit_coaching_feedback.param.dart';
import 'package:core_domain/domain/params/update_coach_preference.param.dart';

/// Contract for optional-coach preferences, feedback, and call outcomes.
abstract interface class CoachingRepository {
  /// Lists detected and user-authored objections.
  Future<List<ObjectionKnowledgeEntryEntity>> listObjections();

  /// Adds a user-authored objection response.
  Future<ObjectionKnowledgeEntryEntity> createCustomObjection(
    CreateCustomObjectionParam params,
  );

  /// Retrieves the authenticated user's default coach mode.
  Future<CoachPreferenceEntity> getPreference();

  /// Updates the authenticated user's default coach mode.
  Future<CoachPreferenceEntity> updatePreference(
    UpdateCoachPreferenceParam params,
  );

  /// Persists explicit feedback about a generated suggestion.
  Future<CoachingFeedbackEntity> submitFeedback(
    SubmitCoachingFeedbackParam params,
  );

  /// Persists the user-qualified outcome of a call session.
  Future<CallOutcomeEntity> recordOutcome(RecordCallOutcomeParam params);
}
