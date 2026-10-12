# Architecture — POC Pinkall Telnyx WebRTC réel

**Projet :** Pinkall  
**Source normative Flutter :** `../../ARCHITECTURE.md`  
**PRD :** `prd-pinkall-telnyx-poc.md`  
**Statut :** STORY-007 en cours ; architecture des incréments suivants approuvée sous gates réels  
**Dernière mise à jour :** 2026-07-11

## 1. Objectif architectural

Remplacer le chemin runtime simulé par un chemin de téléphonie réel : Flutter se connecte à Telnyx via `telnyx_webrtc`, initie un appel PSTN/SIP, reçoit les événements du SDK et transporte l’audio WebRTC.

Le POC conserve l’architecture en couches du monorepo. « Intégration directe » signifie que Pinkall utilise réellement le SDK Telnyx, sans serveur audio ou faux transport intermédiaire ; cela ne signifie pas que la présentation importe les classes du SDK.

## 2. Contraintes non négociables

1. `ARCHITECTURE.md` reste la source de vérité pour les dépendances, noms, providers, Freezed, Riverpod, AutoRoute et la triade d’écran.
2. `core_domain` n’importe jamais `telnyx_webrtc` et n’expose aucun type du SDK ; le vocabulaire Telnyx temporaire du POC est isolé derrière `CallRepository` (ADR-005).
3. `core_data` encapsule le SDK et mappe ses événements vers les types du domain.
4. Le graphe runtime ne contient aucun `InMemoryCallLocalDataSource` ni appel simulé.
5. Les doubles sont admis uniquement sous `test/`.
6. Aucun secret Telnyx n’est compilé, persisté ou journalisé.
7. Aucun transcript, résumé ou conseil n'est créé sans source réelle.
8. Telnyx fournit la téléphonie et Media Streaming ; il n'est pas le contrat STT du produit.
9. Le domain dépend de `StreamingTranscriptionAdapter` et `BatchTranscriptionAdapter`, jamais de Voxtral/Mistral.
10. Le coach est optionnel : préférence utilisateur et surcharge par appel ; `off` interdit tout appel au moteur de coaching.
11. Un appel est bloqué si le CRM ne peut pas démontrer son éligibilité selon la règle configurée.

## 3. Contexte système

```text
Testeur
  │ saisit JWT/SIP + numéro E.164
  ▼
Pinkall Flutter (iOS / Android / macOS)
  │ WebSocket de signalisation + média WebRTC
  ▼
Telnyx Credential Connection + Outbound Voice Profile
  │ réseau téléphonique
  ▼
Correspondant réel
```

Le sprint 2 ne requiert aucun backend Pinkall pour transporter l'audio. Un backend devient obligatoire pour générer des JWT de production, corréler les appels, contrôler Voice API/Media Streaming, appliquer l'éligibilité CRM, transcrire et coacher.

```text
Utilisateur ──► Flutter ──WebRTC──► Telnyx ──PSTN──► Prospect
                  │                   │
                  │ HTTPS/SSE         └── Media Streaming, pistes séparées
                  ▼                              │
             Backend Pinkall ◄───────────────────┘
                  ├── Call orchestration / CRM eligibility
                  ├── AudioGateway
                  ├── StreamingTranscriptionAdapter → Deepgram Flux (principal) / Voxtral (fallback)
                  ├── BatchTranscriptionAdapter → Voxtral Mini Transcribe 2
                  ├── Debrief pipeline
                  └── Optional Coaching Engine (`off|shadow|live`)
```

## 4. Découpage par package

### `packages/core_foundation`

Réutilise les abstractions transverses existantes : `ResultState`, use cases, erreurs et journalisation expurgée. Aucun type Telnyx.

### `packages/core_domain`

Contient les contrats métier et applicatifs du vertical slice :

- `TelnyxAuthenticationEntity` et `TelnyxConfigurationEntity` : configuration runtime non sérialisable et expurgée ;
- `TelnyxConnectionStateEntity` : disconnected, connecting, ready, reconnecting, failure ;
- `CallStateEntity` : newCall, connecting, ringing, active, held, reconnecting, renegotiating, dropped, ended, error ;
- `CallRepository` : connect, disconnect, placeCall, endCall, setMuted, observer les états ;
- use cases publics exposant uniquement `execute()`.

