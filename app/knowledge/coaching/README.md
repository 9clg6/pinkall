# Coaching knowledge catalogue

This directory is a versioned research catalogue, not an autonomous source of
truth. `sources.json` contains bibliographic metadata, `claims.json` contains
curator-authored falsifiable paraphrases, and `recommendations.json` contains
product actions grounded in those claims. No protected source text is stored.

## Promotion pipeline

1. `draft`: research candidate; never eligible in the strict live channel.
2. `review`: source, applicability, limitations, wording, and rights are checked.
3. `shadow`: at least the configured number of distinct human approvals are
   required for the exact artifact version. The recommendation is evaluated but
   never shown to the user.
4. `live`: the same review gates apply, every claim must already be approved,
   source rights must allow live use, and a versioned shadow report must pass.

Human decisions belong in `reviews.json`; an AI agent must never add itself as a
human reviewer. Editing any audited artifact requires a version bump and a new
digest in `catalog-manifest.json`. Stale reviews do not count.

## Coverage snapshot 1.1.0

The catalogue currently records 38 sources, 38 atomic claims, and 50
recommendation cards. Version 1.1.0 adds research candidates for conversational
timing, relevant concrete language, flexible talking/listening, shared
vocabulary, price precision, vocal-cue uncertainty, and turn timing. The source
locators and public metadata for the nine added sources were checked on
2026-07-14.

This is coverage, not approval. Every claim and recommendation remains `draft`,
`reviews.json` remains empty, and the catalogue must not be described as
human-reviewed or scientifically complete. In particular, the catalogue keeps
the conflicting entry-stage and in-negotiation findings about precise offers,
and it records the published dispute about the practical size of a voice-only
emotion-recognition advantage. Acoustic emotion labels must therefore remain
hypotheses that are verified with the speaker, never observations about an
internal state.

`rights-policies.json` is deliberately conservative. A licence allowing access
to a document does not automatically allow source text to be copied into a
commercial product. Sources tagged `copyrighted_metadata_only` may inform
internal shadow research through metadata and independently authored factual
synthesis, but cannot back a strict live card without a new rights review.

## Deterministic audit

From `app/apps/api_agent_vocal`:

```sh
../../tool/dart.sh run bin/audit_coaching_catalog.dart ../../knowledge/coaching
```

The command verifies hashes, unique IDs, versions, provenance, HTTPS locators,
rights assignments, claim/source links, recommendation grounding, review
versions, and promotion gates. It does not pretend to verify scientific truth
or URL content; those remain human research work.

## Shadow evaluation

Cases must come from consented calls and have human labels. Keep raw transcripts
outside this catalogue and use opaque case IDs here. One JSONL observation per
case records the selected card (or null), cited source IDs, latency, provider
tokens, and optionally a cost computed from a versioned external price sheet.

```sh
../../tool/dart.sh run bin/evaluate_coaching_shadow.dart \
  --catalog ../../knowledge/coaching \
  --cases ../../knowledge/coaching/evaluation/cases.json \
  --observations ../../knowledge/coaching/evaluation/observations.jsonl
```

The harness reports correct-card precision, false-positive rate, recall, source
fidelity, p50/p95 latency, token volume, cost coverage, and estimated cost. It
preserves missing measurements as unknown instead of converting them to zero.

## Local objection learning

After a grounded post-call debrief, Pinkall extracts prospect objections and
merges genuinely new formulations into
`discovered-objections.local.json`. The file is intentionally ignored by Git
because it can contain short, redacted call excerpts. Its machine-readable
shape starts from `discovered-objections.example.json`.

Every automatically discovered objection and proposed answer starts with
`review_status: candidate`. It must not become a curated live coaching card
until a human has checked the transcript evidence, product claims, source
grounding, rights and exclusions, then promoted it through the audited
catalogue.

An authenticated user can also explicitly add an objection and their own
response from the app. That entry is marked `origin: custom` (or
`detected_and_custom`) and `review_status: live`: the user's save action is the
human approval for this workspace-owned instruction. The live model may only
select the matching entry; the server displays the stored response rather than
letting the model invent one. Text and UTF-8 `.md`/`.txt` sources are bounded to
32 KiB. They remain separate from the research-backed catalogue and must never
be presented as independently verified advice.

The local file is an adapter for learning and review, not a durable SaaS source
of truth. Render container storage is ephemeral and a multi-instance release
must move this library behind the existing interface to PostgreSQL/Supabase.
