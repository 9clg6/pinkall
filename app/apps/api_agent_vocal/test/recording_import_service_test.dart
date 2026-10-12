import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/application/post_call_service.dart';
import 'package:api_agent_vocal/src/application/recording_import_service.dart';
import 'package:api_agent_vocal/src/application/session_service.dart';
import 'package:api_agent_vocal/src/config/app_config.dart';
import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_contracts.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/recording_transcription_contracts.dart';
import 'package:api_agent_vocal/src/domain/stt_contracts.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:test/test.dart';

void main() {
  test(
    'requires consent, exposes only A/B voices, then assigns real roles',
    () async {
      final _QueueRecordingProvider provider = _QueueRecordingProvider(
        <Future<DiarizedRecordingTranscript> Function()>[
          () async => _transcript(),
        ],
      );
      final _Harness harness = await _createHarness(provider);
      addTearDown(harness.dispose);

      final RecordingImportSnapshot created = await harness.imports.create(
        fileName: 'appel.m4a',
        mimeType: 'audio/x-m4a',
        sizeBytes: 8,
        title: 'Discovery Acme',
        locale: 'fr-FR',
        preparationMarkdown: '# Objectif\r\nQualifier le besoin.',
      );
      expect(created.status, RecordingImportStatus.awaitingConsent);
      expect(
        harness.store.session(created.sessionId)!.coachMode,
        CoachMode.off,
      );
      expect(
        harness.store.session(created.sessionId)!.preparationMarkdown,
        '# Objectif\nQualifier le besoin.',
      );

      await expectLater(
        harness.imports.upload(
          importId: created.id,
          mimeType: 'audio/mp4',
          contentLength: 8,
          bytes: Stream<List<int>>.value(<int>[1, 2, 3, 4, 5, 6, 7, 8]),
        ),
        throwsA(
          isA<RecordingImportException>().having(
            (RecordingImportException error) => error.code,
            'code',
            'consent_required',
          ),
        ),
      );
      expect(provider.calls, 0);

      harness.sessions.acknowledgeTranscriptionConsent(
        sessionId: created.sessionId,
        method: 'verbal_notice',
        acknowledgedAt: DateTime.now().toUtc(),
      );
      expect(
        harness.imports.get(created.id).status,
        RecordingImportStatus.awaitingUpload,
      );
      final List<int> audio = <int>[1, 2, 3, 4, 5, 6, 7, 8];
      final RecordingImportSnapshot uploading = await harness.imports.upload(
        importId: created.id,
        mimeType: 'audio/mp4',
        contentLength: audio.length,
        bytes: Stream<List<int>>.fromIterable(<List<int>>[
          audio.sublist(0, 4),
          audio.sublist(4),
        ]),
      );
      expect(
        uploading.status,
        anyOf(
          RecordingImportStatus.transcribing,
          RecordingImportStatus.awaitingSpeakerAssignment,
        ),
      );
      await _waitUntil(
        () =>
            harness.imports.get(created.id).status ==
            RecordingImportStatus.awaitingSpeakerAssignment,
      );
      final RecordingImportSnapshot provisional = harness.imports.get(
        created.id,
      );
      expect(provisional.voices, <String>['A', 'B']);
      expect(
        provisional.provisionalSegments.map(
          (ProvisionalRecordingSegment item) => item.voice,
        ),
        <String>['A', 'B', 'A'],
      );
      final String provisionalJson = jsonEncode(provisional.toJson());
      expect(provisionalJson, isNot(contains('seller')));
      expect(provisionalJson, isNot(contains('prospect')));
      expect(provisionalJson, isNot(contains('track')));
      final String durableJson = jsonEncode(
        harness.store.exportDurableSnapshot(),
      );
      expect(durableJson, isNot(contains(base64Encode(audio))));
      expect(durableJson, isNot(contains('Bonjour, je vous appelle.')));
      expect(await harness.stagingRoot.list().toList(), isEmpty);

      expect(
        () => harness.imports.assignUserVoice(
          importId: created.id,
          userVoice: 'C',
        ),
        throwsA(
          isA<RecordingImportException>().having(
            (RecordingImportException error) => error.code,
            'code',
            'unknown_user_voice',
          ),
        ),
      );
      final RecordingImportSnapshot finalized = await harness.imports
          .assignUserVoice(importId: created.id, userVoice: 'b');
      expect(finalized.status, RecordingImportStatus.finalized);
      expect(finalized.debriefStatus, RecordingImportDebriefStatus.unavailable);
      expect(
        harness.store.session(created.sessionId)!.status,
        SessionStatus.finalized,
      );
      final List<TranscriptSegment> finalTranscript = harness.store
          .finalTranscript(created.sessionId)!;
      expect(
        finalTranscript
            .where((TranscriptSegment item) => item.text == 'Je vous écoute.')
            .single
            .speaker,
        SpeakerRole.seller,
      );
      expect(
        finalTranscript
            .where((TranscriptSegment item) => item.text.startsWith('Bonjour'))
            .single
            .speaker,
        SpeakerRole.prospect,
      );

      final RecordingImportSnapshot idempotent = await harness.imports
          .assignUserVoice(importId: created.id, userVoice: 'B');
      expect(idempotent.status, RecordingImportStatus.finalized);
      expect(
        () => harness.imports.assignUserVoice(
          importId: created.id,
          userVoice: 'A',
        ),
        throwsA(
          isA<RecordingImportException>().having(
            (RecordingImportException error) => error.code,
            'code',
            'speaker_assignment_conflict',
          ),
        ),
      );
    },
  );

  test('deletes failed audio and allows a complete re-upload', () async {
    final _QueueRecordingProvider provider = _QueueRecordingProvider(
      <Future<DiarizedRecordingTranscript> Function()>[
        () => throw const RecordedTranscriptionException(
          code: 'provider_rate_limited',
          message: 'Provider capacity is full.',
          retryable: true,
        ),
        () async => _transcript(),
      ],
    );
    final _Harness harness = await _createHarness(provider);
    addTearDown(harness.dispose);
    final RecordingImportSnapshot created = await _consentedImport(harness);

    await harness.imports.upload(
      importId: created.id,
      mimeType: 'audio/wav',
      contentLength: 4,
      bytes: Stream<List<int>>.value(<int>[0, 0, 0, 0]),
    );
    await _waitUntil(
      () =>
          harness.imports.get(created.id).status ==
          RecordingImportStatus.failed,
    );
    final RecordingImportSnapshot failed = harness.imports.get(created.id);
    expect(failed.failure?.code, 'provider_rate_limited');
    expect(failed.failure?.retryable, isTrue);
    expect(await harness.stagingRoot.list().toList(), isEmpty);

    await harness.imports.upload(
      importId: created.id,
      mimeType: 'audio/x-wav',
      contentLength: 4,
      bytes: Stream<List<int>>.value(<int>[1, 1, 1, 1]),
    );
    await _waitUntil(
      () =>
          harness.imports.get(created.id).status ==
          RecordingImportStatus.awaitingSpeakerAssignment,
    );
    expect(provider.calls, 2);
    expect(await harness.stagingRoot.list().toList(), isEmpty);
  });

  test(
    'never invokes final OpenAI analysis before explicit assignment',
    () async {
      final _QueueRecordingProvider provider = _QueueRecordingProvider(
        <Future<DiarizedRecordingTranscript> Function()>[
          () async => _transcript(),
        ],
      );
      final _RecordingPostCallGateway gateway = _RecordingPostCallGateway();
      final _Harness harness = await _createHarness(
        provider,
        postCallGateway: gateway,
      );
      addTearDown(harness.dispose);
      final RecordingImportSnapshot created = await _consentedImport(harness);

      await harness.imports.upload(
        importId: created.id,
        mimeType: 'audio/wav',
        contentLength: 4,
        bytes: Stream<List<int>>.value(<int>[0, 0, 0, 0]),
      );
      await _waitUntil(
        () =>
            harness.imports.get(created.id).status ==
            RecordingImportStatus.awaitingSpeakerAssignment,
      );
      expect(gateway.calls, 0);

      final RecordingImportSnapshot finalized = await harness.imports
          .assignUserVoice(importId: created.id, userVoice: 'A');
      expect(gateway.calls, 1);
      expect(finalized.debriefStatus, RecordingImportDebriefStatus.completed);
      expect(finalized.debrief?.provider, 'openai-test-double');
    },
  );

  test(
    'keeps the final transcript usable when the debrief provider fails',
    () async {
      final _QueueRecordingProvider provider = _QueueRecordingProvider(
        <Future<DiarizedRecordingTranscript> Function()>[
          () async => _transcript(),
        ],
      );
      final _Harness harness = await _createHarness(
        provider,
        postCallGateway: const _FailingPostCallGateway(),
      );
      addTearDown(harness.dispose);
      final RecordingImportSnapshot created = await _consentedImport(harness);

      await harness.imports.upload(
        importId: created.id,
        mimeType: 'audio/wav',
        contentLength: 4,
        bytes: Stream<List<int>>.value(<int>[0, 0, 0, 0]),
      );
      await _waitUntil(
        () =>
            harness.imports.get(created.id).status ==
            RecordingImportStatus.awaitingSpeakerAssignment,
      );

      final RecordingImportSnapshot finalized = await harness.imports
          .assignUserVoice(importId: created.id, userVoice: 'A');
      expect(finalized.status, RecordingImportStatus.finalized);
      expect(finalized.debriefStatus, RecordingImportDebriefStatus.failed);
      expect(finalized.finalTranscript, isNotEmpty);
      expect(
        harness.store.session(created.sessionId)!.status,
        SessionStatus.finalized,
      );
    },
  );

  test('enforces duration, size, MIME and process-local capacity', () async {
    final Completer<DiarizedRecordingTranscript> blocked =
        Completer<DiarizedRecordingTranscript>();
    final _QueueRecordingProvider provider = _QueueRecordingProvider(
      <Future<DiarizedRecordingTranscript> Function()>[
        () => blocked.future,
        () async => DiarizedRecordingTranscript(
          durationSeconds: RecordingImportService.maxDurationSeconds + 1,
          language: 'fr',
          segments: _transcript().segments,
          provider: 'fake',
        ),
      ],
    );
    final _Harness harness = await _createHarness(
      provider,
      maxConcurrentTranscriptions: 1,
    );
    addTearDown(() async {
      if (!blocked.isCompleted) {
        blocked.complete(_transcript());
      }
      await harness.dispose();
    });

    await expectLater(
      harness.imports.create(
        fileName: 'appel.exe',
        mimeType: 'audio/mpeg',
        sizeBytes: 4,
        title: null,
        locale: 'fr',
        preparationMarkdown: null,
      ),
      throwsA(
        isA<RecordingImportException>().having(
          (RecordingImportException error) => error.code,
          'code',
          'unsupported_media',
        ),
      ),
    );
    await expectLater(
      harness.imports.create(
        fileName: 'appel.mp3',
        mimeType: 'audio/mpeg',
        sizeBytes: RecordingImportService.maxSizeBytes + 1,
        title: null,
        locale: 'fr',
        preparationMarkdown: null,
      ),
      throwsA(
        isA<RecordingImportException>().having(
          (RecordingImportException error) => error.code,
          'code',
          'payload_too_large',
        ),
      ),
    );

    final RecordingImportSnapshot first = await _consentedImport(harness);
    await harness.imports.upload(
      importId: first.id,
      mimeType: 'audio/wav',
      contentLength: 4,
      bytes: Stream<List<int>>.value(<int>[0, 0, 0, 0]),
    );
    final RecordingImportSnapshot second = await _consentedImport(harness);
    await expectLater(
      harness.imports.upload(
        importId: second.id,
        mimeType: 'audio/wav',
        contentLength: 4,
        bytes: Stream<List<int>>.value(<int>[0, 0, 0, 0]),
      ),
      throwsA(
        isA<RecordingImportException>().having(
          (RecordingImportException error) => error.code,
          'code',
          'rate_limited',
        ),
      ),
    );
    blocked.complete(_transcript());
    await _waitUntil(
      () =>
          harness.imports.get(first.id).status ==
          RecordingImportStatus.awaitingSpeakerAssignment,
    );

    await harness.imports.upload(
      importId: second.id,
      mimeType: 'audio/wav',
      contentLength: 4,
      bytes: Stream<List<int>>.value(<int>[0, 0, 0, 0]),
    );
    await _waitUntil(
      () =>
          harness.imports.get(second.id).status == RecordingImportStatus.failed,
    );
    expect(harness.imports.get(second.id).failure?.code, 'duration_exceeded');
    await expectLater(
      harness.imports.upload(
        importId: second.id,
        mimeType: 'audio/wav',
        contentLength: 4,
        bytes: Stream<List<int>>.value(<int>[0, 0, 0, 0]),
      ),
      throwsA(
        isA<RecordingImportException>().having(
          (RecordingImportException error) => error.code,
          'code',
          'invalid_import_state',
        ),
      ),
    );
  });

  test('exposes and safely clears privacy-sensitive import state', () async {
    final Completer<DiarizedRecordingTranscript> blocked =
        Completer<DiarizedRecordingTranscript>();
    final _QueueRecordingProvider provider = _QueueRecordingProvider(
      <Future<DiarizedRecordingTranscript> Function()>[() => blocked.future],
    );
    final _Harness harness = await _createHarness(provider);
    addTearDown(harness.dispose);
    final RecordingImportSnapshot created = await _consentedImport(harness);

    expect(harness.imports.privacySessionIds, contains(created.sessionId));
    expect(harness.imports.privacyBlockingSessionIds, isEmpty);
    await harness.imports.upload(
      importId: created.id,
      mimeType: 'audio/wav',
      contentLength: 4,
      bytes: Stream<List<int>>.value(<int>[0, 0, 0, 0]),
    );
    expect(
      harness.imports.privacyBlockingSessionIds,
      contains(created.sessionId),
    );
    expect(harness.imports.clearPrivacyState, throwsStateError);

    blocked.complete(_transcript());
    await _waitUntil(
      () =>
          harness.imports.get(created.id).status ==
          RecordingImportStatus.awaitingSpeakerAssignment,
    );
    expect(harness.imports.privacyBlockingSessionIds, isEmpty);
    harness.imports.clearPrivacyState();
    expect(harness.imports.privacySessionIds, isEmpty);
    expect(
      harness.store.session(created.sessionId)?.status,
      SessionStatus.failed,
    );
    harness.store.clearWorkspaceData();
    expect(
      () => harness.imports.get(created.id),
      throwsA(
        isA<RecordingImportException>().having(
          (RecordingImportException error) => error.code,
          'code',
          'not_found',
        ),
      ),
    );
  });
}

