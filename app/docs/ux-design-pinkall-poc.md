# Pinkall — UX design du POC Flutter

**Statut :** spécification prête pour implémentation  
**Périmètre :** iOS, Android et macOS  
**Approche :** mobile-first, puis recomposition adaptative sur macOS  
**Niveau d’accessibilité visé :** WCAG 2.1 AA  
**Source architecturale :** `app/ARCHITECTURE.md`

---

## 1. Intention du POC

Pinkall aide un founder B2B à rester présent pendant un call, puis à exploiter la conversation sans reconstruire ses notes de mémoire.

Le POC doit démontrer une boucle de valeur unique :

1. lancer un appel de démonstration ;
2. voir que les deux interlocuteurs sont distingués pendant l’échange ;
3. raccrocher ;
4. récupérer un résumé, les points clés, un follow-up et **une seule amélioration prioritaire** reliée à un passage précis ;
5. utiliser cette amélioration au prochain call.

### Promesse matérialisée dans l’interface

> Appelle sans prendre de notes. En raccrochant, retrouve qui a dit quoi et comment améliorer ton prochain call.

### Hypothèse à valider

Un founder comprend la valeur de Pinkall et souhaite l’utiliser à nouveau si le débrief :

- lui évite la prise de notes pendant l’appel ;
- lui rend le follow-up immédiatement réutilisable ;
- lui propose une amélioration spécifique, compréhensible et vérifiable.

### Ce que le POC simule clairement

Le POC ne passe pas encore un véritable appel téléphonique. Il utilise une conversation locale déterministe et un faux déroulé temporel afin de tester l’expérience complète sans dépendance VoIP, transcription ou IA.

Le libellé **« Appel de démonstration »** reste visible pendant toute la simulation. Aucune donnée réelle n’est enregistrée ni envoyée.

### Hors périmètre

- authentification et onboarding ;
- véritable VoIP, CallKit, APNS, FCM ou Telnyx ;
- accès au microphone ou au carnet d’adresses ;
- coaching vocal en direct ;
- édition collaborative ;
- connexion CRM ;
- génération IA distante ;
- réglages, facturation et gestion d’équipe ;
- recherche, filtres avancés et pagination.

---

## 2. Principes d’expérience

### 2.1 Une action dominante par écran

- Accueil : **Lancer l’appel démo**.
- Appel : **Raccrocher**.
- Débrief : **Copier le follow-up**.

Les autres actions sont secondaires et ne concurrencent jamais cette action principale.

### 2.2 Le call reste au centre

L’interface n’est ni un CRM miniature ni un tableau de bord de scores. Le nom du prospect, l’état de l’appel, la durée et les derniers propos restent la hiérarchie principale.

### 2.3 Le coaching reste humble et vérifiable

Pinkall ne juge pas la personne et ne donne pas une note globale. Il formule une piste de travail :

- une observation factuelle ;
- le passage concerné ;
- une explication courte ;
- une question à tester au prochain call ;
- une source consultable.

### 2.4 Premium minimal

- grandes zones respirantes ;
- carbone pour la structure, blanc chaud pour le fond, rose pour l’action et le signal ;
- pas de tableau de bord dense ;
- pas de faux graphiques ou de métriques décoratives ;
- pas de verre translucide sur les contenus longs ;
- pas de gradient multicolore ;
- une seule matière rose animée, réservée à l’appel actif et au conseil.

### 2.5 La plateforme ne change pas le modèle mental

Les trois mêmes écrans et les mêmes termes sont utilisés sur mobile et macOS. La version macOS augmente la densité utile par recomposition, sans créer un produit différent.

---

## 3. Architecture de l’information et navigation

Le POC comporte exactement trois routes AutoRoute :

```text
CallsHomeRoute (initiale)
  └── SimulatedCallRoute
        └── CallDebriefRoute(callId)
              └── retour vers CallsHomeRoute
```

### Règles de navigation

| Origine | Action | Destination | Comportement |
|---|---|---|---|
| Accueil | Lancer l’appel démo | Appel simulé | `push` avec transition ascendante légère sur mobile, fondu court sur macOS |
| Appel en préparation | Retour | Accueil | immédiat, car aucun appel actif |
| Appel actif | Retour système / fermeture | Appel | ouvre la confirmation « Quitter l’appel de démonstration ? » |
| Appel actif | Raccrocher | Débrief | termine la fixture, remplace la route Appel, affiche le traitement puis le résultat |
| Débrief | Retour | Accueil | `popUntil` vers l’accueil ; le call terminé apparaît en tête de liste |
| Accueil | Ouvrir un appel récent | Débrief | ouvre le débrief correspondant |

