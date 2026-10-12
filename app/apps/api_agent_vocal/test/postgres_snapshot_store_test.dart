import 'dart:convert';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';
import 'package:api_agent_vocal/src/infrastructure/store/postgres_snapshot_store.dart';
import 'package:test/test.dart';

void main() {
  group('PostgresSnapshotPinkallStore', () {
    test(
      'restores durable CRM and final artifacts, then interrupts live calls',
      () async {
        final _FakeSnapshotDatabase database = _FakeSnapshotDatabase();
        final PostgresSnapshotPinkallStore first = _store(database);
        await first.initialize();

        final ContactRecord contact = first.addContact(
          phoneNumber: '+33102030405',
          name: 'Ada',
          company: 'Pinkall Prospect',
          email: 'ada@example.test',
          metadata: const <String, Object?>{'market': 'b2b'},
        );
        first.setCoachPreferences('me', const <String, Object?>{
          'default_mode': 'live',
        });
        final WorkspaceSalesContext salesContext = first
            .upsertWorkspaceSalesContext(
              companyName: 'Pinkall',
              productName: 'Coach IA',
              pitchMarkdown: '# Promesse\nAméliorer le prochain appel.',
              expectedRevision: null,
            );

        final CallSessionSnapshot live = first.createSession(
          callId: 'call-live',
          destinationNumber: contact.phoneNumber,
          contactId: contact.id,
          coachMode: CoachMode.live,
          sellerTrack: MediaTrack.outbound,
        );
        first.markMediaStarted(
          sessionId: live.id,
          streamId: 'stream-live',
          callControlId: 'control-live',
          callSessionId: 'telnyx-live',
          encoding: 'PCMU',
          sampleRate: 8000,
        );

        final CallSessionSnapshot completed = first.createSession(
          callId: 'call-completed',
          destinationNumber: '+33102030406',
          contactId: null,
          preparationMarkdown:
              '# Préparation\nDécouvrir le délai et le décideur.',
          coachMode: CoachMode.off,
          sellerTrack: MediaTrack.outbound,
        );
        first.acknowledgeTranscriptionConsent(
          sessionId: completed.id,
          method: 'verbal_notice',
          acknowledgedAt: DateTime.utc(2026, 7, 13, 10),
        );
        first.appendAudio(completed.id, MediaTrack.inbound, <int>[1, 2, 3]);
        final TranscriptSegment segment = _segment('seg-final');
        first.upsertTranscriptSegment(completed.id, segment);
        first.replaceFinalTranscript(completed.id, <TranscriptSegment>[
          segment,
        ]);
        first.savePostCallGeneration(
          PostCallGenerationSnapshot(
            sessionId: completed.id,
            status: PostCallGenerationStatus.running,
            attemptCount: 2,
            updatedAt: DateTime.utc(2026, 7, 13, 10, 1),
            failureCode: null,
            retryable: null,
            nextRetryAt: null,
          ),
        );
        first.savePostCallDebrief(
          completed.id,
          _debrief(completed.id, segment.id),
        );
        first.recordExposure('suggestion-1');
        first.recordFeedback(
          suggestionId: 'suggestion-1',
          useful: true,
          used: true,
        );
        first.setOutcome(completed.id, 'meeting_booked');

        await first.flush();
        expect(database.saveCalls, 1, reason: 'mutations are coalesced');
        await first.dispose();

        final PostgresSnapshotPinkallStore restored = _store(database);
        await restored.initialize();

        expect(restored.contacts().single.id, contact.id);
        expect(restored.workspaceSalesContext?.revision, 1);
        expect(
          restored.workspaceSalesContext?.pitchMarkdown,
          '# Promesse\nAméliorer le prochain appel.',
        );
        expect(
          restored.session(completed.id)?.workspaceSalesContext?.revision,
          salesContext.revision,
        );
        expect(restored.coachPreferences('me')['default_mode'], 'live');
        expect(restored.session(live.id)?.status, SessionStatus.failed);
        expect(
          restored.session(live.id)?.failure,
          'interrupted_by_server_restart',
        );
        expect(restored.listActiveSessions(), isEmpty);
        expect(restored.finalTranscript(completed.id)?.single.text, 'Bonjour');
        expect(restored.transcript(completed.id).single.id, segment.id);
        expect(
          restored.session(completed.id)?.preparationMarkdown,
          '# Préparation\nDécouvrir le délai et le décideur.',
        );
        expect(restored.postCallDebrief(completed.id)?.summary.text, 'Résumé');
        expect(
          restored.postCallDebrief(completed.id)?.objections.single.category,
          PostCallObjectionCategory.price,
        );
        expect(
          restored.postCallDebrief(completed.id)?.performanceRubricVersion,
          PostCallDebrief.currentPerformanceRubricVersion,
        );
        expect(
          restored.postCallGeneration(completed.id)?.status,
          PostCallGenerationStatus.completed,
        );
        expect(restored.postCallGeneration(completed.id)?.attemptCount, 2);
        expect(restored.audio(completed.id, MediaTrack.inbound), isEmpty);
        expect(restored.metrics().feedbackCount, 1);
        expect(restored.metrics().usefulCount, 1);
        expect(restored.metrics().usedCount, 1);
        expect(restored.metrics().outcomes['meeting_booked'], 1);
        expect(restored.metrics().storage, 'postgres_snapshot_poc');
        expect(
          database.saveCalls,
          2,
          reason: 'recovery is committed before initialize completes',
        );
        await restored.dispose();
      },
    );

    test('does not persist audio frames or provisional STT deltas', () async {
      final _FakeSnapshotDatabase database = _FakeSnapshotDatabase();
      final PostgresSnapshotPinkallStore store = _store(database);
      await store.initialize();
      final CallSessionSnapshot session = store.createSession(
        callId: 'call-live',
        destinationNumber: '+33102030405',
        contactId: null,
        coachMode: CoachMode.off,
        sellerTrack: MediaTrack.outbound,
      );
      await store.flush();
      expect(database.saveCalls, 1);

      store.appendAudio(session.id, MediaTrack.inbound, <int>[1, 2, 3, 4]);
      store.upsertTranscriptSegment(session.id, _segment('partial'));
      await store.flush();

      expect(database.saveCalls, 1);
      final Map<String, Object?> payload = database.snapshot!.payload;
      expect(jsonEncode(payload), isNot(contains('AQIDBA==')));
      expect(jsonEncode(payload), isNot(contains('partial')));
      await store.dispose();
    });

    test('surfaces failed writes and permits an explicit retry', () async {
      final _FakeSnapshotDatabase database = _FakeSnapshotDatabase();
      final PostgresSnapshotPinkallStore store = _store(database);
      await store.initialize();
      store.addContact(phoneNumber: '+33102030405');
      database.failNextSave = true;

      await expectLater(
        store.flush(),
        throwsA(
          isA<DurabilityException>().having(
            (DurabilityException error) => error.code,
            'code',
            'snapshot_write_failed',
          ),
        ),
      );
      expect(store.isReady, isFalse);
      expect(store.durabilityFailureCode, 'snapshot_write_failed');

      await store.flush();
      expect(store.isReady, isTrue);
      expect(database.snapshot, isNotNull);
      expect(database.saveCalls, 2);
      await store.dispose();
    });

    test(
      'rejects a stale concurrent snapshot instead of overwriting it',
      () async {
        final _FakeSnapshotDatabase database = _FakeSnapshotDatabase();
        final PostgresSnapshotPinkallStore first = _store(database);
        final PostgresSnapshotPinkallStore stale = _store(database);
        await first.initialize();
        await stale.initialize();

        first.addContact(phoneNumber: '+33102030405');
        await first.flush();
        stale.addContact(phoneNumber: '+33102030406');

        await expectLater(
          stale.flush(),
          throwsA(
            isA<DurabilityException>().having(
              (DurabilityException error) => error.code,
              'code',
              'snapshot_revision_conflict',
            ),
          ),
        );
        await first.dispose();
        database.ignoreConflicts = true;
        await stale.dispose();
      },
    );
  });
}

