# Evaluation gates

## Fidelity gate

- Every claim is supported by every cited locator or the contribution of each source
  is stated separately.
- Paraphrases preserve scope, uncertainty, and limitations.
- Rights status permits the stored artifact and intended runtime use.
- Contradictory findings are connected and visible.

## Offline gate

Replay consented, de-identified calls. Use at least two independent reviewers for the
high-risk live subset. Measure trigger precision, recommendation relevance, source
fidelity, brevity, duplication, and harmful counterexamples.

## Shadow gate

Generate recommendations during real calls without showing them. Measure end-to-end
latency, expiry before display, false positives, repeated cards, context mismatch, and
the percentage of turns where abstention was correct.

## Live gate

Enable only opt-in cards that passed shadow thresholds. Show at most one active card.
Capture `displayed`, `dismissed`, `useful`, `too_late`, `incorrect`, `applied`, and a
separate commercial outcome. User feedback is not causal proof.

## Promotion policy

Define thresholds per signal before evaluation. Never choose thresholds after viewing
the same evaluation set. Human approval is mandatory for promotion to `live`.

