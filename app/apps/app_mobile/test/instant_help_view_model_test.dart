import 'dart:async';
import 'dart:typed_data';

import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/instant_help/presentation/instant_help.state.dart';
import 'package:pinkall/features/instant_help/presentation/instant_help.view_model.dart';

void main() {
  test(
    'Instant Help gates capture behind consent and keeps both PCM tracks separate',
    () async {
      final List<String> operations = <String>[];
      final _ExternalSessionRepository repository = _ExternalSessionRepository(
        operations,
      );
      final _MacosCaptureClient capture = _MacosCaptureClient(operations);
      final _BinaryClient binary = _BinaryClient(operations);
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          conversationSessionRepositoryProvider.overrideWithValue(repository),
          macosCallAudioCaptureClientProvider.overrideWithValue(capture),
          pinkallBinaryRealtimeClientProvider.overrideWithValue(binary),
        ],
      );
      final ProviderSubscription<InstantHelpState> subscription = container
          .listen<InstantHelpState>(instantHelpViewModelProvider, (_, _) {});
      addTearDown(() async {
        subscription.close();
        container.dispose();
        await capture.dispose();
        await repository.dispose();
      });

      final InstantHelpViewModel viewModel = container.read(
        instantHelpViewModelProvider.notifier,
      );
      expect(
        await viewModel.start(
          title: 'Discovery Acme',
          preparationMarkdown: '# Objectif\nQualifier le besoin',
        ),
        isTrue,
      );

      expect(operations.take(5), <String>[
        'create',
        'consent',
        'connect-seller',
        'connect-prospect',
        'watch-events',
      ]);
      expect(operations[5], 'capture-start');
      expect(repository.created?.coachModeOverride, CoachMode.off);
      expect(repository.recordedConsent?.acknowledged, isTrue);
      expect(
        repository.recordedConsent?.method,
        TranscriptionConsentMethod.verbalNotice,
      );

      capture.microphone.add(Uint8List.fromList(<int>[1, 0, 2, 0]));
      capture.system.add(Uint8List.fromList(<int>[3, 0, 4, 0]));
      await Future<void>.delayed(Duration.zero);

      expect(binary.seller.frames.single, <int>[1, 0, 2, 0]);
      expect(binary.prospect.frames.single, <int>[3, 0, 4, 0]);
      final InstantHelpState live = container.read(
        instantHelpViewModelProvider,
      );
      expect(live.stage, InstantHelpStage.live);
      expect(live.microphoneDetected, isTrue);
      expect(live.systemAudioDetected, isTrue);
      expect(live.isCoachEnabled, isFalse);
    },
  );

  test(
    'coach activates during capture and stop starts the normal debrief',
    () async {
      final List<String> operations = <String>[];
      final _ExternalSessionRepository repository = _ExternalSessionRepository(
        operations,
      );
      final _MacosCaptureClient capture = _MacosCaptureClient(operations);
      final _BinaryClient binary = _BinaryClient(operations);
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          conversationSessionRepositoryProvider.overrideWithValue(repository),
          macosCallAudioCaptureClientProvider.overrideWithValue(capture),
          pinkallBinaryRealtimeClientProvider.overrideWithValue(binary),
        ],
      );
      final ProviderSubscription<InstantHelpState> subscription = container
          .listen<InstantHelpState>(instantHelpViewModelProvider, (_, _) {});
      addTearDown(() async {
        subscription.close();
        container.dispose();
        await capture.dispose();
        await repository.dispose();
      });
      final InstantHelpViewModel viewModel = container.read(
        instantHelpViewModelProvider.notifier,
      );
      await viewModel.start();

      await viewModel.setCoachEnabled(enabled: true);
      expect(
        container.read(instantHelpViewModelProvider).isCoachEnabled,
        isTrue,
      );
      repository.events.add(
        SessionRealtimeEventEntity.coachingSuggestion(
          CoachingSuggestionEntity(
            id: 'tip-1',
            sessionId: 'session-external',
            kind: CoachingSuggestionKind.nextQuestion,
            text: 'Demande quel coût ce délai crée aujourd’hui.',
            rationale: 'Le besoin est encore abstrait.',
            sources: const <CoachingSourceEntity>[],
            confidence: 0.88,
            createdAt: DateTime.now().toUtc(),
            expiresAt: DateTime.now().toUtc().add(const Duration(seconds: 30)),
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(instantHelpViewModelProvider).suggestion?.id,
        'tip-1',
      );

      final ConversationSessionEntity? finalized = await viewModel
          .stopAndFinalize();
      expect(finalized?.status, ConversationSessionStatus.completed);
      expect(
        operations.where(
          (String value) => <String>{
            'capture-stop',
            'close-seller',
            'close-prospect',
            'finalize',
          }.contains(value),
        ),
        <String>['capture-stop', 'close-seller', 'close-prospect', 'finalize'],
      );
    },
  );
}