PostgresSnapshotPinkallStore _store(_FakeSnapshotDatabase database) {
  return PostgresSnapshotPinkallStore(
    tenantId: 'tenant-test',
    repository: _FakeSnapshotRepository(database),
    maxSessionAudioBytes: 1024 * 1024,
  );
}

TranscriptSegment _segment(String id) {
  return TranscriptSegment(
    id: id,
    track: MediaTrack.inbound,
    speaker: SpeakerRole.prospect,
    text: 'Bonjour',
    startSeconds: 0,
    endSeconds: 1,
    isFinal: id != 'partial',
    provider: 'test',
    createdAt: DateTime.utc(2026, 7, 13, 10),
  );
}

PostCallDebrief _debrief(String sessionId, String segmentId) {
  return PostCallDebrief(
    sessionId: sessionId,
    summary: PostCallGroundedText(
      text: 'Résumé',
      evidenceSegmentIds: <String>[segmentId],
    ),
    keyPoints: <PostCallGroundedText>[
      PostCallGroundedText(
        text: 'Point clé',
        evidenceSegmentIds: <String>[segmentId],
      ),
    ],
    commitments: <PostCallCommitment>[
      PostCallCommitment(
        owner: PostCallCommitmentOwner.seller,
        text: 'Envoyer une proposition',
        dueAt: null,
        evidenceSegmentIds: <String>[segmentId],
      ),
    ],
    followUp: PostCallFollowUp(
      subject: 'Suite de notre échange',
      body: 'Merci pour votre temps.',
      nextAction: 'Envoyer la proposition',
      dueAt: null,
      evidenceSegmentIds: <String>[segmentId],
    ),
    improvement: null,
    generatedAt: DateTime.utc(2026, 7, 13, 10, 5),
    provider: 'test',
    model: 'test-model',
    objections: <PostCallObjection>[
      PostCallObjection(
        category: PostCallObjectionCategory.price,
        text: 'Le prix est trop élevé.',
        responseAngle: 'Clarifier la valeur.',
        suggestedResponse: 'Quel point vous semble difficile à justifier ?',
        evidenceSegmentIds: <String>[segmentId],
        confidence: 0.88,
      ),
    ],
  );
}

