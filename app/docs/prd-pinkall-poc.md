# PRD — Pinkall POC Flutter

| Champ | Valeur |
| --- | --- |
| Produit | Pinkall |
| Document | Product Requirements Document — POC |
| Version | 1.0 |
| Date | 11 juillet 2026 |
| Statut | Prêt pour découpage technique et implémentation |
| Plateformes | macOS, iOS, Android |
| Références | `PRODUCT.md`, `ARCHITECTURE.md`, promesse de la landing Pinkall |

## 1. Résumé exécutif

Pinkall est le coach de call des founders B2B qui conduisent encore eux-mêmes leurs appels de prospection, de discovery, de démonstration et de suivi.

Le POC doit rendre tangible la boucle de valeur centrale sans dépendre d'une infrastructure téléphonique réelle :

1. le founder lance un appel simulé depuis l'application ;
2. il voit une expérience d'appel crédible et termine l'appel ;
3. Pinkall affiche immédiatement qui a dit quoi ;
4. Pinkall prépare le résumé et le follow-up ;
5. Pinkall propose une seule amélioration prioritaire, reliée à un passage précis, ainsi qu'une question à tester au prochain call.

Ce POC ne cherche pas à prouver la faisabilité de Telnyx, WebRTC, CallKit, de la transcription ou d'un moteur de coaching. Il cherche à valider la compréhension, l'utilité perçue et la qualité de l'expérience produit de bout en bout sur macOS, iOS et Android.

## 2. Contexte et problème

### 2.1 Utilisateur prioritaire

Le premier ICP est le founder d'une startup B2B ou d'un SaaS early-stage qui :

- réalise encore directement des appels de prospection ou de discovery ;
- doit vendre tout en apprenant son marché ;
- prend des notes pendant l'appel ou les reconstruit après coup ;
- oublie des détails, des objections ou des engagements ;
- prépare manuellement le prochain message de suivi ;
- manque de recul pour identifier ce qu'il devrait améliorer au prochain appel.

Les sales individuels et petites équipes commerciales constituent une cible secondaire, mais le POC doit rester écrit et conçu pour le founder B2B.

### 2.2 Douleur principale

Pendant un call, le founder doit choisir entre rester présent dans la conversation et prendre des notes. Après le call, il doit reconstruire ce qui a été dit, produire une synthèse, rédiger le follow-up et décider quoi changer dans son approche. Ce travail est lent, incomplet et rarement transformé en apprentissage concret pour le call suivant.

### 2.3 Promesse testée

> Ton coach pour chaque call.

La promesse fonctionnelle du POC est :

> Appelle dans Pinkall sans prendre de notes. En raccrochant, retrouve qui a dit quoi, le résumé, le follow-up et une amélioration précise pour ton prochain call.

### 2.4 Hypothèses produit

- H1 — Une expérience unifiée « appel puis débrief » est plus facile à comprendre et plus désirable qu'un outil de transcription isolé.
- H2 — La transcription par interlocuteur, le résumé et le follow-up réduisent suffisamment le travail post-call pour créer une valeur immédiate.
- H3 — Une seule amélioration prioritaire est perçue comme plus actionnable qu'un score ou un rapport générique.
- H4 — Relier l'amélioration à un passage du call augmente la confiance et la compréhension.
- H5 — L'accès sur macOS et téléphone correspond au contexte réel de travail des founders ; Android est inclus pour vérifier que l'expérience partagée reste cohérente.

## 3. Objectifs et critères de succès

### 3.1 Objectifs du POC

- Démontrer le parcours complet, de la liste des appels au débrief.
- Tester la promesse centrale avec des founders B2B avant l'intégration de la téléphonie et de l'IA réelles.
- Évaluer si le débrief est compris sans explication du concepteur.
- Évaluer si l'amélioration prioritaire donne envie de revenir pour le prochain call.
- Valider une base Flutter commune utilisable sur macOS, iOS et Android et conforme à `ARCHITECTURE.md`.

### 3.2 Succès d'usage du prototype

Lors d'un test modéré avec au moins 5 founders B2B correspondant à l'ICP :

- au moins 4 sur 5 terminent le parcours « lancer un appel simulé → raccrocher → ouvrir le débrief » sans aide ;
- au moins 4 sur 5 identifient correctement les deux interlocuteurs dans la transcription ;
- au moins 4 sur 5 retrouvent le résumé et le follow-up en moins de 30 secondes après le raccrochage ;
- au moins 4 sur 5 peuvent reformuler l'amélioration prioritaire et la question à tester ;
- au moins 3 sur 5 déclarent vouloir essayer Pinkall sur un vrai call, sans présenter ce résultat comme une preuve de traction.