### Navigation système

- Le geste retour iOS et le bouton retour Android suivent les règles ci-dessus.
- La fermeture d’une fenêtre macOS avec un appel actif déclenche la même confirmation.
- `Esc` ferme d’abord une modale, puis agit comme Retour lorsque cela ne détruit aucune donnée.
- `Cmd/Ctrl + N` lance l’appel de démonstration depuis l’accueil.
- `Cmd/Ctrl + Shift + M` active ou désactive le micro simulé pendant l’appel.
- Les raccourcis sont des accélérateurs ; aucune fonctionnalité n’en dépend exclusivement.

---

## 4. Parcours principal

```text
[Ouverture de Pinkall]
          │
          ▼
[Accueil — appels récents]
          │  Lancer l’appel démo
          ▼
[Préparation 0,6 s]
          │
          ▼
[Sonnerie simulée 1,2 s]
          │
          ▼
[Appel actif + transcription progressive]
          │  Raccrocher
          ▼
[Traitement du débrief 1,5 s]
          │
          ▼
[Débrief prêt]
   ├── Résumé
   ├── Transcription
   └── Follow-up
          │
          ▼
[Copier le follow-up / retour à l’accueil]
```

### Critère de réussite du parcours

Sans explication externe, un testeur doit pouvoir :

- démarrer la simulation en moins de 10 secondes ;
- comprendre qu’il s’agit d’une démonstration ;
- identifier visuellement qui parle ;
- trouver le conseil et son passage source en moins de 15 secondes après l’appel ;
- copier le follow-up en une action.

---

## 5. Écran 1 — Accueil / Calls

### Objectif

Donner un point d’entrée immédiat vers la démonstration et rendre visible ce que Pinkall conserve après chaque call.

### Hiérarchie de contenu

1. wordmark Pinkall ;
2. phrase d’accueil : « Prêt pour ton prochain call ? » ;
3. bouton primaire « Lancer l’appel démo » ;
4. derniers appels ;
5. libellé discret « Démonstration locale · aucune donnée envoyée ».

### Wireframe mobile — 390 × 844

```text
┌──────────────────────────────────────┐
│ pinkall.                         [?] │
│                                      │
│ Prêt pour ton                        │
│ prochain call ?                      │
│                                      │
│ Lance une conversation simulée.      │
│ Pinkall préparera le débrief.         │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │  ☎  Lancer l’appel démo          │ │
│ └──────────────────────────────────┘ │
│                                      │
│ Appels récents                       │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ Marie Dubois              34:17  │ │
│ │ Aujourd’hui · Débrief prêt       │ │
│ │ Qualification encore manuelle  › │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ Thomas Leroy              21:08  │ │
│ │ Hier · Débrief prêt              │ │
│ │ Relance prévue jeudi           › │ │
│ └──────────────────────────────────┘ │
│                                      │
│ Démonstration locale                 │
│ Aucune donnée envoyée                │
└──────────────────────────────────────┘
```

### Composants

- `PinkallWordmark`
- `PrimaryButton`
- `RecentCallCard`
- `StatusPill`
- `PrivacyNotice`
- `CallsHomeSkeleton`
- `InlineError`

### États

| État | Présentation | Action disponible |
|---|---|---|
| Chargement | deux cartes skeleton, le CTA reste utilisable si la fixture est prête | lancer la démo |
| Avec historique | deux appels fixtures, le dernier en premier | ouvrir un débrief ou lancer la démo |
| Vide | illustration abstraite rose, « Ton premier débrief apparaîtra ici » | lancer la démo |
| Erreur de chargement local | message inline avec icône, détails non techniques | réessayer |
| Survol macOS | surface de carte légèrement plus contrastée, chevron déplacé de 2 px | clic |
| Focus clavier | anneau rose de 3 px, décalage de 3 px | Entrée / Espace |

### Contraintes

- Le bouton primaire est visible sans scroll à 320 × 568.
- Les cartes complètes sont cliquables, avec une cible minimale de 48 dp.
- La ligne d’aperçu est limitée à deux lignes et ne remplace jamais le nom ou la date.
- Aucun bouton « Ajouter un prospect », « Importer » ou « Connecter un CRM » dans le POC.

---

## 6. Écran 2 — Appel simulé

### Objectif

Faire ressentir la présence d’un téléphone Pinkall et prouver la séparation des interlocuteurs sans inciter l’utilisateur à lire au lieu d’écouter.

