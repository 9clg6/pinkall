# Évaluer le coach en shadow mode

**ID :** STORY-015  
**Epic :** Coach optionnel  
**Priorité :** Must Have  
**Story Points :** 8  
**Statut :** Harness implémenté — dataset annoté requis

## User Story

En tant qu'équipe Pinkall,
je veux exécuter le coach sans afficher ses conseils,
afin de mesurer précision, fidélité aux sources, latence et coût avant de distraire un utilisateur.

## Acceptance Criteria

- [ ] Les segments finaux récents déclenchent uniquement les situations commerciales configurées.
- [ ] Le retriever retourne des cartes applicables au contexte de l'appel et conserve leurs identifiants/version.
- [ ] Le modèle produit un schéma strict : observation, suggestion courte, justification, sources, confiance et expiration.
- [ ] Le `PrecisionGate` rejette les candidats non sourcés, ambigus, tardifs, répétitifs ou non actionnables.
- [ ] Aucun candidat shadow n'est diffusé à Flutter ni présenté comme ayant influencé l'appel.
- [ ] Replay et appels autorisés comparent les candidats aux annotations humaines sans fuite entre corpus et jeu d'évaluation.
- [ ] Le rapport mesure au minimum taux de déclenchement, précision humaine, faux positifs, fidélité aux sources, latence p50/p95 et coût par minute.
- [ ] Les seuils de passage au live sont approuvés et versionnés ; leur échec maintient le système en shadow.

## Dependencies

- STORY-010, STORY-013 et STORY-014.
- Vrais appels autorisés ou enregistrements licenciés/consentis pour l'évaluation.

## Definition of Done

- [ ] Rapport shadow reproductible avec échantillon et limites documentés.
- [ ] Aucun conseil n'a été exposé durant l'évaluation.
- [ ] La décision go/no-go live est explicite.
