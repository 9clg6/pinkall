import 'dart:async';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:test/test.dart';

void main() {
  test('starts empty and upserts partial transcript IDs in place', () async {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);

    expect(store.listSessions(), isEmpty);
    expect(store.contacts(), isEmpty);

    final CallSessionSnapshot session = store.createSession(
      callId: 'call-1',
      destinationNumber: '+33102030405',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    expect(session.transcriptionAllowed, isFalse);
    expect(store.listSessions(), hasLength(1));

    final List<ClientEvent> events = <ClientEvent>[];
    final StreamSubscription<ClientEvent> subscription = store
        .events(session.id)
        .listen(events.add);
    final DateTime createdAt = DateTime.utc(2026, 7, 11);
    store.upsertTranscriptSegment(
      session.id,
      TranscriptSegment(
        id: 'stable-partial-id',
        track: MediaTrack.inbound,
        speaker: SpeakerRole.prospect,
        text: 'Bonjour',
        startSeconds: 0,
        endSeconds: 0,
        isFinal: false,
        provider: 'test',
        createdAt: createdAt,
      ),
    );
    store.upsertTranscriptSegment(
      session.id,
      TranscriptSegment(
        id: 'stable-partial-id',
        track: MediaTrack.inbound,
        speaker: SpeakerRole.prospect,
        text: 'Bonjour.',
        startSeconds: 0,
        endSeconds: 1,
        isFinal: true,
        provider: 'test',
        createdAt: createdAt,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(store.transcript(session.id), hasLength(1));
    expect(store.transcript(session.id).single.isFinal, isTrue);
    expect(events.map((ClientEvent event) => event.data['sequence']), <Object?>[
      1,
      1,
    ]);
    expect(events.map((ClientEvent event) => event.data['id']), <Object?>[
      'stable-partial-id',
      'stable-partial-id',
    ]);
    expect(store.validateMediaToken(session.id, session.mediaToken), isTrue);
    store.updateStatus(session.id, SessionStatus.stopped);
    expect(store.validateMediaToken(session.id, session.mediaToken), isFalse);
    await subscription.cancel();
    await store.dispose();
  });

  test('snapshots versioned workspace context into each new session', () async {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);

    final WorkspaceSalesContext firstContext = store
        .upsertWorkspaceSalesContext(
          companyName: 'Pinkall',
          productName: 'Coach IA',
          pitchMarkdown: '# V1\nConseil après appel.',
          expectedRevision: null,
        );
    final CallSessionSnapshot firstSession = store.createSession(
      callId: 'call-context-v1',
      destinationNumber: '+33102030405',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    final WorkspaceSalesContext secondContext = store
        .upsertWorkspaceSalesContext(
          companyName: 'Pinkall',
          productName: 'Coach IA',
          pitchMarkdown: '# V2\nConseil pendant et après appel.',
          expectedRevision: firstContext.revision,
        );
    final CallSessionSnapshot secondSession = store.createSession(
      callId: 'call-context-v2',
      destinationNumber: '+33102030406',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );

    expect(firstSession.workspaceSalesContext?.revision, 1);
    expect(firstSession.workspaceSalesContext?.pitchMarkdown, contains('V1'));
    expect(secondSession.workspaceSalesContext?.revision, 2);
    expect(secondContext.revision, 2);
    expect(firstSession.toJson()['workspace_sales_context_revision'], 1);
    expect(firstSession.toJson(), isNot(contains('workspace_sales_context')));

    expect(
      () => store.upsertWorkspaceSalesContext(
        companyName: 'Pinkall concurrent',
        productName: 'Coach IA',
        pitchMarkdown: 'Ne doit pas être sauvegardé.',
        expectedRevision: 1,
      ),
      throwsA(isA<WorkspaceSalesContextRevisionConflict>()),
    );
    expect(store.workspaceSalesContext?.revision, 2);

    final Map<String, Object?> durable = store.exportDurableSnapshot();
    final InMemoryPocStore restored = InMemoryPocStore(
      maxSessionAudioBytes: 1024,
    )..restoreDurableSnapshot(durable);
    expect(restored.workspaceSalesContext?.revision, 2);
    expect(
      restored.session(firstSession.id)?.workspaceSalesContext?.pitchMarkdown,
      contains('V1'),
    );
    await store.dispose();
    await restored.dispose();
  });

  test(
    'restores a snapshot created before workspace context existed',
    () async {
      final InMemoryPocStore source = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final Map<String, Object?> legacy = <String, Object?>{
        ...source.exportDurableSnapshot(),
      }..remove('workspace_sales_context');
      final InMemoryPocStore restored = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      )..restoreDurableSnapshot(legacy);

      expect(restored.workspaceSalesContext, isNull);
      await source.dispose();
      await restored.dispose();
    },
  );
}
