# STORY-019 — Apprendre des nouvelles objections

**Statut :** implemented_local_adapter_needs_human_review_and_durable_store  
**Priorité :** haute  
**Dépendances :** STORY-011, STORY-012, STORY-013

## User Story

En tant qu’utilisateur Pinkall, je veux que les objections réellement formulées
par mes prospects soient détectées et capitalisées, afin d’améliorer
progressivement le playbook de réponse sans ralentir le coaching live ni
transformer une sortie IA non revue en vérité produit.

## Acceptance Criteria

- [x] Le débrief OpenAI retourne une liste structurée d’objections prospect.
- [x] Chaque objection cite au moins un segment final prononcé par le prospect.
- [x] Chaque entrée contient une catégorie stable, un angle de réponse, une
  réponse candidate et une confiance.
- [x] La réponse candidate ne doit inventer ni capacité, ni preuve, ni prix, ni
  engagement absent du contexte fiable ; une question de clarification est le
  fallback sûr.
- [x] Les formulations équivalentes d’une même catégorie sont fusionnées et le
  compteur d’occurrences est incrémenté.
- [x] Les nouvelles formulations restent distinctes et deviennent des entrées
  `candidate` dans un document JSON local.
- [x] Les emails, numéros, URLs, longs identifiants et références de session sont
  supprimés ou pseudonymisés avant écriture.
- [x] Les écritures concurrentes sont sérialisées et atomiques.
- [x] Une panne du document d’apprentissage ne peut pas invalider un débrief déjà
  généré et persisté.
- [x] Aucune objection ni réponse candidate n’est promue automatiquement dans le
  catalogue live ; une revue humaine et les gates de STORY-013 restent requis.
- [x] La persistance est derrière une interface remplaçable par PostgreSQL ou un
  store documentaire lors du passage multi-instance.

## Livrable local

Le backend crée, lorsque `COACH_CATALOG_DIR` est configuré :

`knowledge/coaching/discovered-objections.local.json`

Ce fichier est ignoré par Git car il peut contenir de courts extraits
expurgés. `discovered-objections.example.json` documente son enveloppe.

## Limites assumées

- Le document local d’une instance Render est éphémère et non partagé entre
  instances. Il prépare le workflow, mais la production SaaS devra brancher
  l’interface sur Supabase/PostgreSQL.
- La déduplication actuelle combine catégorie et similarité lexicale. Des
  embeddings versionnés pourront remplacer cette politique lorsque le corpus
  annoté permettra d’en mesurer les faux regroupements et faux nouveaux.
- Les réponses candidates servent à la revue et à la curation. Elles ne
  contournent pas les sources, droits et validations du catalogue live.