### Hiérarchie de contenu

1. badge permanent « Appel de démonstration » ;
2. identité du prospect ;
3. statut et durée ;
4. signal audio / waveform ;
5. deux derniers segments de transcription ;
6. contrôles Micro, Raccrocher, Haut-parleur.

### Wireframe mobile — 390 × 844

```text
┌──────────────────────────────────────┐
│ ‹ Retour      Appel de démonstration │
│                                      │
│              ┌──────┐                │
│              │  MD  │                │
│              └──────┘                │
│              Marie Dubois            │
│              Appel en cours          │
│                 02:27                │
│                                      │
│       ▂▅▃▇▄▂▆▃▅▂▇▄▃▆▂               │
│                                      │
│ Transcription en direct              │
│ ┌──────────────────────────────────┐ │
│ │ TOI · 02:11                     │ │
│ │ Qu’est-ce qui vous prend le      │ │
│ │ plus de temps aujourd’hui ?      │ │
│ │                                  │ │
│ │ MARIE · 02:14                   │ │
│ │ On qualifie encore les demandes  │ │
│ │ à la main.                       │ │
│ └──────────────────────────────────┘ │
│                                      │
│   ┌──────┐    ┌──────┐    ┌──────┐  │
│   │ Mic  │    │  ☎   │    │ Son  │  │
│   └──────┘    └──────┘    └──────┘  │
│              Raccrocher              │
└──────────────────────────────────────┘
```

### Machine d’états

```text
preparing → ringing → active → ending → processing → completed
     │          │        │         │
     └──────────┴────────┴─────────┴──→ failed
```

| État | Statut affiché | Comportement |
|---|---|---|
| `preparing` | Préparation de l’appel… | controls désactivés, bouton Retour actif |
| `ringing` | Marie sonne… | waveform douce, vibration/haptique facultative sur mobile |
| `active` | Appel en cours | timer actif, segments ajoutés selon la fixture |
| `activeMuted` | Micro coupé | contrôle Micro rempli rose + icône barrée + annonce lecteur d’écran |
| `ending` | Fin de l’appel… | bouton Raccrocher désactivé, aucune double soumission |
| `failed` | Impossible de lancer la démonstration | actions Réessayer et Retour aux appels |
| confirmation de sortie | Quitter l’appel de démonstration ? | Quitter / Continuer l’appel |

### Comportement de la transcription

- Deux segments maximum sont visibles sur mobile ; le plus ancien disparaît avec un fondu court.
- Le locuteur est identifié par un libellé textuel **TOI** ou **MARIE**, un poids typographique et un marqueur de bord. La couleur seule ne porte jamais l’information.
- Une ligne `Semantics(liveRegion: true)` annonce uniquement le nouveau segment, sans relire tout le panneau.
- Le contenu ne défile pas automatiquement sous le pointeur sur macOS lorsque l’utilisateur explore la transcription.
- Le POC utilise une fixture à vitesse accélérée ; le timer de démonstration peut avancer plus vite que le temps réel, avec un libellé explicite dans l’aide.

### Contrôles

- trois cibles circulaires de 56 dp minimum sur mobile ;
- bouton Raccrocher central de 64 dp ;
- état actif communiqué par icône, libellé et contraste, pas seulement par la couleur ;
- feedback haptique léger sur Micro et Haut-parleur, moyen sur Raccrocher ;
- tooltips sur macOS après 500 ms de survol ;
- labels accessibles : « Couper le micro », « Réactiver le micro », « Terminer l’appel », « Activer le haut-parleur ».

### Motion

- waveform : amplitude lente, 900–1 400 ms, non synchronisée ;
- apparition d’un segment : opacité + translation verticale de 8 px, 180 ms ;
- changement de statut : fondu croisé 160 ms ;
- aucun clignotement supérieur à trois fois par seconde ;
- `prefersReducedMotion` : waveform statique, segments remplacés sans translation, timer inchangé.

---

## 7. Écran 3 — Débrief

### Objectif

Transformer l’appel en actions concrètes, puis permettre au founder de vérifier pourquoi Pinkall formule son conseil.

### Hiérarchie de contenu

1. prospect, date et durée ;
2. sélecteur de vues : Résumé, Transcription, Follow-up ;
3. amélioration prioritaire ;
4. contenu de la vue sélectionnée ;
5. action primaire contextuelle.

La vue initiale est **Résumé**.

### Wireframe mobile — vue Résumé

