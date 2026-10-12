# Architecture Pinkall — POC Flutter

> Statut : architecture de référence du POC  
> Périmètre : iOS, Android et macOS depuis une application Flutter unique  
> Source normative : [`../../ARCHITECTURE.md`](../../ARCHITECTURE.md)  
> En cas de divergence, `ARCHITECTURE.md` prévaut.

## 1. Décision en une phrase

Pinkall est un monorepo Dart/Flutter structuré en quatre packages à dépendances unidirectionnelles et une application `apps/app_mobile`. Le POC livre une tranche verticale de call coaching entièrement simulée par une source de données en mémoire, remplaçable plus tard par Telnyx/WebRTC et une API sans modifier le domaine ni la présentation.

## 2. Objectif et limites du POC

Le POC doit permettre de valider, sur iPhone, Android et macOS, la compréhension et la valeur du parcours suivant :

1. voir un appel de démonstration prêt à démarrer ;
2. lancer l'appel dans l'application ;
3. voir apparaître une transcription différenciant le founder et le prospect ;
4. terminer l'appel ;
5. consulter la transcription complète, les points clés, le résumé, les engagements, un follow-up et une seule amélioration prioritaire reliée à un passage précis ;
6. retrouver l'appel dans un historique local durant la session.

Le POC ne réalise pas encore :

- d'appel téléphonique ou WebRTC réel ;
- d'intégration Telnyx, APNS, FCM, PushKit ou CallKit ;
- d'enregistrement microphone ;
- de transcription ou de coaching par IA ;
- de synchronisation cloud, authentification ou CRM ;
- de persistance après fermeture du processus ;
- de coaching temps réel.

Toute donnée de call est un scénario de démonstration. L'interface doit le signaler sans ambiguïté.

## 3. Drivers architecturaux

| Driver | Conséquence architecturale |
|---|---|
| POC rapide mais remplaçable | Adaptateur `InMemoryCallLocalDataSourceImpl` derrière les contrats Domain/Data. |
| Trois plateformes | Un seul projet Flutter dans `apps/app_mobile`, avec les dossiers natifs `ios/`, `android/` et `macos/`. |
| Futur VoIP et backend | Aucun type Telnyx/WebRTC dans le domaine, les states ou les widgets. Les intégrations futures implémenteront les mêmes ports. |
| Call actif partagé entre routes | La source mémoire et le service de simulation sont des providers `keepAlive`; les ViewModels restent auto-dispose. |
| Démonstration déterministe | Horloge, identifiants et séquence de transcript injectables; aucun `DateTime.now()` ou aléatoire caché. |
| UI crédible sur mobile et desktop | Thème partagé dans `core_presentation`, écrans adaptatifs dans l'app, mêmes cas d'usage sur toutes les plateformes. |
| Évolution sûre | Freezed, génération de code, analyse stricte et tests à chaque frontière. |
| Respect de la vie privée | Aucune donnée réelle, aucun accès micro/téléphonie et aucun stockage persistant dans le POC. |

## 4. Monorepo obligatoire

```text
app/
├── pubspec.yaml                         # workspace Dart 3.9+
├── analysis_options.yaml
├── melos.yaml                           # orchestration seulement
├── apps/
│   └── app_mobile/
│       ├── android/
│       ├── ios/
│       ├── macos/
│       ├── assets/
│       │   ├── translations/
│       │   │   └── fr.json
│       │   └── images/
│       ├── integration_test/
│       ├── lib/
│       │   ├── application/
│       │   │   └── services/
│       │   ├── core/
│       │   │   └── providers/
│       │   │       ├── core/
│       │   │       │   ├── repositories/
│       │   │       │   └── usecases/
│       │   │       ├── data/
│       │   │       │   └── datasource/
│       │   │       ├── services/
│       │   │       ├── app_config.provider.dart
│       │   │       ├── app_router.provider.dart
│       │   │       └── kernel.provider.dart
│       │   ├── features/
│       │   │   └── calls/
│       │   │       └── presentation/
│       │   │           └── screens/
│       │   │               ├── call_home/
│       │   │               ├── active_call/
│       │   │               └── call_debrief/
│       │   ├── foundation/
│       │   │   └── routing/
│       │   ├── gen/
│       │   ├── generated/
│       │   ├── presentation/
│       │   │   ├── app.dart
│       │   │   └── widgets/
│       │   └── main.dart
│       ├── test/
│       └── pubspec.yaml
└── packages/
    ├── core_foundation/
    │   ├── lib/
    │   ├── test/
    │   └── pubspec.yaml
    ├── core_domain/
    │   ├── lib/
    │   ├── test/
    │   └── pubspec.yaml
    ├── core_data/
    │   ├── lib/
    │   ├── test/
    │   └── pubspec.yaml
    └── core_presentation/
        ├── lib/
        ├── test/
        └── pubspec.yaml
```