final class _FakeSnapshotDatabase {
  StoredPocSnapshot? snapshot;
  int saveCalls = 0;
  bool failNextSave = false;
  bool ignoreConflicts = false;
}

final class _FakeSnapshotRepository implements PocSnapshotRepository {
  _FakeSnapshotRepository(this.database);

  final _FakeSnapshotDatabase database;

  @override
  Future<void> initialize() async {}

  @override
  Future<StoredPocSnapshot?> load(String tenantId) async {
    return database.snapshot;
  }

  @override
  Future<int> save({
    required String tenantId,
    required int schemaVersion,
    required int? expectedRevision,
    required Map<String, Object?> payload,
  }) async {
    database.saveCalls += 1;
    if (database.failNextSave) {
      database.failNextSave = false;
      throw StateError('database unavailable');
    }
    final int? currentRevision = database.snapshot?.revision;
    if (!database.ignoreConflicts && expectedRevision != currentRevision) {
      throw const DurabilityException(
        'snapshot_revision_conflict',
        'stale snapshot',
      );
    }
    final int revision = (currentRevision ?? 0) + 1;
    database.snapshot = StoredPocSnapshot(
      schemaVersion: schemaVersion,
      revision: revision,
      payload: (jsonDecode(jsonEncode(payload))! as Map<String, Object?>),
    );
    return revision;
  }

  @override
  Future<void> close() async {}
}
