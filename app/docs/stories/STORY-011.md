# Produire et réconcilier le transcript final batch

**ID :** STORY-011  
**Epic :** Transcription fournisseur-agnostique  
**Priorité :** Must Have  
**Story Points :** 5  
**Statut :** Implémentée — validation de fiabilité à compléter

## User Story

En tant qu'utilisateur ayant raccroché,
je veux retrouver un transcript final fiable et horodaté,
afin que mon débrief ne dépende pas des approximations du streaming live.

## Acceptance Criteria

- [ ] L'enregistrement autorisé de chaque piste crée un job batch idempotent après l'appel.
- [ ] Le domain expose `BatchTranscriptionAdapter` sans type fournisseur ; `VoxtralBatchAdapter` est la première implémentation.
- [ ] Le résultat crée une nouvelle `TranscriptRevision(kind=final)` avec fournisseur, modèle, langue et horodatages.
- [ ] Le réconciliateur relie live et final sans mutation silencieuse et conserve les différences auditables.
- [ ] Le rôle vendeur/prospect vient prioritairement des pistes ; toute ambiguïté reste `unknown`.
- [ ] Si le batch échoue après les retries bornés, le live reste `provisional` et l'interface indique l'échec sans fabriquer de texte.
- [ ] Une reprise du même job ne crée pas de doublon ni deux révisions finales concurrentes.
- [ ] Des appels français réels comparent erreurs live/final, noms propres, timestamps et chevauchements.

## Dependencies

- STORY-010.
- Politique de rétention/suppression et information d'enregistrement/transcription validées.

## Definition of Done

- [ ] Une vraie conversation génère une révision batch finale réconciliée.
- [ ] Échec et retry idempotent sont testés.
- [ ] Le transcript final, pas le live provisoire, est exposé comme source du débrief.
