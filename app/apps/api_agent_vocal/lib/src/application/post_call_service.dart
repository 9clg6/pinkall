import 'dart:async';

import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/coaching_context.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/objection_learning.dart';
import 'package:api_agent_vocal/src/domain/post_call_contracts.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';

/// Builds and persists one idempotent, transcript-grounded call debrief.
final class PostCallService {
  PostCallService({
    required this.store,
    required this.gateway,
    required this.coachCatalog,
    ObjectionLearningSink objectionLearningSink =
        const NoopObjectionLearningSink(),
    void Function(String message)? diagnosticSink,
    int maxAttempts = 3,
    Duration retryBaseDelay = const Duration(milliseconds: 250),
    Future<void> Function(Duration delay)? delay,
    DateTime Function()? clock,
  }) : _maxAttempts = maxAttempts,
       _retryBaseDelay = retryBaseDelay,
       _delay = delay ?? Future<void>.delayed,
       _clock = clock ?? _utcNow,
       _objectionLearningSink = objectionLearningSink,
       _diagnosticSink = diagnosticSink ?? _ignoreDiagnostic {
    if (maxAttempts < 1) {
      throw ArgumentError.value(maxAttempts, 'maxAttempts', 'must be positive');
    }
    if (retryBaseDelay < Duration.zero) {
      throw ArgumentError.value(
        retryBaseDelay,
        'retryBaseDelay',
        'must not be negative',
      );
    }
  }

  final PinkallStore store;
  final PostCallGateway gateway;
  final CoachCatalog coachCatalog;
  final ObjectionLearningSink _objectionLearningSink;
  final void Function(String message) _diagnosticSink;
  final int _maxAttempts;
  final Duration _retryBaseDelay;
  final Future<void> Function(Duration delay) _delay;
  final DateTime Function() _clock;
  final Map<String, Future<PostCallDebrief>> _jobs =
      <String, Future<PostCallDebrief>>{};

  bool get isConfigured => gateway.isConfigured;

  /// Sessions whose post-call analysis can still write durable data.
  ///
  /// Both the in-memory registry and durable recovery states are considered so
  /// privacy deletion cannot race a job resumed after process restart.
  Set<String> get privacyBlockingSessionIds {
    final Set<String> sessionIds = <String>{..._jobs.keys};
    for (final CallSessionSnapshot session in store.listSessions()) {
      final PostCallGenerationStatus? status = store
          .postCallGeneration(session.id)
          ?.status;
      if (status == PostCallGenerationStatus.pending ||
          status == PostCallGenerationStatus.running ||
          status == PostCallGenerationStatus.retrying) {
        sessionIds.add(session.id);
      }
    }
    return Set<String>.unmodifiable(sessionIds);
  }

  /// Returns the latest durable generation diagnostic for [sessionId].
  PostCallGenerationSnapshot? status(String sessionId) {
    return store.postCallGeneration(sessionId);
  }

  /// Marks a finalized transcript as unavailable when no provider is set.
  Future<PostCallGenerationSnapshot> markUnavailable(String sessionId) async {
    final PostCallDebrief? completed = store.postCallDebrief(sessionId);
    if (completed != null) {
      return store.postCallGeneration(sessionId) ??
          _completedStatus(sessionId, completed.generatedAt, 0);
    }
    final PostCallGenerationSnapshot previous =
        store.postCallGeneration(sessionId) ??
        _pendingStatus(sessionId, _clock());
    final PostCallGenerationSnapshot unavailable = PostCallGenerationSnapshot(
      sessionId: sessionId,
      status: PostCallGenerationStatus.unavailable,
      attemptCount: previous.attemptCount,
      updatedAt: _clock().toUtc(),
      failureCode: 'provider_unavailable',
      retryable: false,
      nextRetryAt: null,
    );
    store.savePostCallGeneration(unavailable);
    await store.flush();
    return unavailable;
  }