Il n'existe ni seconde application Flutter par plateforme, ni code Dart produit directement sous `app/lib`. Les trois runners natifs sont générés par `flutter create --platforms=ios,android,macos` dans `apps/app_mobile`.

## 5. Graphe de dépendances

```text
core_foundation
      ▲
      │
core_domain ◄──────────── core_presentation
      ▲                          ▲
      │                          │
core_data ───────────────────────┤
      ▲                          │
      └──────── app_mobile ──────┘
```

La lecture normative reste :

```text
core_foundation  <-  core_domain  <-  core_data  <-  app_mobile
                           ^              ^              |
                           └── core_presentation <───────┘
```

| Module | Peut dépendre de | Ne peut jamais dépendre de |
|---|---|---|
| `core_foundation` | Dart SDK et dépendances techniques sans Flutter UI | `core_domain`, `core_data`, `core_presentation`, `app_mobile` |
| `core_domain` | `core_foundation`, Freezed annotations, JSON annotations pour les Params, RxDart uniquement si un service Domain en a besoin | Flutter, Riverpod, Data, Presentation, app, HTTP, SDK VoIP |
| `core_data` | `core_foundation`, `core_domain`, sérialisation et adaptateurs techniques | `core_presentation`, `app_mobile`, widgets, Riverpod |
| `core_presentation` | Flutter, `core_foundation`, `core_domain` si un contrat UI expose une entité | `core_data`, `app_mobile`, Riverpod, AutoRoute |
| `app_mobile` | Tous les packages, Flutter, Riverpod, AutoRoute, EasyLocalization | — |

`app_mobile` est le composition root : les packages ne créent pas leurs propres providers Riverpod et ne choisissent pas leurs implémentations.

## 6. Responsabilités des couches

### 6.1 `core_foundation`

Contient uniquement les briques transverses sans connaissance de Pinkall UI :

- `AppConfig` et les variantes `Dev`, `Mock`, `Test`, puis `Staging` et `Prod` ;
- `Environment` ;
- `FutureUseCase`, `FutureUseCaseWithParams`, `StreamUseCase` et `ResultState` ;
- exceptions typées ;
- logging ;
- contrats minimaux `Clock` et `IdGenerator` pour rendre la simulation déterministe.

Les implémentations système de `Clock` et `IdGenerator` peuvent être construites dans l'app. Les implémentations fixes pour les tests restent dans les tests.

### 6.2 `core_domain`

Le domaine décrit le produit indépendamment de la téléphonie et du stockage.

#### Agrégat principal

`CallSessionEntity` est la racine d'agrégat et référence des objets immutables :

- `CallStatus`: `ready`, `connecting`, `active`, `completed`, `failed` ;
- `CallParticipantEntity`: rôle, nom affiché, société ;
- `TranscriptTurnEntity`: identifiant, `speaker`, texte, timestamp relatif ;
- `CallDebriefEntity`: résumé, points clés, engagements, brouillon de follow-up ;
- `CoachingAdviceEntity`: observation, interprétation, action à tester, question suggérée et `sourceTurnId` ;
- `CallSessionEntity`: identité, participants, début/fin, statut, transcript et debrief optionnel.

