import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/crm/presentation/crm.screen.dart';

void main() {
  testWidgets('renders a real-contact master-detail CRM on desktop', (
    WidgetTester tester,
  ) async {
    final _TestContactRepository repository = _TestContactRepository(
      contacts: <ContactEntity>[
        _contact(
          id: 'alice',
          phone: '+33611111111',
          firstName: 'Alice',
          lastName: 'Durand',
          company: 'Northstar',
          jobTitle: 'Fondatrice',
          email: 'alice@northstar.test',
          market: ContactMarket.b2b,
          professionalRelevanceConfirmed: true,
          customFields: const <String, String>{'Source': 'Salon SaaS'},
        ),
        _contact(
          id: 'bob',
          phone: '+33622222222',
          firstName: 'Bob',
          lastName: 'Martin',
          company: 'Atelier B',
          email: 'bob@atelier.test',
          market: ContactMarket.b2c,
          hasPriorConsent: true,
        ),
      ],
    );

    await _pumpCrm(tester, repository: repository, size: const Size(1280, 820));

    expect(find.text('PROSPECT'), findsOneWidget);
    expect(find.text('alice@northstar.test'), findsOneWidget);
    expect(find.text('Salon SaaS'), findsOneWidget);
    expect(find.text('Aucune prochaine action enregistrée.'), findsOneWidget);
    expect(
      find.text('Aucune activité enregistrée pour ce prospect.'),
      findsOneWidget,
    );
    expect(find.byTooltip('Copier le numéro'), findsOneWidget);
    expect(find.byType(Card), findsNothing);

    await tester.tap(find.text('Bob Martin').first);
    await tester.pumpAndSettle();

    expect(find.text('bob@atelier.test'), findsOneWidget);
    expect(find.text('alice@northstar.test'), findsNothing);

    await tester.tap(find.byTooltip('Plus d’actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Actualiser les contacts'));
    await tester.pumpAndSettle();

    expect(repository.listCalls, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the empty state and creates a backend contact on mobile', (
    WidgetTester tester,
  ) async {
    final _TestContactRepository repository = _TestContactRepository();
    await _pumpCrm(tester, repository: repository, size: const Size(390, 844));

    expect(find.text('Ta liste d’appels est vide'), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, 'Ajouter un prospect'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextButton, 'Importer une liste'),
      findsOneWidget,
    );
    expect(find.text('Appeler'), findsNothing);
    expect(find.text('Contacts'), findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, 'Ajouter un prospect'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Téléphone *'),
      '+33633333333',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Ajouter'));
    await tester.pumpAndSettle();

    expect(repository.lastCreated?.phoneNumber, '+33633333333');
    expect(find.text('+33633333333'), findsOneWidget);
    expect(find.text('Contact ajouté au CRM.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens a real contact in a read-only mobile detail sheet', (
    WidgetTester tester,
  ) async {
    final _TestContactRepository repository = _TestContactRepository(
      contacts: <ContactEntity>[
        _contact(
          id: 'mobile-detail',
          phone: '+33677777777',
          firstName: 'Maya',
          lastName: 'Lopez',
          company: 'Atelier 17',
          email: 'maya@atelier17.test',
          customFields: const <String, String>{'Source': 'Recommandation'},
        ),
      ],
    );
    await _pumpCrm(tester, repository: repository, size: const Size(390, 844));

    expect(find.text('maya@atelier17.test'), findsNothing);
    await tester.tap(find.text('Maya Lopez'));
    await tester.pumpAndSettle();

    expect(find.text('PROSPECT'), findsOneWidget);
    expect(find.text('maya@atelier17.test'), findsOneWidget);
    expect(find.text('Recommandation'), findsOneWidget);
    expect(find.byTooltip('Fermer la fiche'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('imports pasted CSV and surfaces backend-confirmed feedback', (
    WidgetTester tester,
  ) async {
    final _TestContactRepository repository = _TestContactRepository();
    await _pumpCrm(tester, repository: repository, size: const Size(430, 900));

    await tester.tap(find.widgetWithText(TextButton, 'Importer une liste'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).last,
      'phone_number,first_name,market\n+33644444444,Chloé,b2b',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Importer'));
    await tester.pumpAndSettle();

    expect(repository.lastImport?.rows, hasLength(1));
    expect(find.text('Chloé'), findsOneWidget);
    expect(find.text('1 importé(s), 0 ignoré(s).'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('retries the initial backend error', (WidgetTester tester) async {
    final _TestContactRepository repository = _TestContactRepository(
      contacts: <ContactEntity>[
        _contact(
          id: 'recovered',
          phone: '+33655555555',
          firstName: 'Recovery',
          lastName: 'Contact',
        ),
      ],
      remainingListFailures: 1,
    );
    await _pumpCrm(tester, repository: repository, size: const Size(390, 844));

    expect(find.text('Impossible de charger les contacts'), findsOneWidget);
    expect(find.textContaining('backend test'), findsNothing);
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(find.text('Recovery Contact'), findsOneWidget);
    expect(repository.listCalls, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('embedded directory returns the selected backend contact', (
    WidgetTester tester,
  ) async {
    final ContactEntity contact = _contact(
      id: 'dialer-selection',
      phone: '+33690909090',
      firstName: 'Nora',
      lastName: 'Diallo',
      market: ContactMarket.b2b,
    );
    final _TestContactRepository repository = _TestContactRepository(
      contacts: <ContactEntity>[contact],
    );
    ContactEntity? selected;
    tester.view.physicalSize = const Size(380, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          contactRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: PinkallTheme.light,
          home: Scaffold(
            body: CrmContactDirectoryPane(
              compact: true,
              onContactSelected: (ContactEntity value) => selected = value,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nora Diallo'));
    await tester.pump();

    expect(selected?.id, contact.id);
    expect(selected?.phoneNumber, contact.phoneNumber);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpCrm(
  WidgetTester tester, {
  required _TestContactRepository repository,
  required Size size,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        contactRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: PinkallTheme.light,
        home: const CrmScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

ContactEntity _contact({
  required String id,
  required String phone,
  String? firstName,
  String? lastName,
  String? company,
  String? jobTitle,
  String? email,
  ContactMarket market = ContactMarket.unknown,
  bool? hasPriorConsent,
  bool? professionalRelevanceConfirmed,
  Map<String, String> customFields = const <String, String>{},
}) {
  return ContactEntity(
    id: id,
    phoneNumber: phone,
    market: market,
    createdAt: DateTime.utc(2026, 7, 12),
    updatedAt: DateTime.utc(2026, 7, 12),
    firstName: firstName,
    lastName: lastName,
    company: company,
    jobTitle: jobTitle,
    email: email,
    hasPriorConsent: hasPriorConsent,
    hasOptedOut: false,
    professionalRelevanceConfirmed: professionalRelevanceConfirmed,
    customFields: customFields,
  );
}

final class _TestContactRepository implements ContactRepository {
  _TestContactRepository({
    List<ContactEntity> contacts = const <ContactEntity>[],
    this.remainingListFailures = 0,
  }) : contacts = List<ContactEntity>.of(contacts);

  final List<ContactEntity> contacts;
  int remainingListFailures;
  int listCalls = 0;
  CreateContactParam? lastCreated;
  ImportContactsParam? lastImport;

  @override
  Future<List<ContactEntity>> listContacts(ListContactsParam params) async {
    listCalls += 1;
    if (remainingListFailures > 0) {
      remainingListFailures -= 1;
      throw StateError('backend test indisponible');
    }
    return List<ContactEntity>.unmodifiable(contacts);
  }

  @override
  Future<ContactEntity> createContact(CreateContactParam params) async {
    lastCreated = params;
    final ContactEntity created = ContactEntity(
      id: 'created-${contacts.length + 1}',
      phoneNumber: params.phoneNumber,
      market: params.market,
      createdAt: DateTime.utc(2026, 7, 12),
      updatedAt: DateTime.utc(2026, 7, 12),
      firstName: params.firstName,
      lastName: params.lastName,
      company: params.company,
      jobTitle: params.jobTitle,
      email: params.email,
      hasPriorConsent: params.hasPriorConsent,
      hasOptedOut: params.hasOptedOut,
      professionalRelevanceConfirmed: params.professionalRelevanceConfirmed,
      customFields: params.customFields,
    );
    contacts.add(created);
    return created;
  }

  @override
  Future<ContactImportResultEntity> importContacts(
    ImportContactsParam params,
  ) async {
    lastImport = params;
    for (final ContactImportRowParam row in params.rows) {
      contacts.add(
        ContactEntity(
          id: 'imported-${contacts.length + 1}',
          phoneNumber: row.phoneNumber,
          market: row.market,
          createdAt: DateTime.utc(2026, 7, 12),
          updatedAt: DateTime.utc(2026, 7, 12),
          firstName: row.firstName,
          lastName: row.lastName,
          company: row.company,
          jobTitle: row.jobTitle,
          email: row.email,
          hasPriorConsent: row.hasPriorConsent,
          hasOptedOut: row.hasOptedOut,
          professionalRelevanceConfirmed: row.professionalRelevanceConfirmed,
          customFields: row.customFields,
        ),
      );
    }
    return ContactImportResultEntity(
      importId: 'test-import',
      importedCount: params.rows.length,
      skippedCount: 0,
    );
  }
}
