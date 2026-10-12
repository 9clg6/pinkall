import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/stt_contracts.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/deepgram_flux_stt_provider.dart';
import 'package:test/test.dart';

void main() {
  test('uses Flux v2, 80 ms mono chunks and turn-aware events', () async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final List<int> audioChunkLengths = <int>[];
    final Completer<void> serverCompleted = Completer<void>();
    server.listen((HttpRequest request) async {
      try {
        expect(request.uri.path, '/v2/listen');
        expect(
          request.uri.queryParameters,
          containsPair('model', 'flux-general-multi'),
        );
        expect(
          request.uri.queryParameters,
          containsPair('encoding', 'linear16'),
        );
        expect(
          request.uri.queryParameters,
          containsPair('sample_rate', '8000'),
        );
        expect(
          request.uri.queryParameters,
          containsPair('language_hint', 'fr'),
        );
        expect(
          request.uri.queryParameters,
          containsPair('eot_threshold', '0.8'),
        );
        expect(
          request.uri.queryParameters,
          containsPair('eager_eot_threshold', '0.6'),
        );
        expect(
          request.uri.queryParameters,
          containsPair('eot_timeout_ms', '2500'),
        );
        expect(request.headers.value('authorization'), 'Token test-key');
        final WebSocket socket = await WebSocketTransformer.upgrade(request);
        bool transcriptSent = false;
        await for (final dynamic raw in socket) {
          if (raw is List<int>) {
            audioChunkLengths.add(raw.length);
            if (!transcriptSent) {
              transcriptSent = true;
              for (final Map<String, Object?> message in _oneTurnMessages()) {
                socket.add(jsonEncode(message));
              }
            }
            continue;
          }
          final Map<String, Object?> message =
              jsonDecode(raw as String) as Map<String, Object?>;
          if (message['type'] == 'CloseStream') {
            socket.add(
              jsonEncode(<String, Object?>{
                'type': 'Metadata',
                'request_id': 'request-1',
              }),
            );
            await socket.close();
            serverCompleted.complete();
          }
        }
      } on Object catch (error, stackTrace) {
        if (!serverCompleted.isCompleted) {
          serverCompleted.completeError(error, stackTrace);
        }
      }
    });
    addTearDown(() => server.close(force: true));

    final DeepgramFluxRealtimeSession session =
        await DeepgramFluxRealtimeSession.connect(
          apiKey: 'test-key',
          baseUrl: 'ws://127.0.0.1:${server.port}',
          model: 'flux-general-multi',
          languageHint: 'fr',
          endOfTurnThreshold: 0.8,
          eagerEndOfTurnThreshold: 0.6,
          endOfTurnTimeoutMs: 2500,
          audioFormat: const SttAudioFormat(
            encoding: 'pcm_s16le',
            sampleRate: 8000,
          ),
        );
    final List<SttEvent> events = <SttEvent>[];
    final Completer<void> eventsDone = Completer<void>();
    session.events.listen(events.add, onDone: eventsDone.complete);

    await session.addAudio(List<int>.filled(640, 0));
    await session.addAudio(List<int>.filled(640, 1));
    await session.addAudio(<int>[2, 0, 3, 0]);
    await session.close();
    await serverCompleted.future.timeout(const Duration(seconds: 2));
    await eventsDone.future.timeout(const Duration(seconds: 2));

    expect(audioChunkLengths, <int>[1280, 4]);
    expect(
      events
          .whereType<SttTextDelta>()
          .map((SttTextDelta event) => event.text)
          .join(),
      'Bonjour je vous appelle parce que',
    );
    final SttSegment segment = events.whereType<SttSegment>().single;
    expect(segment.text, 'Bonjour je vous appelle parce que.');
    expect(segment.startSeconds, 0.42);
    expect(segment.endSeconds, 1.72);
    expect(segment.isTurnEnd, isTrue);
    expect(segment.providerTurnId, '0');
    final SttEagerTurnEnd eager = events.whereType<SttEagerTurnEnd>().single;
    expect(eager.text, 'Bonjour je vous appelle');
    expect(eager.providerTurnId, '0');
    expect(eager.startSeconds, 0);
    expect(eager.endSeconds, 1);
    final int eagerIndex = events.indexOf(eager);
    expect(
      events
          .take(eagerIndex)
          .whereType<SttTextDelta>()
          .map((SttTextDelta event) => event.text)
          .join(),
      eager.text,
      reason: 'the eager snapshot must follow its matching transcript deltas',
    );
    expect(events.whereType<SttTurnResumed>().single.providerTurnId, '0');
    expect(
      events.whereType<SttDone>().single.text,
      'Bonjour je vous appelle parce que.',
    );
    final List<SttTurnTelemetry> telemetry = events
        .whereType<SttTurnTelemetry>()
        .toList(growable: false);
    expect(telemetry.map((SttTurnTelemetry item) => item.event), <String>[
      'Update',
      'StartOfTurn',
      'Update',
      'EagerEndOfTurn',
      'TurnResumed',
      'EndOfTurn',
    ]);
    expect(telemetry.last.turnIndex, 0);
    expect(telemetry.last.sequenceId, 5);
    expect(telemetry.last.audioWindowStart, 0);
    expect(telemetry.last.audioWindowEnd, 2);
    expect(telemetry.last.endOfTurnConfidence, 0.93);
    expect(events.whereType<SttFailure>(), isEmpty);
  });

  test(
    'does not fabricate append-only deltas after an interim revision',
    () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      final Completer<void> serverCompleted = Completer<void>();
      server.listen((HttpRequest request) async {
        final WebSocket socket = await WebSocketTransformer.upgrade(request);
        bool sent = false;
        await for (final dynamic raw in socket) {
          if (raw is List<int> && !sent) {
            sent = true;
            for (final Map<String, Object?> message in <Map<String, Object?>>[
              _turnInfo(0, 'StartOfTurn', 'Je souhaite annuler'),
              _turnInfo(1, 'TurnResumed', 'Je souhaite changer'),
              _turnInfo(2, 'Update', 'Je souhaite changer mon offre'),
              _turnInfo(3, 'EndOfTurn', 'Je souhaite changer mon offre.'),
              // A provider retry must not duplicate an already-finalized turn.
              _turnInfo(4, 'EndOfTurn', 'Je souhaite changer mon offre.'),
            ]) {
              socket.add(jsonEncode(message));
            }
            continue;
          }
          if (raw is String &&
              (jsonDecode(raw) as Map<String, Object?>)['type'] ==
                  'CloseStream') {
            await socket.close();
            serverCompleted.complete();
          }
        }
      });
      addTearDown(() => server.close(force: true));

      final DeepgramFluxRealtimeSession session =
          await DeepgramFluxRealtimeSession.connect(
            apiKey: 'test-key',
            baseUrl: 'ws://127.0.0.1:${server.port}',
            model: 'flux-general-multi',
            languageHint: 'fr',
            endOfTurnThreshold: 0.8,
            eagerEndOfTurnThreshold: 0.6,
            endOfTurnTimeoutMs: 2500,
            audioFormat: const SttAudioFormat(
              encoding: 'pcm_s16le',
              sampleRate: 16000,
            ),
          );
      final List<SttEvent> events = <SttEvent>[];
      session.events.listen(events.add);

      await session.addAudio(List<int>.filled(2560, 0));
      await session.close();
      await serverCompleted.future.timeout(const Duration(seconds: 2));

      expect(
        events.whereType<SttTextDelta>().single.text,
        'Je souhaite annuler',
      );
      expect(events.whereType<SttSegment>(), hasLength(1));
      expect(
        events.whereType<SttSegment>().single.text,
        'Je souhaite changer mon offre.',
      );
    },
  );

  test(
    'surfaces one bounded provider failure and still closes safely',
    () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      final Completer<void> serverCompleted = Completer<void>();
      server.listen((HttpRequest request) async {
        final WebSocket socket = await WebSocketTransformer.upgrade(request);
        bool sent = false;
        await for (final dynamic raw in socket) {
          if (raw is List<int> && !sent) {
            sent = true;
            socket
              ..add(
                jsonEncode(<String, Object?>{
                  'type': 'Error',
                  'code': 'INVALID_PARAMETER',
                  'description': 'Unsupported parameter',
                }),
              )
              ..add('{invalid-json');
            continue;
          }
          if (raw is String &&
              (jsonDecode(raw) as Map<String, Object?>)['type'] ==
                  'CloseStream') {
            await socket.close();
            serverCompleted.complete();
          }
        }
      });
      addTearDown(() => server.close(force: true));

      final DeepgramFluxRealtimeSession session =
          await DeepgramFluxRealtimeSession.connect(
            apiKey: 'test-key',
            baseUrl: 'ws://127.0.0.1:${server.port}',
            model: 'flux-general-multi',
            languageHint: 'fr',
            endOfTurnThreshold: 0.8,
            eagerEndOfTurnThreshold: 0.6,
            endOfTurnTimeoutMs: 2500,
            audioFormat: const SttAudioFormat(
              encoding: 'pcm_s16le',
              sampleRate: 8000,
            ),
          );
      final List<SttEvent> events = <SttEvent>[];
      session.events.listen(events.add);

      await session.addAudio(List<int>.filled(1280, 0));
      await expectLater(session.close(), completes);
      await serverCompleted.future.timeout(const Duration(seconds: 2));

      expect(events.whereType<SttFailure>(), hasLength(1));
      expect(
        events.whereType<SttFailure>().single.message,
        'Deepgram Flux error: Unsupported parameter',
      );
    },
  );

  test(
    'rejects unsupported audio and invalid language/model combinations',
    () async {
      Future<DeepgramFluxRealtimeSession> connect({
        String model = 'flux-general-multi',
        String? languageHint = 'fr',
        String encoding = 'pcm_s16le',
        int sampleRate = 8000,
      }) {
        return DeepgramFluxRealtimeSession.connect(
          apiKey: 'test-key',
          baseUrl: 'ws://127.0.0.1:1',
          model: model,
          languageHint: languageHint,
          endOfTurnThreshold: 0.8,
          eagerEndOfTurnThreshold: 0.6,
          endOfTurnTimeoutMs: 2500,
          audioFormat: SttAudioFormat(
            encoding: encoding,
            sampleRate: sampleRate,
          ),
        );
      }

      await expectLater(connect(encoding: 'mulaw'), throwsUnsupportedError);
      await expectLater(connect(sampleRate: 11025), throwsUnsupportedError);
      await expectLater(connect(model: 'flux'), throwsArgumentError);
      await expectLater(
        connect(model: 'flux-general-en', languageHint: 'fr'),
        throwsArgumentError,
      );
    },
  );

  test(
    'delegates final transcription to the configured batch provider',
    () async {
      final _RecordingBatchProvider batch = _RecordingBatchProvider();
      final DeepgramFluxSttProvider provider = DeepgramFluxSttProvider(
        apiKey: 'deepgram-key',
        realtimeBaseUrl: 'wss://api.eu.deepgram.com',
        model: 'flux-general-multi',
        languageHint: 'fr',
        endOfTurnThreshold: 0.8,
        eagerEndOfTurnThreshold: 0.6,
        endOfTurnTimeoutMs: 2500,
        batchProvider: batch,
      );

      final BatchTranscript transcript = await provider.transcribeFinal(
        pcmBytes: <int>[0, 0],
        audioFormat: const SttAudioFormat(
          encoding: 'pcm_s16le',
          sampleRate: 8000,
        ),
        fileName: 'call.wav',
      );

      expect(provider.name, 'deepgram_flux');
      expect(provider.isConfigured, isTrue);
      expect(provider.providesSemanticTurnBoundaries, isTrue);
      expect(batch.providesSemanticTurnBoundaries, isFalse);
      expect(transcript.provider, 'batch-test');
      expect(batch.fileName, 'call.wav');
    },
  );
}