  /// Resumes only jobs that were pending or interrupted by a process restart.
  ///
  /// Terminal failures are never retried automatically. Each resumed call is
  /// still protected by [generate]'s per-session concurrency deduplication.
  int resumeInterruptedJobs() {
    if (!isConfigured) {
      return 0;
    }
    final List<String> candidates = store
        .listSessions()
        .where((CallSessionSnapshot session) {
          if (store.postCallDebrief(session.id) != null ||
              store.finalTranscript(session.id)?.isEmpty != false) {
            return false;
          }
          final PostCallGenerationStatus? status = store
              .postCallGeneration(session.id)
              ?.status;
          return status == null ||
              status == PostCallGenerationStatus.pending ||
              status == PostCallGenerationStatus.running ||
              status == PostCallGenerationStatus.retrying;
        })
        .map((CallSessionSnapshot session) => session.id)
        .toList(growable: false);
    for (final String sessionId in candidates) {
      unawaited(
        generate(sessionId).then<void>(
          (_) {},
          onError: (Object _, StackTrace __) {
            // The sanitized terminal diagnostic is already durable. Startup
            // recovery must not create an unhandled asynchronous error.
          },
        ),
      );
    }
    return candidates.length;
  }

  Future<PostCallDebrief> generate(String sessionId) {
    final PostCallDebrief? completed = store.postCallDebrief(sessionId);
    if (completed != null) {
      return Future<PostCallDebrief>.value(completed);
    }
    final Future<PostCallDebrief>? existing = _jobs[sessionId];
    if (existing != null) {
      return existing;
    }
    late final Future<PostCallDebrief> job;
    job = _generateWithRetry(sessionId).whenComplete(() {
      if (identical(_jobs[sessionId], job)) {
        _jobs.remove(sessionId);
      }
    });
    _jobs[sessionId] = job;
    return job;
  }

  Future<PostCallDebrief> _generateWithRetry(String sessionId) async {
    if (!gateway.isConfigured) {
      await markUnavailable(sessionId);
      throw StateError('Post-call provider is not configured.');
    }
    final List<TranscriptSegment>? transcript = store.finalTranscript(
      sessionId,
    );
    if (transcript == null || transcript.isEmpty) {
      await _persistTerminalFailure(
        sessionId: sessionId,
        code: 'missing_final_transcript',
        attemptCount: store.postCallGeneration(sessionId)?.attemptCount ?? 0,
      );
      throw StateError(
        'A non-empty final transcript is required before post-call analysis.',
      );
    }
    final List<CoachRecommendation> candidates = coachCatalog
        .postCallCandidates();
    final CallSessionSnapshot session =
        store.session(sessionId) ??
        (throw StateError('Session not found: $sessionId'));
    final int previousAttempts =
        store.postCallGeneration(sessionId)?.attemptCount ?? 0;

    for (
      int localAttempt = 1;
      localAttempt <= _maxAttempts;
      localAttempt += 1
    ) {
      final int totalAttempt = previousAttempts + localAttempt;
      final DateTime startedAt = _clock().toUtc();
      store.savePostCallGeneration(
        PostCallGenerationSnapshot(
          sessionId: sessionId,
          status: PostCallGenerationStatus.running,
          attemptCount: totalAttempt,
          updatedAt: startedAt,
          failureCode: null,
          retryable: null,
          nextRetryAt: null,
        ),
      );
      await store.flush();
      try {
        final PostCallDebrief debrief = await gateway.generate(
          sessionId: sessionId,
          transcript: transcript,
          improvementCandidates: candidates,
          preparationMarkdown: composeUntrustedCoachingContextMarkdown(
            workspaceSalesContext: session.workspaceSalesContext,
            callPreparationMarkdown: session.preparationMarkdown,
          ),
        );
        _validateDebrief(
          sessionId: sessionId,
          debrief: debrief,
          candidates: candidates,
        );
        store.savePostCallDebrief(sessionId, debrief);
        store.savePostCallGeneration(
          _completedStatus(sessionId, _clock(), totalAttempt),
        );
        await store.flush();
        await _learnObjections(
          sessionId: sessionId,
          debrief: debrief,
          transcript: transcript,
        );
        return debrief;
      } on DurabilityException {
        rethrow;
      } on Object catch (error, stackTrace) {
        final _PostCallFailure failure = _classifyFailure(error);
        final bool willRetry = failure.retryable && localAttempt < _maxAttempts;
        final Duration delay = willRetry
            ? _retryDelay(localAttempt)
            : Duration.zero;
        final DateTime failedAt = _clock().toUtc();
        store.savePostCallGeneration(
          PostCallGenerationSnapshot(
            sessionId: sessionId,
            status: willRetry
                ? PostCallGenerationStatus.retrying
                : PostCallGenerationStatus.failed,
            attemptCount: totalAttempt,
            updatedAt: failedAt,
            failureCode: failure.code,
            retryable: failure.retryable,
            nextRetryAt: willRetry ? failedAt.add(delay) : null,
          ),
        );
        await store.flush();
        if (!willRetry) {
          Error.throwWithStackTrace(error, stackTrace);
        }
        if (delay > Duration.zero) {
          await _delay(delay);
        }
      }
    }
    throw StateError('Post-call retry loop exited unexpectedly.');
  }

