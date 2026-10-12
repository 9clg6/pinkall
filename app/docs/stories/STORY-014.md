# Ajouter le switch utilisateur et les modes du coach

**ID :** STORY-014  
**Epic :** Coach optionnel  
**Priorité :** Must Have  
**Story Points :** 5  
**Statut :** Implémentée

## User Story

En tant qu'utilisateur Pinkall,
je veux choisir si le coach intervient et surcharger ce choix pour un appel,
afin de contrôler le traitement, le coût et mon niveau de distraction.

## Acceptance Criteria

- [ ] Le coach est désactivé par défaut au niveau utilisateur/workspace selon la politique d'onboarding.
- [ ] Avant l'appel, l'utilisateur choisit `inherit`, `enabled` ou `disabled`; la valeur effective est visible avant composition.
- [ ] Désactiver pendant un appel arrête les nouveaux traitements et retire toute suggestion active.
- [ ] Le serveur calcule `off|shadow|live`; `off` interdit tout envoi de transcript au moteur et toute minute coachée facturable.
- [ ] `shadow` peut traiter uniquement un appel dont l'utilisateur a autorisé le coach, mais n'envoie aucune suggestion à l'interface et n'est pas facturé comme coaching live.
- [ ] `live` reste derrière un feature flag/rollout et ne contourne jamais une préférence utilisateur désactivée.
- [ ] Le choix se synchronise sur les devices sans changer rétroactivement les appels terminés.
- [ ] Les réglages transcription, enregistrement et coaching restent séparés.

## Dependencies

- STORY-012 et STORY-013.

## Definition of Done

- [ ] Tests prouvent qu'aucun appel au moteur n'a lieu en mode `off`.
- [ ] Overrides et changements multi-device sont déterministes.
- [ ] Les trois modes sont observables sans exposer de contenu sensible.