```text
┌──────────────────────────────────────┐
│ ‹ Appels              Débrief prêt ✓ │
│                                      │
│ Marie Dubois                          │
│ Aujourd’hui · 34:17                  │
│                                      │
│ ┌─────────┬────────────┬───────────┐ │
│ │ Résumé  │ Transcript │ Follow-up │ │
│ └─────────┴────────────┴───────────┘ │
│                                      │
│ À retenir                            │
│ ┌──────────────────────────────────┐ │
│ │ • Qualification encore manuelle │ │
│ │ • Décision avec son associé      │ │
│ │ • Relance prévue jeudi           │ │
│ └──────────────────────────────────┘ │
│                                      │
│ Une amélioration pour le prochain    │
│ call                                 │
│ ┌──────────────────────────────────┐ │
│ │ Creuse l’existant avant de       │ │
│ │ présenter ta solution.           │ │
│ │                                  │ │
│ │ Question à tester                │ │
│ │ « Qu’est-ce qui vous manque      │ │
│ │ encore avec votre outil ? »      │ │
│ │                                  │ │
│ │ 02:14 · Voir le passage          │ │
│ │ Source : écoute active         › │ │
│ └──────────────────────────────────┘ │
│                                      │
│ Prochaine action                     │
│ Envoyer le récap avant jeudi         │
└──────────────────────────────────────┘
```

### Vue Transcription

- liste chronologique complète ;
- chaque segment contient locuteur, timestamp et texte ;
- le segment `02:14` lié au conseil utilise un fond rose clair, une bordure gauche et le libellé « Passage lié au conseil » ;
- toucher « Voir le passage » dans Résumé sélectionne la vue Transcription, scroll jusqu’à `02:14` puis place le focus sémantique sur ce segment ;
- aucun lecteur audio fonctionnel dans le POC ; une timeline statique peut indiquer le contexte sans simuler une capacité inexistante.

### Vue Follow-up

- objet de l’email ;
- corps du follow-up prêt à relire ;
- bouton primaire « Copier le follow-up » ;
- après copie : bouton « Follow-up copié » avec coche pendant deux secondes, puis retour au libellé initial ;
- le texte reste sélectionnable sur macOS ;
- pas de bouton « Envoyer » afin de ne pas suggérer une intégration email inexistante.

### Composition du conseil

Le composant `CoachingRecommendationCard` présente toujours les informations dans cet ordre :

1. **Observation** — ce qui est objectivement présent dans la conversation ;
2. **Piste** — l’interprétation prudente de Pinkall ;
3. **À tester** — une question ou une formulation pour le prochain call ;
4. **Passage** — timestamp et lien vers la transcription ;
5. **Méthode** — nom de la source, sans logo ni affiliation suggérée.

Copy de fixture recommandée :

- Observation : « Tu présentes la solution juste après que Marie mentionne son outil actuel. »
- Piste : « Creuse l’expérience actuelle avant de comparer les solutions. »
- À tester : « Qu’est-ce qui fonctionne bien avec votre outil actuel, et qu’est-ce qui vous manque encore ? »
- Passage : `02:14`.
- Méthode : « Écoute active — Program on Negotiation, Harvard Law School ».

### États

| État | Présentation | Action |
|---|---|---|
| Traitement | étapes textuelles « Séparation des voix », « Synthèse », « Préparation du conseil » avec progression déterministe | aucune action destructive |
| Prêt | contenu complet, onglet Résumé sélectionné | naviguer, copier |
| Erreur | « Le débrief n’a pas pu être préparé » et conservation de l’appel dans l’historique | relancer le traitement |
| Copie réussie | toast accessible et bouton temporairement confirmé | continuer |
| Passage ciblé | segment `02:14` mis en évidence et focusé | revenir au Résumé |
| Texte agrandi 200 % | une colonne, tabs scrollables, aucun contenu tronqué | toutes |

### Limites de langage

- Éviter « verdict », « erreur », « mauvais call », « score » et « conversion garantie ».
- Préférer « observation », « piste », « à tester » et « amélioration prioritaire ».
- Ne jamais présenter la source comme une approbation de Pinkall.

---

## 8. Adaptation macOS

### Fenêtre

- taille minimale recommandée : 960 × 640 px ;
- taille de départ : 1180 × 760 px ;
- largeur maximale du contenu principal : 1 280 px ;
- redimensionnement libre au-dessus du minimum ;
- title bar intégrée visuellement, avec zones de drag qui ne recouvrent aucun contrôle.

### Shell macOS

