# Composer un appel depuis un lien Pinkall

**ID :** STORY-018  
**Epic :** Accès rapide à l'appel  
**Priorité :** Should Have  
**Story Points :** 3  
**Statut :** Implémenté, validation de signature requise

## User Story

En tant qu'utilisateur,
je veux ouvrir Pinkall depuis un lien contenant un numéro,
afin d'arriver directement sur le composeur prérempli sans lancer l'appel à mon insu.

## Acceptance Criteria

- [x] `pinkall://call?number=...` ouvre le composeur sur iOS, Android et macOS.
- [x] `https://www.pinkall.app/call?number=...` utilise le même contrat applicatif sur iOS et Android.
- [x] Les liens reçus au démarrage et pendant l'exécution sont pris en charge.
- [x] Les numéros français `06` et `07` sont normalisés en E.164 ; les entrées invalides sont ignorées.
- [x] Le numéro du lien remplace la sélection initiale éventuelle, mais aucun appel ne démarre automatiquement.
- [x] Un lien ne remplace jamais l'écran d'un appel actif et ne contourne pas le briefing projet obligatoire.
- [x] Un lien reçu pendant un appel ou une édition est rejoué dès que la navigation redevient sûre.
- [x] Un même lien peut être appliqué plusieurs fois après une modification manuelle du champ.
- [x] Android distingue les liens Pinkall des intents d'import d'enregistrements audio.
- [x] Les imports de fichiers audio existants restent fonctionnels.
- [x] Le site publie les associations Apple et Android sans redirection de la route `/call` vers une page inexistante.
- [ ] Les Universal Links Apple sont validés avec les profils de distribution définitifs ; macOS conserve le schéma personnalisé tant que l'app est signée ad hoc.
- [ ] L'App Link Android est validé avec l'empreinte de la clé de production définitive.

## Dependencies

- STORY-007 et configuration des domaines `pinkall.app`.

## Definition of Done

- [x] Parsing, navigation à froid et à chaud, préremplissage et manifest Android sont couverts par des tests.
- [x] Les builds iOS et macOS compilent avec le pont `app_links`.
- [ ] Un lien HTTPS est vérifié sur chaque plateforme depuis une version signée et installée.