List<Map<String, Object?>> _oneTurnMessages() {
  return <Map<String, Object?>>[
    _turnInfo(0, 'Update', ''),
    _turnInfo(1, 'StartOfTurn', 'Bonjour'),
    _turnInfo(2, 'Update', 'Bonjour je'),
    _turnInfo(3, 'EagerEndOfTurn', 'Bonjour je vous appelle'),
    _turnInfo(4, 'TurnResumed', 'Bonjour je vous appelle parce que'),
    <String, Object?>{
      ..._turnInfo(5, 'EndOfTurn', 'Bonjour je vous appelle parce que.'),
      'audio_window_start': 0,
      'audio_window_end': 2,
      'words': <Map<String, Object?>>[
        <String, Object?>{'word': 'Bonjour', 'start': 0.42, 'end': 0.71},
        <String, Object?>{'word': 'que.', 'start': 1.55, 'end': 1.72},
      ],
    },
  ];
}

Map<String, Object?> _turnInfo(
  int sequenceId,
  String event,
  String transcript,
) {
  return <String, Object?>{
    'type': 'TurnInfo',
    'request_id': 'request-1',
    'sequence_id': sequenceId,
    'event': event,
    'turn_index': 0,
    'audio_window_start': 0,
    'audio_window_end': 1,
    'end_of_turn_confidence': event == 'EndOfTurn' ? 0.93 : 0.2,
    'transcript': transcript,
    'words': const <Object?>[],
  };
}

final class _RecordingBatchProvider implements SttProvider {
  String? fileName;

  @override
  bool get isConfigured => true;

  @override
  bool get providesSemanticTurnBoundaries => false;

  @override
  String get name => 'batch-test';

  @override
  Future<RealtimeSttSession> openRealtimeSession({
    required MediaTrack track,
    required SttAudioFormat audioFormat,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BatchTranscript> transcribeFinal({
    required List<int> pcmBytes,
    required SttAudioFormat audioFormat,
    required String fileName,
  }) async {
    this.fileName = fileName;
    return const BatchTranscript(
      text: 'final',
      language: 'fr',
      segments: <BatchTranscriptSegment>[],
      provider: 'batch-test',
    );
  }
}