Les entités utilisent Freezed sans JSON. Les listes ne sont jamais mutées en place.

#### Contrat repository

`CallRepository` expose des types Domain uniquement :

```dart
abstract interface class CallRepository {
  Stream<List<CallSessionEntity>> watchCalls();
  Stream<CallSessionEntity?> watchActiveCall();
  Future<List<CallSessionEntity>> getCalls();
  Future<CallSessionEntity?> getCall(String id);
  Future<CallSessionEntity> startCall(StartCallParam param);
  Future<CallSessionEntity> appendTranscriptTurn(
    String callId,
    TranscriptTurnEntity turn,
  );
  Future<CallSessionEntity> completeCall(String callId);
}
```

Le mot `demo` n'entre pas dans ce contrat. En production, les mêmes événements pourront venir d'une session WebRTC et d'un moteur de transcription.

#### Use cases du POC

- `GetCallsUseCase` ;
- `GetCallUseCase` avec `GetCallParam` ;
- `WatchCallsUseCase` ;
- `WatchActiveCallUseCase` ;
- `StartCallUseCase` avec `StartCallParam` ;
- `AppendTranscriptTurnUseCase` avec `AppendTranscriptTurnParam` ;
- `CompleteCallUseCase` avec `CompleteCallParam`.

Chaque classe est `final`, étend la base appropriée de `core_foundation`, reçoit un seul repository et implémente uniquement `invoke()`. Tout appel extérieur passe par `execute()`.

Le debrief du scénario POC est construit dans l'adaptateur Data au moment de la complétion. Une future fonctionnalité de coaching distant introduira un `CoachingRepository` et un use case dédiés ; elle ne sera pas simulée dans un ViewModel.

### 6.3 `core_data`

Contient les représentations techniques et leur traduction vers le domaine :

```text
core_data/lib/
├── datasources/local/
│   ├── call.local.data_source.dart
│   └── impl/call.in_memory.local.data_source.impl.dart
├── mappers/
│   ├── call.mapper.dart
│   ├── transcript_turn.mapper.dart
│   └── call_debrief.mapper.dart
├── model/local/
│   ├── call.local.model.dart
│   ├── transcript_turn.local.model.dart
│   └── call_debrief.local.model.dart
├── repositories/
│   └── call.repository.impl.dart
└── seeds/
    └── demo_call.seed.dart
```

Les `LocalModel` sont Freezed + JSON sérialisables, même si le POC ne persiste pas encore le JSON. Cette décision prépare un futur stockage local sans contaminer le Domain.

`CallLocalDataSource` expose exclusivement des `LocalModel`. `CallRepositoryImpl` est le seul endroit où les mappers convertissent `LocalModel <-> Entity`.

### 6.4 `core_presentation`

Contient les décisions visuelles partagées et indépendantes des routes :

- `PinkallTheme` et ses `ColorScheme` clair/sombre ;
- extensions typographiques et tokens d'espacement ;
- widgets réellement transverses sans copie produit ni navigation ;
- contrats de services UI si nécessaires.

Les couleurs concrètes de marque sont définies ici dans le thème, jamais dans les screens. Les écrans récupèrent les couleurs via `Theme.of(context).colorScheme`.

### 6.5 `app_mobile`

Contient les écrans, leurs ViewModels, l'injection, le routing, la localisation et les orchestrations propres au runtime Flutter.

Chaque écran respecte la triade obligatoire :

```text
xxx.state.dart       # Freezed, état immutable
xxx.view_model.dart  # @riverpod, orchestration de use cases/services
xxx.screen.dart      # @RoutePage, ConsumerStatefulWidget, rendu uniquement
```

## 7. Source de données en mémoire

### 7.1 Contrat et durée de vie

`InMemoryCallLocalDataSourceImpl` est une implémentation `final` de `CallLocalDataSource`. Elle possède :

- un `Map<String, CallLocalModel>` privé ;
- un identifiant d'appel actif optionnel ;
- un stream broadcast ou `BehaviorSubject` de snapshot immutable ;
- une méthode `dispose()` ;
- une copie défensive des listes et maps exposées.