final class _ExternalSessionRepository
    implements ConversationSessionRepository {
  _ExternalSessionRepository(this.operations);

  final List<String> operations;
  final StreamController<SessionRealtimeEventEntity> events =
      StreamController<SessionRealtimeEventEntity>.broadcast(sync: true);
  CreateExternalConversationSessionParam? created;
  RecordTranscriptionConsentParam? recordedConsent;
  late ExternalConversationSessionEntity launch;

  Future<void> dispose() => events.close();

  @override
  Future<ExternalConversationSessionEntity> createExternalSession(
    CreateExternalConversationSessionParam params,
  ) async {
    operations.add('create');
    created = params;
    launch = ExternalConversationSessionEntity(
      session: ConversationSessionEntity(
        id: 'session-external',
        callId: 'external-call',
        status: ConversationSessionStatus.created,
        coachMode: params.coachModeOverride ?? CoachMode.off,
        createdAt: DateTime.utc(2026, 7, 14),
      ),
      source: ExternalConversationSource.macosMeeting,
      locale: 'fr-FR',
      mediaToken: 'ephemeral-token',
      media: ExternalMediaConfigurationEntity(
        encoding: 'pcm_s16le',
        sampleRate: 16000,
        channels: 1,
        sellerWebSocketUri: Uri.parse('wss://api.test/media?track=seller'),
        prospectWebSocketUri: Uri.parse('wss://api.test/media?track=prospect'),
      ),
      title: params.title,
    );
    return launch;
  }

  @override
  Future<TranscriptionConsentEntity> recordTranscriptionConsent(
    RecordTranscriptionConsentParam params,
  ) async {
    operations.add('consent');
    recordedConsent = params;
    return TranscriptionConsentEntity(
      sessionId: params.sessionId,
      acknowledged: params.acknowledged,
      method: params.method,
      acknowledgedAt: params.acknowledgedAt,
    );
  }

  @override
  Stream<SessionRealtimeEventEntity> watchSessionEvents(String sessionId) {
    operations.add('watch-events');
    return events.stream;
  }

  @override
  Future<ConversationSessionEntity> updateCoachMode(
    UpdateSessionCoachModeParam params,
  ) async {
    operations.add('coach-${params.mode.name}');
    final ConversationSessionEntity updated = launch.session.copyWith(
      coachMode: params.mode,
      transcriptionConsentAcknowledged: true,
    );
    launch = launch.copyWith(session: updated);
    return updated;
  }

  @override
  Future<ConversationSessionEntity> finalizeSession(String sessionId) async {
    operations.add('finalize');
    return launch.session.copyWith(
      status: ConversationSessionStatus.completed,
      endedAt: DateTime.utc(2026, 7, 14, 0, 3),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _MacosCaptureClient implements MacosCallAudioCaptureClient {
  _MacosCaptureClient(this.operations);

  final List<String> operations;
  final StreamController<Uint8List> microphone =
      StreamController<Uint8List>.broadcast(sync: true);
  final StreamController<Uint8List> system =
      StreamController<Uint8List>.broadcast(sync: true);

  @override
  Stream<Uint8List> get microphoneAudio => microphone.stream;

  @override
  Stream<Uint8List> get systemAudio => system.stream;

  @override
  Future<void> start({int sampleRate = 16000}) async {
    expect(sampleRate, 16000);
    operations.add('capture-start');
  }

  @override
  Future<void> stop() async => operations.add('capture-stop');

  @override
  Future<void> cancel() async => operations.add('capture-cancel');

  @override
  Future<void> dispose() async {
    await microphone.close();
    await system.close();
  }
}

final class _BinaryClient implements PinkallBinaryRealtimeClient {
  _BinaryClient(this.operations)
    : seller = _BinaryConnection('seller', operations),
      prospect = _BinaryConnection('prospect', operations);

  final List<String> operations;
  final _BinaryConnection seller;
  final _BinaryConnection prospect;

  @override
  Future<PinkallBinaryRealtimeConnection> connect(Uri uri) async {
    final String track = uri.queryParameters['track']!;
    operations.add('connect-$track');
    return track == 'seller' ? seller : prospect;
  }
}

final class _BinaryConnection implements PinkallBinaryRealtimeConnection {
  _BinaryConnection(this.track, this.operations);

  final String track;
  final List<String> operations;
  final List<Uint8List> frames = <Uint8List>[];
  bool closed = false;

  @override
  Future<void> send(Uint8List bytes) async =>
      frames.add(Uint8List.fromList(bytes));

  @override
  Future<void> close() async {
    if (closed) return;
    closed = true;
    operations.add('close-$track');
  }
}