Les secrets ne doivent pas être rendus sérialisables. Un mot de passe/JWT n’apparaît ni dans `toString()`, ni dans les égalités ou erreurs exposées.

### `packages/core_data`

Contient l’adaptateur Telnyx :

```text
TelnyxRemoteDataSource (interface)
  └── TelnyxRemoteDataSourceImpl
        └── TelnyxClient de telnyx_webrtc

CallRepositoryImpl
  ├── appelle le RemoteDataSource
  └── mappe SDK events/errors → domain entities/failures
```

Responsabilités :

- construire `TokenConfig` ou `CredentialConfig` à partir des valeurs runtime ;
- appeler la méthode de connexion appropriée ;
- écouter le flux d’événements du client une seule fois ;
- créer une invitation réelle pour la destination ;
- conserver uniquement en mémoire la référence de l’appel actif ;
- rendre mute/unmute et hangup idempotents au niveau applicatif ;
- annuler les subscriptions lors de la déconnexion ;
- traduire les erreurs sans exposer les secrets ;
- rejeter les événements d’un ancien appel après terminaison.

Le package ne doit contenir aucune source locale de démonstration branchée au runtime.

### `apps/app_mobile`

Contient :

- les providers Riverpod suivant la chaîne `dataSource → repository → useCase → viewModel` ;
- la configuration runtime éphémère ;
- les permissions et capacités natives ;
- les écrans et leur triade `.state.dart`, `.view_model.dart`, `.screen.dart` ;
- les routes AutoRoute.

Toutes les dépendances async sont résolues avec `ref.watch(provider.future)` conformément à `ARCHITECTURE.md`.

### Backend Pinkall — frontière logique des incréments suivants

Le backend reste un monolithe modulaire pour le POC SaaS. Les modules logiques ne supposent pas encore un framework ni un hébergeur :

- `Identity`: utilisateur, workspace, device et émission de JWT Telnyx courts ;
- `Calling`: `CallIntent`, corrélation `callSessionId` Pinkall ↔ identifiants Telnyx et commandes serveur ;
- `Crm`: contacts, imports, statut de prospection et liste `do_not_call` ;
- `Compliance`: évaluation datée/versionnée de l'éligibilité avant composition ;
- `Media`: terminaison WebSocket Telnyx, normalisation des codecs, séquencement et routage des pistes ;
- `Transcription`: contrats live/batch, adaptateurs fournisseur et versions de transcript ;
- `Debrief`: résumé, engagements, prochaine action et follow-up à partir du transcript final ;
- `Coaching`: corpus sourcé, mode effectif, génération, gate de précision et exposition ;
- `Telemetry`: latences, coûts et événements `exposition → action → résultat` sans contenu de conversation dans les métriques.

Les clés Telnyx, Deepgram, Mistral/Voxtral et OpenAI vivent dans un gestionnaire de secrets serveur. Flutter ne reçoit que des tokens Pinkall/Telnyx courts et des événements autorisés pour son workspace. Deepgram et Mistral sont réservés au STT ; OpenAI est réservé au coach et au débrief.

## 5. Flux d’appel sortant

```text
CallSetupScreen
  → CallSetupViewModel.connect(credentials)
    → ConnectTelnyxUseCase.execute(params)
      → CallRepository.connect(params)
        → TelnyxRemoteDataSource.connectWithToken|connectWithCredential
          → TelnyxClient WebSocket

DialerScreen
  → DialerViewModel.placeCall(e164)
    → PlaceCallUseCase.execute(params)
      → CallRepository.placeCall(e164)
        → TelnyxRemoteDataSource.newInvite(e164)
          → événement SDK
            → mapper
              → stream domain
                → ViewModel state
                  → ActiveCallScreen
```

La navigation vers l’écran actif peut commencer à l’état `inviting`, mais l’interface ne déclare jamais l’appel connecté avant l’événement réel correspondant.

## 6. Machine à états

### Connexion

```text
disconnected → connecting → ready
                    └────→ failed
ready → reconnecting → ready | failed
ready | failed → disconnecting → disconnected
```

### Appel

```text
idle → inviting → ringing → active → ending → ended
          │           │        │         └────→ failed
          └───────────┴────────┴──────────────→ failed
```

Règles :

