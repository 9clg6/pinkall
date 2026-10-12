import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core_data/core_data.dart';
import 'package:core_data/model/remote/call_eligibility.remote.model.dart';
import 'package:core_data/model/remote/call_outcome.remote.model.dart';
import 'package:core_data/model/remote/coach_preference.remote.model.dart';
import 'package:core_data/model/remote/coaching_feedback.remote.model.dart';
import 'package:core_data/model/remote/contact.remote.model.dart';
import 'package:core_data/model/remote/contact_import_result.remote.model.dart';
import 'package:core_data/model/remote/conversation_session.remote.model.dart';
import 'package:core_data/model/remote/conversation_transcript.remote.model.dart';
import 'package:core_data/model/remote/session_realtime_event.remote.model.dart';
import 'package:core_data/model/remote/transcription_consent.remote.model.dart';
import 'package:core_domain/core_domain.dart';
import 'package:test/test.dart';

void main() {
  group('ConversationSessionRepositoryImpl', () {
    test(
      'blocks live transcript access until consent is acknowledged',
      () async {
        final _FakeConversationSessionRemoteDataSource remoteDataSource =
            _FakeConversationSessionRemoteDataSource(
              session: _session(consentAcknowledged: false),
            );
        final ConversationSessionRepositoryImpl repository =
            ConversationSessionRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );

        await expectLater(
          repository.watchSessionEvents('session-1'),
          emitsError(isA<TranscriptionConsentRequiredException>()),
        );
        expect(remoteDataSource.didOpenRealtimeStream, isFalse);
      },
    );

    test('maps attributed transcript events after consent', () async {
      final _FakeConversationSessionRemoteDataSource remoteDataSource =
          _FakeConversationSessionRemoteDataSource(
            session: _session(consentAcknowledged: true),
            events: <SessionRealtimeEventRemoteModel>[
              SessionRealtimeEventRemoteModel(
                type: 'transcript_segment',
                payload: <String, dynamic>{
                  'id': 'segment-1',
                  'session_id': 'session-1',
                  'sequence': 1,
                  'speaker': 'prospect',
                  'text': 'Envoyez-moi une proposition.',
                  'started_at': '2026-07-11T10:00:00.000Z',
                  'is_final': true,
                  'confidence': 0.97,
                },
              ),
            ],
          );
      final ConversationSessionRepositoryImpl repository =
          ConversationSessionRepositoryImpl(remoteDataSource: remoteDataSource);

      final SessionRealtimeEventEntity event = await repository
          .watchSessionEvents('session-1')
          .single;

      expect(event, isA<SessionTranscriptSegmentEventEntity>());
      final SessionTranscriptSegmentEventEntity transcriptEvent =
          event as SessionTranscriptSegmentEventEntity;
      expect(transcriptEvent.segment.speaker, TranscriptSpeaker.prospect);
      expect(transcriptEvent.segment.isFinal, isTrue);
      expect(remoteDataSource.didOpenRealtimeStream, isTrue);
    });

    test('maps coach status and preserves unknown realtime events', () async {
      final _FakeConversationSessionRemoteDataSource remoteDataSource =
          _FakeConversationSessionRemoteDataSource(
            session: _session(consentAcknowledged: true),
            events: <SessionRealtimeEventRemoteModel>[
              const SessionRealtimeEventRemoteModel(
                type: 'coach_status',
                payload: <String, dynamic>{
                  'status': 'listening',
                  'outcome': 'none',
                },
              ),
              const SessionRealtimeEventRemoteModel(
                type: 'future_event',
                payload: <String, dynamic>{'version': 2},
              ),
            ],
          );
      final ConversationSessionRepositoryImpl repository =
          ConversationSessionRepositoryImpl(remoteDataSource: remoteDataSource);

      final List<SessionRealtimeEventEntity> events = await repository
          .watchSessionEvents('session-1')
          .toList();

      final SessionCoachStatusEventEntity coachEvent =
          events.first as SessionCoachStatusEventEntity;
      expect(coachEvent.coachStatus.status, CoachAnalysisStatus.listening);
      expect(coachEvent.coachStatus.outcome, CoachAnalysisOutcome.none);
      final SessionUnknownEventEntity unknownEvent =
          events.last as SessionUnknownEventEntity;
      expect(unknownEvent.type, 'future_event');
      expect(unknownEvent.payload, <String, Object?>{'version': 2});
    });

    test('records consent through the dedicated backend contract', () async {
      final _FakeConversationSessionRemoteDataSource remoteDataSource =
          _FakeConversationSessionRemoteDataSource(
            session: _session(consentAcknowledged: false),
          );
      final ConversationSessionRepositoryImpl repository =
          ConversationSessionRepositoryImpl(remoteDataSource: remoteDataSource);
      final DateTime acknowledgedAt = DateTime.utc(2026, 7, 11, 10);

      final TranscriptionConsentEntity consent = await repository
          .recordTranscriptionConsent(
            RecordTranscriptionConsentParam(
              sessionId: 'session-1',
              acknowledged: true,
              method: TranscriptionConsentMethod.verbalNotice,
              acknowledgedAt: acknowledgedAt,
            ),
          );

      expect(consent.acknowledged, isTrue);
      expect(remoteDataSource.consentBody, <String, dynamic>{
        'acknowledged': true,
        'method': 'verbal_notice',
        'acknowledged_at': acknowledgedAt.toIso8601String(),
      });
    });

    test('maps active sessions discovered from another device', () async {
      final _FakeConversationSessionRemoteDataSource remoteDataSource =
          _FakeConversationSessionRemoteDataSource(
            session: _session(consentAcknowledged: true),
          );
      final ConversationSessionRepositoryImpl repository =
          ConversationSessionRepositoryImpl(remoteDataSource: remoteDataSource);

      final List<ConversationSessionEntity> sessions = await repository
          .listActiveSessions();

      expect(sessions.single.id, 'session-1');
      expect(sessions.single.status, ConversationSessionStatus.active);
      expect(sessions.single.coachMode, CoachMode.live);
    });

    test('maps the complete durable session history', () async {
      final _FakeConversationSessionRemoteDataSource remoteDataSource =
          _FakeConversationSessionRemoteDataSource(
            session: _session(consentAcknowledged: true),
          );
      final ConversationSessionRepositoryImpl repository =
          ConversationSessionRepositoryImpl(remoteDataSource: remoteDataSource);

      final List<ConversationSessionEntity> sessions = await repository
          .listSessions();

      expect(sessions.single.id, 'session-1');
    });
  });

  group('ConversationSessionRemoteDataSourceImpl', () {
    test('uses the multi-device active sessions endpoint', () async {
      final _RecordingPinkallHttpClient httpClient =
          _RecordingPinkallHttpClient();
      final ConversationSessionRemoteDataSourceImpl dataSource =
          ConversationSessionRemoteDataSourceImpl(
            httpClient: httpClient,
            realtimeClient: _NeverPinkallRealtimeClient(),
          );

      final List<ConversationSessionRemoteModel> sessions = await dataSource
          .listActiveSessions();

      expect(httpClient.lastGetPath, '/v1/sessions/active');
      expect(sessions.single.callId, 'call-42');
    });

    test('uses the durable call-history endpoint', () async {
      final _RecordingPinkallHttpClient httpClient =
          _RecordingPinkallHttpClient();
      final ConversationSessionRemoteDataSourceImpl dataSource =
          ConversationSessionRemoteDataSourceImpl(
            httpClient: httpClient,
            realtimeClient: _NeverPinkallRealtimeClient(),
          );

      final List<ConversationSessionRemoteModel> sessions = await dataSource
          .listSessions();

      expect(httpClient.lastGetPath, '/v1/sessions');
      expect(sessions.single.callId, 'call-42');
    });
  });

  group('DioPinkallHttpClientImpl', () {
    test('performs a real authenticated JSON request', () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() => server.close(force: true));
      final Completer<_CapturedRequest> captured =
          Completer<_CapturedRequest>();
      server.listen((HttpRequest request) async {
        final String body = await utf8.decoder.bind(request).join();
        captured.complete(
          _CapturedRequest(
            method: request.method,
            path: request.uri.path,
            authorization: request.headers.value(
              HttpHeaders.authorizationHeader,
            ),
            body: body,
          ),
        );
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode(<String, dynamic>{'accepted': true}));
        await request.response.close();
      });
      final DioPinkallHttpClientImpl client = DioPinkallHttpClientImpl(
        baseUri: Uri.parse('http://${server.address.address}:${server.port}'),
        accessTokenProvider: () async => 'session-token',
      );

      final Map<String, dynamic> response = await client.postJson(
        '/v1/sessions',
        body: <String, dynamic>{'call_id': 'call-42'},
      );
      final _CapturedRequest request = await captured.future;

      expect(response, <String, dynamic>{'accepted': true});
      expect(request.method, 'POST');
      expect(request.path, '/v1/sessions');
      expect(request.authorization, 'Bearer session-token');
      expect(jsonDecode(request.body), <String, dynamic>{'call_id': 'call-42'});
    });
  });

  group('CRM, eligibility, and coaching repositories', () {
    test(
      'maps contacts and returns the server-confirmed import counts',
      () async {
        final _FakeContactRemoteDataSource remoteDataSource =
            _FakeContactRemoteDataSource();
        final ContactRepositoryImpl repository = ContactRepositoryImpl(
          remoteDataSource: remoteDataSource,
        );

        final List<ContactEntity> contacts = await repository.listContacts(
          const ListContactsParam(query: 'Acme'),
        );
        final ContactImportResultEntity result = await repository
            .importContacts(
              const ImportContactsParam(
                sourceName: 'prospects.csv',
                rows: <ContactImportRowParam>[
                  ContactImportRowParam(phoneNumber: '+33601020304'),
                ],
              ),
            );

        expect(contacts.single.market, ContactMarket.b2b);
        expect(remoteDataSource.listQuery['query'], 'Acme');
        expect(result.importedCount, 1);
        expect(result.skippedCount, 0);
      },
    );

    test('keeps commercial eligibility separate from consent', () async {
      final CallEligibilityRepositoryImpl repository =
          CallEligibilityRepositoryImpl(
            remoteDataSource: _FakeCallEligibilityRemoteDataSource(),
          );

      final CallEligibilityEntity decision = await repository.evaluate(
        const EvaluateCallEligibilityParam(
          phoneNumber: '+33601020304',
          market: ContactMarket.b2c,
          hasPriorConsent: false,
        ),
      );

      expect(decision.status, CallEligibilityStatus.ineligible);
      expect(
        decision.reasons,
        contains(CallEligibilityReason.b2cConsentMissing),
      );
      expect(decision.policyVersion, 'fr-2026-08-11');
    });

    test('persists optional coach mode, feedback, and call outcome', () async {
      final _FakeCoachingRemoteDataSource remoteDataSource =
          _FakeCoachingRemoteDataSource();
      final CoachingRepositoryImpl repository = CoachingRepositoryImpl(
        remoteDataSource: remoteDataSource,
      );

      final CoachPreferenceEntity preference = await repository
          .updatePreference(
            const UpdateCoachPreferenceParam(defaultMode: CoachMode.shadow),
          );
      final CoachingFeedbackEntity feedback = await repository.submitFeedback(
        const SubmitCoachingFeedbackParam(
          sessionId: 'session-1',
          suggestionId: 'suggestion-1',
          value: SuggestionFeedbackValue.useful,
          applied: true,
        ),
      );
      final CallOutcomeEntity outcome = await repository.recordOutcome(
        const RecordCallOutcomeParam(
          sessionId: 'session-1',
          type: CallOutcomeType.meetingBooked,
        ),
      );

      expect(preference.defaultMode, CoachMode.shadow);
      expect(feedback.applied, isTrue);
      expect(outcome.type, CallOutcomeType.meetingBooked);
      expect(remoteDataSource.outcomeBody, isNot(contains('session_id')));
    });
  });

  group('WebSocketPinkallRealtimeClientImpl', () {
    test('opens a real authenticated JSON event stream', () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() => server.close(force: true));
      final Completer<String?> authorization = Completer<String?>();
      server.listen((HttpRequest request) async {
        authorization.complete(
          request.headers.value(HttpHeaders.authorizationHeader),
        );
        final WebSocket socket = await WebSocketTransformer.upgrade(request);
        socket.add(
          jsonEncode(<String, dynamic>{
            'type': 'session_state',
            'payload': <String, dynamic>{'id': 'session-1'},
          }),
        );
        await socket.close();
      });
      final WebSocketPinkallRealtimeClientImpl client =
          WebSocketPinkallRealtimeClientImpl(
            baseUri: Uri.parse('ws://${server.address.address}:${server.port}'),
            accessTokenProvider: () async => 'realtime-token',
          );

      final Map<String, dynamic> event = await client
          .watchJson('/v1/sessions/session-1/events')
          .single;

      expect(await authorization.future, 'Bearer realtime-token');
      expect(event['type'], 'session_state');
    });
  });
}

