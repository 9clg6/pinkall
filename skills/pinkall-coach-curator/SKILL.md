---
name: pinkall-coach-curator
description: Curate, grade, license-check, structure, and validate evidence-backed sales-call coaching for Pinkall. Use when adding books, courses, papers, videos, practitioner playbooks, vendor studies, or internal experiments to the coaching corpus; when creating or reviewing claims and live recommendation cards; or when auditing source fidelity, applicability, rights, contradictions, and offline/shadow/live evaluation readiness.
---

# Pinkall Coach Curator

Build an auditable coaching catalog. Treat source volume as coverage, never as proof.

## Required workflow

1. Define one narrow coaching question and its intended call context.
2. Check rights before retaining content. Read `references/evidence-and-rights.md`.
3. Register the source without copying a protected work into the catalog.
4. Extract atomic claims with an exact locator, limitations, and contradictions.
5. Grade evidence and context fit independently.
6. Create recommendation cards that separate observation, hypothesis, and action.
7. Validate the catalog with `scripts/validate_catalog.py`.
8. Require human approval before a card can enter shadow or live mode.
9. Run the relevant evaluation gate from `references/evaluation.md`.

Use the contracts in `references/data-contracts.md`. Do not invent missing metadata.

## Non-negotiable rules

- Never publish an unsourced recommendation.
- Never present a probabilistic interpretation as an observed fact.
- Preserve contradictory evidence instead of averaging it away.
- Keep applicability explicit: motion, stage, persona, sector, language, geography,
  deal size, and exclusions.
- Prefer abstention when confidence or context fit is below the release threshold.
- Never store complete copyrighted books, paid courses, or video transcripts merely
  because they are accessible to the curator.
- Keep customer-private playbooks isolated from the global catalog unless the customer
  has explicitly licensed broader use.
- Version sources, claims, cards, policies, models, and evaluation results.

## Release gates

- `draft`: structurally valid but not approved.
- `approved_post_call`: source and content reviewed; usable after calls.
- `shadow`: generated during live calls but invisible to users.
- `live`: passed timing, relevance, safety, and distraction thresholds.
- `retired`: excluded from retrieval but retained for auditability.

No automatic transition may promote a card to `live`.

## Expected outputs

For each curation task, return:

1. source records and rights status;
2. atomic claims with evidence grade and exact locator;
3. recommendation cards or an explicit reason none can be created;
4. contradictions and applicability limits;
5. validation result and required evaluation stage.

