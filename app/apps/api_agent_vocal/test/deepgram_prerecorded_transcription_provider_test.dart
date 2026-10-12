import 'dart:convert';

import 'package:api_agent_vocal/src/domain/recording_transcription_contracts.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/deepgram_prerecorded_transcription_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  test(
    'streams audio to EU prerecorded diarization and parses utterances',
    () async {
      final DeepgramPrerecordedTranscriptionProvider provider =
          DeepgramPrerecordedTranscriptionProvider(
            apiKey: 'deepgram-test-secret',
            baseUrl: 'https://api.eu.deepgram.com',
            model: 'nova-3',
            diarizeModel: 'latest',
            httpClient: MockClient((http.Request request) async {
              expect(request.method, 'POST');
              expect(request.url.path, '/v1/listen');
              expect(request.url.queryParameters['model'], 'nova-3');
              expect(request.url.queryParameters['language'], 'fr');
              expect(request.url.queryParameters['diarize_model'], 'latest');
              expect(request.url.queryParameters['utterances'], 'true');
              expect(request.url.queryParameters, isNot(contains('diarize')));
              expect(
                request.headers['authorization'],
                'Token deepgram-test-secret',
              );
              expect(request.headers['content-type'], 'audio/mp4');
              expect(request.bodyBytes, <int>[1, 2, 3, 4]);
              return http.Response(
                jsonEncode(<String, Object?>{
                  'metadata': <String, Object?>{'duration': 12.5},
                  'results': <String, Object?>{
                    'channels': <Object?>[
                      <String, Object?>{'detected_language': 'fr'},
                    ],
                    'utterances': <Object?>[
                      <String, Object?>{
                        'speaker': 4,
                        'transcript': 'Bonjour, je vous appelle.',
                        'start': 0.2,
                        'end': 2.1,
                        'confidence': 0.94,
                      },
                      <String, Object?>{
                        'speaker': 9,
                        'transcript': 'Je vous écoute.',
                        'start': 2.4,
                        'end': 3.2,
                        'confidence': 0.91,
                      },
                    ],
                  },
                }),
                200,
              );
            }),
          );
      addTearDown(provider.dispose);

      final DiarizedRecordingTranscript transcript = await provider.transcribe(
        audio: RecordedAudioInput(
          fileName: 'appel.m4a',
          mimeType: 'audio/mp4',
          sizeBytes: 4,
          openRead: () => Stream<List<int>>.value(<int>[1, 2, 3, 4]),
        ),
        locale: 'fr-FR',
      );

      expect(transcript.durationSeconds, 12.5);
      expect(transcript.language, 'fr');
      expect(transcript.provider, 'deepgram_prerecorded:nova-3:latest');
      expect(
        transcript.segments.map(
          (DiarizedRecordingSegment item) => item.voiceId,
        ),
        <String>['4', '9'],
      );
      expect(transcript.segments.first.text, 'Bonjour, je vous appelle.');
    },
  );

  test('falls back to diarized words without inventing a speaker', () async {
    final DeepgramPrerecordedTranscriptionProvider provider =
        DeepgramPrerecordedTranscriptionProvider(
          apiKey: 'test-key',
          baseUrl: 'https://api.eu.deepgram.com/v1/listen',
          model: 'nova-3',
          diarizeModel: 'v2',
          httpClient: MockClient((http.Request request) async {
            return http.Response(
              jsonEncode(<String, Object?>{
                'metadata': <String, Object?>{'duration': 4},
                'results': <String, Object?>{
                  'channels': <Object?>[
                    <String, Object?>{
                      'alternatives': <Object?>[
                        <String, Object?>{
                          'words': <Object?>[
                            <String, Object?>{
                              'speaker': 7,
                              'punctuated_word': 'Bonjour',
                              'start': 0,
                              'end': 0.4,
                              'confidence': 0.8,
                            },
                            <String, Object?>{
                              'speaker': 7,
                              'punctuated_word': 'Monsieur.',
                              'start': 0.5,
                              'end': 1,
                              'confidence': 0.9,
                            },
                          ],
                        },
                      ],
                    },
                  ],
                },
              }),
              200,
            );
          }),
        );
    addTearDown(provider.dispose);

    final DiarizedRecordingTranscript transcript = await provider.transcribe(
      audio: RecordedAudioInput(
        fileName: 'appel.wav',
        mimeType: 'audio/wav',
        sizeBytes: 2,
        openRead: () => Stream<List<int>>.value(<int>[0, 0]),
      ),
      locale: 'fr',
    );

    expect(transcript.segments, hasLength(1));
    expect(transcript.segments.single.voiceId, '7');
    expect(transcript.segments.single.text, 'Bonjour Monsieur.');
  });

  test(
    'classifies provider throttling as retryable without leaking audio',
    () async {
      final DeepgramPrerecordedTranscriptionProvider provider =
          DeepgramPrerecordedTranscriptionProvider(
            apiKey: 'test-key',
            baseUrl: 'https://api.eu.deepgram.com',
            model: 'nova-3',
            diarizeModel: 'latest',
            httpClient: MockClient((http.Request request) async {
              return http.Response(
                jsonEncode(<String, Object?>{'err_msg': 'Capacity reached'}),
                429,
              );
            }),
          );
      addTearDown(provider.dispose);

      await expectLater(
        provider.transcribe(
          audio: RecordedAudioInput(
            fileName: 'appel.mp3',
            mimeType: 'audio/mpeg',
            sizeBytes: 2,
            openRead: () => Stream<List<int>>.value(<int>[1, 2]),
          ),
          locale: 'fr',
        ),
        throwsA(
          isA<RecordedTranscriptionException>()
              .having(
                (RecordedTranscriptionException error) => error.code,
                'code',
                'provider_rate_limited',
              )
              .having(
                (RecordedTranscriptionException error) => error.retryable,
                'retryable',
                isTrue,
              ),
        ),
      );
    },
  );
}
