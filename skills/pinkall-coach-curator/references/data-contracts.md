# Catalog contracts

The validator expects three JSON arrays: `sources.json`, `claims.json`, and
`recommendations.json`.

## Source

Required fields:

```json
{
  "id": "source_unique_id",
  "title": "Source title",
  "authors": ["Author"],
  "provenance": "academic",
  "method": "controlled_field_experiment",
  "published_at": "2024-01-01",
  "locator_url": "https://example.com/source",
  "rights": {
    "status": "green",
    "basis": "CC BY 4.0",
    "commercial_use": true,
    "reviewed_at": "2026-07-11"
  },
  "conflicts": [],
  "notes": "Limitations and scope"
}
```

## Claim

Required fields:

```json
{
  "id": "claim_unique_id",
  "statement": "One atomic, curator-authored statement",
  "source_ids": ["source_unique_id"],
  "source_locators": ["p. 12"],
  "evidence_grade": "E3",
  "applicability": {
    "motions": ["b2b_outbound"],
    "stages": ["objection"],
    "languages": ["fr"],
    "excluded_when": []
  },
  "limitations": [],
  "contradicts_claim_ids": [],
  "status": "approved_post_call",
  "version": 1
}
```

## Recommendation

Required fields:

```json
{
  "id": "recommendation_unique_id",
  "claim_ids": ["claim_unique_id"],
  "trigger": {
    "signal": "price_objection",
    "speaker": "prospect"
  },
  "observation_template": "The prospect states a budget constraint.",
  "hypothesis": {
    "label": "budget_constraint",
    "alternatives": ["value_not_understood"]
  },
  "action": {
    "type": "diagnostic_question",
    "suggestion": "Qu’est-ce qui rend ce budget difficile à engager aujourd’hui ?"
  },
  "confidence": {
    "evidence": 0.7,
    "context_minimum": 0.75,
    "live_minimum": 0.82
  },
  "expires_in_seconds": 12,
  "status": "shadow",
  "version": 1
}
```

Keep live suggestions short enough to understand without leaving the conversation.

