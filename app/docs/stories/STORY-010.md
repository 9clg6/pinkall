# Transcrire en direct via Telnyx Media Streaming et un adaptateur remplaçable

**ID :** STORY-010  
**Epic :** Transcription fournisseur-agnostique  
**Priorité :** Must Have  
**Story Points :** 8  
**Statut :** Implémentée — mesures réelles à compléter

## User Story

En tant qu'utilisateur en appel,
je veux voir une transcription live réellement produite à partir des deux pistes,
afin de suivre qui dit quoi sans prendre de notes.

## Acceptance Criteria

- [ ] Un appel Telnyx réel démarre et arrête Media Streaming côté serveur avec `both_tracks` et une corrélation prouvée au `CallIntent`.
- [ ] L'`AudioGateway` valide session/workspace, séquence les frames, borne son buffer et normalise le codec attendu par l'adaptateur.
- [ ] Le domain expose `StreamingTranscriptionAdapter` sans type Mistral/Voxtral ; une suite de conformité teste toute implémentation.
- [ ] `DeepgramFluxRealtimeAdapter` ouvre une session mono par piste, émet les états de tour sans type fournisseur dans le domain et conserve `VoxtralRealtimeAdapter` comme fallback.
- [ ] Le mapping piste → vendeur/prospect est prouvé sur de vrais appels ; sinon le rôle est `unknown`.
- [ ] Seuls les segments réels et autorisés sont diffusés aux devices du workspace par un canal authentifié.
- [ ] Une panne, latence excessive ou quota STT désactive proprement transcription et coach sans interrompre l'audio de l'appel.
- [ ] Le ledger conserve fournisseur, modèle, durée, latence et coût sans contenu de conversation.
- [ ] Des appels français réels mesurent p50/p95, noms propres, bruit, chevauchements et erreurs fournisseur.

## Technical Notes

- Modèle live principal : `flux-general-multi` avec `language_hint=fr` sur l'endpoint européen.
- La piste Telnyx reste l'unique source du rôle, indépendamment du fournisseur.
- Aucune clé Deepgram/Mistral dans Flutter. Aucun média brut dans logs/analytics.

## Dependencies

- STORY-008 et STORY-009.
- Vraies clés Telnyx/Mistral, endpoint WSS public sécurisé et destinations de test contrôlées.
- Gate de topologie Voice API/Media Streaming validé.

## Definition of Done

- [ ] `both_tracks` et les segments Voxtral sont prouvés sur appel réel.
- [ ] L'appel reste utilisable lorsque STT tombe.
- [ ] Tests de conformité et mesures de latence/coût sont archivés.
- [ ] Aucun transcript simulé n'est branché au runtime.
