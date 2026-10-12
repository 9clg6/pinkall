# STORY-020 — Gérer sa bibliothèque d’objections

**Statut :** implemented_local_single_instance  
**Priorité :** haute  
**Dépendances :** STORY-013, STORY-016, STORY-019

## User Story

En tant que vendeur, je veux consulter les objections entendues et définir ma
propre réponse avec du texte ou un document afin que le coach réutilise mon
playbook pendant les appels suivants.

## Acceptance Criteria

- [x] L’utilisateur authentifié peut lister les objections détectées et custom.
- [x] Chaque entrée affiche sa catégorie, son origine, son statut, son nombre
  d’occurrences et sa réponse personnalisée éventuelle.
- [x] Une objection custom accepte une réponse saisie ou un document UTF-8
  `.md`, `.markdown` ou `.txt` de 32 KiB maximum.
- [x] Une objection custom équivalente à une candidate existante enrichit cette
  entrée au lieu de créer un doublon.
- [x] La sauvegarde explicite marque la réponse user-authored `live` sans
  promouvoir la réponse OpenAI candidate détectée automatiquement.
- [x] Le coach ne reçoit que les réponses custom présentant un recouvrement
  lexical avec le dernier tour et OpenAI reste limité à la sélection d’un ID.
- [x] Le texte affiché en live vient du document serveur, pas d’une génération
  libre du modèle.
- [x] Les contenus custom sont signalés comme données utilisateur non fiables
  dans le prompt de sélection.
- [x] Les routes restent authentifiées et les entrées ne sont jamais écrites
  dans les logs applicatifs.
- [x] L’interface est disponible sur macOS, iOS et Android depuis l’accueil.

## Contrat livré

- `GET /v1/coaching/objections`
- `POST /v1/coaching/objections`
- Écran Flutter `/objections`
- Persistance locale `discovered-objections.local.json`

## Limite connue

Le fichier local est commun à l’unique workspace snapshot de l’instance et est
éphémère sur Render. Avant une bêta multi-workspace ou multi-instance, le même
contrat devra être implémenté dans PostgreSQL/Supabase avec `workspace_id`, RLS,
quotas et suppression privacy.
