# Ajouter le CRM et le gate d'éligibilité avant composition

**ID :** STORY-009  
**Epic :** CRM et conformité de prospection  
**Priorité :** Must Have  
**Story Points :** 8  
**Statut :** Implémentée — validation juridique restante

## User Story

En tant que fondateur ou commercial,
je veux importer un prospect ou saisir directement son numéro et connaître son éligibilité,
afin de ne lancer que des appels autorisés et de respecter immédiatement toute opposition.

## Acceptance Criteria

- [ ] L'utilisateur peut créer un contact à partir d'un numéro seul ou importer un CSV sans devoir connecter un CRM tiers.
- [ ] Chaque numéro possède une source, une juridiction, une audience `b2b|b2c|unknown`, une base documentée et un statut `eligible|blocked|needs_review`.
- [ ] Une entrée `do_not_call` ou une opposition bloque toujours la composition, y compris après réimport.
- [ ] Pour la France à compter du 11 août 2026, un contact B2C sans consentement préalable démontrable est bloqué, sauf exception documentée telle qu'un contrat en cours.
- [ ] Un contact B2B n'est éligible qu'après confirmation de la pertinence professionnelle et de la capacité d'information/opposition.
- [ ] Un contact `unknown` ou une preuve insuffisante produit `needs_review` et bloque l'appel jusqu'à qualification humaine.
- [ ] Le dialer libre demande la même qualification et n'offre aucun contournement du gate CRM.
- [ ] La décision affiche une explication, conserve `ruleVersion` et distingue prospection, transcription/enregistrement et coaching.
- [ ] Une matrice automatisée couvre dates, B2B/B2C/unknown, consentement, contrat en cours, opposition et réimport.

## Technical Notes

- Ne pas inférer B2B/B2C par LLM, type de numéro ou domaine email.
- Le moteur constitue un garde-fou produit, pas un avis juridique universel ; les règles restent configurables par juridiction.
- Les tests avant le 11 août 2026 et après cette date doivent produire des décisions distinctes et reproductibles.

## Dependencies

- STORY-008.
- Validation juridique des règles et textes d'information du premier marché.

## Definition of Done

- [ ] Saisie directe et import CSV fonctionnent sans données simulées.
- [ ] Aucun appel ne part pour `blocked` ou `needs_review`.
- [ ] `do_not_call` est prioritaire et auditable.
- [ ] Tests de la matrice de règles passent.
