# Pinkall — Empreinte conversationnelle et accompagnement longitudinal

**Statut :** cible produit et UX ; tranche historique descriptive dans le POC
**Hors scope actuel :** scorecard contextuelle validée et accompagnement causal
**Dépendances minimales :** transcript final fiable, débrief par session, type et objectif du call, feedback et outcome rattachés à la session  
**Décision structurante :** aucun score global, aucune note commerciale, aucun classement

## État du POC — 14 juillet 2026

Une première tranche historique est désormais implémentée dans l'écran
**Progression** et dans `GET /v1/coaching/progress`. Elle compare les 5, 10 ou
20 derniers appels disposant d'un débrief complet aux appels qui les précèdent,
affiche la moyenne des huit axes `performance-v1` sans score global et
recalcule des métriques objectives depuis les transcriptions finales. Les
agrégats ne sont pas persistés séparément et l'absence de fenêtre précédente ou
de transcript exploitable reste explicitement non évaluée.

Cette tranche est un prototype descriptif, pas l'achèvement de la scorecard
cible décrite ci-dessous. Elle porte sur l'unique workspace identifié par le
bearer POC et ne filtre pas encore les appels par type, objectif, ICP, langue ou
playbook comparable. Les bandes cibles contextuelles, niveaux de confiance,
preuves par axe, exercices et relations avec les outcomes restent à valider
avant toute promesse de performance. Le radar actuel ne constitue donc ni un
benchmark, ni une note de vendeur, ni une prédiction de conversion.

## 1. Intention produit

Après chaque appel, Pinkall doit aider l'utilisateur à comprendre :

1. ce qu'il a fait de manière observable ;
2. ce qui était trop présent, adapté ou pas assez présent pour ce type d'appel ;
3. ce qu'il peut travailler en priorité lors des trois prochains appels comparables ;
4. si ce changement produit progressivement un effet utile.

Le radar n'est pas le produit. Il est une visualisation secondaire au service d'un accompagnement fondé sur des preuves. La valeur principale reste : **une amélioration prioritaire, reliée à un passage précis, avec un exercice concret pour le prochain appel**.

Cette initiative prolonge le principe du POC défini par `FR-037` : elle ne doit pas remplacer l'amélioration prioritaire par un tableau de notes.

## 2. Ce que Pinkall ne doit pas faire

- Afficher une moyenne du type « 72/100 » ou un score de vendeur.
- Déduire qu'un appel va convertir à partir d'un ratio de parole.
- Appliquer la même cible à un cold call, une découverte, une démo et une négociation.
- Présenter une corrélation observée comme une causalité.
- Assimiler toute question, affirmation, pause ou interruption à un défaut.
- Noter l'enthousiasme, la confiance, l'émotion, l'accent ou la personnalité à partir de la voix.
- Transformer l'absence de données en zéro.
- Laisser le modèle génératif inventer une métrique ou un seuil à chaque appel.
- Comparer des appels de types différents ou calculés avec des versions différentes de la rubrique.

## 3. Les deux lectures complémentaires

### 3.1 Radar d'équilibre — « trop / adapté / pas assez »

Le radar répond à la demande de visualiser l'intensité de comportements qui peuvent être insuffisants **ou** excessifs. Une valeur plus élevée signifie seulement « davantage », jamais « meilleur ».

Le polygone rose représente l'appel observé. Deux contours lilas délimitent le **repère cible pour ce type d'appel** :

- à l'intérieur de la bande : `pas_assez` ;
- dans la bande : `adapte` ;
- à l'extérieur de la bande : `trop` ;
- preuve ou qualité insuffisante : `non_evalue`.

Les valeurs radiales sont normalisées uniquement pour dessiner des unités différentes sur un même graphique. L'interface n'affiche jamais cette valeur normalisée comme une note. Elle affiche la métrique brute, la cible, le statut, la confiance et les passages justificatifs.

#### Axes proposés