### 3.3 Succès technique du prototype

- Le même parcours critique fonctionne sur macOS, iOS et Android.
- Tous les comportements Must Have disposent d'un test automatisé au niveau pertinent ou d'un scénario de recette documenté lorsque l'automatisation n'est pas raisonnable.
- `flutter analyze` ne retourne aucune erreur ni avertissement dans le code du POC.
- Tous les tests automatisés passent.
- L'application peut exécuter le parcours critique entièrement hors ligne.

### 3.4 Non-objectifs

- Mesurer la qualité réelle de la téléphonie, de la transcription ou de la diarisation.
- Démontrer une amélioration mesurable du taux de conversion commercial.
- Évaluer la qualité d'un corpus de coaching sales ou marketing.
- Préparer une version publiable sur l'App Store ou le Play Store.
- Construire un CRM ou remplacer un CRM existant.

## 4. Principes de conception du POC

1. **Produit explicite.** L'utilisateur comprend avant toute interaction qu'il s'agit d'une simulation locale.
2. **Une boucle de valeur.** Chaque écran sert le parcours appel → débrief → prochain call.
3. **Sorties concrètes.** La transcription, le résumé, le follow-up et l'amélioration sont visibles, pas seulement décrits.
4. **Une amélioration, pas un tableau de scores.** Aucun score composite ou dashboard générique n'est requis.
5. **Founder arbitre.** Le contenu est présenté comme une aide que l'utilisateur peut relire et décider d'appliquer.
6. **Honnêteté du POC.** Aucune donnée simulée ne doit être présentée comme issue d'un vrai appel ou d'une IA en production.
7. **Cohérence cross-platform.** La structure du parcours reste identique ; la densité et la navigation s'adaptent au desktop et au mobile.

## 5. Parcours cible

### 5.1 Happy path

1. Le founder ouvre Pinkall.
2. Il voit ses appels de démonstration, triés du plus récent au plus ancien.
3. Il choisit « Nouvel appel simulé ».
4. Il voit le prospect de démonstration, son entreprise et le contexte du scénario.
5. Il lance l'appel simulé.
6. L'écran passe à l'état « En cours » et affiche un chronomètre.
7. Il termine l'appel.
8. Pinkall affiche brièvement un état « Préparation du débrief ».
9. Le débrief s'ouvre avec :
   - la transcription complète séparée entre « Toi » et « Prospect » ;
   - le résumé ;
   - les points clés et engagements ;
   - le follow-up prêt à relire ;
   - une amélioration prioritaire ;
   - le passage qui motive cette amélioration ;
   - une question à tester au prochain call.
10. Il revient à la liste ; le call terminé apparaît en premier.

### 5.2 Parcours de consultation

1. Le founder ouvre Pinkall.
2. Il sélectionne un call déjà terminé dans l'historique.
3. Le débrief correspondant s'ouvre directement.
4. Il peut naviguer entre les sections sans perdre sa position ou le call sélectionné.

### 5.3 États à couvrir

- Historique avec données de démonstration.
- Historique vide après réinitialisation volontaire.
- Appel prêt à démarrer.
- Appel simulé en cours.
- Préparation déterministe du débrief.
- Call terminé avec débrief complet.
- Erreur contrôlée de chargement d'une fixture invalide.

## 6. Périmètre MoSCoW

### Must Have

- Projet Flutter exécutable sur macOS, iOS et Android.
- Architecture en couches et feature-first conforme à `ARCHITECTURE.md`.
- Historique local des calls simulés.
- Démarrage et fin d'un appel simulé.
- Écran d'appel avec prospect, entreprise, état et durée.
- Génération déterministe d'un débrief à partir d'une fixture locale.
- Transcription complète séparée par interlocuteur et ordonnée dans le temps.
- Résumé, points clés, engagements et follow-up.
- Une amélioration prioritaire reliée à un passage et accompagnée d'une question à tester.
- Navigation complète et responsive sur desktop et mobile.
- Signalétique visible « Démonstration / appel simulé ».
- Fonctionnement hors ligne et sans envoi de données.
- Tests du parcours critique et états loading/error/empty.

### Should Have

- Persistance locale des calls simulés créés entre deux lancements.
- Action pour copier le follow-up dans le presse-papiers.
- Édition locale du follow-up avant copie.
- Choix entre deux scénarios de call de démonstration.
- Action « Rejouer la démo » ou « Réinitialiser les données ».
- Navigation depuis l'amélioration vers le passage correspondant dans la transcription.

### Could Have

