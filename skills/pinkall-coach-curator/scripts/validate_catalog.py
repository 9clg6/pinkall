#!/usr/bin/env python3
"""Validate Pinkall source, claim, and recommendation catalog references."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any


ALLOWED_PROVENANCE = {
    "academic",
    "institutional",
    "practitioner",
    "vendor_data",
    "pinkall_internal",
}
ALLOWED_EVIDENCE = {"E0", "E1", "E2", "E3", "E4"}
ALLOWED_RIGHTS = {"green", "amber", "red"}
ALLOWED_STATUS = {
    "draft",
    "approved_post_call",
    "shadow",
    "live",
    "retired",
}


def load_array(root: Path, name: str) -> list[dict[str, Any]]:
    path = root / name
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as error:
        raise ValueError(f"missing {name}") from error
    except json.JSONDecodeError as error:
        raise ValueError(f"invalid JSON in {name}: {error}") from error
    if not isinstance(value, list) or not all(isinstance(item, dict) for item in value):
        raise ValueError(f"{name} must contain a JSON array of objects")
    return value


def require(record: dict[str, Any], fields: tuple[str, ...], label: str) -> list[str]:
    return [f"{label}: missing {field}" for field in fields if record.get(field) in (None, "", [])]


def unique_index(records: list[dict[str, Any]], kind: str) -> tuple[dict[str, dict[str, Any]], list[str]]:
    index: dict[str, dict[str, Any]] = {}
    errors: list[str] = []
    for position, record in enumerate(records):
        record_id = record.get("id")
        label = f"{kind}[{position}]"
        if not isinstance(record_id, str) or not record_id:
            errors.append(f"{label}: missing id")
        elif record_id in index:
            errors.append(f"{label}: duplicate id {record_id}")
        else:
            index[record_id] = record
    return index, errors


def validate(root: Path) -> list[str]:
    sources = load_array(root, "sources.json")
    claims = load_array(root, "claims.json")
    recommendations = load_array(root, "recommendations.json")
    source_index, errors = unique_index(sources, "source")
    claim_index, claim_errors = unique_index(claims, "claim")
    errors.extend(claim_errors)
    _, recommendation_errors = unique_index(recommendations, "recommendation")
    errors.extend(recommendation_errors)

    for source in sources:
        label = f"source {source.get('id', '?')}"
        errors.extend(require(source, ("title", "authors", "provenance", "method", "locator_url", "rights"), label))
        if source.get("provenance") not in ALLOWED_PROVENANCE:
            errors.append(f"{label}: invalid provenance")
        rights = source.get("rights")
        if not isinstance(rights, dict) or rights.get("status") not in ALLOWED_RIGHTS:
            errors.append(f"{label}: invalid rights status")
        elif rights.get("status") == "red" and rights.get("commercial_use") is True:
            errors.append(f"{label}: red rights cannot allow commercial use")

    for claim in claims:
        label = f"claim {claim.get('id', '?')}"
        errors.extend(require(claim, ("statement", "source_ids", "source_locators", "evidence_grade", "applicability", "status", "version"), label))
        if claim.get("evidence_grade") not in ALLOWED_EVIDENCE:
            errors.append(f"{label}: invalid evidence grade")
        if claim.get("status") not in ALLOWED_STATUS:
            errors.append(f"{label}: invalid status")
        for source_id in claim.get("source_ids", []):
            if source_id not in source_index:
                errors.append(f"{label}: unknown source {source_id}")

    for recommendation in recommendations:
        label = f"recommendation {recommendation.get('id', '?')}"
        errors.extend(require(recommendation, ("claim_ids", "trigger", "observation_template", "hypothesis", "action", "confidence", "expires_in_seconds", "status", "version"), label))
        if recommendation.get("status") not in ALLOWED_STATUS:
            errors.append(f"{label}: invalid status")
        for claim_id in recommendation.get("claim_ids", []):
            if claim_id not in claim_index:
                errors.append(f"{label}: unknown claim {claim_id}")
        action = recommendation.get("action", {})
        suggestion = action.get("suggestion", "") if isinstance(action, dict) else ""
        if len(suggestion.split()) > 24:
            errors.append(f"{label}: live suggestion exceeds 24 words")
        confidence = recommendation.get("confidence", {})
        if isinstance(confidence, dict):
            for key in ("evidence", "context_minimum", "live_minimum"):
                value = confidence.get(key)
                if not isinstance(value, (int, float)) or not 0 <= value <= 1:
                    errors.append(f"{label}: confidence.{key} must be between 0 and 1")

    return errors


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: validate_catalog.py <catalog-directory>", file=sys.stderr)
        return 2
    root = Path(sys.argv[1])
    try:
        errors = validate(root)
    except ValueError as error:
        print(f"INVALID: {error}")
        return 1
    if errors:
        print("INVALID")
        for error in errors:
            print(f"- {error}")
        return 1
    print("VALID")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
