import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/objection_learning.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/file_objection_learning_sink.dart';
import 'package:test/test.dart';

void main() {
  test('records new objections and merges equivalent later wording', () async {
    final Directory directory = await Directory.systemTemp.createTemp(
      'pinkall-objections-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final File file = File('${directory.path}/discovered.local.json');
    final FileObjectionLearningSink sink = FileObjectionLearningSink(file);
    final DateTime firstSeen = DateTime.utc(2026, 7, 15, 8);

    final ObjectionLearningResult first = await sink.learn(
      sessionId: 'session-sensitive-1',
      objections: <PostCallObjection>[
        _priceObjection('Le prix est trop élevé.'),
      ],
      transcript: <TranscriptSegment>[_segment()],
      observedAt: firstSeen,
    );
    final ObjectionLearningResult second = await sink.learn(
      sessionId: 'session-sensitive-2',
      objections: <PostCallObjection>[
        _priceObjection('Le tarif est trop élevé.'),
      ],
      transcript: <TranscriptSegment>[_segment()],
      observedAt: firstSeen.add(const Duration(minutes: 5)),
    );

    expect(first.newCount, 1);
    expect(second.updatedCount, 1);
    final Map<String, Object?> document =
        jsonDecode(await file.readAsString()) as Map<String, Object?>;
    final List<Object?> entries = document['entries']! as List<Object?>;
    expect(entries, hasLength(1));
    final Map<String, Object?> entry = entries.single! as Map<String, Object?>;
    expect(entry['review_status'], 'candidate');
    expect(entry['occurrence_count'], 2);
    expect(jsonEncode(entry), isNot(contains('session-sensitive')));
    expect(jsonEncode(entry), isNot(contains('06 12 34 56 78')));
    expect(jsonEncode(entry), isNot(contains('prospect@example.com')));
    expect(jsonEncode(entry), contains('[phone]'));
    expect(jsonEncode(entry), contains('[email]'));
  });

  test(
    'serializes concurrent learning writes without losing entries',
    () async {
      final Directory directory = await Directory.systemTemp.createTemp(
        'pinkall-objections-concurrent-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final File file = File('${directory.path}/discovered.local.json');
      final FileObjectionLearningSink sink = FileObjectionLearningSink(file);

      final List<ObjectionLearningResult> results = await Future.wait(
        <Future<ObjectionLearningResult>>[
          sink.learn(
            sessionId: 'session-price',
            objections: <PostCallObjection>[
              _priceObjection('Le prix est trop élevé.'),
            ],
            transcript: <TranscriptSegment>[_segment()],
            observedAt: DateTime.utc(2026, 7, 15, 8),
          ),
          sink.learn(
            sessionId: 'session-timing',
            objections: const <PostCallObjection>[
              PostCallObjection(
                category: PostCallObjectionCategory.timing,
                text: 'Ce n’est pas le bon moment.',
                responseAngle: 'Comprendre le calendrier réel.',
                suggestedResponse:
                    'Qu’est-ce qui doit changer avant d’avancer ?',
                evidenceSegmentIds: <String>['segment-1'],
                confidence: 0.86,
              ),
            ],
            transcript: <TranscriptSegment>[_segment()],
            observedAt: DateTime.utc(2026, 7, 15, 8, 1),
          ),
        ],
      );

      expect(
        results.map((ObjectionLearningResult item) => item.newCount),
        <int>[1, 1],
      );
      final Map<String, Object?> document =
          jsonDecode(await file.readAsString()) as Map<String, Object?>;
      expect(
        document['entries'],
        isA<List<Object?>>().having(
          (List<Object?> value) => value.length,
          'length',
          2,
        ),
      );
    },
  );

  test('adds a custom response and promotes an equivalent candidate', () async {
    final Directory directory = await Directory.systemTemp.createTemp(
      'pinkall-objections-custom-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final FileObjectionLearningSink sink = FileObjectionLearningSink(
      File('${directory.path}/discovered.local.json'),
    );
    await sink.learn(
      sessionId: 'session-price',
      objections: <PostCallObjection>[
        _priceObjection('Le prix est trop élevé.'),
      ],
      transcript: <TranscriptSegment>[_segment()],
      observedAt: DateTime.utc(2026, 7, 15, 8),
    );

    final ObjectionKnowledgeEntry saved = await sink.addCustom(
      const CreateCustomObjection(
        category: 'price',
        text: 'Le tarif est trop élevé.',
        responseContent:
            'Revenir à la valeur puis demander quel élément bloque la décision.',
        responseSourceType: 'file',
        responseSourceName: 'playbook-prix.md',
      ),
    );

    expect(saved.origin, ObjectionKnowledgeOrigin.detectedAndCustom);
    expect(saved.reviewStatus, 'live');
    expect(saved.occurrenceCount, 1);
    expect(saved.responseSourceName, 'playbook-prix.md');
    expect(sink.listEntries(), hasLength(1));
    expect(sink.listEntries().single.responseContent, contains('valeur'));
  });

  test('rejects oversized or unsafe custom response metadata', () async {
    final Directory directory = await Directory.systemTemp.createTemp(
      'pinkall-objections-invalid-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final FileObjectionLearningSink sink = FileObjectionLearningSink(
      File('${directory.path}/discovered.local.json'),
    );

    await expectLater(
      sink.addCustom(
        const CreateCustomObjection(
          category: 'price',
          text: 'C’est trop cher.',
          responseContent: 'Réponse',
          responseSourceType: 'file',
          responseSourceName: 'secret<.md',
        ),
      ),
      throwsA(isA<FormatException>()),
    );
    await expectLater(
      sink.addCustom(
        const CreateCustomObjection(
          category: 'price',
          text: 'Le prix est trop élevé',
          responseContent: 'éé',
          responseSourceType: 'file',
          responseSourceName: 'playbook.pdf',
        ),
      ),
      throwsA(isA<FormatException>()),
    );
    await expectLater(
      sink.addCustom(
        CreateCustomObjection(
          category: 'price',
          text: 'Le prix est trop élevé',
          responseContent: List<String>.filled(17000, 'é').join(),
          responseSourceType: 'text',
          responseSourceName: null,
        ),
      ),
      throwsA(isA<FormatException>()),
    );
  });
}

PostCallObjection _priceObjection(String text) => PostCallObjection(
  category: PostCallObjectionCategory.price,
  text: text,
  responseAngle: 'Clarifier la perception de valeur.',
  suggestedResponse: 'Quel point rend cet investissement difficile ?',
  evidenceSegmentIds: const <String>['segment-1'],
  confidence: 0.9,
);

TranscriptSegment _segment() => TranscriptSegment(
  id: 'segment-1',
  track: MediaTrack.inbound,
  speaker: SpeakerRole.prospect,
  text:
      'C’est trop cher. Appelez-moi au 06 12 34 56 78 ou prospect@example.com.',
  startSeconds: 0,
  endSeconds: 2,
  isFinal: true,
  provider: 'test',
  createdAt: DateTime.utc(2026, 7, 15),
);