- Lecture d'un court audio préenregistré local pendant la simulation.
- Animation progressive de la conversation pendant l'appel.
- Recherche ou filtre simple dans l'historique.
- Mode sombre.
- Export local du débrief en texte ou Markdown.
- Évaluation qualitative de l'utilité du débrief à la fin du parcours.

### Won't Have dans ce POC

- Telnyx, SIP, WebRTC ou appels téléphoniques réels.
- APNS, FCM, PushKit, CallKit ou écran d'appel système.
- Numéro Pinkall, portage, renvoi d'appel, appels entrants ou SMS.
- Capture du micro, enregistrement audio ou gestion des permissions audio.
- Speech-to-text réel, diarisation réelle ou traduction automatique.
- LLM, conseil génératif, coaching en temps réel ou RAG.
- Corpus de livres, cours, vidéos ou playbooks de vente intégré au produit.
- Authentification, compte utilisateur, backend ou synchronisation cloud.
- CRM, intégrations HubSpot/Salesforce, import de contacts ou enrichissement de prospects.
- Multi-utilisateur, équipes, rôles, commentaires ou partage.
- Paiement, abonnement, paywall ou quotas.
- Notifications, calendrier ou rappels.
- Publication dans les stores, notarisation macOS ou distribution bêta publique.

## 7. Exigences fonctionnelles

Les exigences Must sont obligatoires pour considérer le POC terminé. Les exigences Should sont implémentées seulement après stabilisation du parcours critique.

### 7.1 Cadre de démonstration et navigation

| ID | Priorité | Exigence testable |
| --- | --- | --- |
| FR-001 | Must | Au premier lancement, l'application affiche une mention persistante indiquant que les appels et débriefs sont simulés. |
| FR-002 | Must | L'utilisateur peut accéder à l'historique, à l'appel simulé et au débrief sans impasse de navigation. |
| FR-003 | Must | Le bouton retour du système et l'action retour de l'interface ramènent à l'écran précédent sans créer de doublon de route. |
| FR-004 | Must | La navigation conserve l'identifiant du call sélectionné afin d'afficher le bon débrief. |
| FR-005 | Must | Sur macOS, le contenu exploite une largeur desktop sans étirer les lignes de lecture au-delà d'une largeur lisible ; sur iOS et Android, aucun contenu critique n'est coupé à 320 px de largeur logique. |

### 7.2 Historique des calls

| ID | Priorité | Exigence testable |
| --- | --- | --- |
| FR-010 | Must | L'écran d'accueil affiche au moins trois calls de démonstration au premier lancement. |
| FR-011 | Must | Les calls sont triés par date de début décroissante. |
| FR-012 | Must | Chaque ligne affiche au minimum le nom du prospect, son entreprise, la date, la durée et l'état du call. |
| FR-013 | Must | Sélectionner un call terminé ouvre le débrief correspondant. |
| FR-014 | Must | Une action principale « Nouvel appel simulé » ouvre l'écran de préparation d'appel. |
| FR-015 | Must | Lorsque la source locale retourne une liste vide, l'écran affiche un empty state avec une action pour lancer un appel simulé. |
| FR-016 | Should | Un call terminé pendant la session apparaît en première position au retour à l'historique. |
| FR-017 | Should | Les calls simulés créés restent disponibles après fermeture et relance de l'application. |

### 7.3 Appel simulé

| ID | Priorité | Exigence testable |
| --- | --- | --- |
| FR-020 | Must | Avant le lancement, l'écran affiche le nom du prospect, son entreprise et un contexte de call court. |
| FR-021 | Must | L'action « Démarrer l'appel simulé » fait passer le call de l'état `ready` à l'état `inProgress`. |
| FR-022 | Must | Pendant l'appel, l'écran affiche explicitement « Appel simulé en cours » et un chronomètre non décroissant. |
| FR-023 | Must | Une action de fin d'appel reste accessible pendant tout l'état `inProgress`. |
| FR-024 | Must | Terminer l'appel fige sa durée, enregistre une date de fin et fait passer son état à `processing`, puis `completed`. |
| FR-025 | Must | Le passage de `processing` à `completed` utilise uniquement des données locales et prend au maximum une seconde hors animation volontaire. |
| FR-026 | Must | Une double activation rapide de l'action de fin ne crée qu'un seul call terminé et un seul débrief. |
| FR-027 | Must | Quitter un appel en cours déclenche une confirmation ; annuler la confirmation conserve l'appel, confirmer le termine comme une simulation. |
| FR-028 | Should | L'utilisateur peut choisir l'un de deux scénarios avant de démarrer l'appel. |

### 7.4 Transcription et débrief