| Axe | Question utilisateur | Signaux bruts | « Pas assez » peut signifier | « Trop » peut signifier | Limites |
|---|---|---|---|---|---|
| **Place occupée** | Est-ce que je laisse assez de place au prospect ? | Part de parole par phase, durée médiane et maximale des tours, plus long monologue vendeur | Le vendeur ne guide pas l'échange ou laisse des silences non fonctionnels | Monologues longs, faible espace de réponse, domination de certaines phases | Le ratio parole/écoute seul ne mesure pas l'écoute |
| **Questions** | Est-ce que je questionne assez, sans mener un interrogatoire ? | Questions par minute, ouvertes/fermées, rafales de questions, questions empilées | Besoin peu exploré, suppositions non vérifiées | Interrogatoire, questions répétitives ou sans rebond | La qualité des relances est évaluée séparément |
| **Affirmations** | Est-ce que j'affirme ou j'explique trop vite ? | Densité d'énoncés déclaratifs, certitudes, conseils non sollicités, affirmation avant vérification | Manque de clarté ou de positionnement | Conversation descendante, conclusions prématurées | Une démo exige naturellement davantage de déclaratif |
| **Pitch produit** | Est-ce que je parle de la solution au bon niveau et au bon moment ? | Part des tours consacrés au produit, caractéristiques citées, moment du premier pitch, liens avec des besoins confirmés | Valeur ou différenciation jamais formulée | Pitch générique, précoce ou déconnecté du besoin | La cible varie fortement selon la motion du call |
| **Pression commerciale** | Est-ce que je fais progresser l'appel sans forcer ? | Demandes de rendez-vous, répétition du CTA, permission, insistance après résistance, langage absolu | Aucune demande ni progression explicite | Insistance, CTA répétés, réponse défensive à une objection | Une objection n'est résolue que si le prospect le manifeste |
| **Rythme de prise de parole** | Est-ce que le dialogue respire ? | Débit articulatoire, pauses après question, alternance, chevauchements et interruptions compétitives | Conversation hachée, lenteur ou latences non fonctionnelles | Débit précipité, coupures ou peu de temps de réflexion | Culture, langue, accent et contexte modèrent tous ces signaux |

L'ordre et le libellé des axes restent stables pour permettre la reconnaissance. Les sous-métriques et les bandes cibles varient selon le contexte.

### 3.2 Profil de maîtrise — « à renforcer / solide »

La qualité d'une conversation ne se réduit pas à des quantités. Les compétences sémantiques apparaissent sous forme de cartes ordonnées, pas dans le même radar :

1. **Accroche et permission** — contexte, raison de l'appel, permission et pertinence.
2. **Découverte et profondeur** — situation, problème, conséquences, résultat souhaité, contraintes, décision et timing.
3. **Écoute et relances** — reformulations, confirmations et questions de suivi reliées à la réponse précédente.
4. **Valeur contextualisée** — lien explicite entre le besoin exprimé et la proposition, sans promesse inventée.
5. **Réceptivité aux objections** — reconnaissance, clarification, réponse pertinente et vérification.
6. **Progression concrète** — prochaine action ou disqualification saine, avec propriétaire, moment et accord mutuel.

Chaque carte utilise l'un des états suivants :

- `non_evalue` ;
- `a_renforcer` ;
- `en_progression` ;
- `solide` ;
- `tres_solide`.

Ces états sont accompagnés d'une rubrique lisible, d'un niveau de confiance et de passages horodatés. Ils ne sont jamais additionnés. Une deuxième visualisation en radar ne sera testée qu'après validation utilisateur ; la liste structurée reste la représentation de référence.

## 4. Comment déterminer ce qui est « bon »

Il n'existe pas de ratio universel crédible. Pinkall doit calibrer en trois couches.

### 4.1 Repères initiaux prudents

Les premières bandes sont volontairement larges et documentées. Chaque règle porte :

- une source ;
- un niveau de preuve ;
- un contexte d'origine ;
- une limite connue ;
- une version ;
- le statut `hypothese`, `repere_recherche`, `repere_vendor` ou `valide_pinkall`.

Un benchmark vendor, par exemple un ratio observé sur des appels enregistrés, reste un point de départ à tester et non une vérité produit.

### 4.2 Profil contextuel

Avant analyse, Pinkall connaît au minimum :

- le type d'appel : `cold_call`, `discovery`, `demo`, `follow_up`, `negotiation`, `closing` ;
- l'objectif déclaré ;
- la langue ;
- l'ICP ou le segment ;
- la phase du call ;
- le playbook éventuellement choisi.

La cible « Questions » d'une découverte peut ainsi être plus élevée que celle d'une démo, tandis que la cible « Pitch produit » suit la logique inverse.

### 4.3 Calibration personnelle et organisationnelle

Après un volume suffisant d'appels comparables :

- Pinkall calcule une baseline robuste par type d'appel, langue et objectif ;
- les changements sont comparés à la médiane et à la dispersion de l'utilisateur, pas à un classement public ;
- les outcomes et feedbacks servent à formuler des hypothèses de personnalisation ;
- aucune causalité n'est affirmée sans expérimentation ;
- l'utilisateur voit si une cible est générale, organisationnelle ou personnelle.

