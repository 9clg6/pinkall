import 'package:core_domain/core_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/coaching/presentation/screens/objections/objection_library.screen.dart';

void main() {
  testWidgets('shows learned objections and saves a manual answer', (
    WidgetTester tester,
  ) async {
    final _TestCoachingRepository repository = _TestCoachingRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          coachingRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: ObjectionLibraryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Le prix est trop élevé.'), findsOneWidget);
    expect(find.text('À enrichir'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add_custom_objection_button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('custom_objection_text_field')),
      'Nous avons déjà un fournisseur.',
    );
    await tester.enterText(
      find.byKey(const Key('custom_objection_response_field')),
      'Demander ce qui fonctionne bien avant de proposer une comparaison.',
    );
    final Finder saveButton = find.byKey(
      const Key('custom_objection_save_button'),
    );
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(repository.created, isNotNull);
    expect(repository.created!.category, 'price');
    expect(repository.created!.responseSourceType, 'text');
    expect(find.text('Réponse prête'), findsOneWidget);
    expect(
      find.text('La réponse est prête pour les prochains appels.'),
      findsOneWidget,
    );
  });
}

final class _TestCoachingRepository implements CoachingRepository {
  final List<ObjectionKnowledgeEntryEntity> entries =
      <ObjectionKnowledgeEntryEntity>[
        ObjectionKnowledgeEntryEntity(
          id: 'objection-price',
          category: 'price',
          text: 'Le prix est trop élevé.',
          reviewStatus: 'candidate',
          origin: 'detected',
          occurrenceCount: 2,
          firstSeenAt: DateTime.utc(2026, 7, 15),
          lastSeenAt: DateTime.utc(2026, 7, 15),
        ),
      ];
  CreateCustomObjectionParam? created;

  @override
  Future<List<ObjectionKnowledgeEntryEntity>> listObjections() async =>
      List<ObjectionKnowledgeEntryEntity>.unmodifiable(entries);

  @override
  Future<ObjectionKnowledgeEntryEntity> createCustomObjection(
    CreateCustomObjectionParam params,
  ) async {
    created = params;
    final ObjectionKnowledgeEntryEntity entry = ObjectionKnowledgeEntryEntity(
      id: 'custom-objection',
      category: params.category,
      text: params.text,
      reviewStatus: 'live',
      origin: 'custom',
      occurrenceCount: 0,
      firstSeenAt: DateTime.utc(2026, 7, 15),
      lastSeenAt: DateTime.utc(2026, 7, 15),
      responseContent: params.responseContent,
      responseSourceType: params.responseSourceType,
      responseSourceName: params.responseSourceName,
    );
    entries.insert(0, entry);
    return entry;
  }

  @override
  Future<CoachPreferenceEntity> getPreference() => throw UnimplementedError();

  @override
  Future<CoachPreferenceEntity> updatePreference(
    UpdateCoachPreferenceParam params,
  ) => throw UnimplementedError();

  @override
  Future<CoachingFeedbackEntity> submitFeedback(
    SubmitCoachingFeedbackParam params,
  ) => throw UnimplementedError();

  @override
  Future<CallOutcomeEntity> recordOutcome(RecordCallOutcomeParam params) =>
      throw UnimplementedError();
}