| ID | Priorité | Exigence testable |
| --- | --- | --- |
| FR-030 | Must | Le débrief affiche un titre et les métadonnées du call sélectionné : prospect, entreprise, date et durée. |
| FR-031 | Must | La transcription affiche tous les segments de la fixture dans l'ordre chronologique. |
| FR-032 | Must | Chaque segment indique sans dépendre uniquement de la couleur s'il vient de « Toi » ou du « Prospect ». |
| FR-033 | Must | Chaque segment affiche un repère temporel au format `mm:ss`. |
| FR-034 | Must | Le débrief présente un résumé distinct de la transcription. |
| FR-035 | Must | Le débrief présente des points clés et des engagements distincts ; un état « Aucun engagement explicite » est prévu si la liste est vide. |
| FR-036 | Must | Le débrief présente un follow-up complet et lisible, prêt à être relu par l'utilisateur. |
| FR-037 | Must | Le débrief présente exactement une amélioration prioritaire, sans score global ni classement de dix métriques. |
| FR-038 | Must | L'amélioration comprend une observation, une recommandation concrète et une question à tester au prochain call. |
| FR-039 | Must | L'amélioration référence un segment existant de la transcription par son identifiant et son repère temporel. |
| FR-040 | Must | Si le segment référencé n'existe pas, l'interface affiche le conseil sans lien cassé et journalise une erreur contrôlée en mode développement. |
| FR-041 | Must | Les données de débrief sont déterministes : rouvrir le même call sans édition affiche le même contenu. |
| FR-042 | Should | Une action depuis l'amélioration amène l'utilisateur au segment référencé et le met temporairement en évidence. |
| FR-043 | Should | L'utilisateur peut copier le follow-up ; un retour visuel confirme la copie pendant au moins une seconde. |
| FR-044 | Should | L'utilisateur peut modifier localement le follow-up avant de le copier, sans modifier la fixture d'origine. |

### 7.5 Données locales et états d'erreur

| ID | Priorité | Exigence testable |
| --- | --- | --- |
| FR-050 | Must | Toutes les données initiales proviennent de fixtures embarquées et aucun appel réseau n'est nécessaire au parcours critique. |
| FR-051 | Must | Le repository expose des entités métier à la présentation ; aucun modèle de stockage ou DTO n'est consommé par un ViewModel ou un écran. |
| FR-052 | Must | Une fixture invalide produit un état d'erreur explicite avec une action de retour ou de nouvelle tentative, jamais un écran vide ou un crash. |
| FR-053 | Must | Les états loading, data, empty et error des écrans asynchrones sont rendus explicitement. |
| FR-054 | Should | Une action de réinitialisation restaure les fixtures de démonstration après confirmation. |

## 8. Modèle conceptuel minimal

Le modèle ci-dessous décrit les objets métier attendus. Les noms Dart définitifs peuvent être adaptés au guide d'architecture, mais leurs responsabilités doivent rester séparées.

### CallSession

- `id`
- `prospect`
- `scenarioId`
- `status` : `ready`, `inProgress`, `processing`, `completed`
- `startedAt`
- `endedAt`
- `duration`
- `debriefId` facultatif avant complétion

### Prospect

- `id`
- `name`
- `company`
- `role`
- `context`

### CallDebrief

- `id`
- `callId`
- `summary`
- `keyPoints`
- `commitments`
- `followUpDraft`
- `transcriptSegments`
- `priorityImprovement`

### TranscriptSegment

- `id`
- `speaker` : `seller` ou `prospect`
- `offset`
- `text`

### PriorityImprovement

- `title`
- `observation`
- `recommendation`
- `nextCallQuestion`
- `sourceSegmentId`

### Invariants métier

- Un call `completed` possède exactement un débrief.
- Un débrief appartient à un seul call.
- Les segments d'une transcription sont ordonnés par offset croissant.
- Une amélioration prioritaire référence au maximum un segment principal et ne crée pas de score global.
- Les contenus simulés portent un indicateur de provenance `demo` au niveau de la source de données.

## 9. Exigences non fonctionnelles