Le volume minimal et la méthode statistique doivent être validés sur données réelles avant d'être figés. Avant ce seuil, l'interface indique « repère initial ».

## 5. Choix de la priorité de coaching

La priorité n'est pas automatiquement l'axe le plus éloigné de sa cible. Le moteur classe les opportunités selon :

1. la solidité des preuves ;
2. l'impact potentiel pour l'objectif du call ;
3. l'actionnabilité au prochain appel ;
4. la répétition sur des appels comparables ;
5. les préférences et feedbacks de l'utilisateur ;
6. l'absence de conseil contradictoire récent.

Le résultat contient :

- une observation factuelle ;
- une interprétation explicitement séparée ;
- un passage principal et, si utile, des passages secondaires ;
- une recommandation ;
- une phrase ou question à tester ;
- un exercice limité aux trois prochains appels comparables ;
- la source ou rubrique utilisée ;
- un moyen de dire « utile », « incorrect », « déjà appliqué » ou « pas pertinent ».

## 6. Pipeline technique cible

```text
Telnyx Media Streaming, pistes séparées
                    │
                    ▼
Voxtral : transcription, locuteurs, timestamps et confiance
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
Métriques déterministes     OpenAI : analyse sémantique structurée
durées, tours, parole,      questions, besoins, pitch, objections,
monologues, alternance      reformulations, next step + segmentIds
          └─────────┬─────────┘
                    ▼
Politique Pinkall versionnée
profil contextuel + bandes + confiance + règles de priorité
                    │
                    ▼
Snapshot immuable par session
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
Débrief + preuves          Feedback + outcome CRM
          │                   │
          └─────────┬─────────┘
                    ▼
Tendances et calibration sur appels comparables
```

**Responsabilités fournisseurs :** Voxtral reste le moteur de transcription. OpenAI réalise l'analyse sémantique et le coaching. L'audio brut n'est pas envoyé à OpenAI ; le modèle reçoit la transcription, le contexte autorisé et des identifiants de segments.

OpenAI renvoie un schéma JSON strict avec catégories, observations, confiance et `evidenceSegmentIds`. Il ne choisit pas librement un score. Le calcul des métriques, l'application des bandes et la sélection finale suivent une politique déterministe, testable et versionnée.

## 7. Modèle de données futur

### `CallAnalysisContext`

- `sessionId`
- `callType`
- `objective`
- `languageCode`
- `icpSegment`
- `playbookId?`
- `targetProfileId`
- `targetProfileVersion`

### `MetricObservation`

- `metricKey`
- `rawValue`
- `unit`
- `phase?`
- `confidence`
- `evidenceSegmentIds`
- `detectorId`
- `detectorVersion`

### `BalanceAxisResult`

- `axisKey`
- `visualIntensity`
- `targetMin`
- `targetMax`
- `status`: `pas_assez | adapte | trop | non_evalue`
- `rawMetrics`
- `confidence`
- `evidenceSegmentIds`
- `explanation`

### `MasteryDimensionResult`

- `dimensionKey`
- `level`: `non_evalue | a_renforcer | en_progression | solide | tres_solide`
- `rubricId`
- `rubricVersion`
- `confidence`
- `evidenceSegmentIds`
- `positiveSignal?`
- `improvementOpportunity?`

### `CallScorecardSnapshot`

- `sessionId`
- `analysisContext`
- `balanceAxes`
- `masteryDimensions`
- `priorityExperiment`
- `algorithmVersion`
- `createdAt`

Le modèle ne comporte volontairement aucun champ `overallScore`.

## 8. Données déjà disponibles et données manquantes

Le socle actuel possède déjà :

- les segments finaux avec locuteur, texte, ordre et timestamps ;
- la session avec contact, début, fin, statut et mode coach ;
- le débrief avec engagements, prochaine action, sources et passages ;
- l'outcome déclaratif ;
- le feedback coach.

Il permet de calculer, après validation des timestamps réels : durée, part de parole, durée des tours, plus long monologue, alternance et complétude de la prochaine étape.

Avant d'afficher la scorecard, il manque notamment :

- `callType`, objectif, langue, ICP et playbook sur la session ;
- une confiance de transcription effectivement renseignée ;
- des annotations persistées pour questions, besoins, objections, reformulations et phases ;
- le lien complet suggestion → session → feedback → outcome ;
- une validation des timestamps inter-pistes sur de vrais appels ;
- un corpus français annoté humainement pour tester les classifications sémantiques.

L'endpoint d'instrumentation `/v1/metrics` ne doit pas alimenter le radar : ses compteurs globaux mesurent l'exposition et l'usage du coach, pas les comportements d'un appel.