Future<_Harness> _createHarness(
  _QueueRecordingProvider provider, {
  int maxConcurrentTranscriptions = 2,
  PostCallGateway postCallGateway = const UnavailablePostCallGateway(
    'not configured',
  ),
}) async {
  final Directory parent = await Directory.systemTemp.createTemp(
    'pinkall_recording_import_test_',
  );
  final Directory stagingRoot = Directory(
    '${parent.path}${Platform.pathSeparator}staging',
  );
  final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
  await store.initialize();
  final SessionService sessions = SessionService(
    config: AppConfig.fromEnvironment(const <String, String>{
      'PINKALL_API_TOKEN': 'recording-test-token-more-than-24-characters',
      'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
      'MISTRAL_API_KEY': 'test-only',
    }),
    store: store,
    sttProvider: const UnavailableSttProvider('not used'),
    coachGateway: const UnavailableCoachGateway('not used'),
    coachCatalog: const _UnavailableCatalog(),
  );
  final PostCallService postCalls = PostCallService(
    store: store,
    gateway: postCallGateway,
    coachCatalog: const _UnavailableCatalog(),
  );
  final RecordingImportService imports = RecordingImportService(
    store: store,
    sessions: sessions,
    postCalls: postCalls,
    transcriptionProvider: provider,
    stagingRoot: stagingRoot,
    maxConcurrentTranscriptions: maxConcurrentTranscriptions,
  );
  await imports.initialize();
  return _Harness(
    parent: parent,
    stagingRoot: stagingRoot,
    store: store,
    sessions: sessions,
    imports: imports,
  );
}