| ID | Catégorie | Exigence mesurable |
| --- | --- | --- |
| NFR-001 | Plateformes | Le parcours critique est recetté sur une build macOS locale, un simulateur iOS et un émulateur Android avec la même base Flutter. |
| NFR-002 | Compatibilité | Le projet utilise la version stable de Flutter verrouillée dans le dépôt et les cibles minimales générées ou explicitement documentées par le projet. |
| NFR-003 | Performance | En mode profile sur une machine ou un simulateur de référence, l'historique devient interactif en moins de 2 secondes après le lancement à chaud. |
| NFR-004 | Performance | Une navigation entre deux écrans alimentés localement affiche son contenu ou un état loading en moins de 300 ms. |
| NFR-005 | Performance | Après la fin d'un appel, le débrief déterministe est disponible en moins d'une seconde, hors animation volontaire. |
| NFR-006 | Fluidité | Le parcours critique ne présente aucune frame lente visible lors d'une vérification Flutter DevTools sur le matériel de référence ; les listes restent fluides avec 100 calls de fixture. |
| NFR-007 | Fiabilité | Vingt exécutions consécutives du scénario démarrer → terminer → débrief ne produisent ni crash, ni doublon, ni débrief associé au mauvais call. |
| NFR-008 | Hors ligne | Le parcours critique fonctionne en mode avion et ne déclenche aucune requête HTTP. |
| NFR-009 | Confidentialité | Le POC ne demande pas la permission micro, contacts, téléphone ou notifications et ne collecte ni ne transmet aucune donnée personnelle. |
| NFR-010 | Transparence | Tous les écrans contenant des appels ou conseils fictifs indiquent qu'il s'agit d'une démonstration ou de données simulées. |
| NFR-011 | Accessibilité | Tous les éléments interactifs ont une cible d'au moins 44 × 44 points logiques et un libellé sémantique exploitable par VoiceOver/TalkBack. |
| NFR-012 | Accessibilité | Le texte principal et les contrôles respectent un contraste WCAG 2.1 AA ; l'information de locuteur ne dépend pas uniquement de la couleur. |
| NFR-013 | Accessibilité | À 200 % de mise à l'échelle du texte, le parcours critique reste utilisable sans texte tronqué ni contrôle inaccessible. |
| NFR-014 | Responsive | Aucun overflow Flutter n'est journalisé à 320 × 568, 390 × 844, 768 × 1024 et 1440 × 900 points logiques. |
| NFR-015 | Architecture | Les dépendances respectent strictement `core_foundation ← core_domain ← core_data ← application`, sans dépendance inverse. |
| NFR-016 | Architecture | Chaque écran respecte la triade `state` Freezed, `view_model` Riverpod et `screen` sans logique métier. |
| NFR-017 | Architecture | La présentation ne connaît que les entités, repositories, use cases et services exposés par les couches autorisées ; elle n'instancie aucune implémentation data. |
| NFR-018 | Localisation | Les textes d'interface sont servis par EasyLocalization ; aucune chaîne utilisateur n'est codée en dur dans les screens. Le français est la locale complète requise pour le POC. |
| NFR-019 | Qualité | `flutter analyze` se termine sans erreur ni avertissement et `flutter test` se termine avec un code de sortie nul. |
| NFR-020 | Tests | Les use cases de cycle d'appel et de récupération du débrief ont des tests unitaires ; les écrans historique, appel et débrief ont chacun au moins un widget test du happy path et un test d'état alternatif. |
| NFR-021 | Maintenabilité | Les fichiers générés (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, clés de locale) ne sont jamais modifiés manuellement. |
| NFR-022 | Observabilité | Les erreurs de fixture, de repository et de transition d'état utilisent le logger de `core_foundation` sans inclure de contenu sensible. |

## 10. Contraintes d'architecture

Le POC doit suivre `ARCHITECTURE.md` même si sa source de données est uniquement locale.

### 10.1 Structure et dépendances

- `core_foundation` contient les primitives transverses, configuration mock/test, résultats, erreurs et logging.
- `core_domain` contient les entités, contrats de repositories et use cases du cycle d'appel et du débrief.
- `core_data` contient les modèles locaux, fixtures, datasource locale, mappers et implémentations de repositories.
- L'application Flutter contient les providers Riverpod, la navigation AutoRoute et les features de présentation.
- `core_presentation` ne reçoit que les éléments réellement partagés entre plusieurs features ; aucune abstraction prématurée n'est exigée.

La direction de dépendance reste :

`core_foundation ← core_domain ← core_data ← app_mobile`

et `core_presentation` dépend seulement des couches autorisées par le guide.

### 10.2 Features de présentation attendues

- `call_history`
- `simulated_call`
- `call_debrief`
- `shared` uniquement pour les composants réellement réutilisés

Chaque écran suit la triade imposée :

- état immutable Freezed ;
- ViewModel Riverpod code-gen ;
- Screen AutoRoute consommant l'état sans logique métier.

### 10.3 Source de données du POC

La source locale doit être substituable. Le contrat de repository ne doit pas révéler qu'il s'agit de JSON, de fixtures Dart ou d'un stockage embarqué. Cette séparation permettra de remplacer plus tard la simulation par une API ou un flux d'appel réel sans réécrire le domaine et la présentation.

### 10.4 Simplicité