Elle est instanciée une fois par `callLocalDataSourceProvider` `keepAlive`, puis détruite via `ref.onDispose`. La navigation entre Home, Active Call et Debrief ne détruit donc pas la session.

### 7.2 Simulation déterministe

`DemoCallSimulationService`, dans `app_mobile/lib/application/services/`, orchestre les use cases sans accéder au DataSource :

1. `StartCallUseCase.execute()` crée la session active ;
2. le service émet les tours du `DemoCallSeed` selon leurs délais relatifs ;
3. chaque tour passe par `AppendTranscriptTurnUseCase.execute()` ;
4. `CompleteCallUseCase.execute()` clôt la session et ajoute le debrief seedé ;
5. toute annulation dispose les timers/subscriptions.

Le service reçoit un `Clock` et un scheduler injectable. Les tests utilisent un fake scheduler : aucun test n'attend le temps réel.

Le seed contient du contenu métier simulé, pas du chrome UI. Les titres, boutons, statuts et messages d'erreur restent dans EasyLocalization.

### 7.3 Remplacement futur

Le passage au produit réel ajoute des adaptateurs, sans changer les écrans :

```text
CallRemoteDataSource + TelnyxCallGateway + TranscriptRemoteDataSource
                              ↓
                       CallRepositoryImpl
                              ↓
                         CallRepository
```

Le choix `mock` ou `remote` se fait uniquement dans les providers selon `AppConfig.env`. Il est interdit de disperser des `if (isMock)` dans les use cases, ViewModels ou screens.

## 8. Graphe des providers Riverpod

Tous les providers vivent dans `apps/app_mobile/lib/core/providers/` et utilisent la génération Riverpod.

```text
appConfigProvider (keepAlive)
  ├── clockProvider (keepAlive)
  ├── idGeneratorProvider (keepAlive)
  ├── appRouterProvider (keepAlive)
  └── callLocalDataSourceProvider (keepAlive, mémoire de session)
        └── callRepositoryProvider
              ├── getCallsUseCaseProvider
              ├── getCallUseCaseProvider
              ├── watchCallsUseCaseProvider
              ├── watchActiveCallUseCaseProvider
              ├── startCallUseCaseProvider
              ├── appendTranscriptTurnUseCaseProvider
              └── completeCallUseCaseProvider
                    └── demoCallSimulationServiceProvider (keepAlive)
                          ├── callHomeViewModelProvider (auto-dispose)
                          ├── activeCallViewModelProvider (auto-dispose)
                          └── callDebriefViewModelProvider (auto-dispose)
```

Règles :

- `@Riverpod(keepAlive: true)` est réservé aux dépendances devant survivre aux routes : configuration, router, source mémoire et service de simulation ;
- endpoints, repositories, use cases et ViewModels utilisent `@riverpod` par défaut ;
- les providers asynchrones sont résolus avec `ref.watch(provider.future)` ;
- un ViewModel résout ses dépendances avec `ref.watch` dans `build()` ;
- `ref.read` est réservé aux actions utilisateur depuis les callbacks ;
- les tests remplacent les bords avec `ProviderContainer(overrides: ...)` ;
- aucun singleton global ou service locator parallèle à Riverpod.

Le `kernelProvider` `keepAlive` initialise les dépendances requises, puis l'app affiche son contenu. Pour le POC mémoire, il ne déclenche aucun appel réseau.

## 9. Navigation AutoRoute

Routes minimales :

```dart
List<AutoRoute> get routes => <AutoRoute>[
  AutoRoute(page: CallHomeRoute.page, initial: true),
  AutoRoute(page: ActiveCallRoute.page),
  AutoRoute(page: CallDebriefRoute.page, path: '/calls/:callId/debrief'),
];
```

