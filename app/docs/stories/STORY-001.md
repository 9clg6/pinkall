# Initialiser le monorepo Flutter

**ID:** STORY-001  
**Epic:** Fondation  
**Priority:** Must Have  
**Story Points:** 3

## User Story

As a product team, I want one Flutter codebase with iOS, Android and macOS runners so that the POC can validate the same experience on phone and desktop.

## Acceptance Criteria

- [x] `apps/app_mobile` contient les runners iOS, Android et macOS.
- [x] Les quatre packages imposés par `ARCHITECTURE.md` existent dans `packages/`.
- [x] Les dépendances respectent le graphe foundation → domain → data/presentation → app.
- [x] AutoRoute, Riverpod, EasyLocalization et le thème partagé sont initialisés.
- [x] Aucune string utilisateur ni couleur métier n’est codée en dur dans les screens.