final class _RecordingPostCallGateway implements PostCallGateway {
  int calls = 0;

  @override
  bool get isConfigured => true;

  @override
  Future<PostCallDebrief> generate({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required List<CoachRecommendation> improvementCandidates,
    String? preparationMarkdown,
  }) async {
    calls += 1;
    return PostCallDebrief(
      sessionId: sessionId,
      summary: PostCallGroundedText(
        text: 'Résumé réel à partir du transcript final.',
        evidenceSegmentIds: <String>[transcript.first.id],
      ),
      keyPoints: const <PostCallGroundedText>[],
      commitments: const <PostCallCommitment>[],
      followUp: PostCallFollowUp(
        subject: 'Suite de notre échange',
        body: 'Merci pour votre temps.',
        nextAction: 'Relancer',
        dueAt: null,
        evidenceSegmentIds: <String>[transcript.first.id],
      ),
      improvement: null,
      generatedAt: DateTime.now().toUtc(),
      provider: 'openai-test-double',
      model: 'test',
    );
  }
}

final class _FailingPostCallGateway implements PostCallGateway {
  const _FailingPostCallGateway();

  @override
  bool get isConfigured => true;

  @override
  Future<PostCallDebrief> generate({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required List<CoachRecommendation> improvementCandidates,
    String? preparationMarkdown,
  }) {
    throw StateError('OpenAI is temporarily unavailable.');
  }
}