- Chaque screen est annoté `@RoutePage()` et étend `ConsumerStatefulWidget`.
- `CallDebriefScreen` reçoit `callId` comme argument de route et charge l'agrégat via son use case.
- Les boutons naviguent dans leurs callbacks avec `context.router`.
- La simulation ne détient jamais de `BuildContext`.
- Une route inconnue ou un identifiant absent produit un état d'erreur localisé, pas une exception UI.
- La route de debrief est compatible avec un deep link futur.

Le router et les classes `*.gr.dart` sont générés. Ils ne sont jamais modifiés manuellement.

## 10. États de présentation

### `CallHomeState`

- liste immutable des calls ;
- appel actif optionnel ;
- indicateur de lancement.

### `ActiveCallState`

- session courante ;
- durée écoulée calculée par le ViewModel/service ;
- état de connexion ;
- action de fin en cours.

### `CallDebriefState`

- session complétée ;
- section sélectionnée si l'UI emploie des tabs ;
- brouillon de follow-up éditable dans une valeur immutable ;
- état de copie/validation si présent.

Les trois states utilisent `@Freezed(copyWith: true)` et une factory `.initial()`. Les ViewModels async exposent `AsyncValue<State>` et les screens rendent obligatoirement `loading`, `error` et `data` avec `.when()`.

Aucune logique métier n'est admise dans les widgets. Le filtrage d'historique, l'association d'un conseil à son `sourceTurnId` et le calcul de durée appartiennent respectivement au ViewModel, au Domain/Data et à un service injectable.

## 11. Localisation EasyLocalization

Le POC démarre en français avec une structure extensible :

```text
apps/app_mobile/assets/translations/fr.json
apps/app_mobile/lib/generated/locale_keys.g.dart
```

`main.dart` initialise `EasyLocalization` autour du `ProviderScope`/widget racine selon l'ordre validé par le framework, puis `MaterialApp.router` transmet `locale`, `supportedLocales` et `localizationsDelegates`.

Conventions de clés :

```text
common.action.*
common.error.*
call.home.*
call.active.*
call.debrief.*
call.status.*
demo.disclaimer.*
```

Toute chaîne écrite par l'équipe et visible à l'utilisateur passe par `LocaleKeys.xxx.tr()`. Les noms de personnes, sociétés, paroles de transcript et contenus générés sont des données du scénario, pas des strings de widget.

Commande :

```bash
dart run easy_localization:generate \
  -S assets/translations \
  -f keys \
  -O lib/generated \
  -o locale_keys.g.dart
```

## 12. Freezed et sérialisation

| Type | Freezed | JSON | Emplacement |
|---|---:|---:|---|
| Entity Domain | oui | non | `core_domain/domain/entities` |
| Params Domain | oui | oui | `core_domain/domain/params` |
| Enum Domain | annotation JSON si nécessaire | selon usage | `core_domain/domain/enum` |
| Local/Remote Model | oui | oui | `core_data/model` |
| State d'écran | oui | non | `app_mobile/features/.../screens` |

Règles :

- tout objet de données est immutable ;
- toute évolution passe par `copyWith()` ;
- les entités ne connaissent jamais `fromJson()` ;
- un State ne contient ni contrôleur Flutter ni stream mutable ;
- un mapper dédié réalise chaque conversion Model/Entity ;
- les fichiers générés ne sont jamais édités.

## 13. Dépendances proposées

Les versions exactes sont résolues lors de l'initialisation avec une version stable de Flutter compatible Dart 3.9+, puis verrouillées dans le lockfile. Les bornes doivent être cohérentes dans tout le workspace ; elles ne sont pas dupliquées arbitrairement par package.

### Runtime

| Module | Dépendances |
|---|---|
| `core_foundation` | `meta` si nécessaire ; aucune dépendance Flutter UI |
| `core_domain` | `core_foundation`, `freezed_annotation`, `json_annotation`, `rxdart` seulement si les services Domain emploient `BehaviorSubject` |
| `core_data` | `core_foundation`, `core_domain`, `freezed_annotation`, `json_annotation` |
| `core_presentation` | Flutter SDK, `core_foundation`, `core_domain`, `gap` si les widgets partagés l'utilisent |
| `app_mobile` | Flutter SDK, `flutter_localizations`, les quatre packages workspace, `flutter_riverpod`, `riverpod_annotation`, `auto_route`, `easy_localization`, `gap` |