- Pas de endpoint Retrofit sans backend à appeler.
- Pas de service abstrait créé pour une opération couverte par un seul use case.
- Pas de package cross-feature avant qu'un composant soit effectivement utilisé dans au moins deux features.
- Pas de moteur générique de workflow d'appel pour quatre états fixes.

## 11. Epics, user stories et critères d'acceptation

### Epic E1 — Fondation cross-platform conforme

**Valeur :** fournir une base démontrable sur les trois plateformes sans compromettre l'architecture future.

#### US-101 — Lancer Pinkall sur les trois plateformes

En tant que testeur produit, je veux lancer la même application sur macOS, iOS et Android afin d'évaluer l'expérience dans les contextes desktop et mobile.

Critères d'acceptation :

1. Une build macOS démarre et affiche l'historique.
2. Une build iOS démarre dans le simulateur et affiche l'historique.
3. Une build Android démarre dans l'émulateur et affiche l'historique.
4. Les trois builds utilisent les mêmes entités et use cases.
5. Aucune plateforme n'affiche un écran exemple Flutter ou un contenu non Pinkall.

#### US-102 — Comprendre qu'il s'agit d'une simulation

En tant que founder, je veux distinguer les données de démonstration d'un vrai call afin de ne pas attribuer au produit des capacités qui ne sont pas encore construites.

Critères d'acceptation :

1. Une mention « Démo » ou « Appel simulé » est visible sur l'historique, l'écran d'appel et le débrief.
2. Aucun texte ne prétend que l'appel a transité par un opérateur réel.
3. Aucune permission micro, téléphone, contacts ou notifications n'est demandée.

### Epic E2 — Historique des calls

**Valeur :** centraliser les conversations et permettre de retrouver leur résultat sans reconstruire ses notes.

#### US-201 — Parcourir les calls récents

En tant que founder, je veux voir mes calls récents afin d'ouvrir rapidement le bon débrief.

Critères d'acceptation :

1. Au moins trois calls de démonstration sont visibles au premier lancement.
2. Ils sont classés du plus récent au plus ancien.
3. Chaque ligne contient prospect, entreprise, date, durée et état.
4. La liste reste utilisable avec 100 calls.
5. L'état vide propose de lancer un appel simulé.

#### US-202 — Ouvrir un débrief existant

En tant que founder, je veux sélectionner un call terminé afin de retrouver sa transcription, son suivi et son conseil.

Critères d'acceptation :

1. Toucher ou cliquer une ligne terminée ouvre le bon call.
2. Revenir à l'historique conserve l'ordre et la position raisonnable de la liste.
3. Une référence inconnue affiche un état d'erreur contrôlé et une action de retour.

### Epic E3 — Expérience d'appel simulé

**Valeur :** rendre crédible la promesse que Pinkall est le lieu où le call se déroule, sans implémenter la téléphonie.

#### US-301 — Préparer un call simulé

En tant que founder, je veux voir qui j'appelle et pourquoi afin de comprendre le contexte avant de démarrer.

Critères d'acceptation :

1. Le nom, l'entreprise et le contexte du prospect sont visibles avant le lancement.
2. Une seule action principale démarre la simulation.
3. L'état est clairement identifié comme prêt et simulé.

#### US-302 — Vivre et terminer le call

En tant que founder, je veux voir un appel en cours et pouvoir raccrocher afin de déclencher le débrief.

Critères d'acceptation :

1. Après démarrage, le statut devient « Appel simulé en cours ».
2. Le chronomètre augmente sans revenir en arrière.
3. L'action de fin reste accessible au clavier, à la souris et au tactile.
4. Une double activation ne crée pas de doublon.
5. Quitter l'écran pendant le call demande confirmation.
6. Après confirmation de fin, un état de préparation est montré puis le débrief s'ouvre en moins d'une seconde.

### Epic E4 — Débrief utile immédiatement

**Valeur :** supprimer la reconstruction manuelle de l'appel et préparer la prochaine action.

#### US-401 — Lire qui a dit quoi

En tant que founder, je veux une transcription séparée par interlocuteur afin de relire l'échange sans ambiguïté.

Critères d'acceptation :

1. Tous les segments sont affichés dans le bon ordre.
2. Chaque segment possède un repère temporel.
3. Les labels « Toi » et « Prospect » sont textuels et accessibles.
4. Une personne ne percevant pas les couleurs peut toujours distinguer les interlocuteurs.

#### US-402 — Retrouver les éléments actionnables

En tant que founder, je veux un résumé, les points clés, les engagements et un follow-up afin de ne pas reprendre mes notes manuellement.

Critères d'acceptation :