- un seul appel actif dans le POC ;
- l’identifiant Telnyx est la clé de corrélation ;
- un événement qui ne correspond pas à l’identifiant courant est ignoré ou journalisé de façon expurgée ;
- `ended` et `failed` sont terminaux ;
- un hangup répété ne relance aucune commande ;
- la durée démarre sur l’événement connecté/actif, pas au clic sur « appeler ».

## 7. Authentification et secrets

### POC

- JWT Telnyx saisi au runtime : mode recommandé.
- Identifiant/mot de passe SIP saisis au runtime : mode développement explicite.
- Caller ID name et number fournis par la configuration de test, sans valeur secrète codée en dur.
- Les valeurs sont conservées en mémoire le temps de la session puis supprimées à la déconnexion.

### Production cible

Un backend authentifie l’utilisateur Pinkall et émet/récupère un JWT Telnyx à durée courte. La clé API Telnyx reste exclusivement côté serveur. Le stockage sécurisé natif d’un refresh token Pinkall relève d’une décision ultérieure ; il ne justifie pas la persistance d’un mot de passe SIP.

### Journalisation

Interdit : JWT, mot de passe, payload d’auth complet, numéro E.164 complet, contenu audio ou transcript. Autorisé : type d’événement, plateforme, code d’erreur et identifiant corrélé haché/tronqué.

## 8. Permissions et configuration native attendue

La story d’implémentation doit modifier les projets natifs de façon ciblée, sans inscrire de secret.

### Android

- `INTERNET`
- `RECORD_AUDIO`
- `MODIFY_AUDIO_SETTINGS`
- demande runtime de `RECORD_AUDIO`
- gestion audio/Bluetooth seulement selon les besoins réels du SDK et la version Android

### iOS

- `NSMicrophoneUsageDescription` claire et localisable
- demande microphone avant le premier appel
- aucune capacité PushKit/CallKit dans ce sprint

### macOS

- `NSMicrophoneUsageDescription`
- entitlement microphone/audio input adapté au sandbox de l’application
- test sur machine réelle avec entrée et sortie audio

Les textes de permission expliquent la finalité : passer un appel Pinkall via Telnyx. Ils n’annoncent pas une transcription encore absente.

## 9. Compatibilité macOS : gate explicite

La fiche pub.dev publie une cible macOS, mais le README et les guides de flux Telnyx détaillent principalement Android, iOS et Web. La compilation du média `flutter_webrtc` sur macOS ne prouve donc pas, à elle seule, que la couche Telnyx complète fonctionne de bout en bout.

Le choix demandé reste une intégration directe de `telnyx_webrtc` sur les trois cibles. Par conséquent :

1. le package doit d’abord résoudre et compiler pour macOS ;
2. la connexion WebSocket Telnyx doit atteindre `ready` ;
3. un appel sortant et l’audio bidirectionnel doivent être testés ;
4. aucun fallback simulé ne peut faire passer le gate ;
5. si l’un de ces tests échoue à cause du support package, STORY-007 est bloquée et une ADR approuvée doit choisir entre contribution/fork Telnyx, SDK Web dans un conteneur adapté ou autre intégration officielle.

Références :