`dio` et `retrofit` ne sont pas requis pour la tranche mémoire. Ils seront ajoutés à `core_data` seulement avec le premier endpoint distant. Un SDK Telnyx/WebRTC sera encapsulé dans un adaptateur de plateforme/app et ne sera jamais une dépendance Domain.

### Développement et tests

- `build_runner` ;
- `freezed` ;
- `json_serializable` ;
- `riverpod_generator` dans `app_mobile` ;
- `auto_route_generator` dans `app_mobile` ;
- `flutter_gen_runner` dans `app_mobile` si des assets image sont ajoutés ;
- `flutter_lints` ou une configuration de lints équivalente complétée par les règles de `ARCHITECTURE.md` ;
- `test` dans les packages Dart ;
- `flutter_test` et `integration_test` dans l'app ;
- `mocktail` pour les doubles aux frontières.

`melos` peut orchestrer les commandes du workspace, mais n'est ni un runtime ni un service locator.

## 14. Génération de code

Les outputs suivants sont générés :

- `*.freezed.dart` ;
- `*.g.dart` ;
- `app_router.gr.dart` ;
- `lib/gen/*.gen.dart` ;
- `lib/generated/locale_keys.g.dart`.

Stratégie :

1. chaque package possédant des builders déclare ses dépendances de génération ;
2. `melos run generate` exécute `dart run build_runner build --delete-conflicting-outputs` dans `core_domain`, `core_data` et `app_mobile` ;
3. le script exécute ensuite EasyLocalization depuis `apps/app_mobile` ;
4. CI vérifie que relancer la génération ne produit aucun diff ;
5. aucun fichier généré n'est corrigé à la main.

Commandes de référence :

```bash
dart run melos run generate
dart run melos run analyze
dart run melos run test
```

En développement ciblé, la commande normative d'un package reste :

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 15. Stratégie de tests

### 15.1 Pyramide

| Niveau | Cible | Vérifications minimales |
|---|---|---|
| Fondation | unitaires | `ResultState`, timeout/exception des use cases, config, clock/id fakes |
| Domain | unitaires | chaque use case en succès/échec, params et invariants de l'agrégat |
| Data | unitaires | seed, ordre des tours, copies immutables, mapping dans les deux sens, cycle start/append/complete, streams et dispose |
| Providers | unitaires | graphe résolu, durée de vie mémoire, overrides de repository/clock/scheduler |
| ViewModels | unitaires | `AsyncLoading`, `AsyncData`, `AsyncError`, actions et annulation de simulation |
| Widgets | `flutter_test` | loading/error/data, callbacks, localisation, sémantique, largeurs mobile et macOS |
| Router | widget | route initiale, passage Active -> Debrief, deep link de debrief invalide/valide |
| Parcours | integration | Home -> start -> transcript -> end -> debrief -> historique sur chaque plateforme disponible en CI |

### 15.2 Règles de déterminisme

- horloge, identifiants et scheduler sont injectés ;
- aucun `Future.delayed` réel dans les tests ;
- aucun réseau, micro, permission système ou plugin natif ;
- les streams sont fermés dans `tearDown` ;
- chaque `ProviderContainer` est disposé ;
- les tests ne dépendent ni de l'ordre d'exécution ni d'un état global.

### 15.3 Contrats prioritaires

1. un tour du prospect reste distingué d'un tour du founder après mapping ;
2. un conseil référence toujours un `sourceTurnId` existant ;
3. terminer un call produit exactement un debrief et libère l'appel actif ;
4. un call complété réapparaît dans l'historique ;
5. quitter puis rouvrir une route conserve la session mémoire ;
6. redémarrer l'app réinitialise volontairement les données du POC ;
7. erreur ou identifiant absent ne fait pas crasher l'UI ;
8. les trois tailles de référence n'ont ni overflow ni contenu inaccessible.