## 9. UX post-call

### Desktop

```text
Prospect · type d'appel · objectif · durée · couverture des preuves

┌──────────────────────────────┬──────────────────────────────┐
│ UNE PRIORITÉ                 │ ÉQUILIBRE DE CET APPEL       │
│ Observation                  │ Radar + repère cible         │
│ Recommandation               │ 6 axes, un seul appel        │
│ Question à tester            │ 5/6 axes évalués             │
│ Extrait · 04:18              │ Confiance : moyenne          │
│ [Voir dans la transcription] │ [Voir le détail des axes]    │
└──────────────────────────────┴──────────────────────────────┘

Profil de maîtrise
Accroche · Découverte · Écoute · Valeur · Objections · Progression

Résumé · Engagements · Follow-up · Transcription
```

La priorité apparaît avant le radar dans l'ordre visuel et sémantique. Le radar reste secondaire.

### Mobile

1. Métadonnées du call.
2. « Une priorité pour ton prochain appel ».
3. Passage principal et accès à la transcription.
4. Radar carré secondaire.
5. Liste accessible des axes en accordéon.
6. Profil de maîtrise.
7. Résumé, engagements et follow-up.

Si moins de quatre axes sont évaluables, Pinkall masque le polygone et montre uniquement les dimensions disponibles.

### Détail d'un axe

Toucher ou focaliser un axe ouvre :

- la définition en langage simple ;
- la mesure brute et le repère cible ;
- « pas assez », « adapté », « trop » ou « non évalué » ;
- la confiance et ce qui la limite ;
- un signal positif éventuel ;
- une opportunité d'amélioration ;
- les extraits horodatés ;
- la source ou le playbook associé.

### Direction visuelle

- Contenant carbon Pinkall avec transparence légère.
- Polygone observé rose, ligne pleine et points visibles.
- Bande cible lilas, hachurée et bordée en pointillés.
- Remplissage du polygone limité pour éviter l'illusion d'une « grande surface = bon score ».
- Animation d'entrée courte, sans boucle, désactivée avec la réduction des animations.
- Le liquid glass reste sur le contenant, jamais sur les graduations.

### Accessibilité

- La couleur n'est jamais le seul porteur d'information.
- La liste structurée des axes contient toutes les données essentielles du graphique.
- Le radar possède une description sémantique courte ; la liste est sa description longue canonique.
- Chaque axe est accessible au clavier et au lecteur d'écran.
- Les traits et points significatifs respectent le contraste non textuel.
- Les valeurs exactes ne doivent jamais être lues uniquement depuis la forme du polygone.

## 10. Phases de construction

### Phase 0 — Instrumenter avant de scorer

- Ajouter le contexte du call à la session.
- Persister la confiance, la langue et les annotations sémantiques.
- Relier suggestion, session, feedback et outcome.
- Valider diarisation, pistes et timestamps sur de vrais appels français autorisés.
- Construire un corpus annoté et une grille d'accord humain.

**Sortie :** aucune scorecard visible ; rapport de qualité des données.

### Phase 1 — Empreinte observable en shadow

- Calculer part de parole, tours, monologue, alternance et next step.
- Exécuter les règles sans les montrer aux utilisateurs.
- Comparer les résultats à des annotations humaines.
- Définir les états `non_evalue` et les seuils de confiance.

**Sortie :** snapshots internes versionnés, sans promesse de performance.

### Phase 2 — Radar d'équilibre par appel

- Afficher les axes suffisamment validés.
- Afficher la bande contextuelle et les preuves.
- Conserver une seule priorité au premier plan.
- Recueillir compréhension, utilité et contestation de chaque diagnostic.

**Sortie :** radar individuel, aucune tendance ni benchmark public.

### Phase 3 — Profil de maîtrise et accompagnement

- Ajouter les rubriques sémantiques validées.
- Proposer un exercice pour trois appels comparables.
- Montrer le progrès descriptif et les passages qui l'expliquent.

**Sortie :** accompagnement longitudinal personnel.

### Phase 4 — Personnalisation prudente

- Apprendre des baselines par motion, langue, ICP et objectif.
- Tester les conseils par cohortes et expérimentations progressives.
- Mettre en relation comportements, feedbacks et outcomes avec intervalles d'incertitude.

**Sortie :** repères personnels et organisationnels clairement étiquetés.

### Phase 5 — Équipe, uniquement si les garde-fous sont validés

