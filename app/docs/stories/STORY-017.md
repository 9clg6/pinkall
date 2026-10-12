# Mesurer exposition, action et résultat du coaching

**ID :** STORY-017  
**Epic :** Mesure de performance commerciale  
**Priorité :** Should Have  
**Story Points :** 5  
**Statut :** En cours

## User Story

En tant qu'utilisateur et équipe produit,
je veux distinguer conseil généré, réellement vu, appliqué et résultat obtenu,
afin d'améliorer le coach sans attribuer au modèle des effets qu'il n'a pas causés.

## Acceptance Criteria

- [ ] Les événements `generated`, `eligible|rejected`, `exposed`, `action_reported` et `outcome_recorded` ont des identifiants et horodatages distincts.
- [ ] `exposed` n'est émis qu'après rendu effectif sur le device actif, jamais à la génération serveur.
- [ ] L'action est déclarée par l'utilisateur ou issue d'un signal explicitement défini ; une similarité de transcript n'est pas présentée comme certitude.
- [ ] Le résultat CRM conserve sa source, sa date et sa définition sans être automatiquement attribué à la suggestion.
- [ ] Le dashboard sépare taux d'éligibilité, exposition, action déclarée, résultat et cohortes `shadow|live|off`.
- [ ] Les libellés parlent d'association/corrélation tant qu'aucune expérimentation causale n'est menée.
- [ ] Les métriques excluent audio, transcript, numéro complet et texte de suggestion ; les détails sensibles restent dans les stockages autorisés.
- [ ] Les minutes facturables correspondent au mode live effectivement activé et aux règles de l'offre, jamais au shadow interne.

## Dependencies

- STORY-016 et STORY-012.

## Definition of Done

- [ ] Chaîne d'événements vérifiée de bout en bout sur appels réels.
- [ ] Dashboard et exports n'inventent aucune étape manquante.
- [ ] Contrôles de confidentialité et de facturation passent.
