import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/recording_import/presentation/recording_import.state.dart';
import 'package:pinkall/features/recording_import/presentation/recording_import.view_model.dart';

void main() {
  test('creates, records consent, then uploads in that exact order', () async {
    final List<String> operations = <String>[];
    final _RecordingImportRepository imports = _RecordingImportRepository(
      operations: operations,
      polledImport: _transcribingImport,
    );
    final _ConversationSessionRepository sessions =
        _ConversationSessionRepository(operations);
    final _RecordingImportClient native = _RecordingImportClient(operations);
    final ProviderContainer container = _container(
      imports: imports,
      sessions: sessions,
      native: native,
    );
    final ProviderSubscription<RecordingImportState> subscription = container
        .listen<RecordingImportState>(
          recordingImportViewModelProvider,
          (_, _) {},
        );
    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    final RecordingImportViewModel viewModel = container.read(
      recordingImportViewModelProvider.notifier,
    );
    viewModel.selectNativeImport(_nativeAudio);
    await viewModel.start(
      title: 'Découverte Acme',
      preparationMarkdown: '# Objectif\nQualifier le besoin',
    );

    expect(operations.take(3), <String>['create', 'consent', 'upload']);
    expect(imports.createdParams?.fileName, 'appel-acme.m4a');
    expect(imports.createdParams?.mimeType, 'audio/mp4');
    expect(imports.createdParams?.sizeBytes, 4096);
    expect(imports.createdParams?.title, 'Découverte Acme');
    expect(
      imports.createdParams?.preparationMarkdown,
      '# Objectif\nQualifier le besoin',
    );
    expect(sessions.consentParams?.sessionId, 'session-import');
    expect(sessions.consentParams?.acknowledged, isTrue);
    expect(
      sessions.consentParams?.method,
      TranscriptionConsentMethod.verbalNotice,
    );
    expect(imports.uploadParams?.importId, 'import-1');
    expect(
      imports.uploadParams?.uploadPath,
      '/v1/recording-imports/import-1/audio',
    );
  });

  test('keeps provisional voices unassigned until explicit selection, then '
      'assigns before retrieving the session', () async {
    final List<String> operations = <String>[];
    final _RecordingImportRepository imports = _RecordingImportRepository(
      operations: operations,
      polledImport: _awaitingAssignmentImport,
    );
    final _ConversationSessionRepository sessions =
        _ConversationSessionRepository(operations);
    final _RecordingImportClient native = _RecordingImportClient(operations);
    final ProviderContainer container = _container(
      imports: imports,
      sessions: sessions,
      native: native,
    );
    final ProviderSubscription<RecordingImportState> subscription = container
        .listen<RecordingImportState>(
          recordingImportViewModelProvider,
          (_, _) {},
        );
    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    final RecordingImportViewModel viewModel = container.read(
      recordingImportViewModelProvider.notifier,
    );
    viewModel.selectNativeImport(_nativeAudio);
    await viewModel.start();
    await _waitUntil(
      () =>
          container.read(recordingImportViewModelProvider).stage ==
          RecordingImportStage.assigningVoice,
    );

    final RecordingImportState provisional = container.read(
      recordingImportViewModelProvider,
    );
    expect(provisional.selectedVoice, isNull);
    expect(provisional.remoteImport?.voices, <String>['A', 'B']);
    expect(
      provisional.remoteImport?.provisionalSegments.map(
        (ProvisionalTranscriptSegmentEntity segment) => segment.voice,
      ),
      <String>['A', 'B'],
    );
    expect(
      provisional.remoteImport?.provisionalSegments.every(
        (ProvisionalTranscriptSegmentEntity segment) =>
            segment.voice != 'seller' && segment.voice != 'prospect',
      ),
      isTrue,
    );

    expect(await viewModel.confirmUserVoice(), isNull);
    expect(imports.assignmentParams, isNull);
    expect(operations, isNot(contains('session')));

    viewModel.selectVoice('B');
    final ConversationSessionEntity? session = await viewModel
        .confirmUserVoice();

    expect(imports.assignmentParams?.userVoice, 'B');
    expect(session?.id, 'session-import');
    expect(
      operations.indexOf('assign:B'),
      lessThan(operations.indexOf('session')),
    );
    expect(operations, <String>[
      'create',
      'consent',
      'upload',
      'poll',
      'assign:B',
      'session',
      'discard:native-import-1',
    ]);
  });

  test(
    'a remotely finalized import returns to explicit voice confirmation',
    () async {
      final List<String> operations = <String>[];
      final _RecordingImportRepository imports = _RecordingImportRepository(
        operations: operations,
        polledImport: _awaitingAssignmentImport.copyWith(
          status: RecordingImportStatus.finalized,
        ),
      );
      final ProviderContainer container = _container(
        imports: imports,
        sessions: _ConversationSessionRepository(operations),
        native: _RecordingImportClient(operations),
      );
      final ProviderSubscription<RecordingImportState> subscription = container
          .listen<RecordingImportState>(
            recordingImportViewModelProvider,
            (_, _) {},
          );
      addTearDown(() {
        subscription.close();
        container.dispose();
      });

      final RecordingImportViewModel viewModel = container.read(
        recordingImportViewModelProvider.notifier,
      );
      viewModel.selectNativeImport(_nativeAudio);
      await viewModel.start();
      await _waitUntil(
        () =>
            container.read(recordingImportViewModelProvider).stage ==
            RecordingImportStage.assigningVoice,
      );

      final RecordingImportState state = container.read(
        recordingImportViewModelProvider,
      );
      expect(state.selectedVoice, isNull);
      expect(state.remoteImport?.status, RecordingImportStatus.finalized);
      expect(state.errorMessage, contains('Confirme ta voix'));
    },
  );
}