ConversationSessionRemoteModel _session({required bool consentAcknowledged}) {
  return ConversationSessionRemoteModel(
    id: 'session-1',
    callId: 'call-42',
    status: 'active',
    coachMode: 'live',
    createdAt: DateTime.utc(2026, 7, 11, 10),
    transcriptionConsentAcknowledged: consentAcknowledged,
  );
}

final class _CapturedRequest {
  const _CapturedRequest({
    required this.method,
    required this.path,
    required this.authorization,
    required this.body,
  });

  final String method;
  final String path;
  final String? authorization;
  final String body;
}

final class _RecordingPinkallHttpClient implements PinkallHttpClient {
  String? lastGetPath;

  @override
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    lastGetPath = path;
    return <String, dynamic>{
      path == '/v1/sessions' ? 'data' : 'items': <Map<String, dynamic>>[
        _session(consentAcknowledged: true).toJson(),
      ],
    };
  }

  @override
  Future<Map<String, dynamic>> patchJson(
    String path, {
    Map<String, dynamic>? body,
  }) => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
  }) => throw UnimplementedError();
}

final class _NeverPinkallRealtimeClient implements PinkallRealtimeClient {
  @override
  Stream<Map<String, dynamic>> watchJson(String path) =>
      throw UnimplementedError();
}

