import 'dart:convert';

import 'package:api_agent_vocal/api_agent_vocal.dart';
import 'package:core_data/model/remote/call_eligibility.remote.model.dart';
import 'package:core_data/model/remote/call_outcome.remote.model.dart';
import 'package:core_data/model/remote/coach_preference.remote.model.dart';
import 'package:core_data/model/remote/coaching_feedback.remote.model.dart';
import 'package:core_data/model/remote/coaching_suggestion.remote.model.dart';
import 'package:core_data/model/remote/contact.remote.model.dart';
import 'package:core_data/model/remote/contact_import_result.remote.model.dart';
import 'package:core_data/model/remote/conversation_session.remote.model.dart';
import 'package:core_data/model/remote/conversation_transcript.remote.model.dart';
import 'package:core_data/model/remote/session_realtime_event.remote.model.dart';
import 'package:core_data/model/remote/transcription_consent.remote.model.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  const String token = 'contract-token-with-more-than-24-characters';
  late PinkallBackend backend;
  late Handler handler;

  setUp(() {
    backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': token,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'contract-test-not-called',
      }),
    );
    handler = ApiRouter(backend: backend).handler;
  });

  tearDown(() => backend.dispose());

  test(
    'session, consent and transcript responses deserialize in core_data',
    () async {
      final _JsonResponse created = await _request(
        handler,
        token: token,
        method: 'POST',
        path: '/v1/sessions',
        body: <String, Object?>{
          'call_id': 'correlation-1',
          'destination_number': '+33102030405',
          'coach_mode_override': 'off',
          'locale': 'fr-FR',
          'context': <String, Object?>{'campaign': 'poc'},
        },
      );
      expect(created.statusCode, 201);
      final ConversationSessionRemoteModel session =
          ConversationSessionRemoteModel.fromJson(created.body);
      expect(session.callId, 'correlation-1');
      expect(session.status, 'created');
      expect(session.transcriptionConsentAcknowledged, isFalse);

      final _JsonResponse fetched = await _request(
        handler,
        token: token,
        method: 'GET',
        path: '/v1/sessions/${session.id}',
      );
      expect(
        ConversationSessionRemoteModel.fromJson(fetched.body).id,
        session.id,
      );

      final _JsonResponse active = await _request(
        handler,
        token: token,
        method: 'GET',
        path: '/v1/sessions/active',
      );
      final List<Object?> items = active.body['items']! as List<Object?>;
      expect(
        ConversationSessionRemoteModel.fromJson(
          items.single! as Map<String, dynamic>,
        ).id,
        session.id,
      );

      final DateTime acknowledgedAt = DateTime.utc(2026, 7, 11, 10);
      final _JsonResponse consentResponse = await _request(
        handler,
        token: token,
        method: 'POST',
        path: '/v1/sessions/${session.id}/transcription-consent',
        body: <String, Object?>{
          'acknowledged': true,
          'method': 'verbal_notice',
          'acknowledged_at': acknowledgedAt.toIso8601String(),
        },
      );
      final TranscriptionConsentRemoteModel consent =
          TranscriptionConsentRemoteModel.fromJson(consentResponse.body);
      expect(consent.sessionId, session.id);
      expect(consent.acknowledged, isTrue);

      backend.store.replaceFinalTranscript(session.id, <TranscriptSegment>[
        TranscriptSegment(
          id: 'segment-1',
          track: MediaTrack.inbound,
          speaker: SpeakerRole.prospect,
          text: 'Rappelez-moi mardi.',
          startSeconds: 1.2,
          endSeconds: 2.4,
          isFinal: true,
          provider: 'contract-test',
          createdAt: DateTime.utc(2026, 7, 11, 10, 0, 2),
        ),
      ]);
      final _JsonResponse transcriptResponse = await _request(
        handler,
        token: token,
        method: 'GET',
        path: '/v1/sessions/${session.id}/transcript/final',
      );
      final ConversationTranscriptRemoteModel transcript =
          ConversationTranscriptRemoteModel.fromJson(transcriptResponse.body);
      expect(transcript.sessionId, session.id);
      expect(transcript.segments.single.speaker, 'prospect');
      expect(transcript.segments.single.sequence, 1);
    },
  );

  test('CRM and call eligibility responses deserialize in core_data', () async {
    final _JsonResponse contactResponse = await _request(
      handler,
      token: token,
      method: 'POST',
      path: '/v1/contacts',
      body: <String, Object?>{
        'phone_number': '+33102030405',
        'market': 'b2b',
        'first_name': 'Ada',
        'company': 'Analytical Engines',
        'professional_relevance_confirmed': true,
        'custom_fields': <String, String>{'source': 'manual'},
      },
    );
    final ContactRemoteModel contact = ContactRemoteModel.fromJson(
      contactResponse.body,
    );
    expect(contact.market, 'b2b');
    expect(contact.customFields, <String, String>{'source': 'manual'});

    final _JsonResponse listResponse = await _request(
      handler,
      token: token,
      method: 'GET',
      path: '/v1/contacts',
    );
    expect(
      ContactRemoteModel.fromJson(
        (listResponse.body['items']! as List<Object?>).single!
            as Map<String, dynamic>,
      ).id,
      contact.id,
    );

    final _JsonResponse importResponse = await _request(
      handler,
      token: token,
      method: 'POST',
      path: '/v1/contacts/import',
      body: <String, Object?>{
        'source_name': 'contract.csv',
        'rows': <Map<String, Object?>>[
          <String, Object?>{'phone_number': '+33102030406', 'market': 'b2b'},
        ],
      },
    );
    final ContactImportResultRemoteModel importResult =
        ContactImportResultRemoteModel.fromJson(importResponse.body);
    expect(importResult.importedCount, 1);
    expect(importResult.skippedCount, 0);

    final _JsonResponse eligibilityResponse = await _request(
      handler,
      token: token,
      method: 'POST',
      path: '/v1/call-eligibility/evaluate',
      body: <String, Object?>{
        'contact_id': contact.id,
        'phone_number': contact.phoneNumber,
        'market': 'b2b',
        'professional_relevance_confirmed': true,
        'country_code': 'FR',
      },
    );
    final CallEligibilityRemoteModel eligibility =
        CallEligibilityRemoteModel.fromJson(eligibilityResponse.body);
    expect(eligibility.status, 'eligible');
    expect(eligibility.contactId, contact.id);
  });

  test(
    'coaching preference, feedback and outcome deserialize in core_data',
    () async {
      final _JsonResponse preferenceResponse = await _request(
        handler,
        token: token,
        method: 'GET',
        path: '/v1/coach/preferences/me',
      );
      expect(
        CoachPreferenceRemoteModel.fromJson(
          preferenceResponse.body,
        ).defaultMode,
        'off',
      );

      final _JsonResponse created = await _request(
        handler,
        token: token,
        method: 'POST',
        path: '/v1/sessions',
        body: <String, Object?>{
          'call_id': 'correlation-2',
          'destination_number': '+33102030407',
          'coach_mode_override': 'off',
        },
      );
      final String sessionId = created.body['id']! as String;

      backend.store.recordExposure('suggestion-1');
      final _JsonResponse feedbackResponse = await _request(
        handler,
        token: token,
        method: 'POST',
        path: '/v1/coaching/feedback',
        body: <String, Object?>{
          'session_id': sessionId,
          'suggestion_id': 'suggestion-1',
          'value': 'useful',
          'applied': true,
          'note': 'Bien placé.',
        },
      );
      final CoachingFeedbackRemoteModel feedback =
          CoachingFeedbackRemoteModel.fromJson(feedbackResponse.body);
      expect(feedback.applied, isTrue);

      final _JsonResponse outcomeResponse = await _request(
        handler,
        token: token,
        method: 'PUT',
        path: '/v1/sessions/$sessionId/outcome',
        body: <String, Object?>{
          'type': 'meeting_booked',
          'note': 'Mardi 10 h.',
        },
      );
      final CallOutcomeRemoteModel outcome = CallOutcomeRemoteModel.fromJson(
        outcomeResponse.body,
      );
      expect(outcome.sessionId, sessionId);
      expect(outcome.type, 'meeting_booked');
    },
  );

  test(
    'pending dial cancellation is idempotent and removes the zombie',
    () async {
      final _JsonResponse created = await _request(
        handler,
        token: token,
        method: 'POST',
        path: '/v1/sessions',
        body: <String, Object?>{
          'call_id': 'failed-dial-correlation',
          'destination_number': '+33102030408',
          'coach_mode_override': 'off',
        },
      );
      final String sessionId = created.body['id']! as String;

      final _JsonResponse first = await _request(
        handler,
        token: token,
        method: 'POST',
        path: '/v1/sessions/$sessionId/cancel',
      );
      final _JsonResponse second = await _request(
        handler,
        token: token,
        method: 'POST',
        path: '/v1/sessions/$sessionId/cancel',
      );
      final ConversationSessionRemoteModel cancelled =
          ConversationSessionRemoteModel.fromJson(first.body);
      expect(cancelled.status, 'failed');
      expect(cancelled.failureReason, 'client_dial_failed');
      expect(ConversationSessionRemoteModel.fromJson(second.body), cancelled);

      final _JsonResponse active = await _request(
        handler,
        token: token,
        method: 'GET',
        path: '/v1/sessions/active',
      );
      expect(active.body['items'], isEmpty);
    },
  );

  test('public realtime envelopes deserialize in core_data', () {
    final DateTime now = DateTime.utc(2026, 7, 11, 10);
    final Map<String, Object?> payload = <String, Object?>{
      'id': 'suggestion-1',
      'session_id': 'session-1',
      'kind': 'next_question',
      'text': 'Quel impact cela a-t-il aujourd’hui ?',
      'rationale': 'Le problème est nommé mais son impact reste inconnu.',
      'sources': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'source-1',
          'title': 'Controlled experiment',
          'evidence_level': 'experimental',
          'author': 'Researcher',
          'url': 'https://example.test/paper',
          'locator': 'p. 12',
        },
      ],
      'confidence': 0.9,
      'created_at': now.toIso8601String(),
      'expires_at': now.add(const Duration(seconds: 12)).toIso8601String(),
    };
    final SessionRealtimeEventRemoteModel envelope =
        SessionRealtimeEventRemoteModel.fromJson(
          ClientEvent(
            type: 'coaching_suggestion',
            sessionId: 'session-1',
            at: now,
            data: payload,
          ).toJson().cast<String, dynamic>(),
        );
    final CoachingSuggestionRemoteModel suggestion =
        CoachingSuggestionRemoteModel.fromJson(envelope.payload);
    expect(suggestion.sources.single.evidenceLevel, 'experimental');
  });
}

Future<_JsonResponse> _request(
  Handler handler, {
  required String token,
  required String method,
  required String path,
  Map<String, Object?>? body,
}) async {
  final Response response = await handler(
    Request(
      method,
      Uri.parse('http://localhost$path'),
      headers: <String, String>{
        'authorization': 'Bearer $token',
        if (body != null) 'content-type': 'application/json',
      },
      body: body == null ? null : jsonEncode(body),
    ),
  );
  final Object? decoded = jsonDecode(await response.readAsString());
  if (decoded is! Map<String, dynamic>) {
    throw StateError('Expected a JSON object from $method $path.');
  }
  return _JsonResponse(statusCode: response.statusCode, body: decoded);
}

final class _JsonResponse {
  const _JsonResponse({required this.statusCode, required this.body});

  final int statusCode;
  final Map<String, dynamic> body;
}
