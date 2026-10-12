# Exposer un coaching live à haute précision

**ID :** STORY-016  
**Epic :** Coach optionnel  
**Priorité :** Should Have  
**Story Points :** 8  
**Statut :** Alpha interne — décision shadow requise avant rollout

## User Story

En tant qu'utilisateur ayant activé le coach,
je veux recevoir une seule suggestion utile au bon moment,
afin d'améliorer la conversation sans lire un rapport générique pendant l'appel.

## Acceptance Criteria

- [ ] Seuls les candidats acceptés par la version approuvée du `PrecisionGate` sont diffusés en mode effectif `live`.
- [ ] L'interface affiche au maximum une carte active, courte, lisible, sourcée et dotée d'une expiration.
- [ ] Une carte expirée, remplacée ou liée à un ancien appel ne peut pas réapparaître.
- [ ] L'utilisateur peut ignorer, masquer ou désactiver immédiatement le coach sans affecter l'appel ni la transcription.
- [ ] La suggestion distingue observation et interprétation et n'affirme pas connaître l'intention du prospect.
- [ ] Une latence hors fenêtre, une source indisponible ou une faible confiance produit aucune suggestion.
- [ ] Le fonctionnement est validé sur device actif mobile et macOS ; les autres devices peuvent suivre l'appel sans exposer deux conseils concurrents.
- [ ] Le rollout est progressif et révocable indépendamment du STT et de la téléphonie.

## Dependencies

- STORY-015 avec décision go live approuvée.

## Definition of Done

- [ ] Tests réels démontrent une carte unique, expiration, désactivation immédiate et absence de candidats rejetés.
- [ ] Rollback/feature flag testés.
- [ ] Coût et latence observés restent dans les seuils du rollout.