ProviderContainer _container({
  required _RecordingImportRepository imports,
  required _ConversationSessionRepository sessions,
  required _RecordingImportClient native,
}) => ProviderContainer(
  overrides: <Override>[
    recordingImportRepositoryProvider.overrideWithValue(imports),
    conversationSessionRepositoryProvider.overrideWithValue(sessions),
    recordingImportClientProvider.overrideWithValue(native),
  ],
);

Future<void> _waitUntil(bool Function() predicate) async {
  final DateTime deadline = DateTime.now().add(const Duration(seconds: 1));
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out while waiting for the recording import state update.');
    }
    await Future<void>.delayed(Duration.zero);
  }
}

const RecordingAudioImport _nativeAudio = RecordingAudioImport(
  id: 'native-import-1',
  name: 'appel-acme.m4a',
  mimeType: 'audio/mp4',
  path: '/pinkall-temporary/native-import-1/appel-acme.m4a',
  sizeBytes: 4096,
);

const RecordingImportEntity _createdImport = RecordingImportEntity(
  id: 'import-1',
  sessionId: 'session-import',
  status: RecordingImportStatus.awaitingConsent,
  uploadPath: '/v1/recording-imports/import-1/audio',
  maxSizeBytes: 209715200,
);

const RecordingImportEntity _transcribingImport = RecordingImportEntity(
  id: 'import-1',
  sessionId: 'session-import',
  status: RecordingImportStatus.transcribing,
);

const RecordingImportEntity _awaitingAssignmentImport = RecordingImportEntity(
  id: 'import-1',
  sessionId: 'session-import',
  status: RecordingImportStatus.awaitingSpeakerAssignment,
  voices: <String>['A', 'B'],
  provisionalSegments: <ProvisionalTranscriptSegmentEntity>[
    ProvisionalTranscriptSegmentEntity(
      id: 'segment-a',
      voice: 'A',
      text: 'Bonjour, merci de prendre cet appel.',
      startSeconds: 0,
      endSeconds: 2.2,
      confidence: 0.97,
    ),
    ProvisionalTranscriptSegmentEntity(
      id: 'segment-b',
      voice: 'B',
      text: 'Je vous écoute.',
      startSeconds: 2.4,
      endSeconds: 3.3,
      confidence: 0.95,
    ),
  ],
);

final class _RecordingImportRepository implements RecordingImportRepository {
  _RecordingImportRepository({
    required this.operations,
    required this.polledImport,
  });

  final List<String> operations;
  final RecordingImportEntity polledImport;
  CreateRecordingImportParam? createdParams;
  UploadRecordingImportParam? uploadParams;
  AssignRecordingSpeakerParam? assignmentParams;

  @override
  Future<RecordingImportEntity> createImport(
    CreateRecordingImportParam params,
  ) async {
    operations.add('create');
    createdParams = params;
    return _createdImport;
  }

  @override
  Future<RecordingImportEntity> uploadRecording(
    UploadRecordingImportParam params,
  ) async {
    operations.add('upload');
    uploadParams = params;
    return _transcribingImport;
  }

  @override
  Future<RecordingImportEntity> getImport(String importId) async {
    operations.add('poll');
    return polledImport;
  }

  @override
  Future<RecordingImportEntity> assignUserVoice(
    AssignRecordingSpeakerParam params,
  ) async {
    operations.add('assign:${params.userVoice}');
    assignmentParams = params;
    return polledImport.copyWith(status: RecordingImportStatus.finalized);
  }
}

final class _ConversationSessionRepository
    implements ConversationSessionRepository {
  _ConversationSessionRepository(this.operations);

  final List<String> operations;
  RecordTranscriptionConsentParam? consentParams;

  @override
  Future<TranscriptionConsentEntity> recordTranscriptionConsent(
    RecordTranscriptionConsentParam params,
  ) async {
    operations.add('consent');
    consentParams = params;
    return TranscriptionConsentEntity(
      sessionId: params.sessionId,
      acknowledged: params.acknowledged,
      method: params.method,
      acknowledgedAt: params.acknowledgedAt,
    );
  }

  @override
  Future<ConversationSessionEntity> getSession(String sessionId) async {
    operations.add('session');
    return ConversationSessionEntity(
      id: sessionId,
      callId: 'imported-call',
      status: ConversationSessionStatus.completed,
      coachMode: CoachMode.off,
      createdAt: DateTime.utc(2026, 7, 14),
      transcriptionConsentAcknowledged: true,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _RecordingImportClient implements RecordingImportClient {
  _RecordingImportClient(this.operations);

  final List<String> operations;

  @override
  Future<RecordingImportAction?> consumePendingAction() async => null;

  @override
  Future<RecordingAudioImport?> pickRecording() async => null;

  @override
  Future<void> discardImport(String id) async {
    operations.add('discard:$id');
  }
}
