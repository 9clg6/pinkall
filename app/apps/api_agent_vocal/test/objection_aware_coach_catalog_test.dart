import 'dart:io';

import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/objection_learning.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/file_objection_learning_sink.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/objection_aware_coach_catalog.dart';
import 'package:test/test.dart';

void main() {
  test('exposes a matching custom answer as a live coach candidate', () async {
    final Directory directory = await Directory.systemTemp.createTemp(
      'pinkall-custom-catalog-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final FileObjectionLearningSink library = FileObjectionLearningSink(
      File('${directory.path}/objections.json'),
    );
    await library.addCustom(
      const CreateCustomObjection(
        category: 'competition',
        text: 'Nous travaillons déjà avec un concurrent.',
        responseContent:
            'Demandez ce qui fonctionne bien aujourd’hui avant de comparer.',
        responseSourceType: 'text',
      ),
    );
    final ObjectionAwareCoachCatalog catalog = ObjectionAwareCoachCatalog(
      base: const _EmptyCatalog(),
      objectionLibrary: library,
    );

    final List<CoachRecommendation> candidates = catalog.candidatesFor(
      mode: CoachMode.live,
      latestText: 'On travaille déjà avec votre concurrent principal.',
    );

    expect(candidates, hasLength(1));
    expect(candidates.single.id, startsWith('custom_objection_'));
    expect(candidates.single.message, contains('fonctionne bien'));
    expect(candidates.single.raw['custom_user_response'], isTrue);
    expect(
      candidates.single.toPromptJson()['trust_level'],
      'untrusted_user_authored_response',
    );
  });

  test('does not expose unrelated custom answers', () async {
    final Directory directory = await Directory.systemTemp.createTemp(
      'pinkall-custom-catalog-unrelated-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final FileObjectionLearningSink library = FileObjectionLearningSink(
      File('${directory.path}/objections.json'),
    );
    await library.addCustom(
      const CreateCustomObjection(
        category: 'price',
        text: 'Le prix est trop élevé.',
        responseContent: 'Revenir à la valeur.',
        responseSourceType: 'text',
      ),
    );
    final ObjectionAwareCoachCatalog catalog = ObjectionAwareCoachCatalog(
      base: const _EmptyCatalog(),
      objectionLibrary: library,
    );

    expect(
      catalog.candidatesFor(
        mode: CoachMode.live,
        latestText: 'Envoyez-moi les disponibilités de votre équipe.',
      ),
      isEmpty,
    );
  });
}

final class _EmptyCatalog implements CoachCatalog {
  const _EmptyCatalog();

  @override
  bool get isAvailable => false;
  @override
  bool get allowsUnreviewedRecommendations => false;
  @override
  int get defaultExpirySeconds => 12;
  @override
  Duration get globalCooldown => const Duration(seconds: 1);
  @override
  int get maxEvaluationsPerMinute => 12;
  @override
  int get maxSuggestionsPerMinute => 2;
  @override
  double get minimumContextMatch => 0.76;
  @override
  double get minimumLiveConfidence => 0.78;
  @override
  CoachReleaseChannel get releaseChannel => CoachReleaseChannel.strict;
  @override
  String get unavailableReason => 'empty';
  @override
  List<CoachRecommendation> candidatesFor({
    required CoachMode mode,
    required String latestText,
  }) => const <CoachRecommendation>[];
  @override
  List<CoachRecommendation> postCallCandidates() =>
      const <CoachRecommendation>[];
}
