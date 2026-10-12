import 'package:api_agent_vocal/src/application/workspace_privacy_service.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryPocStore store;
  late WorkspacePrivacyService service;

  setUp(() async {
    store = InMemoryPocStore(maxSessionAudioBytes: 1024 * 1024);
    await store.initialize();
    service = WorkspacePrivacyService(store: store);
  });

  tearDown(() => store.dispose());

  test('exports user data without live media credentials or raw audio', () {
    store
      ..upsertWorkspaceSalesContext(
        companyName: 'Pinkall',
        productName: 'Coach IA',
        pitchMarkdown: 'Une présentation autorisée.',
        expectedRevision: null,
      )
      ..addContact(phoneNumber: '+33600000000', name: 'Prospect test')
      ..setCoachPreferences('user-1', <String, Object?>{'mode': 'live'});
    final CallSessionSnapshot session = store.createSession(
      callId: 'call-1',
      destinationNumber: '+33600000000',
      contactId: null,
      coachMode: CoachMode.live,
      sellerTrack: MediaTrack.outbound,
    );
    store.failSession(session.id, 'test_complete');

    final Map<String, Object?> exported = service.exportForUser(
      userId: 'user-1',
      workspaceId: 'workspace-1',
      generatedAt: DateTime.utc(2026, 7, 14),
    );

    expect(exported['schema'], 'pinkall.workspace-export.v1');
    expect(exported['raw_audio_included'], isFalse);
    expect(exported['contacts'], hasLength(1));
    expect(exported['coach_preferences'], <String, Object?>{'mode': 'live'});
    final Map<String, Object?> exportedSession =
        (exported['sessions']! as List<Object?>).single as Map<String, Object?>;
    expect(exportedSession['id'], session.id);
    expect(exportedSession, isNot(contains('media_token')));
  });

  test('retention previews then deletes terminal sessions only', () async {
    final CallSessionSnapshot terminal = store.createSession(
      callId: 'call-terminal',
      destinationNumber: '+33600000001',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    store.failSession(terminal.id, 'test_complete');
    final CallSessionSnapshot active = store.createSession(
      callId: 'call-active',
      destinationNumber: '+33600000002',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    final DateTime future = DateTime.now().toUtc().add(const Duration(days: 2));

    final Map<String, Object?> preview = service.previewRetention(
      retentionDays: 1,
      now: future,
    );
    expect(preview['eligible_session_count'], 1);
    expect(preview['active_session_count'], 1);
    expect(preview['destructive_operation_allowed'], isFalse);

    await expectLater(
      service.applyRetention(retentionDays: 1, now: future),
      throwsA(
        isA<WorkspacePrivacyConflict>().having(
          (WorkspacePrivacyConflict error) => error.code,
          'code',
          'privacy_active_call_conflict',
        ),
      ),
    );
    expect(store.session(terminal.id), isNotNull);

    store.failSession(active.id, 'test_complete');

    final Map<String, Object?> result = await service.applyRetention(
      retentionDays: 1,
      now: future,
    );
    expect(result['deleted_session_count'], 2);
    expect(store.session(terminal.id), isNull);
    expect(store.session(active.id), isNull);
  });

  test('blocks import and post-call writers before any mutation', () async {
    final CallSessionSnapshot terminal = store.createSession(
      callId: 'call-terminal',
      destinationNumber: '+33600000010',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    store.failSession(terminal.id, 'test_complete');
    final DateTime future = DateTime.now().toUtc().add(const Duration(days: 2));
    final _FakeActivityProbe probe = _FakeActivityProbe(
      const WorkspacePrivacyActivitySnapshot(
        activeSessionCount: 0,
        activeRecordingImportCount: 1,
        activePostCallJobCount: 0,
      ),
    );
    service = WorkspacePrivacyService(store: store, activityProbe: probe);

    await expectLater(
      service.applyRetention(retentionDays: 1, now: future),
      throwsA(
        isA<WorkspacePrivacyConflict>().having(
          (WorkspacePrivacyConflict error) => error.code,
          'code',
          'privacy_recording_import_conflict',
        ),
      ),
    );
    expect(store.session(terminal.id), isNotNull);
    expect(probe.pruned, isFalse);

    probe.activity = const WorkspacePrivacyActivitySnapshot(
      activeSessionCount: 0,
      activeRecordingImportCount: 0,
      activePostCallJobCount: 1,
    );
    await expectLater(
      service.deleteWorkspaceData(
        confirmation: WorkspacePrivacyService.deletionConfirmation,
      ),
      throwsA(
        isA<WorkspacePrivacyConflict>().having(
          (WorkspacePrivacyConflict error) => error.code,
          'code',
          'privacy_post_call_conflict',
        ),
      ),
    );
    expect(store.session(terminal.id), isNotNull);
    expect(probe.cleared, isFalse);
  });

  test('prunes transient state only after safe durable mutations', () async {
    final _FakeActivityProbe probe = _FakeActivityProbe(
      const WorkspacePrivacyActivitySnapshot(
        activeSessionCount: 0,
        activeRecordingImportCount: 0,
        activePostCallJobCount: 0,
      ),
    );
    service = WorkspacePrivacyService(store: store, activityProbe: probe);

    await service.applyRetention(
      retentionDays: 90,
      now: DateTime.utc(2026, 7, 14),
    );
    expect(probe.pruned, isTrue);

    await service.deleteWorkspaceData(
      confirmation: WorkspacePrivacyService.deletionConfirmation,
    );
    expect(probe.cleared, isTrue);
  });

  test(
    'workspace deletion requires exact confirmation and no active call',
    () async {
      final CallSessionSnapshot session = store.createSession(
        callId: 'call-1',
        destinationNumber: '+33600000003',
        contactId: null,
        coachMode: CoachMode.off,
        sellerTrack: MediaTrack.outbound,
      );

      await expectLater(
        service.deleteWorkspaceData(
          confirmation: WorkspacePrivacyService.deletionConfirmation,
        ),
        throwsA(
          isA<WorkspacePrivacyConflict>().having(
            (WorkspacePrivacyConflict error) => error.code,
            'code',
            'privacy_active_call_conflict',
          ),
        ),
      );
      store
        ..failSession(session.id, 'test_complete')
        ..addContact(phoneNumber: '+33600000004')
        ..setCoachPreferences('user-1', <String, Object?>{'mode': 'shadow'});

      await expectLater(
        service.deleteWorkspaceData(confirmation: 'yes'),
        throwsA(
          isA<WorkspacePrivacyConflict>().having(
            (WorkspacePrivacyConflict error) => error.code,
            'code',
            'privacy_confirmation_invalid',
          ),
        ),
      );

      await service.deleteWorkspaceData(
        confirmation: WorkspacePrivacyService.deletionConfirmation,
      );
      expect(store.listSessions(), isEmpty);
      expect(store.contacts(), isEmpty);
      expect(store.coachPreferences('user-1'), isEmpty);
      expect(store.metrics().exposures, 0);
    },
  );
}

final class _FakeActivityProbe implements WorkspacePrivacyActivityProbe {
  _FakeActivityProbe(this.activity);

  WorkspacePrivacyActivitySnapshot activity;
  bool pruned = false;
  bool cleared = false;

  @override
  WorkspacePrivacyActivitySnapshot inspect() => activity;

  @override
  void pruneOrphanedTransientData() {
    pruned = true;
  }

  @override
  void clearTransientWorkspaceData() {
    cleared = true;
  }
}