### 15.4 Quality gate

Avant intégration :

```bash
dart format --output=none --set-exit-if-changed .
dart run melos run generate
dart run melos run analyze
dart run melos run test
```

La génération doit être propre, l'analyse sans erreur et tous les tests verts. Le parcours d'intégration est obligatoire sur au moins un simulateur mobile et macOS avant de présenter le POC.

## 16. Conventions de code obligatoires

- imports `package:` uniquement ;
- types explicites (`always_specify_types`) ;
- quotes simples ;
- trailing commas ;
- documentation `///` sur toute API publique ;
- `final class` pour les implémentations ;
- `abstract interface class` pour les contrats ;
- constructeurs `const` dès que possible ;
- `Gap` pour les espacements, jamais `SizedBox` utilisé comme espaceur ;
- `Theme.of(context).colorScheme` pour les couleurs ;
- `LocaleKeys` pour le texte UI ;
- `AsyncValue.when` pour les ViewModels async.

## 17. ADR

Les ADR ci-dessous sont acceptés pour le POC et devront être extraits en fichiers dédiés si l'architecture évolue.

### ADR-001 — Monorepo Dart workspace

**Décision :** une app Flutter et quatre packages workspace.  
**Pourquoi :** rendre les dépendances vérifiables et préparer le backend/intégrations sans mélanger le domaine et l'UI.  
**Conséquence :** coût initial de génération et d'orchestration, compensé par des frontières stables.

### ADR-002 — Une app pour iOS, Android et macOS

**Décision :** les trois plateformes partagent `apps/app_mobile`.  
**Pourquoi :** préserver un seul flux produit et maximiser le code commun.  
**Conséquence :** les adaptations desktop passent par des widgets responsifs, pas un fork d'application.

### ADR-003 — Source mémoire derrière un port

**Décision :** persistance POC avec `InMemoryCallLocalDataSourceImpl`.  
**Pourquoi :** démontrer le parcours avant de financer téléphonie, backend et IA.  
**Conséquence :** les données disparaissent au redémarrage, ce qui doit être explicite.

### ADR-004 — Agrégat CallSession

**Décision :** transcript, participants et debrief sont cohérents autour de `CallSessionEntity`.  
**Pourquoi :** empêcher les états partiels incohérents dans le POC.  
**Conséquence :** une future volumétrie élevée pourra séparer les streams sans changer les contrats UI.

### ADR-005 — Simulation dans un service applicatif

**Décision :** le timing du scénario est orchestré dans `app_mobile/application/services`, via des use cases.  
**Pourquoi :** le timing est spécifique à la démo et n'est ni une règle métier ni une responsabilité de widget.  
**Conséquence :** le service doit gérer explicitement annulation et dispose.

### ADR-006 — Riverpod code-gen comme composition root

**Décision :** toute injection passe par des providers générés dans l'app.  
**Pourquoi :** dépendances explicites, overrides de tests et cycles de vie contrôlés.  
**Conséquence :** aucun singleton global ou second conteneur DI.

### ADR-007 — AutoRoute généré

**Décision :** navigation typée avec trois routes POC.  
**Pourquoi :** arguments sûrs et deep links futurs.  
**Conséquence :** toute modification de route requiert une génération.

### ADR-008 — EasyLocalization dès le POC

**Décision :** aucun texte UI en dur, même avec une seule locale initiale.  
**Pourquoi :** la règle est moins coûteuse à appliquer dès le début qu'à corriger.  
**Conséquence :** chaque évolution de copie met à jour `fr.json` et les clés générées.

### ADR-009 — Immutabilité Freezed systématique

**Décision :** Freezed pour entités, params, modèles et states.  
**Pourquoi :** fiabiliser les snapshots de call et les transitions Riverpod.  
**Conséquence :** la génération fait partie du quality gate.

### ADR-010 — Pas de téléphonie réelle dans le POC

**Décision :** aucun plugin VoIP, permission ou push natif.  
**Pourquoi :** valider d'abord la promesse et l'expérience post-call.  
**Conséquence :** l'interface doit parler de démonstration et ne pas laisser croire qu'un appel réel a eu lieu.

