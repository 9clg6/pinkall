import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:api_agent_vocal/src/config/app_config.dart';
import 'package:api_agent_vocal/src/domain/call_preparation.dart';
import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/coaching_context.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/recording_transcription_contracts.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';
import 'package:api_agent_vocal/src/domain/stt_contracts.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/telnyx_media.dart';

/// Orchestrates live media, replaceable STT and optional coaching.
final class SessionService {
  SessionService({
    required this.config,
    required this.store,
    required this.sttProvider,
    required this.coachGateway,
    required this.coachCatalog,
    TelnyxPcmDecoder decoder = const TelnyxPcmDecoder(),
    this.mediaStopWait = const Duration(seconds: 5),
    this.turnSilenceBoundary = const Duration(milliseconds: 1800),
    this.turnIdleFallback = const Duration(milliseconds: 2500),
    this.turnAwareWatchdog = const Duration(seconds: 12),
    this.realtimeRetryBaseDelay = const Duration(milliseconds: 500),
    this.realtimeCleanupTimeout = const Duration(seconds: 2),
    this.realtimeMaxConsecutiveFailures = 4,
    void Function(String message)? diagnosticSink,
  }) : _decoder = decoder,
       _diagnosticSink = diagnosticSink ?? _writeDiagnostic;

  final AppConfig config;
  final PinkallStore store;
  final SttProvider sttProvider;
  final CoachGateway coachGateway;
  final CoachCatalog coachCatalog;
  final Duration mediaStopWait;
  final Duration turnSilenceBoundary;
  final Duration turnIdleFallback;
  final Duration turnAwareWatchdog;
  final Duration realtimeRetryBaseDelay;
  final Duration realtimeCleanupTimeout;
  final int realtimeMaxConsecutiveFailures;
  final TelnyxPcmDecoder _decoder;
  final void Function(String message) _diagnosticSink;
  final Map<String, _MediaRuntime> _media = <String, _MediaRuntime>{};
  final Set<String> _externalSessionIds = <String>{};
  final Set<String> _recordingImportSessionIds = <String>{};
  final Map<String, Future<List<TranscriptSegment>>> _finalizationJobs =
      <String, Future<List<TranscriptSegment>>>{};
  final Map<String, DateTime> _lastCoachExposure = <String, DateTime>{};
  final Set<String> _coachRequestsInFlight = <String>{};
  final Map<String, _PendingCoachTurn> _pendingCoachTurns =
      <String, _PendingCoachTurn>{};
  final Map<String, List<DateTime>> _coachSuggestionHistory =
      <String, List<DateTime>>{};
  final Map<String, List<DateTime>> _coachEvaluationHistory =
      <String, List<DateTime>>{};
  final _CoachLatencyMetrics _coachLatencyMetrics = _CoachLatencyMetrics();

  WorkspaceSalesContext? get workspaceSalesContext =>
      store.workspaceSalesContext;

  WorkspaceSalesContext upsertWorkspaceSalesContext({
    required String companyName,
    required String productName,
    required String pitchMarkdown,
    required int? expectedRevision,
  }) {
    return store.upsertWorkspaceSalesContext(
      companyName: companyName,
      productName: productName,
      pitchMarkdown: pitchMarkdown,
      expectedRevision: expectedRevision,
    );
  }

  CallSessionSnapshot createSession({
    required String callId,
    required String destinationNumber,
    required String? contactId,
    String? preparationMarkdown,
    required CoachMode coachMode,
    required MediaTrack sellerTrack,
  }) {
    _assertCoachCanRun(coachMode);
    return store.createSession(
      callId: callId,
      destinationNumber: destinationNumber,
      contactId: contactId,
      preparationMarkdown: normalizeCallPreparationMarkdown(
        preparationMarkdown,
      ),
      coachMode: coachMode,
      sellerTrack: sellerTrack,
    );
  }

  /// Creates a non-telephony session fed by separate client audio tracks.
  CallSessionSnapshot createExternalSession({
    required String? title,
    String? preparationMarkdown,
    required CoachMode coachMode,
  }) {
    final String normalizedTitle = title?.trim().isNotEmpty == true
        ? title!.trim()
        : 'Réunion macOS';
    final CallSessionSnapshot session = createSession(
      callId: _randomId('external'),
      destinationNumber: normalizedTitle,
      contactId: null,
      preparationMarkdown: preparationMarkdown,
      coachMode: coachMode,
      sellerTrack: MediaTrack.outbound,
    );
    _externalSessionIds.add(session.id);
    return session;
  }

  /// Whether this process created the session for client-captured media.
  bool isExternalSession(String sessionId) =>
      _externalSessionIds.contains(sessionId);

