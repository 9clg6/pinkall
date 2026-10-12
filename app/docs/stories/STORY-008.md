# Construire le backend SaaS et émettre des JWT Telnyx courts

**ID :** STORY-008  
**Epic :** Fondation SaaS et orchestration d'appel  
**Priorité :** Must Have  
**Story Points :** 8  
**Statut :** Fondation bêta implémentée — store métier mono-workspace

## User Story

En tant qu'utilisateur Pinkall,
je veux me connecter à mon workspace sans saisir de secret Telnyx,
afin de passer un appel réel avec une configuration provisionnée et sécurisée par Pinkall.

## Acceptance Criteria

- [ ] Un utilisateur authentifié appartient à un workspace et seuls ses devices autorisés peuvent demander un token d'appel.
- [ ] Le backend émet un JWT Telnyx court ; aucune API key Telnyx ni credential SIP n'est envoyé à Flutter.
- [ ] Avant composition, le backend crée un `CallIntent` Pinkall idempotent avec utilisateur, device et destination expurgée.
- [ ] Un appel réel corrèle ce `CallIntent` avec les identifiants Telnyx disponibles, dont `call_session_id`/`call_control_id` lorsque la topologie les expose.
- [ ] Les webhooks Telnyx vérifient signature et timestamp, rejettent les replays et dédupliquent les événements.
- [ ] L'application peut obtenir son token, atteindre `ready` et passer un appel réel sans saisir de JWT/SIP manuellement.
- [ ] Les secrets vivent dans le gestionnaire serveur, sont rotatifs et absents des logs, réponses API, crash reports et dépôt.
- [ ] Les tests automatisés et une preuve d'appel réel couvrent expiration, rejeu, mauvais workspace et token révoqué.

## Technical Notes

- Conserver `telnyx_webrtc` derrière `core_data`; l'auth Pinkall et la remise de token sont des dépendances serveur.
- Ne pas choisir silencieusement une topologie Media Streaming. Cette story établit la corrélation réelle utilisée par STORY-010.
- Les destinations de test restent contrôlées/allowlistées jusqu'à STORY-009.

## Dependencies

- STORY-007.
- Compte Telnyx réel, clés serveur, Credential Connection et appareils physiques.

## Definition of Done

- [ ] Appel réel via JWT court serveur documenté par identifiants corrélés expurgés.
- [ ] Tests sécurité/idempotence passent.
- [ ] Aucun secret Telnyx ne doit être saisi dans l'application.
- [ ] Architecture et sprint status mis à jour.