### ADR-011 — Exécution déterministe

**Décision :** clock, IDs et scheduler injectables.  
**Pourquoi :** tests rapides et reproductibles, notamment pour le transcript progressif.  
**Conséquence :** aucun accès implicite au temps ou à l'aléatoire dans Domain/Data.

### ADR-012 — Données éphémères et non sensibles

**Décision :** scénario fictif uniquement, stocké en RAM.  
**Pourquoi :** réduire le risque privacy pendant la validation.  
**Conséquence :** pas de migration, chiffrement au repos ou consentement d'enregistrement dans ce POC ; ces sujets deviennent bloquants avant toute donnée réelle.

## 18. Écarts interdits

Les écarts suivants bloquent une review :

1. créer `app/lib`, une app iOS/macOS séparée ou déplacer un package hors de `packages/` ;
2. importer Data, Flutter, Riverpod, AutoRoute, Dio, Telnyx ou WebRTC depuis `core_domain` ;
3. importer l'app ou Presentation depuis `core_data` ;
4. exposer un `LocalModel`, `RemoteModel` ou type SDK dans un repository Domain ;
5. instancier une implémentation Data dans un use case, ViewModel ou screen ;
6. appeler un DataSource ou un client HTTP depuis un ViewModel ;
7. ajouter une branche `isMock` hors du composition root ;
8. mettre le transcript seedé, les timers ou le debrief dans un widget ;
9. omettre un fichier de la triade State/ViewModel/Screen ;
10. utiliser un widget autre que `ConsumerStatefulWidget` pour un screen ;
11. omettre `@RoutePage()` ou naviguer depuis un service avec `BuildContext` ;
12. employer `ref.read` dans `build()` d'un ViewModel ;
13. employer des providers globaux manuels au lieu de la génération Riverpod ;
14. mettre une string UI, couleur de marque ou chemin d'asset en dur dans un screen ;
15. employer un import relatif ;
16. muter une liste de State/Entity/Model en place ;
17. surcharger `execute()` dans un use case ou appeler `invoke()` depuis l'extérieur ;
18. modifier un fichier `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.gen.dart` ou `locale_keys.g.dart` ;
19. ajouter `dio`, `retrofit` ou un SDK VoIP avant qu'un adapter réel soit dans le périmètre ;
20. utiliser une donnée de personne réelle, demander une permission système ou persister un call dans ce POC ;
21. laisser un timer, stream ou `ProviderContainer` non disposé ;
22. faire dépendre un test du temps réel, du réseau ou de l'ordre d'exécution.

## 19. Séquence d'implémentation

L'ordre de création respecte strictement la checklist de `ARCHITECTURE.md` :

1. Foundation : ResultState/use cases, config, clock et IDs ;
2. Domain : enums, entités, params, repository, use cases ;
3. Data : local models, mappers, DataSource mémoire, repository impl ;
4. Providers : DataSource -> repository -> use cases -> service ;
5. Presentation : State -> ViewModel -> Screen pour Home, Active Call et Debrief ;
6. traductions puis génération des LocaleKeys ;
7. router puis génération AutoRoute ;
8. tests de chaque couche, intégration et quality gate.

## 20. Definition of Done architecture

Le POC respecte cette architecture lorsque :

- les trois dossiers natifs existent sous `apps/app_mobile` ;
- le graphe de dépendances du workspace ne comporte aucune arête inverse ;
- le parcours complet fonctionne sans réseau avec le DataSource mémoire ;
- changer le provider mémoire pour un fake de test ne modifie aucun ViewModel ;
- aucun type Data n'est visible dans Domain ou Presentation ;
- les écrans n'ont ni logique métier, ni string/couleur/asset en dur ;
- toute génération est reproductible et ne laisse aucun diff ;
- analyse, tests unitaires, widgets et parcours d'intégration sont verts ;
- le POC indique clairement que l'appel, le transcript et les conseils sont simulés.