À partir de 1 024 px, l’accueil et le débrief utilisent une sidebar de 280 px. Elle ne constitue pas une quatrième route : elle expose la liste des appels et garde la navigation existante.

```text
┌──────────────────────────────────────────────────────────────────────────┐
│ ● ● ●   pinkall.                                      Démo locale       │
├───────────────────────┬──────────────────────────────────────────────────┤
│ [＋ Nouvel appel]     │                                                  │
│                       │  Marie Dubois                         34:17       │
│ Appels récents        │  Aujourd’hui · Débrief prêt                      │
│                       │                                                  │
│ ● Marie Dubois        │  [Résumé] [Transcription] [Follow-up]            │
│   Aujourd’hui         │                                                  │
│                       │  ┌──────────────────┐  ┌──────────────────────┐  │
│ ○ Thomas Leroy        │  │ À retenir       │  │ Amélioration        │  │
│   Hier                │  │ • Point clé     │  │ Observation         │  │
│                       │  │ • Engagement    │  │ Piste                │  │
│                       │  │ • Prochaine     │  │ Question à tester    │  │
│                       │  │   action        │  │ 02:14 · Passage      │  │
│                       │  └──────────────────┘  └──────────────────────┘  │
└───────────────────────┴──────────────────────────────────────────────────┘
```

### Recomposition par écran

| Écran | Mobile | macOS |
|---|---|---|
| Accueil | CTA puis liste verticale | sidebar d’appels + zone principale avec CTA et dernier débrief |
| Appel | identité, waveform, transcription, contrôles empilés | panneau appel à gauche (40 %), transcription live à droite (60 %), dock de contrôles centré |
| Débrief | tabs et cartes en une colonne | transcription ou résumé au centre, conseil dans un rail droit de 360 px |

### Interactions desktop

- états hover distincts uniquement pour les dispositifs disposant d’un pointeur ;
- clic droit sur une carte : aucun menu contextuel dans le POC ;
- ordre de tabulation : sidebar, tabs, contenu principal, actions ;
- séparateurs redimensionnables exclus du POC ;
- scrollbars macOS natives, jamais masquées de force ;
- le bouton principal ne s’étire pas sur toute la largeur au-delà de 480 px.

### Largeurs intermédiaires

- `0–599` : une colonne mobile ;
- `600–1023` : une colonne large, cartes en grille lorsque le texte reste lisible ;
- `1024+` : shell macOS à sidebar ;
- si une fenêtre macOS descend sous 1 024 px, la sidebar se transforme en panneau escamotable sans changer de route.

---

## 9. Design system Pinkall

Tous les tokens vivent dans `core_presentation` et alimentent `ThemeData` / `ColorScheme`. Les screens ne contiennent aucune couleur en dur.

### 9.1 Couleurs

| Token sémantique | Valeur de référence | Usage | Contraste vérifié |
|---|---:|---|---:|
| `background` | `#FCF9FB` | fond général blanc chaud | — |
| `surface` | `#FFFFFF` | cartes, panneaux | — |
| `surfaceContainerLow` | `#F7F1F4` | zones secondaires | — |
| `surfaceContainerHigh` | `#EDE3E8` | contrôles sélectionnés neutres | — |
| `onSurface` | `#29252A` | carbone, texte principal | 14.42:1 sur background |
| `onSurfaceVariant` | `#494249` | texte secondaire | 9.30:1 sur background |
| `mutedText` | `#6E646B` | métadonnées de 14 sp minimum | 5.43:1 sur background |
| `outline` | `#DFD4DA` | bordures ; jamais seule pour un état | — |
| `primary` | `#C2185B` | rose, action et focus | 5.87:1 avec blanc |
| `primaryHover` | `#A90F4D` | survol/pressed desktop | > 7:1 avec blanc |
| `primaryContainer` | `#F8DCE7` | passage lié et conseil | 11.77:1 avec carbone |
| `primaryWash` | `#FFF0F6` | halo discret | — |
| `onPrimary` | `#FFFFFF` | texte des boutons roses | 5.87:1 sur primary |
| `error` | `#A90F4D` | erreur avec icône et libellé | > 7:1 avec blanc |

Règles :

- aucun état ne dépend uniquement du rose ;
- le rose plein est réservé au CTA, au focus et à l’appel actif ;
- les grands fonds restent blanc chaud ou carbone ;
- pas de deuxième couleur de marque dans le POC ;
- les contrastes doivent être retestés avec les valeurs Flutter finales.

### 9.2 Typographie