  Future<void> _learnObjections({
    required String sessionId,
    required PostCallDebrief debrief,
    required List<TranscriptSegment> transcript,
  }) async {
    try {
      final ObjectionLearningResult result = await _objectionLearningSink.learn(
        sessionId: sessionId,
        objections: debrief.objections,
        transcript: transcript,
        observedAt: debrief.generatedAt,
      );
      _diagnosticSink(
        'objection_learning detected=${result.detectedCount} '
        'new=${result.newCount} updated=${result.updatedCount}',
      );
    } on Object catch (error) {
      _diagnosticSink('objection_learning_failed type=${error.runtimeType}');
    }
  }

  void _validateDebrief({
    required String sessionId,
    required PostCallDebrief debrief,
    required List<CoachRecommendation> candidates,
  }) {
    if (debrief.sessionId != sessionId) {
      throw StateError('Post-call provider returned a mismatched session ID.');
    }
    final PostCallImprovement? improvement = debrief.improvement;
    if (improvement != null &&
        !candidates.any(
          (CoachRecommendation item) => item.id == improvement.recommendationId,
        )) {
      throw StateError(
        'Post-call provider selected an improvement outside the eligible set.',
      );
    }
  }

  Future<void> _persistTerminalFailure({
    required String sessionId,
    required String code,
    required int attemptCount,
  }) async {
    store.savePostCallGeneration(
      PostCallGenerationSnapshot(
        sessionId: sessionId,
        status: PostCallGenerationStatus.failed,
        attemptCount: attemptCount,
        updatedAt: _clock().toUtc(),
        failureCode: code,
        retryable: false,
        nextRetryAt: null,
      ),
    );
    await store.flush();
  }

  Duration _retryDelay(int completedAttempt) {
    final int multiplier = 1 << (completedAttempt - 1).clamp(0, 8);
    return _retryBaseDelay * multiplier;
  }

  static _PostCallFailure _classifyFailure(Object error) {
    if (error is PostCallGatewayException) {
      final String code = RegExp(r'^[a-z0-9_]{1,64}$').hasMatch(error.code)
          ? error.code
          : 'generation_failed';
      return _PostCallFailure(code, error.retryable);
    }
    return switch (error) {
      FormatException() => const _PostCallFailure(
        'invalid_provider_response',
        false,
      ),
      StateError() => const _PostCallFailure('generation_conflict', false),
      ArgumentError() => const _PostCallFailure(
        'invalid_provider_response',
        false,
      ),
      _ => const _PostCallFailure('generation_failed', false),
    };
  }

  static PostCallGenerationSnapshot _completedStatus(
    String sessionId,
    DateTime at,
    int attemptCount,
  ) {
    return PostCallGenerationSnapshot(
      sessionId: sessionId,
      status: PostCallGenerationStatus.completed,
      attemptCount: attemptCount,
      updatedAt: at.toUtc(),
      failureCode: null,
      retryable: null,
      nextRetryAt: null,
    );
  }

  static PostCallGenerationSnapshot _pendingStatus(
    String sessionId,
    DateTime at,
  ) {
    return PostCallGenerationSnapshot(
      sessionId: sessionId,
      status: PostCallGenerationStatus.pending,
      attemptCount: 0,
      updatedAt: at.toUtc(),
      failureCode: null,
      retryable: null,
      nextRetryAt: null,
    );
  }

  static DateTime _utcNow() => DateTime.now().toUtc();

  static void _ignoreDiagnostic(String _) {}
}

final class _PostCallFailure {
  const _PostCallFailure(this.code, this.retryable);

  final String code;
  final bool retryable;
}
