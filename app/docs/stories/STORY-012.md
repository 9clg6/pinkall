# Générer le débrief et le rattacher au CRM

**ID :** STORY-012  
**Epic :** Mémoire d'appel et CRM  
**Priorité :** Must Have  
**Story Points :** 8  
**Statut :** Implémentée — évaluation humaine à compléter

## User Story

En tant que commercial après un appel,
je veux retrouver transcription, résumé, points clés, engagements et follow-up,
afin de mettre mon CRM à jour sans reprendre mes notes.

## Acceptance Criteria

- [ ] Le débrief démarre uniquement depuis une révision finale réelle, ou affiche explicitement son statut provisoire si le batch est indisponible.
- [ ] La sortie structurée contient résumé, points clés, engagements par locuteur, objections, prochaine action et brouillon de follow-up.
- [ ] Chaque engagement et information importante référence les segments de transcript qui le justifient.
- [ ] Une information absente ou ambiguë reste vide/incertaine ; le modèle ne crée ni rendez-vous ni engagement.
- [ ] Le résultat et le transcript complet sont rattachés au contact et à l'appel dans le CRM Pinkall.
- [ ] Toute écriture vers un CRM externe ou tout envoi de follow-up nécessite validation utilisateur dans ce premier incrément.
- [ ] Une régénération crée une version et ne remplace pas silencieusement une correction humaine.
- [ ] Les coûts, latences et erreurs du modèle sont mesurés sans journaliser le contenu.

## Dependencies

- STORY-011 et STORY-009.
- Fournisseur de modèle serveur réel et schéma de sortie validé.

## Definition of Done

- [ ] Un appel réel produit un débrief traçable jusqu'au transcript final.
- [ ] Les cas « information absente » et hallucination sont couverts par évaluation.
- [ ] Aucune action externe ne part sans validation utilisateur.