  /// Creates a role-free prerecorded import session with live coaching off.
  CallSessionSnapshot createRecordingImportSession({
    required String? title,
    String? preparationMarkdown,
  }) {
    final String normalizedTitle = title?.trim().isNotEmpty == true
        ? title!.trim()
        : 'Appel importé';
    final CallSessionSnapshot session = createSession(
      callId: _randomId('recording'),
      destinationNumber: normalizedTitle,
      contactId: null,
      preparationMarkdown: preparationMarkdown,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    _recordingImportSessionIds.add(session.id);
    return session;
  }

  /// Finalizes a diarized import only after the user identifies their voice.
  Future<List<TranscriptSegment>> finalizeRecordingImportTranscript({
    required String sessionId,
    required List<DiarizedRecordingSegment> segments,
    required String userVoiceId,
    required String provider,
  }) async {
    final CallSessionSnapshot session = _requiredSession(sessionId);
    if (!_recordingImportSessionIds.contains(sessionId)) {
      throw StateError('Session $sessionId is not a recording import.');
    }
    if (!session.transcriptionAllowed) {
      throw StateError('Transcription consent has not been acknowledged.');
    }
    final List<TranscriptSegment>? completed = store.finalTranscript(sessionId);
    if (completed != null) {
      return completed;
    }
    if (segments.isEmpty) {
      throw const FormatException('A diarized transcript is required.');
    }
    final String normalizedUserVoice = userVoiceId.trim();
    if (normalizedUserVoice.isEmpty ||
        !segments.any(
          (DiarizedRecordingSegment segment) =>
              segment.voiceId == normalizedUserVoice,
        )) {
      throw const FormatException(
        'The selected user voice was not detected in the recording.',
      );
    }
    final List<DiarizedRecordingSegment> ordered =
        segments
            .where(
              (DiarizedRecordingSegment segment) =>
                  segment.text.trim().isNotEmpty &&
                  segment.startSeconds.isFinite &&
                  segment.endSeconds.isFinite &&
                  segment.startSeconds >= 0 &&
                  segment.endSeconds >= segment.startSeconds,
            )
            .toList(growable: false)
          ..sort(
            (DiarizedRecordingSegment left, DiarizedRecordingSegment right) =>
                left.startSeconds.compareTo(right.startSeconds),
          );
    if (ordered.length != segments.length) {
      throw const FormatException('The diarized transcript is invalid.');
    }
    store.updateStatus(sessionId, SessionStatus.finalizing);
    await store.flush();
    final DateTime now = DateTime.now().toUtc();
    final List<TranscriptSegment> finalTranscript = ordered
        .map((DiarizedRecordingSegment segment) {
          final bool isUser = segment.voiceId == normalizedUserVoice;
          return TranscriptSegment(
            id: _randomId('seg'),
            track: isUser ? MediaTrack.outbound : MediaTrack.inbound,
            speaker: isUser ? SpeakerRole.seller : SpeakerRole.prospect,
            text: segment.text.trim(),
            startSeconds: segment.startSeconds,
            endSeconds: segment.endSeconds,
            isFinal: true,
            provider: provider,
            createdAt: now,
          );
        })
        .toList(growable: false);
    store.replaceFinalTranscript(sessionId, finalTranscript);
    await store.flush();
    return List<TranscriptSegment>.unmodifiable(finalTranscript);
  }

  CallSessionSnapshot acknowledgeTranscriptionConsent({
    required String sessionId,
    required String method,
    required DateTime acknowledgedAt,
  }) {
    if (method.trim().isEmpty) {
      throw const FormatException('Consent method cannot be empty.');
    }
    final DateTime now = DateTime.now().toUtc();
    if (acknowledgedAt.toUtc().isAfter(now.add(const Duration(minutes: 5)))) {
      throw const FormatException('Consent timestamp cannot be in the future.');
    }
    return store.acknowledgeTranscriptionConsent(
      sessionId: sessionId,
      method: method.trim(),
      acknowledgedAt: acknowledgedAt,
    );
  }

  Future<void> beginMedia(String sessionId, TelnyxStartFrame frame) async {
    final CallSessionSnapshot session = _requiredSession(sessionId);
    if (session.status != SessionStatus.awaitingMedia) {
      throw StateError(
        'Session $sessionId cannot start media from ${session.status.name}.',
      );
    }
    if (frame.channels != 1) {
      throw UnsupportedError('Telnyx media must be mono for this POC.');
    }
    final SttAudioFormat pcmFormat = _decoder.outputFormat(
      encoding: frame.encoding,
      sampleRate: frame.sampleRate,
      channels: frame.channels,
    );
    final _MediaRuntime? existing = _media[sessionId];
    if (existing != null) {
      existing.markMediaEnded();
      await _closeRuntime(existing);
    }
    _media[sessionId] = _MediaRuntime(
      sessionId: session.id,
      sourceEncoding: frame.encoding,
      pcmFormat: pcmFormat,
      source: _MediaRuntimeSource.telnyx,
    );
    store.markMediaStarted(
      sessionId: sessionId,
      streamId: frame.streamId,
      callControlId: frame.callControlId,
      callSessionId: frame.callSessionId,
      encoding: frame.encoding,
      sampleRate: frame.sampleRate,
    );
    await store.flush();
  }

  Future<void> ingestAudio(String sessionId, TelnyxAudioFrame frame) async {
    final CallSessionSnapshot session = _requiredSession(sessionId);
    final _MediaRuntime? runtime = _media[sessionId];
    if (runtime == null) {
      throw StateError('Telnyx media arrived before a start event.');
    }
    if (!session.transcriptionAllowed) {
      // Deliberately do not decode, buffer, persist or send pre-consent audio.
      return;
    }
    final List<int> pcm = _decoder.decodeBase64(
      frame.payload,
      encoding: runtime.sourceEncoding,
    );
    await _ingestPcmAudio(
      session: session,
      runtime: runtime,
      track: frame.track,
      pcm: pcm,
      timestampMilliseconds: frame.timestamp,
    );
  }

  /// Opens one external PCM16 track while keeping the normal session lifecycle.
  Future<void> beginExternalMediaTrack(
    String sessionId,
    MediaTrack track,
  ) async {
    final CallSessionSnapshot session = _requiredSession(sessionId);
    if (!_externalSessionIds.contains(sessionId)) {
      throw StateError('Session $sessionId is not an external media session.');
    }
    final _MediaRuntime? existing = _media[sessionId];
    if (existing != null) {
      if (existing.source != _MediaRuntimeSource.externalClient) {
        throw StateError('Session $sessionId already uses Telnyx media.');
      }
      if (!existing.connectedExternalTracks.add(track)) {
        throw StateError(
          'External media track ${track.name} is already connected.',
        );
      }
      return;
    }
    if (session.status != SessionStatus.awaitingMedia) {
      throw StateError(
        'Session $sessionId cannot start media from ${session.status.name}.',
      );
    }
    const SttAudioFormat format = SttAudioFormat(
      encoding: 'pcm_s16le',
      sampleRate: 16000,
    );
    final _MediaRuntime runtime = _MediaRuntime(
      sessionId: session.id,
      sourceEncoding: 'PCM_S16LE',
      pcmFormat: format,
      source: _MediaRuntimeSource.externalClient,
    )..connectedExternalTracks.add(track);
    _media[sessionId] = runtime;
    store.markMediaStarted(
      sessionId: sessionId,
      streamId: 'client:$sessionId',
      callControlId: null,
      callSessionId: null,
      encoding: 'PCM_S16LE',
      sampleRate: format.sampleRate,
    );
    await store.flush();
  }

  /// Ingests raw little-endian, mono PCM16 from one external client track.
  Future<void> ingestExternalPcm16(
    String sessionId,
    MediaTrack track,
    List<int> pcm,
  ) async {
    final CallSessionSnapshot session = _requiredSession(sessionId);
    final _MediaRuntime? runtime = _media[sessionId];
    if (runtime == null ||
        runtime.source != _MediaRuntimeSource.externalClient ||
        !runtime.connectedExternalTracks.contains(track)) {
      throw StateError('External media arrived before its track was opened.');
    }
    if (pcm.isEmpty || pcm.length.isOdd) {
      throw const FormatException(
        'External media must contain complete PCM16 samples.',
      );
    }
    await _ingestPcmAudio(
      session: session,
      runtime: runtime,
      track: track,
      pcm: pcm,
      timestampMilliseconds: null,
    );
  }

  Future<void> _ingestPcmAudio({
    required CallSessionSnapshot session,
    required _MediaRuntime runtime,
    required MediaTrack track,
    required List<int> pcm,
    required int? timestampMilliseconds,
  }) async {
    if (!session.transcriptionAllowed) {
      // Pre-consent bytes never reach either the transient buffer or STT.
      return;
    }
    // The batch transcript is the durable fallback. Buffer first so a
    // realtime provider outage never discards audio needed after the call.
    store.appendAudio(session.id, track, pcm);
    final double previousAudioEnd = runtime.lastAudioEndSeconds[track] ?? 0;
    final double frameEnd = timestampMilliseconds == null
        ? previousAudioEnd + (pcm.length / (runtime.pcmFormat.sampleRate * 2))
        : timestampMilliseconds / 1000;
    runtime.lastAudioEndSeconds[track] = max(previousAudioEnd, frameEnd);
    final RealtimeSttSession? providerSession = await _providerSession(
      runtime,
      track,
    );
    if (providerSession == null) {
      return;
    }
    try {
      await providerSession.addAudio(pcm);
    } on Object catch (error) {
      _scheduleRealtimeRecovery(
        runtime,
        track,
        reason: 'audio_append_failed',
        error: error,
      );
    }
  }

  /// Closes one external track and stops media when the last track leaves.
  Future<void> endExternalMediaTrack(String sessionId, MediaTrack track) async {
    final _MediaRuntime? runtime = _media[sessionId];
    if (runtime == null ||
        runtime.source != _MediaRuntimeSource.externalClient) {
      return;
    }
    runtime.connectedExternalTracks.remove(track);
    if (runtime.connectedExternalTracks.isNotEmpty) {
      return;
    }
    await endMedia(sessionId);
  }

  Future<void> endMedia(String sessionId) async {
    final _MediaRuntime? runtime = _media[sessionId];
    if (runtime != null) {
      runtime.markMediaEnded();
      await _closeRuntime(runtime);
      if (identical(_media[sessionId], runtime)) {
        _media.remove(sessionId);
      }
    }
    final CallSessionSnapshot? snapshot = store.session(sessionId);
    if (snapshot != null &&
        snapshot.status != SessionStatus.failed &&
        snapshot.status != SessionStatus.finalizing &&
        snapshot.status != SessionStatus.finalized) {
      store.updateStatus(sessionId, SessionStatus.stopped);
      await store.flush();
    }
  }

  Future<List<TranscriptSegment>> finalize(String sessionId) {
    final CallSessionSnapshot session = _requiredSession(sessionId);
    if (!session.transcriptionAllowed) {
      throw StateError('Transcription consent has not been acknowledged.');
    }
    final List<TranscriptSegment>? completed = store.finalTranscript(sessionId);
    if (completed != null) {
      return Future<List<TranscriptSegment>>.value(completed);
    }
    final Future<List<TranscriptSegment>>? existing =
        _finalizationJobs[sessionId];
    if (existing != null) {
      return existing;
    }
    late final Future<List<TranscriptSegment>> job;
    job = _finalizeOnce(sessionId).whenComplete(() {
      if (identical(_finalizationJobs[sessionId], job)) {
        _finalizationJobs.remove(sessionId);
      }
    });
    _finalizationJobs[sessionId] = job;
    return job;
  }

  Future<List<TranscriptSegment>> _finalizeOnce(String sessionId) async {
    final _MediaRuntime? runtime = _media[sessionId];
    if (runtime != null) {
      try {
        await runtime.mediaEnded.future.timeout(mediaStopWait);
      } on TimeoutException {
        throw StateError(
          'Media stream is still active. End the call and retry finalize.',
        );
      }
      await _closeRuntime(runtime);
      if (identical(_media[sessionId], runtime)) {
        _media.remove(sessionId);
      }
    }
    final CallSessionSnapshot session = _requiredSession(sessionId);
    store.updateStatus(sessionId, SessionStatus.finalizing);
    await store.flush();
    final List<Future<_TrackBatchResult>> jobs = <Future<_TrackBatchResult>>[];
    final int sampleRate = session.mediaSampleRate ?? 8000;
    final SttAudioFormat format = SttAudioFormat(
      encoding: 'pcm_s16le',
      sampleRate: sampleRate,
    );
    for (final MediaTrack track in MediaTrack.values) {
      final List<int> bytes = store.audio(sessionId, track);
      if (bytes.isEmpty) {
        continue;
      }
      jobs.add(
        sttProvider
            .transcribeFinal(
              pcmBytes: bytes,
              audioFormat: format,
              fileName: '${session.id}_${track.name}.wav',
            )
            .then(
              (BatchTranscript transcript) => _TrackBatchResult(
                track: track,
                transcript: transcript,
                audioDurationSeconds: bytes.length / (sampleRate * 2),
              ),
            ),
      );
    }
    if (jobs.isEmpty) {
      store.updateStatus(sessionId, SessionStatus.stopped);
      await store.flush();
      throw StateError('No consented audio is available for finalization.');
    }
    late final List<TranscriptSegment> finalSegments;
    try {
      final List<_TrackBatchResult> results = await Future.wait(jobs);
      finalSegments = <TranscriptSegment>[];
      for (final _TrackBatchResult result in results) {
        final List<BatchTranscriptSegment> rawProviderSegments =
            result.transcript.segments.isEmpty &&
                result.transcript.text.trim().isNotEmpty
            ? <BatchTranscriptSegment>[
                BatchTranscriptSegment(
                  text: result.transcript.text.trim(),
                  startSeconds: 0,
                  endSeconds: result.audioDurationSeconds,
                ),
              ]
            : result.transcript.segments;
        final List<BatchTranscriptSegment> providerSegments = _mergeBatchTurns(
          rawProviderSegments,
        );
        for (final BatchTranscriptSegment segment in providerSegments) {
          finalSegments.add(
            TranscriptSegment(
              id: _randomId('seg'),
              track: result.track,
              speaker: session.speakerFor(result.track),
              text: segment.text,
              startSeconds: segment.startSeconds,
              endSeconds: segment.endSeconds,
              isFinal: true,
              provider: result.transcript.provider,
              createdAt: DateTime.now().toUtc(),
            ),
          );
        }
      }
      finalSegments.sort(
        (TranscriptSegment left, TranscriptSegment right) =>
            left.startSeconds.compareTo(right.startSeconds),
      );
    } on Object catch (error) {
      store.failSession(sessionId, 'Final transcription failed: $error');
      await store.flush();
      rethrow;
    }
    store.replaceFinalTranscript(sessionId, finalSegments);
    await store.flush();
    return finalSegments;
  }

  List<BatchTranscriptSegment> _mergeBatchTurns(
    List<BatchTranscriptSegment> segments,
  ) {
    final List<BatchTranscriptSegment> ordered =
        segments
            .where((BatchTranscriptSegment item) => item.text.trim().isNotEmpty)
            .toList(growable: true)
          ..sort(
            (BatchTranscriptSegment left, BatchTranscriptSegment right) =>
                left.startSeconds.compareTo(right.startSeconds),
          );
    if (ordered.length < 2) {
      return ordered;
    }
    final double maximumGapSeconds = turnSilenceBoundary.inMilliseconds / 1000;
    final List<BatchTranscriptSegment> turns = <BatchTranscriptSegment>[];
    BatchTranscriptSegment current = ordered.first;
    for (final BatchTranscriptSegment next in ordered.skip(1)) {
      final double gapSeconds = max(0, next.startSeconds - current.endSeconds);
      if (gapSeconds < maximumGapSeconds) {
        current = BatchTranscriptSegment(
          text: _joinTurnText(current.text, next.text),
          startSeconds: min(current.startSeconds, next.startSeconds),
          endSeconds: max(current.endSeconds, next.endSeconds),
        );
      } else {
        turns.add(current);
        current = next;
      }
    }
    turns.add(current);
    return turns;
  }

  CallSessionSnapshot setCoachMode(String sessionId, CoachMode mode) {
    _requiredSession(sessionId);
    _assertCoachCanRun(mode);
    final CallSessionSnapshot updated = store.setCoachMode(sessionId, mode);
    if (mode == CoachMode.off) {
      final _MediaRuntime? runtime = _media[sessionId];
      if (runtime != null) {
        for (final MediaTrack track
            in runtime.speculativeCoachTurns.keys.toList(growable: false)) {
          _cancelSpeculativeCoachTurn(
            runtime,
            track,
            providerTurnId: null,
            reason: 'coach_disabled',
          );
        }
      }
    }
    return updated;
  }

  CallSessionSnapshot cancelPendingDial(String sessionId) {
    final CallSessionSnapshot session = _requiredSession(sessionId);
    if (session.status == SessionStatus.failed &&
        session.failure == 'client_dial_failed') {
      return session;
    }
    if (session.status != SessionStatus.awaitingMedia) {
      throw StateError(
        'Only a created session can be cancelled after a dial failure.',
      );
    }
    store.failSession(sessionId, 'client_dial_failed');
    return _requiredSession(sessionId);
  }

  void validateCoachMode(CoachMode mode) => _assertCoachCanRun(mode);

  /// Process-local latency telemetry for the live coaching critical path.
  ///
  /// These measurements intentionally contain no transcript text and are not
  /// billing records. They reset whenever the API process restarts.
  Map<String, Object?> liveCoachLatencyMetrics() =>
      _coachLatencyMetrics.toJson();

  Future<void> dispose() async {
    final List<_MediaRuntime> runtimes = _media.values.toList(growable: false);
    _media.clear();
    _externalSessionIds.clear();
    _recordingImportSessionIds.clear();
    for (final _MediaRuntime runtime in runtimes) {
      runtime.markMediaEnded();
    }
    await Future.wait(runtimes.map(_closeRuntime));
  }

  Future<RealtimeSttSession?> _providerSession(
    _MediaRuntime runtime,
    MediaTrack track,
  ) async {
    if (runtime.closing) {
      return null;
    }
    final RealtimeSttSession? existing = runtime.providerSessions[track];
    if (existing != null) {
      return existing;
    }
    final _RealtimeRecoveryState recovery = runtime.realtimeRecovery
        .putIfAbsent(track, _RealtimeRecoveryState.new);
    if (recovery.exhausted) {
      return null;
    }
    final DateTime? retryAfter = recovery.retryAfter;
    if (retryAfter != null && DateTime.now().toUtc().isBefore(retryAfter)) {
      return null;
    }
    final Future<void>? cleanupJob = recovery.cleanupJob;
    if (cleanupJob != null) {
      await cleanupJob;
      if (runtime.closing || recovery.exhausted) {
        return null;
      }
    }
    final Future<RealtimeSttSession?>? opening =
        runtime.providerOpeningJobs[track];
    if (opening != null) {
      return opening;
    }
    final Future<RealtimeSttSession?> job = _openProviderSession(
      runtime,
      track,
      recovery,
    );
    runtime.providerOpeningJobs[track] = job;
    try {
      return await job;
    } finally {
      if (identical(runtime.providerOpeningJobs[track], job)) {
        runtime.providerOpeningJobs.remove(track);
      }
    }
  }

  Future<RealtimeSttSession?> _openProviderSession(
    _MediaRuntime runtime,
    MediaTrack track,
    _RealtimeRecoveryState recovery,
  ) async {
    late final RealtimeSttSession created;
    try {
      created = await sttProvider.openRealtimeSession(
        track: track,
        audioFormat: runtime.pcmFormat,
      );
    } on Object catch (error) {
      _scheduleRealtimeRecovery(
        runtime,
        track,
        reason: 'session_open_failed',
        error: error,
      );
      return null;
    }
    if (runtime.closing) {
      await _closeProviderSession(runtime, track, created, null);
      return null;
    }
    final int recoveryAttempt = recovery.consecutiveFailures;
    recovery.retryAfter = null;
    runtime.providerSessions[track] = created;
    runtime.providerEpochs.update(
      track,
      (int epoch) => epoch + 1,
      ifAbsent: () => 1,
    );
    runtime.subscriptions[track] = created.events.listen(
      (SttEvent event) => _onSttEvent(runtime, track, created, event),
      onError: (Object error, StackTrace stackTrace) {
        if (!identical(runtime.providerSessions[track], created)) {
          return;
        }
        _scheduleRealtimeRecovery(
          runtime,
          track,
          reason: 'event_stream_failed',
          error: error,
        );
      },
      onDone: () {
        if (runtime.closing ||
            !identical(runtime.providerSessions[track], created)) {
          return;
        }
        _scheduleRealtimeRecovery(
          runtime,
          track,
          reason: 'event_stream_closed',
        );
      },
    );
    if (recoveryAttempt > 0) {
      _diagnosticSink(
        'pinkall.stt realtime_reopened session=${runtime.sessionId} '
        'track=${track.name} attempt=$recoveryAttempt',
      );
    }
    return created;
  }

  void _onSttEvent(
    _MediaRuntime runtime,
    MediaTrack track,
    RealtimeSttSession source,
    SttEvent event,
  ) {
    if (!identical(runtime.providerSessions[track], source)) {
      return;
    }
    final String sessionId = runtime.sessionId;
    final CallSessionSnapshot? session = store.session(sessionId);
    if (session == null) {
      return;
    }
    if (event is! SttFailure) {
      final _RealtimeRecoveryState? recovery = runtime.realtimeRecovery[track];
      if (recovery != null && recovery.consecutiveFailures > 0) {
        recovery
          ..consecutiveFailures = 0
          ..retryAfter = null
          ..exhausted = false;
        _diagnosticSink(
          'pinkall.stt realtime_recovered session=${runtime.sessionId} '
          'track=${track.name}',
        );
      }
    }
    switch (event) {
      case SttTextDelta(:final String text):
        final _PartialTranscript partial = runtime.partials.putIfAbsent(
          track,
          () => _PartialTranscript(
            id: _randomId('partial'),
            createdAt: DateTime.now().toUtc(),
            startSeconds: runtime.lastEndSeconds[track] ?? 0,
          ),
        );
        partial.appendDelta(text);
        if (partial.text.trim().isNotEmpty) {
          _upsertPartialTurn(runtime, track, session);
          if (sttProvider.providesSemanticTurnBoundaries) {
            _scheduleTurnAwareWatchdog(runtime, track);
          } else {
            _schedulePartialCommit(runtime, track);
          }
        }
      case SttEagerTurnEnd(
        :final String text,
        :final double startSeconds,
        :final double endSeconds,
        :final String? providerTurnId,
      ):
        _startSpeculativeCoachTurn(
          runtime,
          track,
          session,
          text: text,
          startSeconds: startSeconds,
          endSeconds: endSeconds,
          providerTurnId: providerTurnId,
        );
      case SttTurnResumed(:final String? providerTurnId):
        _cancelSpeculativeCoachTurn(
          runtime,
          track,
          providerTurnId: providerTurnId,
          reason: 'turn_resumed',
        );
      case SttSegment(
        :final String text,
        :final double startSeconds,
        :final double endSeconds,
        :final bool isTurnEnd,
        :final String? providerTurnId,
      ):
        _cancelPartialCommit(runtime, track);
        _cancelTurnAwareWatchdog(runtime, track);
        final _PartialTranscript? existing = runtime.partials[track];
        final int providerEpoch = runtime.providerEpochs[track] ?? 0;
        if (existing != null &&
            existing.hasConfirmedTiming &&
            existing.confirmedEpoch == providerEpoch &&
            startSeconds - existing.confirmedEndSeconds >=
                turnSilenceBoundary.inMilliseconds / 1000) {
          _commitPartialTurn(runtime, track, confirmedOnly: true);
        }
        final _PartialTranscript partial = runtime.partials.putIfAbsent(
          track,
          () => _PartialTranscript(
            id: _randomId('partial'),
            createdAt: DateTime.now().toUtc(),
            startSeconds: startSeconds,
          ),
        );
        partial.acceptSegment(
          text: text,
          startSeconds: startSeconds,
          endSeconds: endSeconds,
          providerEpoch: providerEpoch,
          providerTurnId: providerTurnId,
        );
        _upsertPartialTurn(runtime, track, session);
        if (isTurnEnd) {
          _commitPartialTurn(runtime, track, confirmedOnly: true);
        } else if (sttProvider.providesSemanticTurnBoundaries) {
          _scheduleTurnAwareWatchdog(runtime, track);
        } else {
          _schedulePartialCommit(runtime, track);
        }
      case SttDone(:final String text):
        _cancelPartialCommit(runtime, track);
        _cancelTurnAwareWatchdog(runtime, track);
        _PartialTranscript? partial = runtime.partials[track];
        final int finalCount = runtime.finalSegmentCounts[track] ?? 0;
        if (partial == null && (finalCount > 0 || text.trim().isEmpty)) {
          break;
        }
        if (partial == null) {
          partial = _PartialTranscript(
            id: _randomId('partial'),
            createdAt: DateTime.now().toUtc(),
            startSeconds: runtime.lastEndSeconds[track] ?? 0,
          )..acceptDoneFallback(text);
          runtime.partials[track] = partial;
        } else if (!partial.hasConfirmedText && finalCount == 0) {
          partial.acceptDoneFallback(text);
        }
        _commitPartialTurn(runtime, track);
      case SttTurnTelemetry(
        :final String event,
        :final int? turnIndex,
        :final int? sequenceId,
        :final double? audioWindowStart,
        :final double? audioWindowEnd,
        :final double? endOfTurnConfidence,
      ):
        if (sttProvider.providesSemanticTurnBoundaries) {
          if (event == 'EndOfTurn') {
            _cancelTurnAwareWatchdog(runtime, track);
          } else if (runtime.partials[track]?.text.trim().isNotEmpty == true) {
            // Flux may revise an interim transcript and stop emitting text
            // deltas. Turn telemetry still proves that the provider session is
            // alive, so keep the emergency watchdog from firing mid-speech.
            _scheduleTurnAwareWatchdog(runtime, track);
          }
        }
        if (_loggedTurnTelemetryEvents.contains(event)) {
          _diagnosticSink(
            'pinkall.stt turn_event provider=${sttProvider.name} '
            'session=$sessionId track=${track.name} '
            'event=${_safeTelemetryEvent(event)} '
            'turn_index=${turnIndex ?? 'none'} '
            'sequence_id=${sequenceId ?? 'none'} '
            'audio_window_start=${audioWindowStart ?? 'none'} '
            'audio_window_end=${audioWindowEnd ?? 'none'} '
            'eot_confidence=${endOfTurnConfidence ?? 'none'}',
          );
        }
      case SttFailure(:final String message):
        if (runtime.closing) {
          _diagnosticSink(
            'pinkall.stt realtime_close_event_failed '
            'session=${runtime.sessionId} track=${track.name} '
            'detail=${_safeDiagnostic(message)}',
          );
          break;
        }
        _scheduleRealtimeRecovery(
          runtime,
          track,
          reason: 'provider_event_failed',
          error: message,
        );
    }
  }

  void _schedulePartialCommit(_MediaRuntime runtime, MediaTrack track) {
    _cancelPartialCommit(runtime, track);
    final int generation = runtime.partialCommitGenerations[track] ?? 0;
    runtime.partialCommitTimers[track] = Timer(turnIdleFallback, () {
      if (runtime.partialCommitGenerations[track] != generation) {
        return;
      }
      runtime.partialCommitTimers.remove(track);
      if (runtime.closing) {
        return;
      }
      _commitPartialTurn(runtime, track);
    });
  }

  void _cancelPartialCommit(_MediaRuntime runtime, MediaTrack track) {
    runtime.partialCommitGenerations.update(
      track,
      (int generation) => generation + 1,
      ifAbsent: () => 1,
    );
    runtime.partialCommitTimers.remove(track)?.cancel();
  }

  void _scheduleTurnAwareWatchdog(_MediaRuntime runtime, MediaTrack track) {
    _cancelTurnAwareWatchdog(runtime, track);
    final int generation = runtime.turnAwareWatchdogGenerations[track] ?? 0;
    runtime.turnAwareWatchdogTimers[track] = Timer(turnAwareWatchdog, () {
      if (runtime.turnAwareWatchdogGenerations[track] != generation) {
        return;
      }
      runtime.turnAwareWatchdogTimers.remove(track);
      if (runtime.closing) {
        return;
      }
      _diagnosticSink(
        'pinkall.stt turn_watchdog_fired provider=${sttProvider.name} '
        'session=${runtime.sessionId} track=${track.name}',
      );
      _commitPartialTurn(runtime, track);
    });
  }

  void _cancelTurnAwareWatchdog(_MediaRuntime runtime, MediaTrack track) {
    runtime.turnAwareWatchdogGenerations.update(
      track,
      (int generation) => generation + 1,
      ifAbsent: () => 1,
    );
    runtime.turnAwareWatchdogTimers.remove(track)?.cancel();
  }

  void _upsertPartialTurn(
    _MediaRuntime runtime,
    MediaTrack track,
    CallSessionSnapshot session,
  ) {
    final _PartialTranscript? partial = runtime.partials[track];
    if (partial == null || partial.text.trim().isEmpty) {
      return;
    }
    store.upsertTranscriptSegment(
      runtime.sessionId,
      TranscriptSegment(
        id: partial.id,
        track: track,
        speaker: session.speakerFor(track),
        text: partial.text,
        startSeconds: partial.startSeconds,
        endSeconds: partial.endSeconds,
        isFinal: false,
        provider: sttProvider.name,
        createdAt: partial.createdAt,
      ),
    );
  }

  void _commitPartialTurn(
    _MediaRuntime runtime,
    MediaTrack track, {
    bool confirmedOnly = false,
  }) {
    final _PartialTranscript? partial = runtime.partials.remove(track);
    final String text = partial == null
        ? ''
        : (confirmedOnly ? partial.confirmedText : partial.text).trim();
    if (partial == null || text.isEmpty) {
      return;
    }
    final CallSessionSnapshot? session = store.session(runtime.sessionId);
    if (session == null ||
        session.status == SessionStatus.failed ||
        session.status == SessionStatus.finalizing ||
        session.status == SessionStatus.finalized) {
      return;
    }
    final double endSeconds = max(
      partial.startSeconds,
      partial.endSeconds > partial.startSeconds
          ? partial.endSeconds
          : runtime.lastAudioEndSeconds[track] ?? partial.startSeconds,
    );
    final TranscriptSegment segment = TranscriptSegment(
      id: partial.id,
      track: track,
      speaker: session.speakerFor(track),
      text: text,
      startSeconds: partial.startSeconds,
      endSeconds: endSeconds,
      isFinal: true,
      provider: '${sttProvider.name}:turn_boundary',
      createdAt: partial.createdAt,
    );
    runtime.finalSegmentCounts.update(
      track,
      (int count) => count + 1,
      ifAbsent: () => 1,
    );
    runtime.lastEndSeconds[track] = endSeconds;
    store.upsertTranscriptSegment(runtime.sessionId, segment);
    if (!runtime.closing && segment.speaker == SpeakerRole.prospect) {
      final bool speculativeEvaluationCoversTurn = _confirmSpeculativeCoachTurn(
        runtime,
        track,
        segment,
        providerTurnId: partial.providerTurnId,
      );
      if (!speculativeEvaluationCoversTurn) {
        _maybeCoach(runtime.sessionId, segment);
      }
    }
  }

  void _startSpeculativeCoachTurn(
    _MediaRuntime runtime,
    MediaTrack track,
    CallSessionSnapshot session, {
    required String text,
    required double startSeconds,
    required double endSeconds,
    required String? providerTurnId,
  }) {
    if (runtime.closing || session.speakerFor(track) != SpeakerRole.prospect) {
      return;
    }
    final String eagerText = text.trim();
    if (eagerText.isEmpty) {
      return;
    }
    final _PartialTranscript partial = runtime.partials.putIfAbsent(
      track,
      () => _PartialTranscript(
        id: _randomId('partial'),
        createdAt: DateTime.now().toUtc(),
        startSeconds: startSeconds,
      )..appendDelta(eagerText),
    );
    _upsertPartialTurn(runtime, track, session);
    final _SpeculativeCoachTurn? existing =
        runtime.speculativeCoachTurns[track];
    if (existing != null &&
        existing.providerTurnId == providerTurnId &&
        existing.segmentId == partial.id &&
        !existing.isResolved) {
      return;
    }
    if (existing != null) {
      runtime.speculativeCoachTurns.remove(track);
      if (existing.cancel(reason: 'superseded_eager_turn')) {
        _coachLatencyMetrics.recordSpeculativeCancellation();
      }
    }
    final DateTime triggeredAt = DateTime.now().toUtc();
    final TranscriptSegment provisional = TranscriptSegment(
      id: partial.id,
      track: track,
      speaker: SpeakerRole.prospect,
      text: eagerText,
      startSeconds: startSeconds,
      endSeconds: max(startSeconds, endSeconds),
      isFinal: false,
      provider: '${sttProvider.name}:eager_eot',
      createdAt: partial.createdAt,
    );
    final _SpeculativeCoachTurn speculation = _SpeculativeCoachTurn(
      providerTurnId: providerTurnId,
      segmentId: partial.id,
      triggerText: eagerText,
      triggeredAt: triggeredAt,
    );
    runtime.speculativeCoachTurns[track] = speculation;
    final bool accepted = _maybeCoach(
      runtime.sessionId,
      provisional,
      speculation: speculation,
    );
    if (!accepted) {
      if (identical(runtime.speculativeCoachTurns[track], speculation)) {
        runtime.speculativeCoachTurns.remove(track);
      }
      speculation.cancel(reason: 'evaluation_skipped');
      return;
    }
    _coachLatencyMetrics.recordSpeculativeStart();
    _diagnosticSink(
      'pinkall.coach speculative_started session=${runtime.sessionId} '
      'track=${track.name} turn_id=${providerTurnId ?? 'none'}',
    );
  }

  void _cancelSpeculativeCoachTurn(
    _MediaRuntime runtime,
    MediaTrack track, {
    required String? providerTurnId,
    required String reason,
  }) {
    final _SpeculativeCoachTurn? speculation =
        runtime.speculativeCoachTurns[track];
    if (speculation == null ||
        (providerTurnId != null &&
            speculation.providerTurnId != null &&
            speculation.providerTurnId != providerTurnId)) {
      return;
    }
    runtime.speculativeCoachTurns.remove(track);
    if (speculation.cancel(reason: reason)) {
      _coachLatencyMetrics.recordSpeculativeCancellation();
      _diagnosticSink(
        'pinkall.coach speculative_cancelled session=${runtime.sessionId} '
        'track=${track.name} reason=$reason',
      );
    }
  }

  bool _confirmSpeculativeCoachTurn(
    _MediaRuntime runtime,
    MediaTrack track,
    TranscriptSegment finalSegment, {
    required String? providerTurnId,
  }) {
    final _SpeculativeCoachTurn? speculation = runtime.speculativeCoachTurns
        .remove(track);
    if (speculation == null) {
      return false;
    }
    final bool turnIdChanged =
        providerTurnId != null &&
        speculation.providerTurnId != null &&
        providerTurnId != speculation.providerTurnId;
    if (turnIdChanged ||
        _normalizeSpeculativeTurn(speculation.triggerText) !=
            _normalizeSpeculativeTurn(finalSegment.text)) {
      final String reason = turnIdChanged
          ? 'final_turn_changed'
          : 'final_transcript_changed';
      if (speculation.cancel(reason: reason)) {
        _coachLatencyMetrics.recordSpeculativeCancellation();
      }
      _diagnosticSink(
        'pinkall.coach speculative_cancelled session=${runtime.sessionId} '
        'track=${track.name} reason=$reason',
      );
      return false;
    }
    final DateTime confirmedAt = DateTime.now().toUtc();
    speculation.confirm(at: confirmedAt);
    _coachLatencyMetrics.recordEagerToFinal(
      confirmedAt.difference(speculation.triggeredAt),
    );
    _diagnosticSink(
      'pinkall.coach speculative_confirmed session=${runtime.sessionId} '
      'track=${track.name} '
      'eager_to_final_ms='
      '${confirmedAt.difference(speculation.triggeredAt).inMilliseconds}',
    );
    return true;
  }

  bool _maybeCoach(
    String sessionId,
    TranscriptSegment latest, {
    _SpeculativeCoachTurn? speculation,
  }) {
    if (speculation?.isCancelled == true) {
      return false;
    }
    final CallSessionSnapshot session = _requiredSession(sessionId);
    final CoachMode mode = session.coachMode;
    if (mode == CoachMode.off || session.status != SessionStatus.streaming) {
      return false;
    }
    if (_coachRequestsInFlight.contains(sessionId)) {
      _pendingCoachTurns[sessionId] = _PendingCoachTurn(
        segment: latest,
        speculation: speculation,
      );
      return true;
    }
    final DateTime now = DateTime.now().toUtc();
    final DateTime? last = _lastCoachExposure[sessionId];
    final Duration cooldown =
        config.coachMinimumInterval > coachCatalog.globalCooldown
        ? config.coachMinimumInterval
        : coachCatalog.globalCooldown;
    if (last != null && now.difference(last) < cooldown) {
      return false;
    }
    final List<DateTime> suggestionHistory =
        _coachSuggestionHistory.putIfAbsent(sessionId, () => <DateTime>[])
          ..removeWhere(
            (DateTime timestamp) =>
                now.difference(timestamp) >= const Duration(minutes: 1),
          );
    if (suggestionHistory.length >= coachCatalog.maxSuggestionsPerMinute) {
      return false;
    }
    final List<DateTime> evaluationHistory =
        _coachEvaluationHistory.putIfAbsent(sessionId, () => <DateTime>[])
          ..removeWhere(
            (DateTime timestamp) =>
                now.difference(timestamp) >= const Duration(minutes: 1),
          );
    if (evaluationHistory.length >= coachCatalog.maxEvaluationsPerMinute) {
      _diagnosticSink(
        'pinkall.coach skipped session=$sessionId '
        'reason=evaluation_rate_limit',
      );
      return false;
    }
    final List<CoachRecommendation> candidates = coachCatalog.candidatesFor(
      mode: mode,
      latestText: latest.text,
    );
    if (candidates.isEmpty) {
      _diagnosticSink(
        'pinkall.coach skipped session=$sessionId reason=no_eligible_candidate',
      );
      return false;
    }
    _coachRequestsInFlight.add(sessionId);
    evaluationHistory.add(now);
    _emitCoachStatus(sessionId, status: 'analyzing');
    unawaited(
      _runCoachEvaluation(
        _CoachEvaluation(
          sessionId: sessionId,
          mode: mode,
          preparationMarkdown: composeUntrustedCoachingContextMarkdown(
            workspaceSalesContext: session.workspaceSalesContext,
            callPreparationMarkdown: session.preparationMarkdown,
          ),
          transcript: store
              .transcript(sessionId)
              .where((TranscriptSegment item) => item.isFinal)
              .toList(growable: false),
          triggeringSegment: latest,
          candidates: candidates,
          suggestionHistory: suggestionHistory,
          speculation: speculation,
          requestStartedAt: now,
        ),
      ),
    );
    return true;
  }

  Future<void> _runCoachEvaluation(_CoachEvaluation evaluation) async {
    final Stopwatch modelLatency = Stopwatch()..start();
    DateTime? modelCompletedAt;
    DateTime? deliveredAt;
    String outcome = 'failed';
    try {
      final CoachSelection selection = await coachGateway.select(
        sessionId: evaluation.sessionId,
        transcript: evaluation.transcript,
        triggeringSegment: evaluation.triggeringSegment,
        candidates: evaluation.candidates,
        preparationMarkdown: evaluation.preparationMarkdown,
      );
      modelLatency.stop();
      modelCompletedAt = DateTime.now().toUtc();
      final _SpeculativeCoachTurn? speculation = evaluation.speculation;
      if (speculation != null && !await speculation.confirmation) {
        outcome = speculation.cancelReason ?? 'speculation_cancelled';
        _emitCoachStatus(
          evaluation.sessionId,
          status: 'listening',
          outcome: 'resumed',
        );
        return;
      }
      final CallSessionSnapshot? current = store.session(evaluation.sessionId);
      if (current == null ||
          current.status != SessionStatus.streaming ||
          current.coachMode != evaluation.mode) {
        outcome = 'stale_session';
        return;
      }
      final _CoachEvaluationResult result = _applyCoachSelection(
        evaluation,
        selection,
        modelLatency: modelLatency.elapsed,
      );
      outcome = result.outcome;
      deliveredAt = result.deliveredAt;
    } on Object catch (error) {
      if (modelLatency.isRunning) {
        modelLatency.stop();
      }
      outcome = 'failed';
      _diagnosticSink(
        'pinkall.coach failed session=${evaluation.sessionId} '
        'candidate_count=${evaluation.candidates.length} '
        'latency_ms=${modelLatency.elapsedMilliseconds} '
        'error=${error.runtimeType}',
      );
      _emitCoachStatus(
        evaluation.sessionId,
        status: 'listening',
        outcome: 'failed',
      );
    } finally {
      if (modelLatency.isRunning) {
        modelLatency.stop();
      }
      _recordCoachLatency(
        evaluation,
        outcome: outcome,
        modelLatency: modelLatency.elapsed,
        modelCompletedAt: modelCompletedAt,
        deliveredAt: deliveredAt,
      );
      _coachRequestsInFlight.remove(evaluation.sessionId);
      final _PendingCoachTurn? pending = _pendingCoachTurns.remove(
        evaluation.sessionId,
      );
      final bool retryCancelledSpeculationWithFinal =
          evaluation.speculation?.isCancelled == true &&
          pending?.speculation == null;
      final bool pendingIsNewSpeculation =
          pending?.speculation != null &&
          !identical(pending?.speculation, evaluation.speculation);
      if (pending != null &&
          (pending.segment.id != evaluation.triggeringSegment.id ||
              retryCancelledSpeculationWithFinal ||
              pendingIsNewSpeculation)) {
        scheduleMicrotask(
          () => _maybeCoach(
            evaluation.sessionId,
            pending.segment,
            speculation: pending.speculation,
          ),
        );
      }
    }
  }

  _CoachEvaluationResult _applyCoachSelection(
    _CoachEvaluation evaluation,
    CoachSelection selection, {
    required Duration modelLatency,
  }) {
    final Set<String> candidateIds = evaluation.candidates
        .map((CoachRecommendation candidate) => candidate.id)
        .toSet();
    final String? selectedId = selection.recommendationId;
    if (selectedId == null) {
      _logCoachDecision(
        sessionId: evaluation.sessionId,
        outcome: 'model_selected_none',
        selection: selection,
        candidateCount: evaluation.candidates.length,
        allowedRecommendationIds: candidateIds,
        latency: modelLatency,
        minimumConfidence: max(
          config.coachMinimumConfidence,
          coachCatalog.minimumLiveConfidence,
        ),
        minimumContextMatch: coachCatalog.minimumContextMatch,
      );
      _emitCoachStatus(
        evaluation.sessionId,
        status: 'listening',
        outcome: 'none',
      );
      return const _CoachEvaluationResult(outcome: 'model_selected_none');
    }
    final CoachRecommendation? recommendation = evaluation.candidates
        .cast<CoachRecommendation?>()
        .firstWhere(
          (CoachRecommendation? item) => item?.id == selectedId,
          orElse: () => null,
        );
    if (recommendation == null) {
      _logCoachDecision(
        sessionId: evaluation.sessionId,
        outcome: 'invalid_recommendation',
        selection: selection,
        candidateCount: evaluation.candidates.length,
        allowedRecommendationIds: candidateIds,
        latency: modelLatency,
      );
      throw StateError(
        'Coach selected a recommendation outside the eligible set.',
      );
    }
    final double minimumConfidence = max(
      max(config.coachMinimumConfidence, coachCatalog.minimumLiveConfidence),
      _recommendationThreshold(recommendation, 'live_minimum'),
    );
    final double minimumContextMatch = max(
      coachCatalog.minimumContextMatch,
      _recommendationThreshold(recommendation, 'context_minimum'),
    );
    if (selection.confidence < minimumConfidence ||
        selection.contextMatch < minimumContextMatch) {
      _logCoachDecision(
        sessionId: evaluation.sessionId,
        outcome: 'below_quality_threshold',
        selection: selection,
        candidateCount: evaluation.candidates.length,
        allowedRecommendationIds: candidateIds,
        latency: modelLatency,
        minimumConfidence: minimumConfidence,
        minimumContextMatch: minimumContextMatch,
      );
      _emitCoachStatus(
        evaluation.sessionId,
        status: 'listening',
        outcome: 'filtered',
      );
      return const _CoachEvaluationResult(outcome: 'below_quality_threshold');
    }
    final Set<String> finalSegmentIds = store
        .transcript(evaluation.sessionId)
        .where((TranscriptSegment item) => item.isFinal)
        .map((TranscriptSegment item) => item.id)
        .toSet();
    if (selection.evidenceSegmentIds.isEmpty ||
        selection.evidenceSegmentIds.any(
          (String id) => !finalSegmentIds.contains(id),
        )) {
      _logCoachDecision(
        sessionId: evaluation.sessionId,
        outcome: 'invalid_evidence',
        selection: selection,
        candidateCount: evaluation.candidates.length,
        allowedRecommendationIds: candidateIds,
        latency: modelLatency,
        minimumConfidence: minimumConfidence,
        minimumContextMatch: minimumContextMatch,
      );
      _emitCoachStatus(
        evaluation.sessionId,
        status: 'listening',
        outcome: 'filtered',
      );
      return const _CoachEvaluationResult(outcome: 'invalid_evidence');
    }
    final String decisionOutcome = evaluation.mode == CoachMode.shadow
        ? 'shadow_suggestion'
        : 'suggestion';
    _logCoachDecision(
      sessionId: evaluation.sessionId,
      outcome: decisionOutcome,
      selection: selection,
      candidateCount: evaluation.candidates.length,
      allowedRecommendationIds: candidateIds,
      latency: modelLatency,
      minimumConfidence: minimumConfidence,
      minimumContextMatch: minimumContextMatch,
    );
    if (evaluation.mode == CoachMode.shadow) {
      evaluation.suggestionHistory.add(DateTime.now().toUtc());
      store.recordShadowGeneration();
      _emitCoachStatus(
        evaluation.sessionId,
        status: 'listening',
        outcome: 'suggestion',
      );
      _persistCoachState(evaluation.sessionId);
      return const _CoachEvaluationResult(outcome: 'shadow_suggestion');
    }
    return _publishCoachSuggestion(evaluation, selection, recommendation);
  }

  _CoachEvaluationResult _publishCoachSuggestion(
    _CoachEvaluation evaluation,
    CoachSelection selection,
    CoachRecommendation recommendation,
  ) {
    final String suggestionId = _randomId('sug');
    final DateTime createdAt = DateTime.now().toUtc();
    final DateTime expiresAt = createdAt.add(
      Duration(
        seconds: _expirySeconds(
          recommendation,
          coachCatalog.defaultExpirySeconds,
        ),
      ),
    );
    _lastCoachExposure[evaluation.sessionId] = createdAt;
    evaluation.suggestionHistory.add(createdAt);
    store.recordExposure(suggestionId);
    store.emit(
      ClientEvent(
        type: 'coaching_suggestion',
        sessionId: evaluation.sessionId,
        at: createdAt,
        data: <String, Object?>{
          'id': suggestionId,
          'session_id': evaluation.sessionId,
          'suggestion_id': suggestionId,
          'recommendation_id': recommendation.id,
          'kind': _suggestionKind(recommendation),
          'text': recommendation.message,
          'message': recommendation.message,
          'source_ids': recommendation.sourceIds,
          'sources': recommendation.sources
              .map((CoachSource source) => source.toClientJson())
              .toList(growable: false),
          'confidence': selection.confidence,
          'context_match': selection.contextMatch,
          'rationale': selection.rationale,
          'evidence_segment_ids': selection.evidenceSegmentIds,
          'reason_code': selection.reasonCode,
          'trigger_signal': selection.triggerSignal,
          'release_channel': coachCatalog.releaseChannel.wireName,
          'unreviewed_catalog_enabled':
              coachCatalog.allowsUnreviewedRecommendations,
          'created_at': createdAt.toIso8601String(),
          'expires_at': expiresAt.toIso8601String(),
        },
      ),
    );
    _emitCoachStatus(
      evaluation.sessionId,
      status: 'listening',
      outcome: 'suggestion',
    );
    _persistCoachState(evaluation.sessionId);
    return _CoachEvaluationResult(
      outcome: 'suggestion',
      deliveredAt: createdAt,
    );
  }

  void _persistCoachState(String sessionId) {
    unawaited(
      Future<void>.sync(store.flush).catchError((Object error) {
        _diagnosticSink(
          'pinkall.coach durability_failed session=$sessionId '
          'code=${store.durabilityFailureCode ?? 'unknown'} '
          'error=${error.runtimeType}',
        );
      }),
    );
  }

  void _recordCoachLatency(
    _CoachEvaluation evaluation, {
    required String outcome,
    required Duration modelLatency,
    required DateTime? modelCompletedAt,
    required DateTime? deliveredAt,
  }) {
    final _SpeculativeCoachTurn? speculation = evaluation.speculation;
    final DateTime triggerAt =
        speculation?.triggeredAt ?? evaluation.requestStartedAt;
    final DateTime finalAt =
        speculation?.confirmedAt ?? evaluation.requestStartedAt;
    final Duration? finalToEmit = deliveredAt == null
        ? null
        : _nonNegativeDuration(deliveredAt.difference(finalAt));
    final Duration? eagerToEmit = deliveredAt == null || speculation == null
        ? null
        : _nonNegativeDuration(deliveredAt.difference(triggerAt));
    final Duration? confirmationWait =
        speculation?.confirmedAt == null || modelCompletedAt == null
        ? null
        : _nonNegativeDuration(
            speculation!.confirmedAt!.difference(modelCompletedAt),
          );
    final Duration? modelAfterConfirmation =
        speculation?.confirmedAt == null || modelCompletedAt == null
        ? null
        : _nonNegativeDuration(
            modelCompletedAt.difference(speculation!.confirmedAt!),
          );
    _coachLatencyMetrics.recordEvaluation(
      outcome: outcome,
      modelLatency: modelLatency,
      finalToEmit: finalToEmit,
    );
    final Map<String, Object?> diagnostic = <String, Object?>{
      'trigger': speculation == null ? 'final_eot' : 'eager_eot',
      'outcome': outcome,
      'model_ms': modelLatency.inMilliseconds,
      'trigger_to_request_ms': _nonNegativeDuration(
        evaluation.requestStartedAt.difference(triggerAt),
      ).inMilliseconds,
      if (confirmationWait != null)
        'confirmation_wait_ms': confirmationWait.inMilliseconds,
      if (modelAfterConfirmation != null)
        'model_after_confirmation_ms': modelAfterConfirmation.inMilliseconds,
      if (finalToEmit != null) 'final_to_emit_ms': finalToEmit.inMilliseconds,
      if (eagerToEmit != null) 'eager_to_emit_ms': eagerToEmit.inMilliseconds,
    };
    _diagnosticSink(
      'pinkall.coach latency session=${evaluation.sessionId} '
      '${jsonEncode(diagnostic)}',
    );
  }

  void _emitCoachStatus(
    String sessionId, {
    required String status,
    String? outcome,
  }) {
    final DateTime now = DateTime.now().toUtc();
    store.emit(
      ClientEvent(
        type: 'coach_status',
        sessionId: sessionId,
        at: now,
        data: <String, Object?>{
          'status': status,
          if (outcome != null) 'outcome': outcome,
          'at': now.toIso8601String(),
        },
      ),
    );
  }

  void _logCoachDecision({
    required String sessionId,
    required String outcome,
    required CoachSelection selection,
    required int candidateCount,
    required Set<String> allowedRecommendationIds,
    required Duration latency,
    double? minimumConfidence,
    double? minimumContextMatch,
  }) {
    final Map<String, Object?> diagnostic = <String, Object?>{
      'outcome': outcome,
      'candidate_count': candidateCount,
      'latency_ms': latency.inMilliseconds,
      ...selection.toSafeDiagnosticJson(
        allowedRecommendationIds: allowedRecommendationIds,
      ),
      'confidence': selection.confidence,
      'context_match': selection.contextMatch,
      if (minimumConfidence != null) 'minimum_confidence': minimumConfidence,
      if (minimumContextMatch != null)
        'minimum_context_match': minimumContextMatch,
    };
    _diagnosticSink(
      'pinkall.coach decision session=$sessionId ${jsonEncode(diagnostic)}',
    );
  }

  Future<void> _closeRuntime(_MediaRuntime runtime) {
    final Future<void>? existing = runtime.closeJob;
    if (existing != null) {
      return existing;
    }
    final Future<void> job = _performCloseRuntime(runtime);
    runtime.closeJob = job;
    return job;
  }

  void _scheduleRealtimeRecovery(
    _MediaRuntime runtime,
    MediaTrack track, {
    required String reason,
    Object? error,
  }) {
    _cancelSpeculativeCoachTurn(
      runtime,
      track,
      providerTurnId: null,
      reason: 'provider_recovery',
    );
    if (!runtime.closing && runtime.partials.containsKey(track)) {
      // Keep the current turn across the provider reconnect. A transport
      // failure is not evidence that the speaker stopped talking.
      runtime.partials[track]?.promotePendingDelta();
      _schedulePartialCommit(runtime, track);
    }
    final RealtimeSttSession? session = runtime.providerSessions.remove(track);
    final StreamSubscription<SttEvent>? subscription = runtime.subscriptions
        .remove(track);
    final _RealtimeRecoveryState recovery = runtime.realtimeRecovery
        .putIfAbsent(track, _RealtimeRecoveryState.new);
    if (session != null || subscription != null) {
      final Future<void> cleanupJob = _closeProviderSession(
        runtime,
        track,
        session,
        subscription,
      );
      recovery.cleanupJob = cleanupJob;
      unawaited(
        cleanupJob.whenComplete(() {
          if (identical(recovery.cleanupJob, cleanupJob)) {
            recovery.cleanupJob = null;
          }
        }),
      );
    }
    if (runtime.closing || recovery.exhausted) {
      return;
    }
    recovery.consecutiveFailures += 1;
    if (recovery.consecutiveFailures >= realtimeMaxConsecutiveFailures) {
      recovery
        ..exhausted = true
        ..retryAfter = null;
    } else {
      final int exponent = min(recovery.consecutiveFailures - 1, 5);
      final int multiplier = 1 << exponent;
      recovery.retryAfter = DateTime.now().toUtc().add(
        realtimeRetryBaseDelay * multiplier,
      );
    }
    final String errorDiagnostic = error == null
        ? ''
        : ' error=${error.runtimeType} detail=${_safeDiagnostic(error)}';
    final int retryInMilliseconds = recovery.retryAfter == null
        ? 0
        : max(
            0,
            recovery.retryAfter!
                .difference(DateTime.now().toUtc())
                .inMilliseconds,
          );
    _diagnosticSink(
      'pinkall.stt ${recovery.exhausted ? 'realtime_exhausted' : 'realtime_retry_scheduled'} '
      'session=${runtime.sessionId} track=${track.name} reason=$reason '
      'failure=${recovery.consecutiveFailures} '
      'retry_in_ms=$retryInMilliseconds$errorDiagnostic',
    );
  }

  Future<void> _closeProviderSession(
    _MediaRuntime runtime,
    MediaTrack track,
    RealtimeSttSession? session,
    StreamSubscription<SttEvent>? subscription,
  ) async {
    if (subscription != null) {
      try {
        await subscription.cancel().timeout(realtimeCleanupTimeout);
      } on Object catch (error) {
        _diagnosticSink(
          'pinkall.stt subscription_cancel_failed '
          'session=${runtime.sessionId} track=${track.name} '
          'error=${error.runtimeType}',
        );
      }
    }
    if (session != null) {
      try {
        await session.close().timeout(realtimeCleanupTimeout);
      } on Object catch (error) {
        _diagnosticSink(
          'pinkall.stt recovery_close_failed session=${runtime.sessionId} '
          'track=${track.name} error=${error.runtimeType}',
        );
      }
    }
  }

  Future<void> _performCloseRuntime(_MediaRuntime runtime) async {
    runtime.closing = true;
    for (final MediaTrack track in runtime.speculativeCoachTurns.keys.toList(
      growable: false,
    )) {
      _cancelSpeculativeCoachTurn(
        runtime,
        track,
        providerTurnId: null,
        reason: 'runtime_closed',
      );
    }
    for (final MediaTrack track in runtime.partialCommitTimers.keys.toList()) {
      _cancelPartialCommit(runtime, track);
    }
    for (final MediaTrack track
        in runtime.turnAwareWatchdogTimers.keys.toList()) {
      _cancelTurnAwareWatchdog(runtime, track);
    }
    final List<Future<RealtimeSttSession?>> openingJobs = runtime
        .providerOpeningJobs
        .values
        .toList(growable: false);
    if (openingJobs.isNotEmpty) {
      await Future.wait(
        openingJobs.map((Future<RealtimeSttSession?> job) async {
          try {
            await job;
          } on Object {
            // Opening is fail-soft and the batch buffer is already complete.
          }
        }),
      );
    }
    final List<Future<void>> cleanupJobs = runtime.realtimeRecovery.values
        .map((_RealtimeRecoveryState state) => state.cleanupJob)
        .whereType<Future<void>>()
        .toList(growable: false);
    if (cleanupJobs.isNotEmpty) {
      await Future.wait(cleanupJobs);
    }
    for (final MapEntry<MediaTrack, RealtimeSttSession> entry
        in runtime.providerSessions.entries) {
      try {
        await entry.value.close();
      } on Object catch (error) {
        _diagnosticSink(
          'pinkall.stt session_close_failed session=${runtime.sessionId} '
          'track=${entry.key.name} error=${error.runtimeType}',
        );
      }
    }
    for (final MapEntry<MediaTrack, StreamSubscription<SttEvent>> entry
        in runtime.subscriptions.entries) {
      try {
        await entry.value.cancel();
      } on Object catch (error) {
        _diagnosticSink(
          'pinkall.stt subscription_cancel_failed '
          'session=${runtime.sessionId} track=${entry.key.name} '
          'error=${error.runtimeType}',
        );
      }
    }
    for (final MediaTrack track in runtime.partials.keys.toList()) {
      _commitPartialTurn(runtime, track);
    }
  }

  void _assertCoachCanRun(CoachMode mode) {
    if (mode == CoachMode.off) {
      return;
    }
    if (!coachGateway.isConfigured) {
      throw StateError('Coach provider is not configured.');
    }
    if (!coachCatalog.isAvailable) {
      throw StateError(coachCatalog.unavailableReason ?? 'Coach unavailable.');
    }
    final List<CoachRecommendation> approved = coachCatalog.candidatesFor(
      mode: mode,
      latestText: '',
    );
    if (approved.isEmpty) {
      throw StateError(
        'No ${mode.name} recommendation is eligible for '
        'COACH_RELEASE_CHANNEL=${coachCatalog.releaseChannel.wireName}.',
      );
    }
  }

  CallSessionSnapshot _requiredSession(String id) {
    final CallSessionSnapshot? session = store.session(id);
    if (session == null) {
      throw StateError('Session not found: $id');
    }
    return session;
  }

  static String _randomId(String prefix) {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(
      18,
      (int _) => random.nextInt(256),
      growable: false,
    );
    return '${prefix}_${base64UrlEncode(bytes).replaceAll('=', '')}';
  }

  static int _expirySeconds(CoachRecommendation recommendation, int fallback) {
    final Object? value = recommendation.raw['expires_in_seconds'];
    return value is num && value.toInt() > 0 ? value.toInt() : fallback;
  }

  static double _recommendationThreshold(
    CoachRecommendation recommendation,
    String key,
  ) {
    final Object? rawConfidence = recommendation.raw['confidence'];
    if (rawConfidence is! Map<String, Object?>) {
      return 0;
    }
    final Object? value = rawConfidence[key];
    return value is num ? value.toDouble().clamp(0, 1) : 0;
  }

  static String _suggestionKind(CoachRecommendation recommendation) {
    final Object? action = recommendation.raw['action'];
    final String type =
        action is Map<String, Object?> && action['type'] is String
        ? (action['type']! as String).toLowerCase()
        : '';
    if (type.contains('objection')) {
      return 'objection_handling';
    }
    if (type.contains('next_step')) {
      return 'next_step';
    }
    if (type.contains('listen')) {
      return 'listen';
    }
    if (type.contains('clarif') || type.contains('context')) {
      return 'clarification';
    }
    return 'next_question';
  }

  static String _joinTurnText(String left, String right) {
    final String before = left.trim();
    final String after = right.trim();
    if (before.isEmpty) {
      return after;
    }
    if (after.isEmpty) {
      return before;
    }
    final String separator = RegExp(r'^[,.;:!?)]').hasMatch(after) ? '' : ' ';
    return '$before$separator$after'.replaceAll(RegExp(r'\s+'), ' ');
  }

  static String _normalizeSpeculativeTurn(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp('[’`´]'), "'")
        .replaceAll(RegExp(r'''[.,!?;:"“”«»…()\[\]{}]'''), '')
        .replaceAll(RegExp(r'[-–—]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static Duration _nonNegativeDuration(Duration value) =>
      value.isNegative ? Duration.zero : value;

  static String _safeDiagnostic(Object error) {
    String value = error.toString();
    value = value.replaceAll(
      RegExp(r'bearer\s+[^\s,;]+', caseSensitive: false),
      'Bearer [redacted]',
    );
    value = value.replaceAll(
      RegExp(
        r'(api[_-]?key|authorization|token)\s*[:=]\s*[^\s,;&]+',
        caseSensitive: false,
      ),
      '[redacted credential]',
    );
    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    return value.length <= 320 ? value : '${value.substring(0, 320)}…';
  }

  static String _safeTelemetryEvent(String event) {
    return RegExp(r'^[A-Za-z][A-Za-z0-9_]{0,47}$').hasMatch(event)
        ? event
        : 'invalid';
  }

  static const Set<String> _loggedTurnTelemetryEvents = <String>{
    'StartOfTurn',
    'EagerEndOfTurn',
    'TurnResumed',
    'EndOfTurn',
  };

  static void _writeDiagnostic(String message) => stderr.writeln(message);
}

final class _PendingCoachTurn {
  const _PendingCoachTurn({required this.segment, this.speculation});

  final TranscriptSegment segment;
  final _SpeculativeCoachTurn? speculation;
}

final class _SpeculativeCoachTurn {
  _SpeculativeCoachTurn({
    required this.providerTurnId,
    required this.segmentId,
    required this.triggerText,
    required this.triggeredAt,
  });

  final String? providerTurnId;
  final String segmentId;
  final String triggerText;
  final DateTime triggeredAt;
  final Completer<bool> _confirmation = Completer<bool>();
  DateTime? confirmedAt;
  String? cancelReason;
  bool? _confirmed;

  Future<bool> get confirmation => _confirmation.future;

  bool get isResolved => _confirmation.isCompleted;

  bool get isCancelled => _confirmed == false;

  bool confirm({required DateTime at}) {
    if (_confirmation.isCompleted) {
      return false;
    }
    _confirmed = true;
    confirmedAt = at;
    _confirmation.complete(true);
    return true;
  }

  bool cancel({required String reason}) {
    if (_confirmation.isCompleted) {
      return false;
    }
    _confirmed = false;
    cancelReason = reason;
    _confirmation.complete(false);
    return true;
  }
}

final class _CoachEvaluation {
  const _CoachEvaluation({
    required this.sessionId,
    required this.mode,
    required this.preparationMarkdown,
    required this.transcript,
    required this.triggeringSegment,
    required this.candidates,
    required this.suggestionHistory,
    required this.speculation,
    required this.requestStartedAt,
  });

  final String sessionId;
  final CoachMode mode;
  final String? preparationMarkdown;
  final List<TranscriptSegment> transcript;
  final TranscriptSegment triggeringSegment;
  final List<CoachRecommendation> candidates;
  final List<DateTime> suggestionHistory;
  final _SpeculativeCoachTurn? speculation;
  final DateTime requestStartedAt;
}

final class _CoachEvaluationResult {
  const _CoachEvaluationResult({required this.outcome, this.deliveredAt});

  final String outcome;
  final DateTime? deliveredAt;
}

final class _CoachLatencyMetrics {
  final _RollingLatency _modelLatency = _RollingLatency();
  final _RollingLatency _finalToEmit = _RollingLatency();
  final _RollingLatency _eagerToFinal = _RollingLatency();
  final Map<String, int> _outcomes = <String, int>{};
  int _evaluations = 0;
  int _delivered = 0;
  int _speculativeStarts = 0;
  int _speculativeCancellations = 0;

  void recordSpeculativeStart() {
    _speculativeStarts += 1;
  }

  void recordSpeculativeCancellation() {
    _speculativeCancellations += 1;
  }

  void recordEagerToFinal(Duration latency) {
    _eagerToFinal.add(latency);
  }

  void recordEvaluation({
    required String outcome,
    required Duration modelLatency,
    required Duration? finalToEmit,
  }) {
    _evaluations += 1;
    _modelLatency.add(modelLatency);
    _outcomes.update(outcome, (int count) => count + 1, ifAbsent: () => 1);
    if (finalToEmit != null) {
      _delivered += 1;
      _finalToEmit.add(finalToEmit);
    }
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'scope': 'process_lifetime',
      'evaluations': _evaluations,
      'delivered': _delivered,
      'model_ms': _modelLatency.toJson(),
      'final_to_emit_ms': _finalToEmit.toJson(),
      'speculative': <String, Object?>{
        'started': _speculativeStarts,
        'cancelled': _speculativeCancellations,
        'eager_to_final_ms': _eagerToFinal.toJson(),
      },
      'outcomes': Map<String, int>.unmodifiable(_outcomes),
    };
  }
}

final class _RollingLatency {
  static const int _capacity = 256;
  final List<int> _milliseconds = <int>[];

  void add(Duration latency) {
    if (_milliseconds.length == _capacity) {
      _milliseconds.removeAt(0);
    }
    _milliseconds.add(max(0, latency.inMilliseconds));
  }

  Map<String, Object?> toJson() {
    if (_milliseconds.isEmpty) {
      return const <String, Object?>{
        'count': 0,
        'p50': null,
        'p95': null,
        'max': null,
      };
    }
    final List<int> sorted = List<int>.of(_milliseconds)..sort();
    int percentile(double value) =>
        sorted[((sorted.length - 1) * value).round()];
    return <String, Object?>{
      'count': sorted.length,
      'p50': percentile(0.5),
      'p95': percentile(0.95),
      'max': sorted.last,
    };
  }
}

enum _MediaRuntimeSource { telnyx, externalClient }

final class _MediaRuntime {
  _MediaRuntime({
    required this.sessionId,
    required this.sourceEncoding,
    required this.pcmFormat,
    required this.source,
  });

  final String sessionId;
  final String sourceEncoding;
  final SttAudioFormat pcmFormat;
  final _MediaRuntimeSource source;
  final Set<MediaTrack> connectedExternalTracks = <MediaTrack>{};
  final Map<MediaTrack, RealtimeSttSession> providerSessions =
      <MediaTrack, RealtimeSttSession>{};
  final Map<MediaTrack, StreamSubscription<SttEvent>> subscriptions =
      <MediaTrack, StreamSubscription<SttEvent>>{};
  final Map<MediaTrack, int> providerEpochs = <MediaTrack, int>{};
  final Map<MediaTrack, _PartialTranscript> partials =
      <MediaTrack, _PartialTranscript>{};
  final Map<MediaTrack, _SpeculativeCoachTurn> speculativeCoachTurns =
      <MediaTrack, _SpeculativeCoachTurn>{};
  final Map<MediaTrack, int> finalSegmentCounts = <MediaTrack, int>{};
  final Map<MediaTrack, double> lastEndSeconds = <MediaTrack, double>{};
  final Map<MediaTrack, double> lastAudioEndSeconds = <MediaTrack, double>{};
  final Map<MediaTrack, Timer> partialCommitTimers = <MediaTrack, Timer>{};
  final Map<MediaTrack, int> partialCommitGenerations = <MediaTrack, int>{};
  final Map<MediaTrack, Timer> turnAwareWatchdogTimers = <MediaTrack, Timer>{};
  final Map<MediaTrack, int> turnAwareWatchdogGenerations = <MediaTrack, int>{};
  final Map<MediaTrack, Future<RealtimeSttSession?>> providerOpeningJobs =
      <MediaTrack, Future<RealtimeSttSession?>>{};
  final Map<MediaTrack, _RealtimeRecoveryState> realtimeRecovery =
      <MediaTrack, _RealtimeRecoveryState>{};
  final Completer<void> mediaEnded = Completer<void>();
  Future<void>? closeJob;
  bool closing = false;

  void markMediaEnded() {
    if (!mediaEnded.isCompleted) {
      mediaEnded.complete();
    }
  }
}

final class _RealtimeRecoveryState {
  int consecutiveFailures = 0;
  DateTime? retryAfter;
  Future<void>? cleanupJob;
  bool exhausted = false;
}

final class _PartialTranscript {
  _PartialTranscript({
    required this.id,
    required this.createdAt,
    required this.startSeconds,
  });

  final String id;
  final DateTime createdAt;
  double startSeconds;
  double? _confirmedEndSeconds;
  int? _confirmedEpoch;
  String? _providerTurnId;
  String _confirmedText = '';
  String _pendingDelta = '';

  String get confirmedText => _confirmedText;

  String get text =>
      SessionService._joinTurnText(_confirmedText, _pendingDelta);

  bool get hasConfirmedText => _confirmedText.trim().isNotEmpty;

  bool get hasConfirmedTiming => _confirmedEndSeconds != null;

  int? get confirmedEpoch => _confirmedEpoch;

  double get confirmedEndSeconds => _confirmedEndSeconds ?? startSeconds;

  double get endSeconds => _confirmedEndSeconds ?? startSeconds;

  String? get providerTurnId => _providerTurnId;

  void appendDelta(String delta) {
    if (delta.isEmpty) {
      return;
    }
    _pendingDelta = '$_pendingDelta$delta';
  }

  void acceptSegment({
    required String text,
    required double startSeconds,
    required double endSeconds,
    required int providerEpoch,
    String? providerTurnId,
  }) {
    final String stable = text.trim();
    if (stable.isEmpty) {
      return;
    }
    if (_confirmedText.isEmpty) {
      this.startSeconds = startSeconds;
    }
    _confirmedText = SessionService._joinTurnText(_confirmedText, stable);
    _pendingDelta = '';
    _confirmedEpoch = providerEpoch;
    _providerTurnId = providerTurnId ?? _providerTurnId;
    _confirmedEndSeconds = max(
      _confirmedEndSeconds ?? startSeconds,
      endSeconds,
    );
  }

  void acceptDoneFallback(String fullTrackText) {
    final String stable = fullTrackText.trim();
    if (stable.isEmpty) {
      return;
    }
    _confirmedText = stable;
    _pendingDelta = '';
  }

  void promotePendingDelta() {
    if (_pendingDelta.trim().isEmpty) {
      return;
    }
    _confirmedText = SessionService._joinTurnText(
      _confirmedText,
      _pendingDelta,
    );
    _pendingDelta = '';
  }
}

final class _TrackBatchResult {
  const _TrackBatchResult({
    required this.track,
    required this.transcript,
    required this.audioDurationSeconds,
  });

  final MediaTrack track;
  final BatchTranscript transcript;
  final double audioDurationSeconds;
}