Future<RecordingImportSnapshot> _consentedImport(_Harness harness) async {
  final RecordingImportSnapshot created = await harness.imports.create(
    fileName: 'appel.wav',
    mimeType: 'audio/wav',
    sizeBytes: 4,
    title: null,
    locale: 'fr',
    preparationMarkdown: null,
  );
  harness.sessions.acknowledgeTranscriptionConsent(
    sessionId: created.sessionId,
    method: 'verbal_notice',
    acknowledgedAt: DateTime.now().toUtc(),
  );
  return created;
}

DiarizedRecordingTranscript _transcript() {
  return const DiarizedRecordingTranscript(
    durationSeconds: 30,
    language: 'fr',
    provider: 'fake:diarized',
    segments: <DiarizedRecordingSegment>[
      DiarizedRecordingSegment(
        voiceId: 'provider-9',
        text: 'Bonjour, je vous appelle.',
        startSeconds: 0,
        endSeconds: 2,
        confidence: 0.95,
      ),
      DiarizedRecordingSegment(
        voiceId: 'provider-4',
        text: 'Je vous écoute.',
        startSeconds: 2.2,
        endSeconds: 3.1,
        confidence: 0.92,
      ),
      DiarizedRecordingSegment(
        voiceId: 'provider-9',
        text: 'Merci, voici le contexte.',
        startSeconds: 3.4,
        endSeconds: 5.3,
        confidence: 0.9,
      ),
    ],
  );
}