- Agrégats d'équipe anonymisés et suffisamment volumineux.
- Coaching, pas surveillance ni classement individuel.
- Contrôles d'accès, rétention et consentement explicites.

## 11. Priorisation

### Must

- Aucun score global.
- Contexte du call et version de la rubrique visibles.
- Métriques déterministes séparées de l'analyse OpenAI.
- Statut, métrique brute, cible, confiance et preuves par axe.
- Une seule priorité avant le radar.
- État `non_evalue` robuste.
- Liste accessible équivalente au graphique.
- Calcul idempotent et snapshot immuable par session.

### Should

- Feedback par axe.
- Exercice sur trois appels comparables.
- Comparaison uniquement à contexte et version identiques.
- Explication de l'origine de chaque repère.
- Historique personnel descriptif.

### Could

- Cibles personnalisées après volume suffisant.
- Rubriques propres à un playbook ou une organisation.
- Expérimentation contrôlée d'une recommandation.

### Won't, tant que non validé

- Classement des vendeurs.
- Benchmark « meilleurs vendeurs » présenté comme universel.
- Prédiction de conversion à partir du radar.
- Score d'émotion, d'accent, d'énergie ou de confiance vocale.
- Coaching automatique fondé sur un seul appel peu fiable.

## 12. Critères d'acceptation futurs

1. Aucun écran, API ou modèle ne contient de moyenne ou d'`overallScore`.
2. L'utilisateur voit le type d'appel et l'origine du repère cible.
3. Chaque axe affiché possède au moins une mesure brute, une confiance et une règle versionnée.
4. Chaque diagnostic sémantique renvoie vers au moins un segment existant ou devient `non_evalue`.
5. Une transcription trop courte ou peu fiable n'engendre aucune valeur inventée.
6. La priorité n'est pas choisie uniquement selon l'écart numérique le plus grand.
7. La priorité reste lisible avant le radar sur desktop, mobile et lecteur d'écran.
8. Les données essentielles sont disponibles sans perception des couleurs ni lecture du graphique.
9. Les comparaisons longitudinales filtrent les appels incompatibles.
10. Toute association avec un outcome est présentée comme descriptive tant qu'elle n'a pas été testée causalement.

## 13. Sources de cadrage

Les sources suivantes fondent les taxonomies et garde-fous ; elles ne fournissent pas à elles seules des seuils universels de vente.

- [Huang et al. — Asking questions increases liking, avec un rôle particulier des follow-up questions](https://www.hbs.edu/ris/Publication%20Files/Huang%20et%20al%202017_6945bc5e-3b3e-4c0a-addd-254c9e603c60.pdf)
- [Kluger et al. — méta-analyse de l'écoute au travail](https://link.springer.com/article/10.1007/s10869-023-09897-5)
- [Itzchakov et al. — essai de terrain sur l'écoute, les perceptions et la persuasion](https://doi.org/10.1073/pnas.2421982122)
- [Drollinger et al. — Active Empathetic Listening : percevoir, traiter, répondre](https://doi.org/10.1002/mar.20105)
- [Université du Nouveau-Mexique — MITI, taxonomie comportementale transparente](https://casaa.unm.edu/tools/miti.html)
- [Franke & Park — méta-analyse de l'adaptive selling](https://doi.org/10.1509/jmkr.43.4.693)
- [Yeomans et al. — comportements de conversational receptiveness](https://doi.org/10.1016/j.obhdp.2020.03.011)
- [LREC-COLING 2024 — typologie et difficulté d'annotation des interruptions](https://aclanthology.org/2024.lrec-main.110/)
- [Curhan et al. — silences et réflexion en négociation](https://doi.org/10.1037/apl0000877)
- [Gong — ratios observés sur différents types d'appels, à utiliser comme benchmarks vendor seulement](https://www.gong.io/blog/talk-to-listen-conversion-ratio)
- [Applied Ergonomics — limites de lecture précise des radar charts](https://www.sciencedirect.com/science/article/pii/S0003687023000340)
- [W3C — images complexes et alternatives textuelles](https://www.w3.org/WAI/tutorials/images/complex/)
- [WCAG 2.2 — ne pas dépendre uniquement de la couleur](https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html)

## 14. Décision de roadmap

Le dashboard historique du POC anticipe volontairement une partie des phases 2
et 3 pour tester la compréhension utilisateur. Il ne remplace pas le travail de
validation en shadow ni les critères d'acceptation ci-dessus : les comparaisons
contextuelles, preuves, confiances et repères cibles restent des prérequis à
une scorecard commercialisable. Cette validation n'empêche ni le POC Telnyx ni
le coaching live de progresser séparément.