1. Les quatre types de contenu ont des sections distinctes.
2. Le résumé ne dépasse pas la longueur définie dans la fixture et reste lisible sur mobile.
3. L'absence d'engagement est formulée explicitement.
4. Le follow-up est affiché en entier et peut être sélectionné.
5. Si la copie est implémentée, le presse-papiers reçoit exactement le texte affiché ou édité.

#### US-403 — Savoir quoi tester au prochain call

En tant que founder, je veux une amélioration prioritaire et une question concrète afin de progresser sans analyser un dashboard de scores.

Critères d'acceptation :

1. Une seule amélioration est affichée.
2. Elle sépare l'observation, la recommandation et la question à tester.
3. Elle référence un passage existant par son repère temporel.
4. Aucun score global ni benchmark inventé n'est affiché.
5. Le contenu est identifié comme exemple de démonstration, pas comme conseil généré par un moteur en production.

### Epic E5 — Qualité de démonstration et validation

**Valeur :** disposer d'un POC suffisamment stable et honnête pour produire un apprentissage utilisateur fiable.

#### US-501 — Utiliser le parcours dans des conditions variées

En tant que testeur, je veux vérifier les états alternatifs et tailles d'écran afin de ne pas confondre un défaut du prototype avec un rejet du concept.

Critères d'acceptation :

1. Loading, empty, data et error peuvent être exercés avec des fixtures de test.
2. Aucun overflow n'apparaît aux dimensions définies par NFR-014.
3. Le texte agrandi à 200 % reste utilisable.
4. Le parcours complet est réalisable au clavier sur macOS.
5. VoiceOver/TalkBack annonce le statut du call, les interlocuteurs et les actions principales.

#### US-502 — Rejouer une session de test propre

En tant que chercheur produit, je veux restaurer les données de démonstration afin que chaque entretien commence dans le même état.

Critères d'acceptation :

1. Si la persistance locale est implémentée, une action protégée par confirmation restaure les fixtures initiales.
2. La réinitialisation ne nécessite aucun accès réseau.
3. Le prochain lancement présente le même jeu de données de départ.

## 12. Stratégie de contenu de démonstration

Le POC doit utiliser un scénario compréhensible sans connaissance préalable du produit du prospect.

### Scénario principal recommandé

- Founder : vend un SaaS B2B qui automatise une tâche encore partiellement manuelle.
- Prospect : responsable d'une petite équipe utilisant déjà un outil concurrent.
- Tension : le founder présente trop vite sa solution avant de comprendre ce que l'outil actuel ne résout pas.
- Engagement : le prospect accepte de partager son processus actuel ou de revoir une démonstration.
- Amélioration : approfondir le coût ou la friction du statu quo avant de pitcher.
- Question à tester : « Malgré cet outil, qu'est-ce que votre équipe fait encore manuellement ? »

### Règles de contenu

- La transcription doit comporter assez de tours de parole pour rendre la distinction des locuteurs évidente, sans dépasser environ 5 minutes de lecture.
- Le résumé doit refléter uniquement les informations présentes dans la transcription.
- Le follow-up ne doit pas inventer de promesse, d'engagement ou de date absents de la transcription.
- L'observation de coaching doit être descriptive ; l'interprétation et la recommandation doivent être formulées séparément.
- Aucun nom de client, chiffre de performance ou témoignage réel ne doit être inventé.
- Aucun auteur, livre, université ou playbook ne doit être cité comme source tant que le corpus n'a pas été constitué et vérifié.

## 13. Plan de validation utilisateur

### 13.1 Protocole

Pour chaque participant :

1. Présenter uniquement la phrase « Pinkall, ton coach pour chaque call ».
2. Donner l'application sans expliquer la navigation.
3. Demander de lancer puis terminer un call simulé.
4. Demander : « Qu'est-ce que Pinkall a préparé pour toi ? »
5. Demander de retrouver ce que le prospect a dit sur son outil actuel.
6. Demander quelle amélioration serait appliquée au prochain call.
7. Demander ce qui manque pour utiliser Pinkall sur un vrai call.
8. Relever séparément les problèmes de compréhension, d'utilité, de confiance et d'interface.

### 13.2 Données collectées

- Réussite ou échec de chaque tâche.
- Temps jusqu'au débrief, au follow-up et au conseil.
- Reformulation spontanée de la promesse.
- Partie du débrief consultée en premier.
- Réaction à l'amélioration unique.
- Préférence et attentes entre macOS et téléphone.
- Conditions nécessaires pour partager un vrai appel consenti.

### 13.3 Décisions après test

