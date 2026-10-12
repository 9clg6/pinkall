import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';

/// Raised when a destructive privacy request is not safe to execute.
final class WorkspacePrivacyConflict implements Exception {
  const WorkspacePrivacyConflict(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'WorkspacePrivacyConflict($code): $message';
}

/// Sanitized snapshot of work that can still mutate workspace data.
///
/// Destructive privacy operations must observe every count at zero before
/// mutating the store. The snapshot deliberately exposes counts only: no
/// session, import or provider identifiers cross the privacy API boundary.
final class WorkspacePrivacyActivitySnapshot {
  const WorkspacePrivacyActivitySnapshot({
    required this.activeSessionCount,
    required this.activeRecordingImportCount,
    required this.activePostCallJobCount,
  });

  final int activeSessionCount;
  final int activeRecordingImportCount;
  final int activePostCallJobCount;

  bool get hasInFlightWork =>
      activeSessionCount > 0 ||
      activeRecordingImportCount > 0 ||
      activePostCallJobCount > 0;

  Map<String, Object?> toJson() => <String, Object?>{
    'active_session_count': activeSessionCount,
    'active_recording_import_count': activeRecordingImportCount,
    'active_post_call_job_count': activePostCallJobCount,
    'destructive_operation_allowed': !hasInFlightWork,
  };
}

/// Runtime barrier covering mutations that live outside the durable store.
///
/// Recording imports and provider jobs keep short-lived in-memory state. A
/// store-only check would let one of those jobs write after retention or
/// deletion and recreate data. The runtime composition root therefore supplies
/// a probe that both reports in-flight work and prunes safe transient state.
abstract interface class WorkspacePrivacyActivityProbe {
  WorkspacePrivacyActivitySnapshot inspect();

  /// Removes transient records whose durable session was deleted by retention.
  void pruneOrphanedTransientData();

  /// Removes all idle transient records after full workspace deletion.
  void clearTransientWorkspaceData();
}

/// Privacy export, retention and deletion orchestration for one workspace.
///
/// The current snapshot store is already scoped to one workspace. The HTTP
/// layer is responsible for supplying the authenticated user and for ensuring
/// that the store instance matches the authenticated workspace.
final class WorkspacePrivacyService {
  WorkspacePrivacyService({
    required this.store,
    WorkspacePrivacyActivityProbe? activityProbe,
  }) : _activityProbe = activityProbe ?? _StorePrivacyActivityProbe(store);

  static const String deletionConfirmation = 'DELETE MY PINKALL WORKSPACE';

  final PinkallStore store;
  final WorkspacePrivacyActivityProbe _activityProbe;
  bool _destructiveOperationInProgress = false;

  /// Builds a portable JSON export without live media credentials or audio.
  Map<String, Object?> exportForUser({
    required String userId,
    required String workspaceId,
    required DateTime generatedAt,
  }) {
    final List<CallSessionSnapshot> sessions = store.listSessions();
    return <String, Object?>{
      'schema': 'pinkall.workspace-export.v1',
      'generated_at': generatedAt.toUtc().toIso8601String(),
      'workspace_id': workspaceId,
      'workspace_sales_context': store.workspaceSalesContext?.toJson(),
      'contacts': store
          .contacts()
          .map((ContactRecord contact) => contact.toJson())
          .toList(growable: false),
      'coach_preferences': store.coachPreferences(userId),
      'coaching_metrics': store.metrics().toJson(),
      'sessions': sessions
          .map((CallSessionSnapshot session) {
            final List<TranscriptSegment>? finalTranscript = store
                .finalTranscript(session.id);
            final PostCallDebrief? debrief = store.postCallDebrief(session.id);
            return <String, Object?>{
              // CallSessionSnapshot omits the high-entropy media token by
              // default. The export intentionally does not contain raw audio.
              ...session.toJson(),
              'final_transcript': finalTranscript
                  ?.map((TranscriptSegment segment) => segment.toJson())
                  .toList(growable: false),
              'post_call_debrief': debrief?.toJson(),
            };
          })
          .toList(growable: false),
      'raw_audio_included': false,
    };
  }

