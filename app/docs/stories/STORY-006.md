# Valider le POC multi-plateforme

**ID:** STORY-006  
**Epic:** Quality  
**Priority:** Must Have  
**Story Points:** 3

## User Story

As a product team, I want automated checks and native builds so that the POC is a reliable base for the next iteration.

## Acceptance Criteria

- [x] La génération Freezed, Riverpod, AutoRoute et LocaleKeys réussit.
- [x] `dart analyze` ne retourne aucune erreur.
- [x] Les tests critiques du domain, de la data et des widgets passent.
- [x] Un build macOS réussit et l’app est lancée localement.
- [x] Les runners iOS et Android sont présents et reconnus par Flutter.