Police de marque : **Onest Variable**, empaquetée localement et référencée via flutter_gen. Les fallbacks natifs sont SF Pro sur Apple et Roboto sur Android.

| Style | Mobile | macOS | Poids | Hauteur de ligne |
|---|---:|---:|---:|---:|
| `displayLarge` | 40 sp | 52 sp | 650 | 1.05 |
| `headlineLarge` | 30 sp | 36 sp | 650 | 1.12 |
| `headlineMedium` | 24 sp | 28 sp | 620 | 1.18 |
| `titleLarge` | 20 sp | 22 sp | 620 | 1.25 |
| `titleMedium` | 16 sp | 17 sp | 600 | 1.30 |
| `bodyLarge` | 17 sp | 17 sp | 450 | 1.50 |
| `bodyMedium` | 15 sp | 15 sp | 450 | 1.50 |
| `labelLarge` | 15 sp | 15 sp | 600 | 1.20 |
| `labelSmall` | 13 sp | 13 sp | 600 | 1.25 |

- aucun texte informatif sous 13 sp ;
- pas de labels en capitales espacées à répétition ;
- nombres de timer avec chiffres tabulaires ;
- largeur de ligne : 45–75 caractères sur macOS.

### 9.3 Espacement et dimensions

Échelle : `4, 8, 12, 16, 24, 32, 48, 64`.

| Token | Valeur |
|---|---:|
| `spaceXs` | 4 |
| `spaceSm` | 8 |
| `spaceMd` | 16 |
| `spaceLg` | 24 |
| `spaceXl` | 32 |
| `space2xl` | 48 |
| `space3xl` | 64 |
| marge écran mobile | 20 |
| marge écran compact 320 px | 16 |
| marge contenu macOS | 32–48 |
| cible tactile minimale | 48 × 48 dp |
| cible pointeur minimale | 32 × 32 px, 40 × 40 recommandé |

Les espacements dans le code utilisent `Gap(token)` conformément à l’architecture ; pas de `SizedBox` décoratif.

### 9.4 Formes, bordures et élévation

| Élément | Rayon | Bordure / élévation |
|---|---:|---|
| bouton principal | 12 | aucune ; fond rose |
| bouton circulaire d’appel | cercle | ombre courte 8 % seulement |
| carte | 16 | bordure 1 px `outline` |
| panneau conseil | 20 | bordure rose 1 px + halo rose très faible |
| tabs | 10 | surface neutre, indicateur plein |
| modale | 20 | scrim carbone 36 % |

Les ombres ne servent pas à empiler chaque carte. Une bordure et un changement de surface suffisent dans la majorité des cas.

### 9.5 Motion tokens

| Token | Valeur | Usage |
|---|---:|---|
| `durationFast` | 120 ms | hover, pressed, focus |
| `durationStandard` | 180 ms | changement de tab, segment transcript |
| `durationEmphasis` | 280 ms | ouverture de débrief, modale |
| `easeOut` | `cubic-bezier(0.23, 1, 0.32, 1)` | entrées |
| `easeInOut` | `cubic-bezier(0.77, 0, 0.175, 1)` | waveform / matière |

- animer uniquement `opacity` et `transform` quand possible ;
- aucune transition globale `all` ;
- pas de scale depuis zéro ;
- les animations récurrentes s’arrêtent lorsque l’app n’est plus au premier plan ;
- toutes les animations non essentielles respectent la réduction des mouvements.

---

## 10. Accessibilité

### 10.1 Perceptible

- contraste texte normal ≥ 4.5:1, grands textes et composants ≥ 3:1 ;
- locuteurs identifiés par texte et structure, jamais par couleur seule ;
- statut d’appel accompagné d’un libellé ;
- mise à l’échelle du texte jusqu’à 200 % sans troncature ni scroll horizontal à 320 px ;
- timestamps et durées annoncés sous une forme lisible, par exemple « 2 minutes 14 secondes » ;
- waveform marquée décorative pour les technologies d’assistance.

### 10.2 Opérable

- ordre de focus logique et stable ;
- toutes les actions activables au clavier sur macOS ;
- aucune action primaire uniquement au survol ou au geste ;
- modale de sortie avec focus initial sur « Continuer l’appel », focus piégé et retour au déclencheur ;
- zones tactiles de 48 dp minimum ;
- pas de limite de temps imposée à l’utilisateur ;
- confirmation avant toute sortie d’un appel actif.

### 10.3 Compréhensible

