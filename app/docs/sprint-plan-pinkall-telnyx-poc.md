# Sprint 2 — POC d’appel réel Telnyx

**Projet :** Pinkall  
**Statut :** En cours  
**Période :** à partir du 2026-07-11  
**Capacité planifiée :** 8 points

## Objectif

Remplacer le vertical slice simulé par un parcours d’appel sortant Telnyx réellement connecté, avec audio bidirectionnel et commandes d’appel sur iOS, Android et macOS.

## Story engagée

| Story | Intitulé | Points | Priorité | Statut |
|---|---|---:|---|---|
| STORY-007 | Passer un appel sortant réel avec Telnyx WebRTC | 8 | Must Have | En cours |

## Ordre de réalisation

1. Vérifier la compatibilité du package et résoudre les dépendances sur les trois plateformes.
2. Construire les abstractions domain et l’adaptateur data Telnyx.
3. Brancher l’authentification runtime sans persistance.
4. Brancher connexion, appel sortant, événements, audio et contrôles.
5. Ajouter permissions et configurations natives sans secret.
6. Supprimer le chemin runtime simulé et rendre honnête l’état post-appel.
7. Exécuter les tests automatisés puis les tests d’appels réels.

## Gates

- Aucun identifiant ou API key dans le dépôt.
- Aucun provider runtime de simulation.
- Appel réel et audio bidirectionnel prouvés sur iOS et Android.
- Appel réel macOS obligatoire pour déclarer STORY-007 terminée ; incompatibilité `telnyx_webrtc` = statut bloqué, pas fallback simulé.
- Aucun transcript affiché tant que Telnyx Media Streaming et un adaptateur STT réel ne l'alimentent pas.
- STORY-007 reste `in_progress` jusqu'aux appels physiques avec vraies clés ; les builds seuls ne ferment pas la story.

## Backlog ordonné après le gate STORY-007

| Ordre | Story | Points | Incrément | Statut |
|---:|---|---:|---|---|
| 1 | STORY-008 — Backend SaaS et JWT Telnyx courts | 8 | 3 | Planifiée |
| 2 | STORY-009 — CRM et gate d'éligibilité | 8 | 3 | Planifiée |
| 3 | STORY-010 — Media Streaming + Voxtral live | 8 | 4 | Planifiée |
| 4 | STORY-011 — Transcript final batch | 5 | 4 | Planifiée |
| 5 | STORY-012 — Débrief et rattachement CRM | 8 | 4 | Planifiée |
| 6 | STORY-013 — Cartes de coaching sourcées | 8 | 5 | Planifiée |
| 7 | STORY-014 — Switch et modes `off|shadow|live` | 5 | 5 | Planifiée |
| 8 | STORY-015 — Évaluation shadow | 8 | 5 | Planifiée |
| 9 | STORY-016 — Coaching live haute précision | 8 | 6 | Planifiée |
| 10 | STORY-017 — Mesure exposition/action/résultat | 5 | 6 | Planifiée |

## Dépendances séquentielles

```text
007 vrai appel
  → 008 backend/JWT/corrélation
    → 009 CRM/éligibilité
      → 010 Media Streaming/Voxtral live
        → 011 transcript batch
          → 012 débrief/CRM

010 + 013 corpus + 014 switch
  → 015 shadow
    → 016 live
      → 017 mesure complète
```

Les appels entrants en arrière-plan, FCM/APNS, PushKit et CallKit restent hors de cette séquence et feront l'objet d'un sprint distinct après validation de la chaîne sortante.