final class _FakeConversationSessionRemoteDataSource
    implements ConversationSessionRemoteDataSource {
  _FakeConversationSessionRemoteDataSource({
    required this.session,
    this.events = const <SessionRealtimeEventRemoteModel>[],
  });

  final ConversationSessionRemoteModel session;
  final List<SessionRealtimeEventRemoteModel> events;
  bool didOpenRealtimeStream = false;
  Map<String, dynamic>? consentBody;

  @override
  Future<ConversationSessionRemoteModel> cancelSession(
    String sessionId,
  ) async => session;

  @override
  Future<ConversationSessionRemoteModel> createSession(
    Map<String, dynamic> body,
  ) async => session;

  @override
  Future<ExternalConversationSessionRemoteModel> createExternalSession(
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<ConversationSessionRemoteModel> finalizeSession(
    String sessionId,
  ) async => session;

  @override
  Future<ConversationTranscriptRemoteModel> getFinalTranscript(
    String sessionId,
  ) => throw UnimplementedError();

  @override
  Future<CallDebriefRemoteModel> getDebrief(String sessionId) =>
      throw UnimplementedError();

  @override
  Future<CoachingProgressRemoteModel> getCoachingProgress({
    required int windowSize,
    required int recentLimit,
  }) => throw UnimplementedError();

  @override
  Future<ConversationSessionRemoteModel> getSession(String sessionId) async =>
      session;

  @override
  Future<List<ConversationSessionRemoteModel>> listActiveSessions() async =>
      <ConversationSessionRemoteModel>[session];

  @override
  Future<List<ConversationSessionRemoteModel>> listSessions() async =>
      <ConversationSessionRemoteModel>[session];

  @override
  Future<TranscriptionConsentRemoteModel> recordTranscriptionConsent(
    String sessionId,
    Map<String, dynamic> body,
  ) async {
    consentBody = body;
    return TranscriptionConsentRemoteModel(
      sessionId: sessionId,
      acknowledged: body['acknowledged'] as bool,
      method: body['method'] as String,
      acknowledgedAt: DateTime.parse(body['acknowledged_at'] as String),
    );
  }

  @override
  Future<ConversationSessionRemoteModel> updateCoachMode(
    String sessionId,
    Map<String, dynamic> body,
  ) async => session;

  @override
  Stream<SessionRealtimeEventRemoteModel> watchSessionEvents(String sessionId) {
    didOpenRealtimeStream = true;
    return Stream<SessionRealtimeEventRemoteModel>.fromIterable(events);
  }
}

final class _FakeContactRemoteDataSource implements ContactRemoteDataSource {
  Map<String, dynamic> listQuery = <String, dynamic>{};

  @override
  Future<ContactRemoteModel> createContact(Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<ContactImportResultRemoteModel> importContacts(
    Map<String, dynamic> body,
  ) async {
    return const ContactImportResultRemoteModel(
      importId: 'import-1',
      importedCount: 1,
      skippedCount: 0,
    );
  }

  @override
  Future<List<ContactRemoteModel>> listContacts(
    Map<String, dynamic> queryParameters,
  ) async {
    listQuery = queryParameters;
    return <ContactRemoteModel>[
      ContactRemoteModel(
        id: 'contact-1',
        phoneNumber: '+33601020304',
        market: 'b2b',
        company: 'Acme',
        createdAt: DateTime.utc(2026, 7, 11),
        updatedAt: DateTime.utc(2026, 7, 11),
      ),
    ];
  }
}

final class _FakeCallEligibilityRemoteDataSource
    implements CallEligibilityRemoteDataSource {
  @override
  Future<CallEligibilityRemoteModel> evaluate(Map<String, dynamic> body) async {
    return CallEligibilityRemoteModel(
      status: 'ineligible',
      reasons: const <String>['b2c_consent_missing'],
      checkedAt: DateTime.utc(2026, 7, 11),
      policyVersion: 'fr-2026-08-11',
    );
  }
}

final class _FakeCoachingRemoteDataSource implements CoachingRemoteDataSource {
  Map<String, dynamic> outcomeBody = <String, dynamic>{};

  @override
  Future<ObjectionKnowledgeListRemoteModel> listObjections() =>
      throw UnimplementedError();

  @override
  Future<ObjectionKnowledgeEntryRemoteModel> createCustomObjection(
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<CoachPreferenceRemoteModel> getPreference() =>
      throw UnimplementedError();

  @override
  Future<CallOutcomeRemoteModel> recordOutcome(
    String sessionId,
    Map<String, dynamic> body,
  ) async {
    outcomeBody = body;
    return CallOutcomeRemoteModel(
      sessionId: sessionId,
      type: body['type'] as String,
      recordedAt: DateTime.utc(2026, 7, 11),
    );
  }

  @override
  Future<CoachingFeedbackRemoteModel> submitFeedback(
    Map<String, dynamic> body,
  ) async {
    return CoachingFeedbackRemoteModel(
      id: 'feedback-1',
      sessionId: body['session_id'] as String,
      suggestionId: body['suggestion_id'] as String,
      value: body['value'] as String,
      applied: body['applied'] as bool,
      submittedAt: DateTime.utc(2026, 7, 11),
    );
  }

  @override
  Future<CoachPreferenceRemoteModel> updatePreference(
    Map<String, dynamic> body,
  ) async {
    return CoachPreferenceRemoteModel(
      defaultMode: body['default_mode'] as String,
      updatedAt: DateTime.utc(2026, 7, 11),
    );
  }
}