- labels explicites ; éviter les icônes seules hors contrôles standards d’appel ;
- les erreurs indiquent ce qui s’est passé et comment continuer ;
- le traitement du débrief explique les étapes sans promettre une durée réseau ;
- la distinction Démonstration / produit réel est persistante ;
- le conseil sépare explicitement observation et interprétation.

### 10.4 Robuste

- `Semantics` nommé sur boutons, tabs, cartes cliquables et statuts ;
- `MergeSemantics` pour une carte appel ;
- `ExcludeSemantics` pour les icônes doublant un libellé ;
- annonces live courtes et non intrusives ;
- états sélectionnés et activés exposés (`selected`, `toggled`, `button`) ;
- tests TalkBack Android, VoiceOver iOS/macOS et navigation clavier macOS.

### 10.5 Checklist d’acceptation

- [ ] Aucun débordement à 320 × 568 avec texte à 200 %.
- [ ] Le CTA de l’accueil est atteignable en moins de trois tabulations sur macOS.
- [ ] VoiceOver annonce « Appel de démonstration, Marie Dubois, appel en cours, 2 minutes 27 secondes ».
- [ ] Le bouton Micro annonce son nouvel état après activation.
- [ ] Le nouveau segment transcript est annoncé une seule fois.
- [ ] « Voir le passage » déplace le focus vers le segment correspondant.
- [ ] Le toast de copie est annoncé sans voler durablement le focus.
- [ ] Le parcours entier reste utilisable avec réduction des mouvements.

---

## 11. Localisation obligatoire

Le POC est livré en français, mais aucune string affichée ne doit être écrite en dur dans les screens, widgets ou view models. Tous les textes UI, aides, labels sémantiques, dialogues, toasts et contenus de fixture affichés passent par EasyLocalization et `LocaleKeys.xxx.tr()`.

### Structure recommandée

```json
{
  "common": {
    "action": {},
    "status": {},
    "accessibility": {},
    "error": {}
  },
  "callsHome": {},
  "simulatedCall": {},
  "callDebrief": {},
  "demoFixture": {}
}
```

### Inventaire minimal des clés

| Domaine | Exemples de clés |
|---|---|
| `common` | `common_action_retry`, `common_action_back`, `common_status_ready`, `common_error_generic` |
| `callsHome` | `calls_home_title`, `calls_home_subtitle`, `calls_home_start_demo`, `calls_home_recent_title`, `calls_home_empty_title`, `calls_home_privacy_notice` |
| `simulatedCall` | `simulated_call_demo_badge`, `simulated_call_preparing`, `simulated_call_ringing`, `simulated_call_active`, `simulated_call_end`, `simulated_call_exit_dialog_title`, `simulated_call_exit_dialog_continue` |
| `callDebrief` | `call_debrief_ready`, `call_debrief_tab_summary`, `call_debrief_tab_transcript`, `call_debrief_tab_follow_up`, `call_debrief_key_points`, `call_debrief_recommendation_title`, `call_debrief_copy_follow_up`, `call_debrief_copy_success` |
| `demoFixture` | nom affiché, segments de transcript, points clés, observation, piste, question à tester, follow-up et source |
| `accessibility` | labels complets des contrôles, durée parlée, nouveau segment, état selected/toggled |

### Données dynamiques

- noms, numéros et identifiants sont des données, pas des labels UI ;
- dates et heures utilisent le locale courant (`DateFormat`) ;
- pluriels passent par `.plural()` ;
- les interpolations passent par `tr(args:)` ou `namedArgs` ;
- aucun assemblage de phrase par concaténation ;
- le fichier `fr.json` est la source de la fixture française du POC afin de respecter la règle zéro string en dur.

Après chaque changement :

```bash
dart run easy_localization:generate \
  -S assets/translations \
  -f keys \
  -O lib/generated \
  -o locale_keys.g.dart
```

---

## 12. Handoff conforme à `ARCHITECTURE.md`

### Triade de présentation obligatoire

```text
apps/app_mobile/lib/features/calls/presentation/screens/
├── calls_home/
│   ├── calls_home.state.dart
│   ├── calls_home.view_model.dart
│   ├── calls_home.screen.dart
│   └── widgets/
├── simulated_call/
│   ├── simulated_call.state.dart
│   ├── simulated_call.view_model.dart
│   ├── simulated_call.screen.dart
│   └── widgets/
└── call_debrief/
    ├── call_debrief.state.dart
    ├── call_debrief.view_model.dart
    ├── call_debrief.screen.dart
    └── widgets/
```

Chaque screen :