  /// Returns an honest dry-run of the configured terminal-session retention.
  Map<String, Object?> previewRetention({
    required int retentionDays,
    required DateTime now,
  }) {
    final DateTime cutoff = now.toUtc().subtract(Duration(days: retentionDays));
    final int eligible = store.listSessions().where((CallSessionSnapshot item) {
      final bool terminal =
          item.status == SessionStatus.stopped ||
          item.status == SessionStatus.finalized ||
          item.status == SessionStatus.failed;
      return terminal &&
          (item.endedAt ?? item.updatedAt).toUtc().isBefore(cutoff);
    }).length;
    final WorkspacePrivacyActivitySnapshot activity = _activityProbe.inspect();
    return <String, Object?>{
      'retention_days': retentionDays,
      'cutoff': cutoff.toIso8601String(),
      'eligible_session_count': eligible,
      ...activity.toJson(),
      'raw_audio_durable': false,
    };
  }

  /// Applies terminal-session retention and commits the mutation durably.
  Future<Map<String, Object?>> applyRetention({
    required int retentionDays,
    required DateTime now,
  }) async {
    return _runDestructive<Map<String, Object?>>(() async {
      final DateTime cutoff = now.toUtc().subtract(
        Duration(days: retentionDays),
      );
      final int deleted = store.deleteSessionsEndedBefore(cutoff);
      _activityProbe.pruneOrphanedTransientData();
      await store.flush();
      return <String, Object?>{
        'retention_days': retentionDays,
        'cutoff': cutoff.toIso8601String(),
        'deleted_session_count': deleted,
      };
    });
  }

  /// Deletes the workspace only after an exact confirmation and with no call
  /// in progress. This method does not delete the Supabase Auth identity; that
  /// remains an explicit privileged control-plane operation.
  Future<void> deleteWorkspaceData({required String confirmation}) async {
    if (confirmation != deletionConfirmation) {
      throw const WorkspacePrivacyConflict(
        'privacy_confirmation_invalid',
        'The workspace deletion confirmation does not match.',
      );
    }
    await _runDestructive<void>(() async {
      _activityProbe.clearTransientWorkspaceData();
      store.clearWorkspaceData();
      await store.flush();
    });
  }

  Future<T> _runDestructive<T>(Future<T> Function() mutation) async {
    if (_destructiveOperationInProgress) {
      throw const WorkspacePrivacyConflict(
        'privacy_operation_in_progress',
        'Another privacy operation is already in progress.',
      );
    }
    final WorkspacePrivacyActivitySnapshot activity = _activityProbe.inspect();
    if (activity.activeSessionCount > 0) {
      throw const WorkspacePrivacyConflict(
        'privacy_active_call_conflict',
        'End every active call before changing workspace data.',
      );
    }
    if (activity.activeRecordingImportCount > 0) {
      throw const WorkspacePrivacyConflict(
        'privacy_recording_import_conflict',
        'Wait for every recording import to finish before changing workspace data.',
      );
    }
    if (activity.activePostCallJobCount > 0) {
      throw const WorkspacePrivacyConflict(
        'privacy_post_call_conflict',
        'Wait for every post-call analysis to finish before changing workspace data.',
      );
    }
    _destructiveOperationInProgress = true;
    try {
      return await mutation();
    } finally {
      _destructiveOperationInProgress = false;
    }
  }
}

/// Store-only fallback used by focused unit tests and alternate compositions.
///
/// The production router replaces it with a probe that also sees recording
/// imports and the in-memory post-call job registry.
final class _StorePrivacyActivityProbe
    implements WorkspacePrivacyActivityProbe {
  const _StorePrivacyActivityProbe(this.store);

  final PinkallStore store;

  @override
  WorkspacePrivacyActivitySnapshot inspect() {
    final int postCallJobs = store.listSessions().where((
      CallSessionSnapshot session,
    ) {
      final PostCallGenerationStatus? status = store
          .postCallGeneration(session.id)
          ?.status;
      return status == PostCallGenerationStatus.pending ||
          status == PostCallGenerationStatus.running ||
          status == PostCallGenerationStatus.retrying;
    }).length;
    return WorkspacePrivacyActivitySnapshot(
      activeSessionCount: store.listActiveSessions().length,
      activeRecordingImportCount: 0,
      activePostCallJobCount: postCallJobs,
    );
  }

  @override
  void pruneOrphanedTransientData() {}

  @override
  void clearTransientWorkspaceData() {}
}
