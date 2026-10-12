# Créer le vertical slice métier local

**ID:** STORY-002  
**Epic:** Calls  
**Priority:** Must Have  
**Story Points:** 5

## User Story

As a founder, I want realistic local call data so that I can evaluate the product flow before real telephony exists.

## Acceptance Criteria

- [x] Les entités CallSession, TranscriptSegment et CoachingAdvice sont immuables avec Freezed.
- [x] Le domain expose un repository abstrait et des use cases, sans dépendre de la data.
- [x] La data expose un datasource local abstrait et une implémentation in-memory finale.
- [x] Le repository mappe les modèles data vers les entités domain.
- [x] Les use cases retournent un `ResultState` via `execute()`.
- [x] Les données sont clairement identifiables comme simulées.