- est `@RoutePage()` ;
- étend `ConsumerStatefulWidget` ;
- observe son ViewModel Riverpod ;
- rend l’état sans logique métier ;
- utilise `LocaleKeys` et `Theme.of(context).colorScheme` ;
- utilise `Gap` pour l’espacement ;
- ne contient aucun import relatif.

### Objets métier suggérés

- `CallEntity`
- `CallParticipantEntity`
- `TranscriptSegmentEntity`
- `CallDebriefEntity`
- `CoachingRecommendationEntity`
- `FollowUpDraftEntity`

### États de présentation suggérés

- `CallsHomeState` : appels récents, chargement, erreur ;
- `SimulatedCallState` : phase, durée, états micro/son, segments visibles, erreur ;
- `CallDebriefState` : phase de traitement, tab sélectionné, débrief, passage ciblé, état de copie.

### Couche data du POC

Une datasource locale fournit une fixture déterministe. Elle implémente le contrat du domaine ; le ViewModel ne connaît ni JSON, ni timer de simulation, ni fixture.

Le déroulé temporel et la création du débrief sont orchestrés par des use cases/services testables, jamais dans le screen.

### Widgets partagés

À placer dans `core_presentation` ou `features/shared` seulement lorsqu’ils sont réellement utilisés par plusieurs écrans :

- `PinkallPrimaryButton`
- `PinkallStatusPill`
- `SpeakerTranscriptSegment`
- `CallDurationLabel`
- `CoachingRecommendationCard`
- `PinkallSegmentedControl`
- `PinkallInlineError`

Les widgets propres à un seul écran restent dans son dossier `widgets/`.

### Routage

```text
CallsHomeRoute       initiale
SimulatedCallRoute   sans argument réseau
CallDebriefRoute     callId obligatoire
```

La génération AutoRoute reste la seule source des classes de route.

---

## 13. Critères d’acceptation UX du POC

### Accueil

- [ ] Le nom Pinkall, la proposition et le CTA sont visibles sans scroll sur un petit mobile.
- [ ] Le CTA lance la simulation en une action.
- [ ] L’app indique explicitement que la démonstration est locale et simulée.
- [ ] Un appel récent ouvre son débrief.

### Appel

- [ ] Les états Préparation, Sonnerie, Actif et Fin sont perceptibles et annoncés.
- [ ] Les propos du founder et du prospect sont distinguables sans dépendre de la couleur.
- [ ] Le micro et le haut-parleur simulés changent d’état de façon visible et accessible.
- [ ] Raccrocher ne peut être déclenché qu’une fois.
- [ ] Quitter un appel actif demande confirmation.

### Débrief

- [ ] Le résumé contient les points clés, engagements et prochaine action.
- [ ] Une seule amélioration prioritaire est mise en avant.
- [ ] Le conseil distingue Observation, Piste et À tester.
- [ ] Le passage source est accessible en une action.
- [ ] Le follow-up se copie en une action avec confirmation accessible.
- [ ] Aucune fonctionnalité non implémentée n’est présentée comme disponible.

### Responsive et plateforme

- [ ] iOS et Android utilisent la même hiérarchie mobile-first.
- [ ] À 1 024 px, le contenu se recompose sans créer de route supplémentaire.
- [ ] La fenêtre macOS reste utilisable à 960 × 640.
- [ ] Aucun overflow à 320 px ou avec un zoom texte de 200 %.
- [ ] Souris, trackpad, clavier, VoiceOver et gestes mobiles sont pris en charge.

### Architecture et localisation

- [ ] Les trois écrans respectent la triade State / ViewModel / Screen.
- [ ] Toutes les données sont immutables.
- [ ] Tous les textes visibles et sémantiques passent par `LocaleKeys`.
- [ ] Tous les espacements utilisent `Gap` et les couleurs le thème.
- [ ] Les routes sont déclarées avec AutoRoute.

---

## 14. Ordre d’implémentation recommandé

1. tokens, thème Pinkall et composants de base ;
2. traductions françaises et génération des `LocaleKeys` ;
3. entités + fixture locale + repository ;
4. accueil et historique local ;
5. machine d’états de l’appel simulé ;
6. débrief et lien vers le passage ;
7. adaptation macOS ;
8. accessibilité, réduction des mouvements et tests golden ;
9. tests du parcours complet sur iOS, Android et macOS.

Le POC est terminé lorsque le parcours principal fonctionne hors ligne, de manière déterministe et accessible sur les trois plateformes, sans laisser croire qu’un véritable appel ou une analyse distante a eu lieu.