- [SDK Flutter officiel](https://developers.telnyx.com/docs/voice/webrtc/flutter-sdk)
- [Package telnyx_webrtc](https://pub.dev/packages/telnyx_webrtc)

## 10. Media Streaming et transcription fournisseur-agnostique

### Pourquoi le backend est obligatoire

Media Streaming exige un endpoint WebSocket serveur et une topologie Telnyx contrôlable avec les identifiants d'appel. Les clés Telnyx, Deepgram, Mistral/Voxtral et OpenAI ne peuvent pas être confiées à Flutter. Le backend est également responsable de l'ordonnancement, de la normalisation audio, de l'attribution des pistes et de la diffusion authentifiée des segments.

### Gate topologique avant implémentation complète

Le POC actuel initie l'appel depuis `telnyx_webrtc`. Avant de déclarer Media Streaming disponible, un appel réel doit démontrer :

1. la création d'un `CallIntent` Pinkall avant composition ;
2. la corrélation prouvée entre ce `CallIntent`, le leg WebRTC et `call_session_id`/`call_control_id` Telnyx ;
3. le démarrage/arrêt serveur d'un stream `both_tracks` ;
4. la réception des deux pistes et de leurs métadonnées sur l'`AudioGateway` ;
5. l'absence d'altération audible de l'appel lorsque le traitement secondaire tombe.

Si le SDK WebRTC sortant ne permet pas cette corrélation, aucune hypothèse ne contourne le gate. Une ADR doit choisir et tester une topologie Voice API officielle, par exemple un pont contrôlé entre leg WebRTC/SIP et PSTN.

### Flux live

```text
Telnyx both_tracks
  → AudioGateway
    → validate stream/call/workspace
    → order sequence numbers + bounded jitter buffer
    → decode/resample to canonical PCM
    → map inbound/outbound to seller/prospect after real-call proof
    → StreamingTranscriptionAdapter.start(session)
      → StreamingTranscriptionAdapter.push(frame)
        → DeepgramFluxRealtimeAdapter (principal)
          → TranscriptDelta (ephemeral)
          → TranscriptSegmentFinal (versioned)
            → authenticated SSE/WebSocket to Flutter
            → optional Coaching Engine
```

Contrat logique, sans type fournisseur :

```text
StreamingTranscriptionAdapter
  start(callSessionId, language, audioFormat, speakerTrack)
  push(AudioFrame(sequence, occurredAt, bytes))
  events() -> TranscriptDelta | TranscriptSegmentFinal | TranscriptionFailure
  finish()
```

L'adaptateur principal est `DeepgramFluxRealtimeAdapter`, utilisant `flux-general-multi`, `language_hint=fr` et l'endpoint européen `/v2/listen`. Une connexion mono est ouverte par piste Telnyx ; `EndOfTurn` confirme une prise de parole, tandis que `Update`, `StartOfTurn`, `EagerEndOfTurn` et `TurnResumed` restent provisoires. `VoxtralRealtimeAdapter` demeure sélectionnable comme fallback. Dans les deux cas, le rôle du locuteur vient exclusivement de la piste Telnyx validée. En cas d'ambiguïté, `speakerRole = unknown`.

### Transcript final batch

L'enregistrement contrôlé de chaque piste alimente après raccrochage :

```text
BatchTranscriptionAdapter.transcribe(recording, metadata)
  → VoxtralBatchAdapter
    → TranscriptRevision(kind=final, segments, words, model, generatedAt)
      → TranscriptReconciler(liveRevision, finalRevision)
        → version finale pour débrief/CRM
```

Le transcript live n'est jamais réécrit silencieusement. Le batch crée une nouvelle révision ; le réconciliateur conserve les identifiants, horodatages et différences. Un échec batch conserve le live avec le statut `provisional`. Une reprise idempotente ne crée pas deux révisions finales identiques.

### Résilience et sécurité

- la perte du STT ne raccroche pas l'appel ;
- les buffers sont bornés et une surcharge dégrade vers « transcription indisponible », jamais vers une mémoire non bornée ;
- les événements Telnyx et jobs batch sont idempotents et corrélés par identifiants non secrets ;
- le média brut n'entre ni dans les logs, ni dans les analytics ;
- les segments ne sont diffusés qu'aux devices autorisés du workspace ;
- le fournisseur, modèle, langue, durée, latence et coût sont enregistrés dans un usage ledger sans contenu textuel ;
- la rétention audio/transcript est configurable avant tout stockage persistant.

Références :

- [Telnyx Media Streaming](https://developers.telnyx.com/docs/voice/programmable-voice/media-streaming)
- [Bonnes pratiques webhooks Voice API](https://developers.telnyx.com/docs/voice/programmable-voice/voice-api-webhooks)
- [Deepgram Flux](https://developers.deepgram.com/docs/flux/quickstart)
- [Machine d'états Flux](https://developers.deepgram.com/docs/flux/state)
- [Flux multilingue](https://developers.deepgram.com/docs/flux/language-prompting)
- [Voxtral Realtime](https://docs.mistral.ai/studio-api/audio/speech_to_text/realtime_transcription)
- [Voxtral live et batch](https://docs.mistral.ai/studio-api/audio/speech_to_text)
- [OpenAI Realtime et audio](https://developers.openai.com/api/docs/guides/realtime)
- [OpenAI Structured Outputs](https://developers.openai.com/api/docs/guides/structured-outputs)

## 11. Attribution des locuteurs et vérité du transcript

Pinkall n'étiquette « vendeur » et « prospect » que si la provenance inbound/outbound est vérifiable sur un appel réel et stable pour la topologie retenue. Le mapping piste → rôle est attaché à la session, testé sur appels sortants et entrants, puis immuable pour cette session.

Le modèle STT peut produire des mots, des horodatages et éventuellement une diarisation batch, mais il ne remplace pas la preuve téléphonique de la piste. En cas de contradiction ou d'absence de piste, l'interface affiche `unknown` et le coach ne formule aucun conseil dépendant du rôle.

## 12. Coach optionnel : préférence, shadow et live

### Mode effectif

Le produit sépare les choix visibles de l'utilisateur des flags opérés par Pinkall :

- préférence utilisateur : `enabled` ou `disabled`, `disabled` par défaut ;
- surcharge avant appel : `inherit`, `enabled` ou `disabled` ;
- mode de déploiement serveur pour les appels autorisés : `shadow` ou `live`.

```text
user disabled OR call override disabled → off
user/call enabled + rollout shadow      → shadow
user/call enabled + rollout live        → live
```

`off` est une frontière de traitement : le moteur de coaching ne reçoit aucun segment. `shadow` exécute exactement la chaîne candidate et mesure ses sorties mais ne diffuse aucune suggestion à l'utilisateur. `live` peut exposer une suggestion après le même gate de précision.

La transcription possède son propre réglage et sa propre information ; activer la transcription n'active jamais implicitement le coach.

### Chaîne de coaching

```text
TranscriptSegmentFinal + CallContext + CRM Context
  → SignalDetector (objection, question, pricing, next step)
    → PlaybookRetriever (cartes sourcées et versionnées)
      → CoachModelAdapter (texte seulement)
        → CandidateSuggestion
          → PrecisionGate
            ├── reject → metric only
            ├── shadow → evaluation only
            └── live → one expiring card to the active device
```

Le modèle ne reçoit que les tours nécessaires, un résumé roulant borné et les cartes récupérées. Les sources complètes et l'historique illimité ne sont pas réinjectés à chaque tour.

Pour le premier incrément, `CoachModelAdapter` appelle l'API Responses d'OpenAI en texte
avec Structured Outputs et `store: false`. Il ne reçoit jamais le flux audio et
ne rédige pas librement un playbook : il peut uniquement sélectionner l'identifiant
d'une carte déjà éligible ou répondre qu'aucune carte ne convient. Le modèle reste
configurable et doit être choisi par évaluation de précision, latence et coût ; un
modèle texte efficace avec effort de raisonnement faible constitue le point de départ.
L'API Realtime OpenAI reste un adaptateur futur possible pour un véritable agent
vocal audio, pas une seconde chaîne de transcription en parallèle de Voxtral.

### Gate de haute précision

Une suggestion est exposable seulement si :

- elle répond à un signal explicite dans un segment final et récent ;
- elle est cohérente avec l'offre, l'ICP, l'étape et l'objectif de l'appel ;
- elle référence au moins une carte de coaching publiée et applicable ;
- elle sépare l'observation de l'interprétation et n'affirme pas une intention non observée ;
- elle propose une seule action brève, réalisable avant expiration ;
- confiance, actionnabilité, fraîcheur et politique de fréquence franchissent leurs seuils versionnés ;
- aucune suggestion plus récente n'est encore active.

En cas d'échec, le système n'affiche rien. Le cache live est éphémère ; les candidats rejetés peuvent être conservés sous forme expurgée pour les évaluations autorisées, jamais pour contourner la préférence `off`.

### Mesures `exposition → action → résultat`

Chaque suggestion possède `suggestionId`, `callSessionId`, versions du corpus/gate/modèle et horodatages :

1. `suggestion_generated` : candidat produit ;
2. `suggestion_eligible` ou `suggestion_rejected` : décision du gate ;
3. `suggestion_exposed` : carte réellement rendue sur le device actif ;
4. `suggestion_action_reported` : utilisateur indique appliqué/ignoré/inutile, sans prétendre détecter automatiquement sa pensée ;
5. `call_outcome_recorded` : prochaine étape, rendez-vous, conversion ou autre résultat CRM.

Les tableaux de bord séparent taux d'exposition, taux d'action déclaré et résultats. Une association statistique n'est jamais libellée comme preuve causale sans expérimentation appropriée.

## 13. CRM et gate d'éligibilité avant appel

Le CRM accepte saisie manuelle et import, mais aucune source de données ne rend un contact automatiquement appelable. Le modèle minimal est :

```text
Contact
  id, workspaceId, name, company, phoneE164, source

CallEligibility
  audience: b2b | b2c | unknown
  jurisdiction
  basis: prior_consent | current_contract | professional_relevance | other_reviewed
  consentEvidenceId?
  informedAt?
  opposedAt?
  ruleVersion
  status: eligible | blocked | needs_review
  evaluatedAt
```

Avant `PlaceCallUseCase`, `EvaluateCallEligibilityUseCase` calcule une décision explicable :

- `opposedAt` ou présence dans `do_not_call` bloque toujours ;
- en France à compter du 11 août 2026, B2C requiert une preuve de consentement préalable, sauf exception documentée telle qu'un contrat en cours ;
- B2B peut être éligible lorsque la sollicitation est professionnelle/pertinente, que l'information est fournie et que l'opposition reste simple ;
- `unknown`, preuve expirée ou règle non disponible produit `needs_review`, qui bloque la composition jusqu'à qualification humaine ;
- la décision conserve les faits d'entrée et `ruleVersion`, sans déduire B2B/B2C par un LLM.

Le consentement à recevoir une prospection, l'information relative à l'enregistrement/transcription et la préférence de coaching sont trois objets différents. Aucun ne vaut automatiquement pour les deux autres.

Référence : [CNIL — prospection commerciale par téléphone](https://www.cnil.fr/fr/prospection-commerciale-par-telephone-hors-automate-dappel-quelles-sont-les-regles)

## 14. Push et appels en arrière-plan

Hors sprint 2. Phase suivante dédiée :

- Android : FCM, credential push Telnyx et gestion background ;
- iOS : APNS VoIP/PushKit, token transmis à Telnyx et CallKit ;
- récupération de l’invitation après réveil de l’application ;
- idempotence des notifications tardives et appels déjà terminés.

Une push ne transporte pas l’audio : elle réveille l’application, qui restaure la connexion et récupère l’invitation Telnyx. Cette phase possède ses propres risques et tests natifs.

Référence : [Push Flutter Telnyx](https://developers.telnyx.com/docs/voice/webrtc/push-notifications/flutter/index).

## 15. Consentement, confidentialité et sécurité

- Le microphone n’est activé que pour un appel initié/accepté par l’utilisateur.
- Enregistrement/transcription désactivés dans STORY-007.
- La permission de prospecter, l'information/enregistrement de la conversation et l'activation du coach sont enregistrés séparément.
- En France à compter du 11 août 2026, le gate bloque par défaut un B2C sans consentement préalable démontrable, sauf exception documentée ; un B2B conserve un chemin information/opposition selon la règle configurée.
- La liste `do_not_call` est vérifiée avant chaque composition et prévaut sur un import ou une ancienne autorisation.
- Toute activation future exige un écran de divulgation, un mécanisme opérationnel pour informer l’autre participant et un avis juridique pour les pays ciblés.
- Les webhooks futurs doivent vérifier `Telnyx-Signature-Ed25519` et `Telnyx-Timestamp`, imposer une fenêtre anti-rejeu et dédupliquer `event.id`.
- Les endpoints backend doivent être en HTTPS, avec secrets gérés hors dépôt et rotation possible.
- La rétention et suppression de l’audio/transcript doivent être configurables avant stockage.
- Les crash reports et analytics excluent secrets, PII et contenu de conversation.

## 16. Stratégie de test

### Tests automatisés

- Domain : transitions d’état, validation E.164, idempotence.
- Data : mapping d’événements et d’erreurs avec un double de SDK dans `test/` uniquement.
- ViewModel : permissions refusées, connexion, appel, mute et hangup.
- Architecture : recherche statique empêchant l'import de `telnyx_webrtc` hors de `core_data` et empêchant le provider runtime simulé.
- Contrats STT : suite de conformité partagée pour adaptateurs live/batch, événements hors ordre, reprise et panne fournisseur.
- Transcript : stabilité des segments finaux, nouvelle révision batch, réconciliation idempotente et rôle `unknown` par défaut.
- Compliance : matrice B2B/B2C/unknown, date du 11 août 2026, consentement, contrat en cours, opposition et priorité `do_not_call`.
- Coach : `off` interdit tout appel modèle ; `shadow` n'expose rien ; `live` n'expose que les candidats admis et respecte une carte active/expiration.
- Télémétrie : aucune exposition n'est comptée avant rendu effectif et aucun résultat n'est transformé en action déclarée.

### Tests d'intégration réels

- Compte et identifiants Telnyx dédiés au test.
- Numéros de destination contrôlés/allowlistés.
- iPhone physique, appareil Android physique et Mac.
- Checklist par plateforme : connexion, sonnerie, réponse, audio dans les deux sens, mute/unmute, hangup distant/local, refus de permission, coupure réseau.
- Captures de logs expurgés comme preuve ; aucun secret ou contenu d'appel dans les artefacts.
- Media Streaming réel : deux pistes, séquences, codec, mapping vendeur/prospect et arrêt propre.
- Deepgram Flux réel : français, noms propres, bruit téléphonique, frontières de tour, `TurnResumed`, latence p50/p95, coupure/reprise et coût mesuré.
- Voxtral batch réel : transcript final, noms propres, réconciliation et coût mesuré.
- Batch réel : comparaison live/final et conservation des révisions.
- Shadow replay : jeu d'appels autorisés annoté manuellement avant tout rollout `live`.

## 17. ADR

### ADR-001 — `telnyx_webrtc` plutôt que `telnyx_common`

**Décision :** intégrer le SDK bas niveau demandé.  
**Pourquoi :** contrôler les événements, les états et les frontières de l’architecture ; `telnyx_common` est annoncé beta.  
**Conséquence :** plus d’adaptation et de tests de cycle de vie.

### ADR-002 — Authentification runtime pour le POC

**Décision :** JWT/SIP fournis au lancement, sans persistance.  
**Pourquoi :** valider la téléphonie avant de construire l’auth Pinkall et éviter les secrets dans le dépôt.  
**Conséquence :** expérience volontairement développeur, non distribuable en production.

### ADR-003 — Aucun faux débrief

**Décision :** masquer ou déclarer indisponible toute transcription tant que Telnyx Media Streaming et un adaptateur STT réel ne l'alimentent pas.  
**Pourquoi :** une simulation ne valide ni la qualité, ni la latence, ni l’attribution des locuteurs.  
**Conséquence :** STORY-007 valide le téléphone, pas encore la promesse complète de coaching.

### ADR-004 — macOS soumis à une preuve

**Décision :** tenter le package direct comme demandé, mais ne pas prétendre au support sans build et appel réel.  
**Pourquoi :** la cible est publiée mais les guides officiels ne documentent pas le flux macOS au même niveau qu’iOS/Android.  
**Conséquence :** incompatibilité upstream = blocker et nouvelle décision d’architecture.

### ADR-005 — Vocabulaire Telnyx temporaire dans le domain du POC

**Décision :** conserver les noms `Telnyx*` dans les entités/use cases du vertical slice, sans aucune dépendance au SDK.  
**Pourquoi :** un seul fournisseur est dans le scope et renommer prématurément masquerait les contraintes réelles d’authentification/connexion à valider.  
**Conséquence :** avant d’ajouter un second opérateur, ces contrats devront devenir `Voip*`/`Calling*` et Telnyx restera uniquement dans `core_data`.

### ADR-006 — Client lazy et auto-reconnexion désactivée dans le POC

**Décision :** ne construire `TelnyxClient` qu’au premier `connect` et passer `autoReconnect: false`.  
**Pourquoi :** la version 4.3.0 conserve une subscription Connectivity non annulable publiquement ; après `disconnect`, un ancien client configuré en auto-reconnexion peut sinon tenter de rouvrir un socket avec sa configuration précédente.  
**Conséquence :** une coupure réseau termine l'appel dans ce POC. Avant production et push/background, mettre à niveau ou patcher le SDK avec un vrai `dispose`, l'annulation de la subscription et la purge des credentials.

### ADR-007 — Media Streaming puis adaptateur STT

**Décision :** Telnyx fournit `both_tracks` à l'`AudioGateway`; le domain consomme `StreamingTranscriptionAdapter`. Deepgram Flux est l'implémentation live principale, Voxtral reste le fallback live et l'adaptateur batch final.  
**Pourquoi :** séparer téléphonie et reconnaissance vocale, maîtriser l'attribution des pistes, le coût et le changement de fournisseur.  
**Conséquence :** une topologie Call Control corrélable est un gate réel ; le moteur STT Telnyx n'est plus la voie cible et aucun type Deepgram/Voxtral ne fuit dans les contrats métier.

### ADR-008 — Transcript live provisoire, transcript batch final

**Décision :** le live alimente l'interface et le coach ; une nouvelle révision batch devient la source du débrief et du CRM.  
**Pourquoi :** la faible latence et la meilleure exactitude finale ont des contraintes différentes.  
**Conséquence :** stockage versionné, réconciliation et statut `provisional` si le batch échoue.

### ADR-009 — Coach optionnel et traitement strictement désactivable

**Décision :** préférence utilisateur désactivée par défaut, surcharge par appel et modes serveur `shadow|live`; le mode effectif `off` ne transmet rien au moteur de coaching.  
**Pourquoi :** le coach a un coût, une sensibilité et une charge cognitive distincts de la transcription.  
**Conséquence :** télémétrie, facturation et pipeline doivent respecter le mode effectif, pas seulement masquer l'UI.

### ADR-010 — Shadow obligatoire avant live

**Décision :** chaque version significative du corpus, du modèle ou du gate passe par replay/`shadow` avant exposition.  
**Pourquoi :** optimiser la précision plutôt que le volume de conseils et observer les faux positifs sans distraire l'appelant.  
**Conséquence :** « aucune suggestion » est un résultat valide ; le rollout `live` exige des seuils documentés sur de vrais appels autorisés.

### ADR-011 — Gate CRM avant composition

**Décision :** la composition dépend d'une décision `eligible`; `blocked` et `needs_review` empêchent l'appel.  
**Pourquoi :** après le 11 août 2026, l'absence de consentement préalable B2C en France ne peut pas être réparée pendant un appel de prospection ; le B2B reste soumis à information/opposition et aux règles applicables.  
**Conséquence :** audience, source, preuve, opposition et version de règle deviennent des données produit de premier rang, distinctes du consentement à transcrire.

## 18. Gate de solutioning

La solution est prête à poursuivre STORY-007 et à ordonner les incréments suivants parce que les responsabilités, contrats et critères de preuve sont définis. Elle n'autorise pas à déclarer terminés :

- macOS avant un appel réel ;
- le backend/JWT avant de vraies clés et un token Telnyx court réellement utilisé ;
- Media Streaming avant une corrélation Call Control et la réception réelle de `both_tracks` ;
- l'adaptateur Voxtral avant de vrais flux français, latences, erreurs et coûts observés ;
- le transcript final avant un vrai enregistrement batch et une réconciliation auditée ;
- l'attribution des locuteurs avant une donnée de piste vérifiable sur la topologie retenue ;
- le CRM de prospection avant les tests de règles B2B/B2C/unknown et `do_not_call` ;
- le mode `shadow` avant des cartes de coaching sourcées et un jeu d'évaluation autorisé ;
- le mode `live` avant des métriques de précision/latence approuvées et le switch fonctionnel ;
- les appels entrants en arrière-plan avant FCM/APNS/CallKit.

## 19. Ordre des stories

| Ordre | Story | Gate de sortie principal |
|---:|---|---|
| 1 | STORY-007 — Appel Telnyx réel | appels et audio bidirectionnel sur appareils physiques, vraies clés |
| 2 | STORY-008 — Backend SaaS et JWT Telnyx | token court serveur et appel corrélé réel |
| 3 | STORY-009 — CRM et éligibilité | import/saisie, `do_not_call`, matrice B2B/B2C/unknown |
| 4 | STORY-010 — Media Streaming + Voxtral live | `both_tracks` réel, segments live et panne STT non bloquante |
| 5 | STORY-011 — Transcript final batch | révision finale Voxtral et réconciliation auditée |
| 6 | STORY-012 — Débrief et CRM | résumé/follow-up réels issus du final, écriture CRM contrôlée |
| 7 | STORY-013 — Cartes de coaching sourcées | corpus initial revu, versionné et évaluable |
| 8 | STORY-014 — Switch et modes coach | préférence + override, `off` étanche, `shadow` invisible |
| 9 | STORY-015 — Coaching shadow | replay/appels autorisés et rapport précision/latence |
| 10 | STORY-016 — Coaching live haute précision | une carte utile, expirable, sourcée, rollout contrôlé |
| 11 | STORY-017 — Mesure action/résultat | chaîne d'événements vérifiée et dashboard sans causalité inventée |