Future<void> _waitUntil(
  bool Function() predicate, {
  Duration timeout = const Duration(seconds: 2),
}) async {
  final DateTime deadline = DateTime.now().add(timeout);
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Condition was not met within $timeout.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

final class _Harness {
  const _Harness({
    required this.parent,
    required this.stagingRoot,
    required this.store,
    required this.sessions,
    required this.imports,
  });

  final Directory parent;
  final Directory stagingRoot;
  final InMemoryPocStore store;
  final SessionService sessions;
  final RecordingImportService imports;

  Future<void> dispose() async {
    await imports.dispose();
    await sessions.dispose();
    await store.dispose();
    if (await parent.exists()) {
      await parent.delete(recursive: true);
    }
  }
}

final class _QueueRecordingProvider
    implements RecordedCallTranscriptionProvider {
  _QueueRecordingProvider(this.outcomes);

  final List<Future<DiarizedRecordingTranscript> Function()> outcomes;
  int calls = 0;

  @override
  bool get isConfigured => true;

  @override
  String get name => 'fake_recorded';

  @override
  Future<DiarizedRecordingTranscript> transcribe({
    required RecordedAudioInput audio,
    required String locale,
  }) async {
    calls += 1;
    final List<int> bytes = await audio.openRead().expand((List<int> value) {
      return value;
    }).toList();
    expect(bytes, hasLength(audio.sizeBytes));
    if (outcomes.isEmpty) {
      throw StateError('No fake provider outcome remains.');
    }
    return outcomes.removeAt(0)();
  }

  @override
  Future<void> dispose() async {}
}

final class _UnavailableCatalog implements CoachCatalog {
  const _UnavailableCatalog();

  @override
  bool get allowsUnreviewedRecommendations => false;

  @override
  int get defaultExpirySeconds => 0;

  @override
  Duration get globalCooldown => Duration.zero;

  @override
  bool get isAvailable => false;

  @override
  int get maxEvaluationsPerMinute => 0;

  @override
  int get maxSuggestionsPerMinute => 0;

  @override
  double get minimumContextMatch => 1;

  @override
  double get minimumLiveConfidence => 1;

  @override
  CoachReleaseChannel get releaseChannel => CoachReleaseChannel.strict;

  @override
  String? get unavailableReason => 'not configured';

  @override
  List<CoachRecommendation> candidatesFor({
    required CoachMode mode,
    required String latestText,
  }) => const <CoachRecommendation>[];

  @override
  List<CoachRecommendation> postCallCandidates() =>
      const <CoachRecommendation>[];
}
