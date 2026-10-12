# Passer un appel sortant réel avec Telnyx WebRTC

**ID :** STORY-007  
**Epic :** Téléphone Pinkall réel  
**Priorité :** Must Have  
**Story Points :** 8  
**Statut :** Implémentée — validation mobile physique restante

## User Story

En tant que fondateur ou commercial,
je veux me connecter à Telnyx et appeler un vrai numéro depuis Pinkall,
afin de valider que Pinkall peut devenir mon téléphone de prospection avant d’ajouter la transcription et le coaching.

## Acceptance Criteria

### AC1 — Authentification runtime

- [ ] Étant donné un JWT Telnyx valide saisi au runtime, lorsque je me connecte, l’application utilise `connectWithToken` et atteint un état « prêt » fourni par Telnyx.
- [ ] En mode développement explicite, je peux utiliser un utilisateur et un mot de passe SIP saisis au runtime avec `connectWithCredential`.
- [x] Les secrets sont masqués, non préremplis, non persistés et absents des logs.
- [x] Une authentification invalide affiche une erreur expurgée et compréhensible, puis permet de réessayer.

### AC2 — Permission microphone

- [x] La permission microphone est déclarée et demandée sur Android, iOS et macOS avec une explication claire.
- [x] Si elle est refusée, Pinkall n’initie pas l’appel audio et propose une action de correction.
- [x] Aucune permission d’enregistrement/transcription supplémentaire n’est présentée comme déjà utilisée.

### AC3 — Appel Telnyx réel

- [x] Étant donné un client Telnyx prêt et un numéro E.164 valide, lorsque je touche « appeler », Pinkall envoie une véritable invitation `telnyx_webrtc`.
- [x] L’identifiant et les états de l’appel viennent du SDK ; un timer ou un délai local ne peut pas simuler la connexion.
- [ ] Un téléphone de destination contrôlé sonne réellement et peut répondre.
- [ ] Après réponse, les deux participants s’entendent dans les deux sens.

### AC4 — Contrôles et cycle de vie

- [ ] Mute/unmute agit sur le véritable appel actif et l’interface reflète son état.
- [ ] Raccrocher termine l’appel Telnyx réel ; un second clic n’envoie pas une commande incohérente.
- [ ] Un raccrochage distant, un échec réseau ou un rejet ramène l’application vers un état terminal exact.
- [x] Les événements tardifs d’un ancien appel ne réactivent pas l’écran actif.

### AC5 — Zéro simulation runtime

- [x] Aucun `InMemoryCallLocalDataSource`, repository de démonstration ou provider simulé n’est accessible depuis le graphe runtime.
- [x] Aucun appel, transcript, résumé, engagement, follow-up ou conseil fictif n’apparaît.
- [x] Après l’appel, la transcription est absente ou explicitement indiquée comme non configurée.
- [x] Les fixtures et doubles éventuels restent confinés aux tests.

### AC6 — Architecture du dépôt

- [x] `core_domain` expose repository, entités et use cases sans importer le package Telnyx.
- [x] `core_data` encapsule `telnyx_webrtc` dans un RemoteDataSource et mappe les événements vers le domain.
- [x] Les providers suivent `dataSource → repository → useCase → viewModel` avec `ref.watch(...future)`.
- [x] Chaque nouvel écran respecte la triade `.state.dart`, `.view_model.dart`, `.screen.dart` et les autres règles de `ARCHITECTURE.md`.

### AC7 — Couverture des plateformes

- [ ] iOS : build, connexion, appel et audio bidirectionnel réussis sur appareil physique.
- [ ] Android : build, connexion, appel et audio bidirectionnel réussis sur appareil physique.
- [ ] macOS : build, connexion, appel et audio bidirectionnel réussis sur Mac.
- [ ] Si `telnyx_webrtc` empêche la validation macOS, la story passe en `blocked` avec la preuve d’incompatibilité ; aucune simulation ou affirmation de support ne contourne ce gate.

### AC8 — Consentement et sécurité

- [x] L’utilisateur est informé avant connexion que Pinkall utilise le microphone et Telnyx pour passer l’appel.
- [x] La fonctionnalité de transcription/enregistrement reste désactivée dans cette story.
- [x] Les analytics, logs et crash reports excluent secrets, numéro complet et contenu d’appel.
- [x] Une recherche de secrets et une revue des configurations natives ne trouvent aucune valeur Telnyx sensible.

## Technical Notes

- Utiliser directement le package bas niveau `telnyx_webrtc`; ne pas substituer `telnyx_common` sans ADR et validation produit.
- Le package est publié avec une cible macOS mais les guides Telnyx documentent surtout iOS/Android. Conserver macOS comme gate expérimental jusqu’à validation connexion + audio réelle.
- Utiliser JWT pour le chemin nominal. Les credentials SIP sont uniquement un accélérateur de développement.
- `telnyx_webrtc` 4.3.0 n’expose pas de dispose de sa subscription réseau : le POC crée le client à la demande et désactive l’auto-reconnexion ; un patch/upgrade est requis avant production.
- Conserver un seul appel actif et corréler tous les événements avec son identifiant réel.
- Ne pas démarrer de transcription depuis Flutter. L'incrément suivant utilise Telnyx Media Streaming côté serveur puis le contrat fournisseur-agnostique `StreamingTranscriptionAdapter`; Voxtral sera le premier adaptateur.
- Le push mobile et CallKit appartiennent à un sprint ultérieur.

## Tasks

- [x] Ajouter la dépendance Telnyx compatible et réaliser le spike des trois builds.
- [x] Créer les entités, repository et use cases du domain.
- [x] Créer le RemoteDataSource Telnyx et le repository data.
- [x] Créer la chaîne de providers Riverpod runtime.
- [x] Construire l’écran de connexion runtime et le dialer.
- [x] Brancher la machine à états, mute et hangup.
- [x] Configurer les permissions natives sur Android, iOS et macOS.
- [x] Retirer du runtime les sources et parcours simulés.
- [x] Ajouter les tests unitaires/widget sans brancher de fake en production.
- [ ] Exécuter et documenter les appels réels sur trois plateformes.

## Dependencies

- Compte Telnyx actif.
- Credential Connection et Outbound Voice Profile configurés.
- JWT ou SIP credentials dédiés au test.
- Caller ID Telnyx autorisé.
- Appareils physiques iOS/Android et Mac avec microphone.
- Numéro de destination contrôlé.

## Out of Scope

- Transcription, enregistrement, résumé, coaching et CRM.
- Backend Pinkall et émission de JWT.
- Appels entrants en arrière-plan, FCM, APNS/PushKit et CallKit.
- Historique persistant.

## Definition of Done

- [ ] Tous les critères d’acceptation sont satisfaits.
- [x] Analyse statique et tests automatisés passent.
- [x] Les builds des trois plateformes passent.
- [ ] Les preuves manuelles démontrent un appel réel et un audio bidirectionnel sur les trois plateformes.
- [ ] Aucun secret ni contenu d’appel n’est présent dans les artefacts.
- [ ] Le PRD, l’architecture et le statut de sprint sont à jour.