- **Continuer vers un prototype téléphonie** si la boucle post-call est comprise, désirée et considérée suffisamment différenciante.
- **Réviser la promesse ou l'information architecture** si les utilisateurs comprennent Pinkall comme un simple notetaker ou un CRM.
- **Réviser le débrief** si le follow-up attire toute l'attention mais que l'amélioration n'apporte pas de raison de revenir.
- **Ne pas engager Telnyx/WebRTC** si le parcours simulé ne crée pas une intention d'essai suffisamment forte.

## 14. Risques et mesures de réduction

| Risque | Impact | Réduction |
| --- | --- | --- |
| La simulation donne une impression trompeuse de maturité | Perte de confiance | Marquage « Démo / simulé » persistant et aucun faux état réseau |
| La qualité d'une fixture est confondue avec la qualité future de l'IA | Faux positif ou faux négatif | Expliquer que le contenu est déterministe et tester la structure de valeur, pas la précision algorithmique |
| Le POC devient un prototype Telnyx prématuré | Délai et risque élevés | Maintenir toute téléphonie réelle en Won't Have |
| Les trois plateformes multiplient les variantes UI | Dilution de l'effort | Une base Flutter, un parcours commun, adaptations responsive limitées |
| L'architecture cible produit trop de boilerplate | Ralentissement | Respecter les couches mais appliquer KISS ; ne créer que les contrats utiles au remplacement futur de la source locale |
| Les conseils paraissent génériques | Valeur faible | Une seule amélioration, liée à un passage, avec une question concrète |
| Le follow-up invente des faits | Perte de confiance | Fixture cohérente et test automatisé des engagements repris |
| Les tests utilisateurs valident l'interface mais pas la douleur | Mauvaise décision produit | Interroger le comportement actuel de prise de notes et de suivi avant de montrer le prototype |

## 15. Traçabilité

| Epic | Hypothèses | Exigences principales |
| --- | --- | --- |
| E1 — Fondation cross-platform | H5 | FR-001 à FR-005, NFR-001 à NFR-002, NFR-015 à NFR-018 |
| E2 — Historique | H1, H2 | FR-010 à FR-017 |
| E3 — Appel simulé | H1, H5 | FR-020 à FR-028, NFR-005, NFR-007 |
| E4 — Débrief | H2, H3, H4 | FR-030 à FR-044 |
| E5 — Qualité et validation | Toutes | FR-050 à FR-054, NFR-003 à NFR-014, NFR-019 à NFR-022 |

### Ordre d'implémentation recommandé

1. E1 — Fondation cross-platform et fixtures minimales.
2. E2 — Historique et navigation vers un débrief existant.
3. E4 — Débrief complet sur données préchargées.
4. E3 — Cycle d'appel simulé qui produit ce débrief.
5. E5 — États alternatifs, accessibilité, responsive et protocole de validation.
6. Should Have uniquement si tous les Must Have sont stables.

Cet ordre livre rapidement la sortie à plus forte valeur — le débrief — avant de polir la simulation d'appel.

## 16. Definition of Done du POC

Le POC est terminé lorsque :

- tous les Must Have sont implémentés ;
- les critères d'acceptation des US-101 à US-501 sont vérifiés ;
- le parcours critique fonctionne sur macOS, iOS et Android ;
- le jeu de fixtures principal est cohérent entre transcription, résumé, engagements, follow-up et amélioration ;
- aucune capacité réelle non implémentée n'est suggérée comme existante ;
- les exigences d'architecture NFR-015 à NFR-018 sont respectées ;
- `flutter analyze` et `flutter test` passent ;
- aucun crash, doublon ou mauvais rattachement de débrief n'apparaît sur vingt parcours consécutifs ;
- les écrans critiques ont été recettés aux dimensions et réglages d'accessibilité définis ;
- une build démontrable ou une commande de lancement documentée est disponible pour chaque plateforme ;
- le POC est prêt à être présenté aux premiers founders B2B selon le protocole de validation.

## 17. Décisions reportées après le POC

Les choix suivants ne doivent être pris qu'après validation de l'expérience simulée :

- fournisseur télécom et architecture Telnyx/WebRTC ;
- stratégie d'appels entrants et sortants ;
- enregistrement, consentement et conformité par pays ;
- moteur de transcription et qualité de diarisation ;
- latence acceptable pour le quasi temps réel ;
- construction et gouvernance du corpus de coaching sales/marketing ;
- frontière entre conseil live et conseil post-call ;
- modèle de données CRM et intégrations ;
- authentification, synchronisation, chiffrement et rétention ;
- pricing et packaging par utilisateur, numéro ou volume d'appels.

Ces décisions constituent le prochain niveau de découverte et d'architecture ; elles ne doivent pas bloquer le POC local.
