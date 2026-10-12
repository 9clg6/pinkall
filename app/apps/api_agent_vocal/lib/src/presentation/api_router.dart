import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:api_agent_vocal/src/application/backend.dart';
import 'package:api_agent_vocal/src/application/call_eligibility_service.dart';
import 'package:api_agent_vocal/src/application/coaching_progress_service.dart';
import 'package:api_agent_vocal/src/application/recording_import_service.dart';
import 'package:api_agent_vocal/src/application/workspace_privacy_service.dart';
import 'package:api_agent_vocal/src/domain/auth_contracts.dart';
import 'package:api_agent_vocal/src/domain/coaching_progress_models.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/objection_learning.dart';
import 'package:api_agent_vocal/src/domain/post_call_contracts.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';
import 'package:api_agent_vocal/src/domain/stt_contracts.dart';
import 'package:api_agent_vocal/src/domain/telnyx_call_control_contracts.dart';
import 'package:api_agent_vocal/src/domain/voice_contracts.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/telnyx_media.dart';
import 'package:api_agent_vocal/src/infrastructure/telnyx/telnyx_webhook_verifier.dart';
import 'package:api_agent_vocal/src/presentation/authenticated_request.dart';
import 'package:api_agent_vocal/src/presentation/request_telemetry.dart';
import 'package:csv/csv.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// HTTP and WebSocket transport for the `/v1` backend contract.
final class ApiRouter {
  ApiRouter({
    required this.backend,
    CallEligibilityService eligibility = const CallEligibilityService(),
    CoachingProgressService? coachingProgress,
    WorkspacePrivacyService? privacy,
    RequestTelemetry? requestTelemetry,
    int retentionDays = 90,
  }) : _eligibility = eligibility,
       _coachingProgress =
           coachingProgress ?? CoachingProgressService(store: backend.store),
       _privacy =
           privacy ??
           WorkspacePrivacyService(
             store: backend.store,
             activityProbe: _BackendPrivacyActivityProbe(backend),
           ),
       _requestTelemetry = requestTelemetry ?? RequestTelemetry(),
       _retentionDays = retentionDays {
    if (retentionDays < 1 || retentionDays > 3650) {
      throw ArgumentError.value(
        retentionDays,
        'retentionDays',
        'must be between 1 and 3650',
      );
    }
    _registerRoutes();
  }

  final PinkallBackend backend;
  final CallEligibilityService _eligibility;
  final CoachingProgressService _coachingProgress;
  final WorkspacePrivacyService _privacy;
  final RequestTelemetry _requestTelemetry;
  final int _retentionDays;
  final Router _router = Router();
  final TelnyxMediaFrameParser _telnyxParser = const TelnyxMediaFrameParser();
  static const int _maxExternalMediaFrameBytes = 64 * 1024;
  // package:web_socket intentionally permits only 1000 and private-use
  // 3000-4999 close codes. Keep protocol errors explicit and portable with a
  // stable Pinkall-owned 4xxx namespace.
  static const int _closeUnsupportedMedia = 4003;
  static const int _closeInvalidMedia = 4007;
  static const int _closeMediaConflict = 4008;
  static const int _closeMediaTooLarge = 4009;
  static const int _closeMediaInternalError = 4011;
  static const int _closeMediaRateLimited = 4013;
  final _BriefingTranscriptionGate _briefingTranscriptionGate =
      _BriefingTranscriptionGate(
        maxConcurrent: 2,
        maxStartsPerWindow: 10,
        window: const Duration(minutes: 1),
      );
  final _ExternalMediaConnectionGate _externalMediaConnectionGate =
      _ExternalMediaConnectionGate(
        maxConcurrent: 8,
        maxStartsPerWindow: 30,
        window: const Duration(minutes: 1),
      );

  /// Complete request handler with safe errors and bearer authentication.
  Handler get handler {
    return Pipeline()
        .addMiddleware(_requestTelemetry.middleware())
        .addMiddleware(_privacyCacheControlMiddleware())
        .addMiddleware(_errorMiddleware())
        .addMiddleware(_authenticationMiddleware())
        .addHandler(_router.call);
  }

  void _registerRoutes() {
    _router
      ..get('/health', _publicHealth)
      ..get('/v1/health', _health)
      ..get('/v1/me', _getCurrentPrincipal)
      ..get('/v1/config', _config)
      ..get('/v1/metrics', _metrics)
      ..get('/v1/privacy/export', _exportWorkspaceData)
      ..get('/v1/privacy/retention', _previewRetention)
      ..post('/v1/privacy/retention/apply', _applyRetention)
      ..delete('/v1/privacy/workspace-data', _deleteWorkspaceData)
      ..get('/v1/coaching/progress', _getCoachingProgress)
      ..get('/v1/coaching/objections', _listObjections)
      ..post('/v1/coaching/objections', _createCustomObjection)
      ..get('/v1/workspace/sales-context', _getWorkspaceSalesContext)
      ..put('/v1/workspace/sales-context', _putWorkspaceSalesContext)
      ..post('/v1/briefings/transcriptions', _transcribeBriefing)
      ..post('/v1/voice/token', _issueVoiceToken)
      ..get('/v1/events', _workspaceEventsWebSocket)
      ..get('/v1/sessions/active', _listActiveSessions)
      ..get('/v1/sessions', _listSessions)
      ..post('/v1/sessions', _createSession)
      ..post('/v1/sessions/external', _createExternalSession)
      ..get('/v1/sessions/<sessionId>', _getSession)
      ..post('/v1/sessions/<sessionId>/cancel', _cancelPendingDial)
      ..post(
        '/v1/sessions/<sessionId>/transcription-consent',
        _acknowledgeTranscriptionConsent,
      )
      ..post('/v1/sessions/<sessionId>/finalize', _finalizeSession)
      ..patch('/v1/sessions/<sessionId>/coach-mode', _setCoachMode)
      ..get('/v1/sessions/<sessionId>/events', _clientEventsWebSocket)
      ..get('/v1/sessions/<sessionId>/events/sse', _clientEventsSse)
      ..get('/v1/sessions/<sessionId>/transcript/final', _finalTranscript)
      ..get('/v1/sessions/<sessionId>/debrief', _postCallDebrief)
      ..get('/v1/sessions/<sessionId>/media/client', _clientMediaWebSocket)
      ..post('/v1/telnyx/webhooks', _telnyxWebhook)
      ..get('/v1/telnyx/media/<sessionId>', _telnyxMediaWebSocket)
      ..post('/v1/recording-imports', _createRecordingImport)
      ..get('/v1/recording-imports/<importId>', _getRecordingImport)
      ..put('/v1/recording-imports/<importId>/audio', _uploadRecordingImport)
      ..post(
        '/v1/recording-imports/<importId>/speaker-assignment',
        _assignRecordingImportSpeaker,
      )
      ..get('/v1/contacts', _listContacts)
      ..post('/v1/contacts', _createContact)
      ..post('/v1/contacts/import', _importContacts)
      ..post('/v1/call-eligibility/evaluate', _evaluateCallEligibility)
      ..get('/v1/coach/preferences/me', _getCoachPreferences)
      ..put('/v1/coach/preferences/me', _putCoachPreferences)
      ..post('/v1/coaching/feedback', _recordCoachingFeedback)
      ..put('/v1/sessions/<sessionId>/outcome', _setOutcome);
  }

  Response _publicHealth(Request request) {
    final bool ready =
        backend.config.validationErrors.isEmpty &&
        backend.sttProvider.isConfigured &&
        backend.store.isReady;
    return _jsonResponse(
      <String, Object?>{'status': ready ? 'ok' : 'degraded', 'ready': ready},
      statusCode: ready ? HttpStatus.ok : HttpStatus.serviceUnavailable,
      additionalHeaders: const <String, String>{
        HttpHeaders.cacheControlHeader: 'no-store',
      },
    );
  }

  Response _health(Request request) {
    final List<String> errors = backend.config.validationErrors;
    final bool ready =
        errors.isEmpty &&
        backend.sttProvider.isConfigured &&
        backend.store.isReady;
    return _jsonResponse(<String, Object?>{
      'status': ready ? 'ok' : 'degraded',
      'ready': ready,
      'storage': backend.store.storageDescription,
      'durability': <String, Object?>{
        'durable': backend.store.isDurable,
        'ready': backend.store.isReady,
        'failure_code': backend.store.durabilityFailureCode,
        'live_audio_resumable': false,
      },
      'stt': <String, Object?>{
        'provider': backend.sttProvider.name,
        'configured': backend.sttProvider.isConfigured,
      },
      'voice': <String, Object?>{
        'provider': 'telnyx',
        'token_issuer_configured': backend.voiceTokenProvider.isConfigured,
        'outbound_call_control_configured': backend.outboundCalls.isConfigured,
      },
      'coach': <String, Object?>{
        'optional': true,
        'configured': backend.coachGateway.isConfigured,
        'catalog_available': backend.coachCatalog.isAvailable,
        'release_channel': backend.coachCatalog.releaseChannel.wireName,
        'unreviewed_cards_enabled':
            backend.coachCatalog.allowsUnreviewedRecommendations,
      },
      'post_call': <String, Object?>{
        'optional': true,
        'configured': backend.postCallGateway.isConfigured,
      },
      'recording_import': <String, Object?>{
        'optional': true,
        'provider': backend.recordingImports.transcriptionProvider.name,
        'configured': backend.recordingImports.isConfigured,
        'raw_audio_durable': false,
      },
      'configuration_errors': errors,
    }, statusCode: ready ? HttpStatus.ok : HttpStatus.serviceUnavailable);
  }

  Response _config(Request request) {
    return _jsonResponse(backend.config.toSanitizedJson());
  }

  Response _getCurrentPrincipal(Request request) {
    final AuthPrincipal principal = request.authPrincipal;
    return _jsonResponse(<String, Object?>{
      'user_id': principal.userId,
      'workspace_id': principal.workspaceId,
      'membership_role': principal.membershipRole.name,
      'auth_mode': principal.mode.wireName,
      'storage_scope': 'single_snapshot_workspace',
    });
  }

  Response _metrics(Request request) {
    return _jsonResponse(<String, Object?>{
      ...backend.store.metrics().toJson(),
      'live_coach_latency': backend.sessions.liveCoachLatencyMetrics(),
    });
  }

  Response _exportWorkspaceData(Request request) {
    final AuthPrincipal principal = request.authPrincipal;
    final Map<String, Object?> payload = _privacy.exportForUser(
      userId: _preferenceUserId(principal),
      workspaceId: principal.workspaceId,
      generatedAt: DateTime.now().toUtc(),
    );
    final String date = DateTime.now()
        .toUtc()
        .toIso8601String()
        .split('T')
        .first;
    return _jsonResponse(
      payload,
      additionalHeaders: <String, String>{
        'content-disposition':
            'attachment; filename="pinkall-workspace-$date.json"',
      },
    );
  }

  Response _previewRetention(Request request) {
    final Response? denied = _requireWorkspaceAdmin(request);
    if (denied != null) {
      return denied;
    }
    return _jsonResponse(
      _privacy.previewRetention(
        retentionDays: _retentionDays,
        now: DateTime.now().toUtc(),
      ),
    );
  }

  Future<Response> _applyRetention(Request request) async {
    final Response? denied = _requireWorkspaceAdmin(request);
    if (denied != null) {
      return denied;
    }
    final Response? userAuthDenied = _requireUserAuthForDestructivePrivacy(
      request,
    );
    if (userAuthDenied != null) {
      return userAuthDenied;
    }
    final Map<String, Object?> body = await _jsonBody(request);
    final String expectedConfirmation = 'APPLY $_retentionDays DAY RETENTION';
    if (_requiredText(body, 'confirmation') != expectedConfirmation) {
      return _errorResponse(
        'privacy_confirmation_invalid',
        'The retention confirmation does not match the active policy.',
        HttpStatus.badRequest,
      );
    }
    return _jsonResponse(
      await _privacy.applyRetention(
        retentionDays: _retentionDays,
        now: DateTime.now().toUtc(),
      ),
    );
  }

  Future<Response> _deleteWorkspaceData(Request request) async {
    final AuthPrincipal principal = request.authPrincipal;
    if (principal.membershipRole != WorkspaceMembershipRole.owner) {
      return _errorResponse(
        'forbidden',
        'Only a workspace owner can delete workspace data.',
        HttpStatus.forbidden,
      );
    }
    final Response? userAuthDenied = _requireUserAuthForDestructivePrivacy(
      request,
    );
    if (userAuthDenied != null) {
      return userAuthDenied;
    }
    final Map<String, Object?> body = await _jsonBody(request);
    await _privacy.deleteWorkspaceData(
      confirmation: _requiredText(body, 'confirmation'),
    );
    return _jsonResponse(<String, Object?>{
      'deleted': true,
      'workspace_id': principal.workspaceId,
      'auth_identity_deleted': false,
      'external_provider_deletion_requested': false,
    });
  }

  static Response? _requireWorkspaceAdmin(Request request) {
    final WorkspaceMembershipRole role = request.authPrincipal.membershipRole;
    if (role == WorkspaceMembershipRole.owner ||
        role == WorkspaceMembershipRole.admin) {
      return null;
    }
    return _errorResponse(
      'forbidden',
      'Workspace administrator access is required.',
      HttpStatus.forbidden,
    );
  }

  static Response? _requireUserAuthForDestructivePrivacy(Request request) {
    if (request.authPrincipal.mode == AuthMode.supabaseJwt) {
      return null;
    }
    return _errorResponse(
      'user_auth_required',
      'Destructive privacy operations require an authenticated user session.',
      HttpStatus.forbidden,
    );
  }

  static String _preferenceUserId(AuthPrincipal principal) {
    // Preserve the pre-auth POC snapshot key during the compatibility phase.
    return principal.mode == AuthMode.pocBearer ? 'me' : principal.userId;
  }

  Response _getWorkspaceSalesContext(Request request) {
    return _jsonResponse(<String, Object?>{
      'data': backend.sessions.workspaceSalesContext?.toJson(),
    });
  }

  Future<Response> _putWorkspaceSalesContext(Request request) async {
    final Map<String, Object?> body = await _jsonBody(request);
    final WorkspaceSalesContext context = backend.sessions
        .upsertWorkspaceSalesContext(
          companyName: _requiredText(body, 'company_name'),
          productName: _requiredText(body, 'product_name'),
          pitchMarkdown: _requiredText(body, 'pitch_markdown'),
          expectedRevision: _expectedRevision(body['expected_revision']),
        );
    await backend.store.flush();
    return _jsonResponse(<String, Object?>{'data': context.toJson()});
  }

  Future<Response> _transcribeBriefing(Request request) async {
    if (!backend.sttProvider.isConfigured) {
      return _errorResponse(
        'stt_not_configured',
        'Speech-to-text is temporarily unavailable.',
        HttpStatus.serviceUnavailable,
      );
    }
    final _BriefingTranscriptionPermit? permit = _briefingTranscriptionGate
        .tryAcquire(DateTime.now().toUtc());
    if (permit == null) {
      return _jsonResponse(
        const <String, Object?>{
          'error': <String, Object?>{
            'code': 'briefing_transcription_rate_limited',
            'message': 'Too many briefing transcriptions. Retry shortly.',
          },
        },
        statusCode: HttpStatus.tooManyRequests,
        additionalHeaders: const <String, String>{'retry-after': '60'},
      );
    }

    try {
      final Map<String, String> query = request.requestedUri.queryParameters;
      final String encoding = query['encoding'] ?? 'pcm_s16le';
      if (encoding != 'pcm_s16le') {
        throw UnsupportedError(
          'Briefing dictation requires pcm_s16le mono audio.',
        );
      }
      final int? sampleRate = int.tryParse(query['sample_rate'] ?? '16000');
      if (sampleRate == null ||
          !const <int>{
            8000,
            16000,
            24000,
            32000,
            44100,
            48000,
          }.contains(sampleRate)) {
        throw const FormatException(
          'sample_rate must be a supported speech sample rate.',
        );
      }
      final Uint8List pcmBytes = await _boundedBytesBody(
        request,
        maxBytes: 10 * 1024 * 1024,
      );
      if (pcmBytes.isEmpty) {
        throw const FormatException('Briefing audio cannot be empty.');
      }

      final BatchTranscript transcript = await backend.sttProvider
          .transcribeFinal(
            pcmBytes: pcmBytes,
            audioFormat: SttAudioFormat(
              encoding: encoding,
              sampleRate: sampleRate,
            ),
            fileName: 'pinkall-briefing.wav',
          );
      final String text = transcript.text.trim().isNotEmpty
          ? transcript.text.trim()
          : transcript.segments
                .map((BatchTranscriptSegment segment) => segment.text.trim())
                .where((String value) => value.isNotEmpty)
                .join(' ');
      if (text.isEmpty) {
        throw const FormatException(
          'No speech was detected in the briefing audio.',
        );
      }
      return _jsonResponse(<String, Object?>{
        'text': text,
        'language': transcript.language,
        'provider': transcript.provider,
      });
    } finally {
      permit.release();
    }
  }

  Future<Response> _issueVoiceToken(Request request) async {
    if (!backend.voiceTokenProvider.isConfigured) {
      return _errorResponse(
        'voice_not_configured',
        'Telnyx Voice token issuance is not configured.',
        HttpStatus.serviceUnavailable,
      );
    }
    final Map<String, Object?> body = await _jsonBody(request);
    final VoiceAccessToken access = await backend.voiceTokenProvider.issue(
      deviceId: _requiredText(body, 'device_id'),
    );
    return _jsonResponse(access.toJson(), statusCode: HttpStatus.created);
  }

  Response _listSessions(Request request) {
    return _jsonResponse(<String, Object?>{
      'data': backend.store
          .listSessions()
          .map((CallSessionSnapshot session) => session.toJson())
          .toList(growable: false),
      'storage': backend.store.storageDescription,
    });
  }

  Response _getCoachingProgress(Request request) {
    final AuthPrincipal principal = request.authPrincipal;
    final int windowSize = _boundedQueryInt(
      request,
      key: 'window',
      fallback: 5,
      minimum: 1,
      maximum: 20,
    );
    final int recentLimit = _boundedQueryInt(
      request,
      key: 'limit',
      fallback: 20,
      minimum: 1,
      maximum: 50,
    );
    final CoachingProgressSnapshot progress = _coachingProgress.build(
      windowSize: windowSize,
      recentLimit: recentLimit,
    );
    return _jsonResponse(<String, Object?>{
      ...progress.toJson(),
      'scope': 'single_snapshot_workspace',
      'workspace_id': principal.workspaceId,
      'auth_mode': principal.mode.wireName,
      'rubric_version': PostCallDebrief.currentPerformanceRubricVersion,
      'storage': backend.store.storageDescription,
    });
  }

  Response _listObjections(Request request) {
    if (!backend.objectionLibrary.isAvailable) {
      return _errorResponse(
        'objection_library_unavailable',
        backend.objectionLibrary.unavailableReason ??
            'The objection library is not configured.',
        HttpStatus.serviceUnavailable,
      );
    }
    return _jsonResponse(<String, Object?>{
      'items': backend.objectionLibrary
          .listEntries()
          .map((ObjectionKnowledgeEntry entry) => entry.toJson())
          .toList(growable: false),
      'storage': 'local_file_single_instance',
    });
  }

  Future<Response> _createCustomObjection(Request request) async {
    if (!backend.objectionLibrary.isAvailable) {
      return _errorResponse(
        'objection_library_unavailable',
        backend.objectionLibrary.unavailableReason ??
            'The objection library is not configured.',
        HttpStatus.serviceUnavailable,
      );
    }
    final Map<String, Object?> body = await _jsonBody(request);
    final ObjectionKnowledgeEntry entry = await backend.objectionLibrary
        .addCustom(
          CreateCustomObjection(
            category: _requiredText(body, 'category'),
            text: _requiredText(body, 'text'),
            responseContent: _requiredText(body, 'response_content'),
            responseSourceType:
                _optionalText(body['response_source_type']) ?? 'text',
            responseSourceName: _optionalText(body['response_source_name']),
          ),
        );
    return _jsonResponse(entry.toJson(), statusCode: HttpStatus.created);
  }

  Response _listActiveSessions(Request request) {
    final AuthPrincipal principal = request.authPrincipal;
    return _jsonResponse(<String, Object?>{
      'items': backend.store
          .listActiveSessions()
          .map((CallSessionSnapshot session) => session.toJson())
          .toList(growable: false),
      'scope': 'single_snapshot_workspace',
      'workspace_id': principal.workspaceId,
      'auth_mode': principal.mode.wireName,
      'storage': backend.store.storageDescription,
    });
  }

  Response _getSession(Request request, String sessionId) {
    final CallSessionSnapshot? session = backend.store.session(sessionId);
    if (session == null) {
      throw StateError('Session not found: $sessionId');
    }
    return _jsonResponse(session.toJson());
  }

  FutureOr<Response> _workspaceEventsWebSocket(Request request) {
    final Handler socketHandler = webSocketHandler((
      WebSocketChannel channel,
      String? protocol,
    ) {
      channel.sink.add(
        jsonEncode(<String, Object?>{
          'type': 'workspace.snapshot',
          'at': DateTime.now().toUtc().toIso8601String(),
          'data': <String, Object?>{
            'active_sessions': backend.store
                .listActiveSessions()
                .map((CallSessionSnapshot session) => session.toJson())
                .toList(growable: false),
          },
        }),
      );
      final StreamSubscription<ClientEvent> subscription = backend.store
          .workspaceEvents()
          .listen((ClientEvent event) => channel.sink.add(event.encode()));
      channel.stream.listen(
        (_) {},
        onDone: () => unawaited(subscription.cancel()),
        onError: (Object _) => unawaited(subscription.cancel()),
      );
    });
    return socketHandler(request);
  }

  Future<Response> _createSession(Request request) async {
    final Map<String, Object?> body = await _optionalJsonBody(request);
    final String? requestedCoachMode =
        _optionalText(body['coach_mode_override']) ??
        _optionalText(body['coach_mode']);
    final CoachMode mode = requestedCoachMode != null
        ? CoachMode.tryParse(requestedCoachMode)
        : backend.config.defaultCoachMode;
    final MediaTrack sellerTrack = body['seller_track'] is String
        ? MediaTrack.parse(body['seller_track']! as String)
        : MediaTrack.outbound;
    final CallSessionSnapshot session = backend.sessions.createSession(
      callId: _requiredText(body, 'call_id'),
      destinationNumber: _requiredText(body, 'destination_number'),
      contactId: _optionalText(body['contact_id']),
      preparationMarkdown: _optionalPreparationMarkdown(
        body['preparation_markdown'],
      ),
      coachMode: mode,
      sellerTrack: sellerTrack,
    );
    await backend.store.flush();
    return _jsonResponse(<String, Object?>{
      ...session.toJson(),
      'media_stream_url': _mediaStreamUrl(session),
      'storage': backend.store.storageDescription,
    }, statusCode: HttpStatus.created);
  }

  Future<Response> _createExternalSession(Request request) async {
    final Map<String, Object?> body = await _jsonBody(request);
    if (_requiredText(body, 'source') != 'macos_meeting') {
      throw const FormatException('source must be macos_meeting.');
    }
    final String? title = _optionalText(body['title']);
    if (title != null && title.runes.length > 200) {
      throw const FormatException('title must not exceed 200 characters.');
    }
    final String locale = _optionalText(body['locale']) ?? 'fr-FR';
    if (locale.length > 35 ||
        !RegExp(r'^[A-Za-z]{2,3}(?:-[A-Za-z0-9]{2,8})*$').hasMatch(locale)) {
      throw const FormatException('locale must be a valid BCP 47 tag.');
    }
    final String? requestedCoachMode =
        _optionalText(body['coach_mode_override']) ??
        _optionalText(body['coach_mode']);
    final CoachMode mode = requestedCoachMode != null
        ? CoachMode.tryParse(requestedCoachMode)
        : backend.config.defaultCoachMode;
    final CallSessionSnapshot session = backend.sessions.createExternalSession(
      title: title,
      preparationMarkdown: _optionalPreparationMarkdown(
        body['preparation_markdown'],
      ),
      coachMode: mode,
    );
    await backend.store.flush();
    final String mediaPath = '/v1/sessions/${session.id}/media/client';
    return _jsonResponse(<String, Object?>{
      ...session.toJson(includeMediaCredentials: true),
      'source': 'macos_meeting',
      'title': title,
      'locale': locale,
      'media_websocket_path': mediaPath,
      'media': <String, Object?>{
        'encoding': 'pcm_s16le',
        'sample_rate': 16000,
        'channels': 1,
        'seller_websocket_url': _clientMediaUrl(session, clientTrack: 'seller'),
        'prospect_websocket_url': _clientMediaUrl(
          session,
          clientTrack: 'prospect',
        ),
      },
      'consent_required': !session.transcriptionAllowed,
      'storage': backend.store.storageDescription,
    }, statusCode: HttpStatus.created);
  }

  Future<Response> _createRecordingImport(Request request) async {
    final Map<String, Object?> body = await _jsonBody(request);
    if (_requiredText(body, 'source') != 'recording_import') {
      throw const FormatException('source must be recording_import.');
    }
    final String? title = _optionalText(body['title']);
    if (title != null && title.runes.length > 200) {
      throw const FormatException('title must not exceed 200 characters.');
    }
    final String locale = _optionalText(body['locale']) ?? 'fr-FR';
    if (locale.length > 35 ||
        !RegExp(r'^[A-Za-z]{2,3}(?:-[A-Za-z0-9]{2,8})*$').hasMatch(locale)) {
      throw const FormatException('locale must be a valid BCP 47 tag.');
    }
    final Object? rawSize = body['size_bytes'];
    if (rawSize is! int) {
      throw const FormatException('size_bytes must be an integer.');
    }
    final RecordingImportSnapshot snapshot = await backend.recordingImports
        .create(
          fileName: _requiredText(body, 'file_name'),
          mimeType: _requiredText(body, 'mime_type'),
          sizeBytes: rawSize,
          title: title,
          locale: locale,
          preparationMarkdown: _optionalPreparationMarkdown(
            body['preparation_markdown'],
          ),
        );
    return _jsonResponse(
      _recordingImportDto(snapshot),
      statusCode: HttpStatus.created,
    );
  }

  Response _getRecordingImport(Request request, String importId) {
    return _jsonResponse(
      _recordingImportDto(backend.recordingImports.get(importId)),
    );
  }

  Future<Response> _uploadRecordingImport(
    Request request,
    String importId,
  ) async {
    final String? contentType = request.headers[HttpHeaders.contentTypeHeader];
    if (contentType == null || contentType.trim().isEmpty) {
      throw const RecordingImportException(
        code: 'unsupported_media',
        message: 'Content-Type is required for the recording upload.',
        retryable: true,
      );
    }
    final String? rawLength = request.headers[HttpHeaders.contentLengthHeader]
        ?.trim();
    final int? contentLength = rawLength == null
        ? null
        : int.tryParse(rawLength);
    if (rawLength != null && contentLength == null) {
      throw const FormatException('Content-Length must be an integer.');
    }
    final RecordingImportSnapshot snapshot = await backend.recordingImports
        .upload(
          importId: importId,
          mimeType: contentType,
          contentLength: contentLength,
          bytes: request.read(),
        );
    return _jsonResponse(
      _recordingImportDto(snapshot),
      statusCode: HttpStatus.accepted,
    );
  }

  Future<Response> _assignRecordingImportSpeaker(
    Request request,
    String importId,
  ) async {
    final Map<String, Object?> body = await _jsonBody(request);
    final RecordingImportSnapshot snapshot = await backend.recordingImports
        .assignUserVoice(
          importId: importId,
          userVoice: _requiredText(body, 'user_voice'),
        );
    return _jsonResponse(_recordingImportDto(snapshot));
  }

  Map<String, Object?> _recordingImportDto(RecordingImportSnapshot snapshot) {
    return <String, Object?>{
      ...snapshot.toJson(),
      'upload_url': '/v1/recording-imports/${snapshot.id}/audio',
      'consent_required':
          backend.store.session(snapshot.sessionId)?.transcriptionAllowed !=
          true,
      'max_size_bytes': RecordingImportService.maxSizeBytes,
      'max_duration_seconds': RecordingImportService.maxDurationSeconds,
      'max_encoded_bitrate_bps':
          RecordingImportService.maxEncodedBitrateBitsPerSecond,
      'accepted_mime_types': RecordingImportService.acceptedMimeTypes,
      'failure_code': snapshot.failure?.code,
      'failure_reason': snapshot.failure?.message,
      'failure_retryable': snapshot.failure?.retryable,
    };
  }

  Future<Response> _acknowledgeTranscriptionConsent(
    Request request,
    String sessionId,
  ) async {
    final Map<String, Object?> body = await _jsonBody(request);
    if (body['acknowledged'] != true) {
      throw const FormatException('acknowledged must be true.');
    }
    final String method = _requiredText(body, 'method');
    if (!const <String>{
      'verbal_notice',
      'automated_notice',
      'contractual',
    }.contains(method)) {
      throw const FormatException('method is invalid.');
    }
    final String? requestSessionId = _optionalText(body['session_id']);
    if (requestSessionId != null && requestSessionId != sessionId) {
      throw const FormatException('session_id does not match the URL.');
    }
    final DateTime acknowledgedAt =
        DateTime.tryParse(
          _optionalText(body['acknowledged_at']) ??
              _requiredText(body, 'timestamp'),
        )?.toUtc() ??
        (throw const FormatException('acknowledged_at must be ISO-8601.'));
    backend.sessions.acknowledgeTranscriptionConsent(
      sessionId: sessionId,
      method: method,
      acknowledgedAt: acknowledgedAt,
    );
    await backend.store.flush();
    return _jsonResponse(<String, Object?>{
      'session_id': sessionId,
      'acknowledged': true,
      'method': method,
      'acknowledged_at': acknowledgedAt.toIso8601String(),
    });
  }

  Future<Response> _finalizeSession(Request request, String sessionId) async {
    await backend.sessions.finalize(sessionId);
    PostCallDebrief? debrief = backend.store.postCallDebrief(sessionId);
    String debriefStatus = debrief != null ? 'completed' : 'unavailable';
    Map<String, Object?>? debriefError;
    if (backend.postCalls.isConfigured) {
      try {
        debrief = await backend.postCalls.generate(sessionId);
        debriefStatus = 'completed';
      } on DurabilityException {
        rethrow;
      } on Object catch (error) {
        debriefStatus = 'failed';
        debriefError = _postCallFailureDiagnostic(error);
        stderr.writeln(
          'Post-call generation failed for $sessionId: ${error.runtimeType}',
        );
      }
    } else if (debrief == null) {
      await backend.postCalls.markUnavailable(sessionId);
    }
    return _jsonResponse(<String, Object?>{
      ...backend.store.session(sessionId)!.toJson(),
      'debrief_status': debriefStatus,
      if (debriefError != null) 'debrief_error': debriefError,
    });
  }

  Future<Response> _cancelPendingDial(Request request, String sessionId) async {
    final CallSessionSnapshot session = backend.sessions.cancelPendingDial(
      sessionId,
    );
    await backend.store.flush();
    return _jsonResponse(session.toJson());
  }

  Future<Response> _setCoachMode(Request request, String sessionId) async {
    final Map<String, Object?> body = await _jsonBody(request);
    final CoachMode mode = CoachMode.tryParse(_requiredText(body, 'mode'));
    final CallSessionSnapshot session = backend.sessions.setCoachMode(
      sessionId,
      mode,
    );
    await backend.store.flush();
    return _jsonResponse(session.toJson());
  }

  Response _finalTranscript(Request request, String sessionId) {
    final CallSessionSnapshot? session = backend.store.session(sessionId);
    if (session == null) {
      throw StateError('Session not found: $sessionId');
    }
    final List<TranscriptSegment>? transcript = backend.store.finalTranscript(
      sessionId,
    );
    if (transcript == null) {
      throw StateError(
        'Final transcript is not available for session $sessionId.',
      );
    }
    final DateTime baseTime = session.startedAt ?? session.createdAt;
    return _jsonResponse(<String, Object?>{
      'session_id': sessionId,
      'segments': transcript.indexed
          .map(
            ((int, TranscriptSegment) item) => item.$2.toClientJson(
              sessionId: sessionId,
              sequence: item.$1 + 1,
              sessionStartedAt: baseTime,
            ),
          )
          .toList(growable: false),
      'finalized_at': session.updatedAt.toUtc().toIso8601String(),
      'language_code': null,
    });
  }

  Response _postCallDebrief(Request request, String sessionId) {
    if (backend.store.session(sessionId) == null) {
      throw StateError('Session not found: $sessionId');
    }
    final PostCallDebrief? debrief = backend.store.postCallDebrief(sessionId);
    if (debrief == null) {
      throw StateError(
        'Post-call debrief is not available for session $sessionId.',
      );
    }
    return _jsonResponse(debrief.toJson());
  }

  static Map<String, Object?> _postCallFailureDiagnostic(Object error) {
    final (String, bool) diagnostic = switch (error) {
      PostCallGatewayException() => (
        RegExp(r'^[a-z0-9_]{1,64}$').hasMatch(error.code)
            ? error.code
            : 'generation_failed',
        error.retryable,
      ),
      HttpException() => ('upstream_provider_error', false),
      FormatException() => ('invalid_provider_response', false),
      StateError() => ('generation_conflict', false),
      _ => ('generation_failed', false),
    };
    return <String, Object?>{
      'code': diagnostic.$1,
      'message': 'Le débrief automatique a échoué. Réessayez plus tard.',
      'retryable': diagnostic.$2,
    };
  }

  FutureOr<Response> _clientEventsWebSocket(Request request, String sessionId) {
    final CallSessionSnapshot? session = backend.store.session(sessionId);
    if (session == null) {
      throw StateError('Session not found: $sessionId');
    }
    final Handler socketHandler = webSocketHandler((
      WebSocketChannel channel,
      String? protocol,
    ) {
      channel.sink.add(
        ClientEvent(
          type: 'session_state',
          sessionId: sessionId,
          at: DateTime.now().toUtc(),
          data: session.toJson(),
        ).encode(),
      );
      final StreamSubscription<ClientEvent> subscription = backend.store
          .events(sessionId)
          .listen((ClientEvent event) => channel.sink.add(event.encode()));
      channel.stream.listen(
        (_) {},
        onDone: () => unawaited(subscription.cancel()),
        onError: (Object _) => unawaited(subscription.cancel()),
      );
    });
    return socketHandler(request);
  }

  Response _clientEventsSse(Request request, String sessionId) {
    final CallSessionSnapshot? session = backend.store.session(sessionId);
    if (session == null) {
      throw StateError('Session not found: $sessionId');
    }
    late final StreamSubscription<ClientEvent> subscription;
    late final Timer heartbeat;
    late final StreamController<List<int>> controller;
    controller = StreamController<List<int>>(
      onListen: () {
        controller.add(
          utf8.encode(
            'event: session.snapshot\ndata: '
            '${jsonEncode(session.toJson())}\n\n',
          ),
        );
        subscription = backend.store
            .events(sessionId)
            .listen(
              (ClientEvent event) => controller.add(
                utf8.encode(
                  'event: ${event.type}\ndata: ${event.encode()}\n\n',
                ),
              ),
            );
        heartbeat = Timer.periodic(
          const Duration(seconds: 20),
          (_) => controller.add(utf8.encode(': heartbeat\n\n')),
        );
      },
      onCancel: () async {
        heartbeat.cancel();
        await subscription.cancel();
      },
    );
    return Response.ok(
      controller.stream,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'text/event-stream; charset=utf-8',
        HttpHeaders.cacheControlHeader: 'no-cache, no-transform',
        HttpHeaders.connectionHeader: 'keep-alive',
      },
    );
  }

  FutureOr<Response> _telnyxMediaWebSocket(Request request, String sessionId) {
    final String token = request.requestedUri.queryParameters['token'] ?? '';
    if (!backend.store.validateMediaToken(sessionId, token)) {
      return _jsonResponse(const <String, Object?>{
        'error': 'invalid_media_credential',
      }, statusCode: HttpStatus.unauthorized);
    }
    final Handler socketHandler = webSocketHandler((
      WebSocketChannel channel,
      String? protocol,
    ) {
      unawaited(_consumeTelnyxStream(channel, sessionId));
    });
    return socketHandler(request);
  }

  FutureOr<Response> _clientMediaWebSocket(Request request, String sessionId) {
    final String token = request.requestedUri.queryParameters['token'] ?? '';
    if (!backend.store.validateMediaToken(sessionId, token)) {
      return _jsonResponse(const <String, Object?>{
        'error': 'invalid_media_credential',
      }, statusCode: HttpStatus.unauthorized);
    }
    if (!backend.sessions.isExternalSession(sessionId)) {
      return _errorResponse(
        'external_media_session_required',
        'This session was not created for client-captured media.',
        HttpStatus.conflict,
      );
    }
    final String? clientTrack = _optionalText(
      request.requestedUri.queryParameters['track'],
    );
    final MediaTrack? track = switch (clientTrack) {
      'seller' => MediaTrack.outbound,
      'prospect' => MediaTrack.inbound,
      _ => null,
    };
    if (track == null) {
      return _errorResponse(
        'invalid_media_track',
        'track must be seller or prospect.',
        HttpStatus.badRequest,
      );
    }
    if (request.requestedUri.queryParameters['sample_rate'] != '16000') {
      return _errorResponse(
        'unsupported_media_format',
        'sample_rate must be 16000.',
        HttpStatus.unprocessableEntity,
      );
    }
    final Handler socketHandler = webSocketHandler((
      WebSocketChannel channel,
      String? protocol,
    ) {
      final _ExternalMediaConnectionPermit? permit =
          _externalMediaConnectionGate.tryAcquire(DateTime.now().toUtc());
      if (permit == null) {
        unawaited(
          channel.sink.close(
            _closeMediaRateLimited,
            'media_connection_rate_limited',
          ),
        );
        return;
      }
      unawaited(
        _consumeClientMediaStream(
          channel,
          sessionId: sessionId,
          track: track,
        ).whenComplete(permit.release),
      );
    });
    return socketHandler(request);
  }

  Future<void> _consumeClientMediaStream(
    WebSocketChannel channel, {
    required String sessionId,
    required MediaTrack track,
  }) async {
    final _ExternalMediaByteRateGate byteRateGate = _ExternalMediaByteRateGate(
      maxBytesPerWindow: 512 * 1024,
      window: const Duration(seconds: 5),
    );
    bool opened = false;
    try {
      await backend.sessions.beginExternalMediaTrack(sessionId, track);
      opened = true;
      await for (final Object? message in channel.stream) {
        if (message is! List<int>) {
          await channel.sink.close(
            _closeUnsupportedMedia,
            'binary_pcm16_required',
          );
          return;
        }
        if (message.isEmpty || message.length.isOdd) {
          await channel.sink.close(_closeInvalidMedia, 'invalid_pcm16_frame');
          return;
        }
        if (message.length > _maxExternalMediaFrameBytes) {
          await channel.sink.close(
            _closeMediaTooLarge,
            'media_frame_too_large',
          );
          return;
        }
        if (!byteRateGate.tryConsume(message.length, DateTime.now().toUtc())) {
          await channel.sink.close(
            _closeMediaRateLimited,
            'media_byte_rate_limited',
          );
          return;
        }
        await backend.sessions.ingestExternalPcm16(
          sessionId,
          track,
          Uint8List.fromList(message),
        );
      }
    } on FormatException {
      await channel.sink.close(_closeInvalidMedia, 'invalid_pcm16_frame');
    } on StateError catch (error) {
      final bool capacityExceeded = error.message.toString().contains(
        'MAX_SESSION_AUDIO_BYTES',
      );
      await channel.sink.close(
        capacityExceeded ? _closeMediaTooLarge : _closeMediaConflict,
        capacityExceeded ? 'session_audio_limit_reached' : 'media_conflict',
      );
    } on Object catch (error) {
      backend.store.failSession(
        sessionId,
        'External media stream failed: ${error.runtimeType}',
      );
      try {
        await backend.store.flush();
      } on Object catch (durabilityError) {
        stderr.writeln(
          'External media failure durability flush failed for $sessionId: '
          '${durabilityError.runtimeType}',
        );
      }
      await channel.sink.close(_closeMediaInternalError, 'media_stream_failed');
    } finally {
      if (opened) {
        await backend.sessions.endExternalMediaTrack(sessionId, track);
      }
    }
  }

  Future<Response> _telnyxWebhook(Request request) async {
    if (!backend.outboundCalls.isConfigured) {
      return _errorResponse(
        'telnyx_webhook_not_configured',
        'Signed Telnyx outbound Call Control is not configured.',
        HttpStatus.serviceUnavailable,
      );
    }
    final String rawBody = await _boundedRawBody(request);
    try {
      final TelnyxWebhookDisposition disposition = await backend.outboundCalls
          .handleWebhook(
            rawBody: rawBody,
            signature: request.headers['telnyx-signature-ed25519'],
            timestamp: request.headers['telnyx-timestamp'],
          );
      return _jsonResponse(disposition.toJson());
    } on TelnyxWebhookVerificationException catch (error) {
      return _errorResponse(
        'invalid_telnyx_signature',
        error.message,
        HttpStatus.forbidden,
      );
    }
  }

  Future<void> _consumeTelnyxStream(
    WebSocketChannel channel,
    String sessionId,
  ) async {
    bool stopped = false;
    try {
      await for (final Object? message in channel.stream) {
        final TelnyxMediaFrame frame = _telnyxParser.parse(message);
        switch (frame) {
          case TelnyxConnectedFrame():
            // Protocol handshake only. Media metadata arrives in `start`.
            break;
          case TelnyxStartFrame():
            await backend.sessions.beginMedia(sessionId, frame);
          case TelnyxAudioFrame():
            await backend.sessions.ingestAudio(sessionId, frame);
          case TelnyxStopFrame():
            await backend.sessions.endMedia(sessionId);
            stopped = true;
            await channel.sink.close();
            return;
          case TelnyxErrorFrame():
            final String message =
                'Telnyx media error ${frame.code ?? 'unknown'}: '
                        '${frame.title ?? ''} ${frame.detail ?? ''}'
                    .trim();
            backend.store.failSession(sessionId, message);
            await backend.store.flush();
            throw StateError(message);
        }
      }
    } on Object catch (error) {
      backend.store.failSession(sessionId, 'Media stream failed: $error');
      try {
        await backend.store.flush();
      } on Object catch (durabilityError) {
        stderr.writeln(
          'Media failure durability flush failed for $sessionId: '
          '${durabilityError.runtimeType}',
        );
      }
      await channel.sink.close(1011, 'media_stream_failed');
    } finally {
      if (!stopped) {
        await backend.sessions.endMedia(sessionId);
      }
    }
  }

  Response _listContacts(Request request) {
    final String query =
        request.requestedUri.queryParameters['query']?.toLowerCase().trim() ??
        '';
    final Iterable<ContactRecord> contacts = backend.store.contacts().where(
      (ContactRecord contact) =>
          query.isEmpty ||
          contact.phoneNumber.contains(query) ||
          (contact.name?.toLowerCase().contains(query) ?? false) ||
          (contact.company?.toLowerCase().contains(query) ?? false),
    );
    return _jsonResponse(<String, Object?>{
      'items': contacts.map(_contactDto).toList(growable: false),
      'storage': backend.store.storageDescription,
    });
  }

  Future<Response> _createContact(Request request) async {
    final Map<String, Object?> body = await _jsonBody(request);
    final ContactRecord record = _storeContact(body);
    await backend.store.flush();
    return _jsonResponse(_contactDto(record), statusCode: HttpStatus.created);
  }

  Future<Response> _importContacts(Request request) async {
    final Map<String, Object?> body = await _jsonBody(request);
    final List<Map<String, Object?>> rows = _contactImportRows(body);
    final List<String> errors = <String>[];
    int importedCount = 0;
    for (int index = 0; index < rows.length; index += 1) {
      try {
        _storeContact(rows[index]);
        importedCount += 1;
      } on Object catch (error) {
        errors.add('row ${index + 1}: $error');
      }
    }
    await backend.store.flush();
    return _jsonResponse(<String, Object?>{
      'import_id': 'imp_${DateTime.now().toUtc().microsecondsSinceEpoch}',
      'imported_count': importedCount,
      'skipped_count': errors.length,
      'errors': errors,
    });
  }

  Future<Response> _evaluateCallEligibility(Request request) async {
    return _jsonResponse(_eligibility.evaluate(await _jsonBody(request)));
  }

  Response _getCoachPreferences(Request request) {
    final Map<String, Object?> stored = backend.store.coachPreferences(
      _preferenceUserId(request.authPrincipal),
    );
    return _jsonResponse(<String, Object?>{
      'default_mode':
          stored['default_mode'] ?? backend.config.defaultCoachMode.name,
      'updated_at':
          stored['updated_at'] ?? DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<Response> _putCoachPreferences(Request request) async {
    final Map<String, Object?> body = await _jsonBody(request);
    final CoachMode mode = CoachMode.tryParse(
      _requiredText(body, 'default_mode'),
    );
    backend.sessions.validateCoachMode(mode);
    final Map<String, Object?> preference = <String, Object?>{
      'default_mode': mode.name,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
    backend.store.setCoachPreferences(
      _preferenceUserId(request.authPrincipal),
      preference,
    );
    await backend.store.flush();
    return _jsonResponse(preference);
  }

  Future<Response> _recordCoachingFeedback(Request request) async {
    final Map<String, Object?> body = await _jsonBody(request);
    final String sessionId = _requiredText(body, 'session_id');
    if (backend.store.session(sessionId) == null) {
      throw StateError('Session not found: $sessionId');
    }
    final String suggestionId = _requiredText(body, 'suggestion_id');
    final String value = _requiredText(body, 'value');
    const Set<String> allowedValues = <String>{
      'useful',
      'not_useful',
      'incorrect',
      'distracting',
    };
    if (!allowedValues.contains(value)) {
      throw const FormatException('value is invalid.');
    }
    final bool applied = body['applied'] == true;
    final DateTime submittedAt = DateTime.now().toUtc();
    backend.store.recordFeedback(
      suggestionId: suggestionId,
      useful: value == 'useful',
      used: applied,
    );
    await backend.store.flush();
    return _jsonResponse(<String, Object?>{
      'id': 'feedback_${submittedAt.microsecondsSinceEpoch}',
      'session_id': sessionId,
      'suggestion_id': suggestionId,
      'value': value,
      'applied': applied,
      'submitted_at': submittedAt.toIso8601String(),
      'note': _optionalText(body['note']),
    });
  }

  Future<Response> _setOutcome(Request request, String sessionId) async {
    final Map<String, Object?> body = await _jsonBody(request);
    final String type = _requiredText(body, 'type');
    final DateTime recordedAt = DateTime.now().toUtc();
    backend.store.setOutcome(sessionId, type);
    await backend.store.flush();
    return _jsonResponse(<String, Object?>{
      'session_id': sessionId,
      'type': type,
      'recorded_at': recordedAt.toIso8601String(),
      'note': _optionalText(body['note']),
    });
  }

  ContactRecord _storeContact(Map<String, Object?> body) {
    final String phoneNumber = _requiredText(body, 'phone_number');
    if (!RegExp(r'^\+[1-9]\d{6,14}$').hasMatch(phoneNumber)) {
      throw const FormatException('phone_number must be E.164.');
    }
    final Object? customFields = body['custom_fields'];
    final Map<String, Object?> metadata = <String, Object?>{
      'market': _optionalText(body['market']) ?? 'unknown',
      'first_name': _optionalText(body['first_name']),
      'last_name': _optionalText(body['last_name']),
      'job_title': _optionalText(body['job_title']),
      'has_prior_consent': body['has_prior_consent'],
      'has_opted_out': body['has_opted_out'],
      'professional_relevance_confirmed':
          body['professional_relevance_confirmed'],
      'custom_fields': customFields is Map<String, Object?>
          ? customFields
          : const <String, Object?>{},
    };
    return backend.store.addContact(
      phoneNumber: phoneNumber,
      name: _optionalText(body['first_name']) ?? _optionalText(body['name']),
      company: _optionalText(body['company']),
      email: _optionalText(body['email']),
      metadata: metadata,
    );
  }

  Map<String, Object?> _contactDto(ContactRecord contact) {
    final Map<String, Object?> metadata = contact.metadata;
    return <String, Object?>{
      'id': contact.id,
      'phone_number': contact.phoneNumber,
      'market': metadata['market'] ?? 'unknown',
      'created_at': contact.createdAt.toUtc().toIso8601String(),
      'updated_at': contact.createdAt.toUtc().toIso8601String(),
      'first_name': metadata['first_name'] ?? contact.name,
      'last_name': metadata['last_name'],
      'company': contact.company,
      'job_title': metadata['job_title'],
      'email': contact.email,
      'has_prior_consent': metadata['has_prior_consent'],
      'has_opted_out': metadata['has_opted_out'],
      'professional_relevance_confirmed':
          metadata['professional_relevance_confirmed'],
      'custom_fields': metadata['custom_fields'] ?? const <String, String>{},
    };
  }

  List<Map<String, Object?>> _contactImportRows(Map<String, Object?> body) {
    final Object? rawRows = body['rows'];
    if (rawRows is List<Object?>) {
      return rawRows
          .map((Object? row) {
            if (row is! Map<String, Object?>) {
              throw const FormatException(
                'Every import row must be an object.',
              );
            }
            return row;
          })
          .toList(growable: false);
    }
    final String? csv = _optionalText(body['csv']);
    if (csv == null) {
      throw const FormatException('rows is required.');
    }
    final List<List<dynamic>> parsed = const CsvToListConverter(
      shouldParseNumbers: false,
    ).convert(csv);
    if (parsed.isEmpty) {
      throw const FormatException('CSV must contain a header row.');
    }
    final List<String> headers = parsed.first
        .map((dynamic value) => value.toString().trim().toLowerCase())
        .toList(growable: false);
    return parsed
        .skip(1)
        .map((List<dynamic> row) {
          final Map<String, Object?> values = <String, Object?>{};
          for (int column = 0; column < headers.length; column += 1) {
            values[headers[column]] = column < row.length
                ? row[column].toString().trim()
                : '';
          }
          values['phone_number'] =
              values['phone_number'] ?? values['phone'] ?? values['number'];
          return values;
        })
        .toList(growable: false);
  }

  String _mediaStreamUrl(CallSessionSnapshot session) {
    final String path = '/v1/telnyx/media/${session.id}';
    final Map<String, String> query = <String, String>{
      'token': session.mediaToken,
    };
    return _webSocketUrl(path: path, query: query);
  }

  String _clientMediaUrl(
    CallSessionSnapshot session, {
    required String clientTrack,
  }) {
    return _webSocketUrl(
      path: '/v1/sessions/${session.id}/media/client',
      query: <String, String>{
        'track': clientTrack,
        'sample_rate': '16000',
        'token': session.mediaToken,
      },
    );
  }

  String _webSocketUrl({
    required String path,
    required Map<String, String> query,
  }) {
    final String? publicBase = backend.config.publicBaseUrl;
    if (publicBase == null) {
      return Uri(path: path, queryParameters: query).toString();
    }
    final Uri base = Uri.parse(publicBase);
    final String scheme = switch (base.scheme) {
      'https' => 'wss',
      'http' => 'ws',
      'wss' || 'ws' => base.scheme,
      _ => throw const FormatException(
        'PUBLIC_BASE_URL must use http(s) or ws(s).',
      ),
    };
    return base
        .replace(scheme: scheme, path: path, queryParameters: query)
        .toString();
  }

  Middleware _authenticationMiddleware() {
    return (Handler inner) {
      return (Request request) async {
        final String path = request.requestedUri.path;
        if (path == '/health' ||
            path == '/v1/telnyx/webhooks' ||
            path.startsWith('/v1/telnyx/media/') ||
            _isClientMediaPath(path)) {
          return inner(request);
        }
        final String header =
            request.headers[HttpHeaders.authorizationHeader] ?? '';
        final RegExpMatch? match = RegExp(
          r'^Bearer ([^\s]+)$',
          caseSensitive: false,
        ).firstMatch(header.trim());
        if (match == null) {
          return _jsonResponse(const <String, Object?>{
            'error': 'unauthorized',
          }, statusCode: HttpStatus.unauthorized);
        }
        final String? rawWorkspaceId = request.headers['x-pinkall-workspace-id']
            ?.trim();
        final String? requestedWorkspaceId =
            rawWorkspaceId == null || rawWorkspaceId.isEmpty
            ? null
            : rawWorkspaceId;
        try {
          final AuthPrincipal principal = await backend.authentication
              .authenticate(
                token: match.group(1)!,
                requestedWorkspaceId: requestedWorkspaceId,
              );
          return inner(
            request.change(
              context: <String, Object>{authPrincipalContextKey: principal},
            ),
          );
        } on AuthenticationException catch (error) {
          if (error.code == 'auth_not_configured') {
            return _jsonResponse(const <String, Object?>{
              'error': 'api_auth_not_configured',
            }, statusCode: HttpStatus.serviceUnavailable);
          }
          return _jsonResponse(const <String, Object?>{
            'error': 'unauthorized',
          }, statusCode: HttpStatus.unauthorized);
        }
      };
    };
  }

  /// Privacy responses must never enter shared or browser caches, including
  /// authorization failures and conflict diagnostics produced by middleware.
  Middleware _privacyCacheControlMiddleware() {
    return (Handler inner) {
      return (Request request) async {
        final Response response = await inner(request);
        if (!request.requestedUri.path.startsWith('/v1/privacy/')) {
          return response;
        }
        return response.change(
          headers: <String, String>{
            ...response.headers,
            HttpHeaders.cacheControlHeader: 'private, no-store',
            HttpHeaders.pragmaHeader: 'no-cache',
            HttpHeaders.expiresHeader: '0',
            HttpHeaders.varyHeader: 'Authorization, X-Pinkall-Workspace-Id',
          },
        );
      };
    };
  }

  Middleware _errorMiddleware() {
    return (Handler inner) {
      return (Request request) async {
        try {
          return await inner(request);
        } on WorkspaceSalesContextRevisionConflict {
          return _errorResponse(
            'revision_conflict',
            'The sales context changed. Reload it before saving again.',
            HttpStatus.conflict,
          );
        } on WorkspacePrivacyConflict catch (error) {
          return _errorResponse(
            error.code,
            error.message,
            error.code == 'privacy_confirmation_invalid'
                ? HttpStatus.badRequest
                : HttpStatus.conflict,
          );
        } on RecordingImportException catch (error) {
          final int statusCode = switch (error.code) {
            'not_found' => HttpStatus.notFound,
            'provider_unavailable' ||
            'service_unavailable' => HttpStatus.serviceUnavailable,
            'rate_limited' ||
            'upload_rate_limited' => HttpStatus.tooManyRequests,
            'payload_too_large' => HttpStatus.requestEntityTooLarge,
            'unsupported_media' ||
            'mime_type_mismatch' => HttpStatus.unsupportedMediaType,
            'duration_exceeded' ||
            'encoded_bitrate_exceeded' => HttpStatus.unprocessableEntity,
            'invalid_import_state' ||
            'consent_required' ||
            'speaker_assignment_conflict' => HttpStatus.conflict,
            _ => HttpStatus.badRequest,
          };
          return _errorResponse(error.code, error.message, statusCode);
        } on FormatException catch (error) {
          return _errorResponse('invalid_request', error.message, 400);
        } on UnsupportedError catch (error) {
          return _errorResponse(
            'unsupported_media',
            error.message ?? error.toString(),
            422,
          );
        } on StateError catch (error) {
          final bool notFound = error.message.toString().contains('not found');
          return _errorResponse(
            notFound ? 'not_found' : 'conflict',
            error.message.toString(),
            notFound ? 404 : 409,
          );
        } on HttpException catch (error) {
          return _errorResponse('upstream_provider_error', error.message, 502);
        } on DurabilityException catch (error) {
          stderr.writeln(
            '${request.method} ${request.requestedUri.path}: ${error.code}',
          );
          return _errorResponse(
            'durability_unavailable',
            'The durable write did not commit. Retry the request.',
            HttpStatus.serviceUnavailable,
          );
        } on HijackException {
          // A successful WebSocket upgrade deliberately throws this sentinel
          // so shelf_io knows that the handler now owns the socket. Turning it
          // into a JSON 500 makes shelf_io try to answer an already-hijacked
          // request and breaks the media/events channels.
          rethrow;
        } on Object catch (error) {
          stderr.writeln(
            '${request.method} ${request.requestedUri.path}: '
            '${error.runtimeType}',
          );
          return _errorResponse(
            'internal_error',
            'An internal error occurred.',
            500,
          );
        }
      };
    };
  }

  static Future<Map<String, Object?>> _jsonBody(Request request) async {
    final String raw = await _boundedRawBody(request);
    final Object? decoded = jsonDecode(raw);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Request body must be a JSON object.');
    }
    return decoded;
  }

  static Future<String> _boundedRawBody(Request request) async {
    final BytesBuilder bytes = BytesBuilder(copy: false);
    int length = 0;
    await for (final List<int> chunk in request.read()) {
      length += chunk.length;
      if (length > 2 * 1024 * 1024) {
        throw const FormatException('Request body exceeds 2 MiB.');
      }
      bytes.add(chunk);
    }
    try {
      return utf8.decode(bytes.takeBytes());
    } on FormatException {
      throw const FormatException('Request body must be valid UTF-8.');
    }
  }

  static Future<Uint8List> _boundedBytesBody(
    Request request, {
    required int maxBytes,
  }) async {
    final BytesBuilder bytes = BytesBuilder(copy: false);
    int length = 0;
    await for (final List<int> chunk in request.read()) {
      length += chunk.length;
      if (length > maxBytes) {
        throw FormatException(
          'Request body exceeds ${(maxBytes / (1024 * 1024)).floor()} MiB.',
        );
      }
      bytes.add(chunk);
    }
    return bytes.takeBytes();
  }

  static Future<Map<String, Object?>> _optionalJsonBody(Request request) async {
    final String raw = await _boundedRawBody(request);
    if (raw.trim().isEmpty) {
      return <String, Object?>{};
    }
    final Object? decoded = jsonDecode(raw);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Request body must be a JSON object.');
    }
    return decoded;
  }

  static Response _jsonResponse(
    Map<String, Object?> body, {
    int statusCode = HttpStatus.ok,
    Map<String, String> additionalHeaders = const <String, String>{},
  }) {
    return Response(
      statusCode,
      body: jsonEncode(body),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        HttpHeaders.cacheControlHeader: 'no-store',
        ...additionalHeaders,
      },
    );
  }

  static Response _errorResponse(String code, String message, int statusCode) {
    return _jsonResponse(<String, Object?>{
      'error': <String, Object?>{'code': code, 'message': message},
    }, statusCode: statusCode);
  }

  static String _requiredText(Map<String, Object?> source, String key) {
    final String? value = _optionalText(source[key]);
    if (value == null) {
      throw FormatException('$key is required.');
    }
    return value;
  }

  static String? _optionalText(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }

  static int _boundedQueryInt(
    Request request, {
    required String key,
    required int fallback,
    required int minimum,
    required int maximum,
  }) {
    final String? raw = request.url.queryParameters[key];
    if (raw == null || raw.trim().isEmpty) {
      return fallback;
    }
    final int? value = int.tryParse(raw);
    if (value == null || value < minimum || value > maximum) {
      throw FormatException('$key must be between $minimum and $maximum.');
    }
    return value;
  }

  static String? _optionalPreparationMarkdown(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is! String) {
      throw const FormatException('preparation_markdown must be a string.');
    }
    return value;
  }

  static int? _expectedRevision(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is! int || value < 1) {
      throw const FormatException(
        'expected_revision must be a positive integer or null.',
      );
    }
    return value;
  }

  static bool _isClientMediaPath(String path) {
    return RegExp(r'^/v1/sessions/[^/]+/media/client$').hasMatch(path);
  }
}

/// Production privacy probe spanning persistent and process-local writers.
final class _BackendPrivacyActivityProbe
    implements WorkspacePrivacyActivityProbe {
  const _BackendPrivacyActivityProbe(this.backend);

  final PinkallBackend backend;

  @override
  WorkspacePrivacyActivitySnapshot inspect() {
    final Set<String> importSessionIds =
        backend.recordingImports.privacySessionIds;
    final int activeCallSessions = backend.store
        .listActiveSessions()
        .where(
          (CallSessionSnapshot session) =>
              !importSessionIds.contains(session.id),
        )
        .length;
    return WorkspacePrivacyActivitySnapshot(
      activeSessionCount: activeCallSessions,
      activeRecordingImportCount:
          backend.recordingImports.privacyBlockingSessionIds.length,
      activePostCallJobCount:
          backend.postCalls.privacyBlockingSessionIds.length,
    );
  }

  @override
  void pruneOrphanedTransientData() {
    backend.recordingImports.pruneOrphanedPrivacyState();
  }

  @override
  void clearTransientWorkspaceData() {
    backend.recordingImports.clearPrivacyState();
  }
}

/// Small in-process cost guard for the single-workspace snapshot scope.
///
/// Production multi-tenant auth can replace this with a distributed quota
/// keyed by the authenticated workspace without changing the endpoint contract.
final class _BriefingTranscriptionGate {
  _BriefingTranscriptionGate({
    required this.maxConcurrent,
    required this.maxStartsPerWindow,
    required this.window,
  });

  final int maxConcurrent;
  final int maxStartsPerWindow;
  final Duration window;
  final List<DateTime> _startedAt = <DateTime>[];
  int _inFlight = 0;

  _BriefingTranscriptionPermit? tryAcquire(DateTime now) {
    _startedAt.removeWhere(
      (DateTime startedAt) => now.difference(startedAt) >= window,
    );
    if (_inFlight >= maxConcurrent || _startedAt.length >= maxStartsPerWindow) {
      return null;
    }
    _startedAt.add(now);
    _inFlight += 1;
    return _BriefingTranscriptionPermit(() {
      if (_inFlight > 0) {
        _inFlight -= 1;
      }
    });
  }
}

final class _BriefingTranscriptionPermit {
  _BriefingTranscriptionPermit(this._onRelease);

  final void Function() _onRelease;
  bool _released = false;

  void release() {
    if (_released) {
      return;
    }
    _released = true;
    _onRelease();
  }
}

/// Process-local connection quota for client-captured meeting media.
final class _ExternalMediaConnectionGate {
  _ExternalMediaConnectionGate({
    required this.maxConcurrent,
    required this.maxStartsPerWindow,
    required this.window,
  });

  final int maxConcurrent;
  final int maxStartsPerWindow;
  final Duration window;
  final List<DateTime> _startedAt = <DateTime>[];
  int _inFlight = 0;

  _ExternalMediaConnectionPermit? tryAcquire(DateTime now) {
    _startedAt.removeWhere(
      (DateTime startedAt) => now.difference(startedAt) >= window,
    );
    if (_inFlight >= maxConcurrent || _startedAt.length >= maxStartsPerWindow) {
      return null;
    }
    _startedAt.add(now);
    _inFlight += 1;
    return _ExternalMediaConnectionPermit(() {
      if (_inFlight > 0) {
        _inFlight -= 1;
      }
    });
  }
}

final class _ExternalMediaConnectionPermit {
  _ExternalMediaConnectionPermit(this._onRelease);

  final void Function() _onRelease;
  bool _released = false;

  void release() {
    if (_released) {
      return;
    }
    _released = true;
    _onRelease();
  }
}

/// Rolling byte quota that permits short network bursts without unbounded input.
final class _ExternalMediaByteRateGate {
  _ExternalMediaByteRateGate({
    required this.maxBytesPerWindow,
    required this.window,
  });

  final int maxBytesPerWindow;
  final Duration window;
  final List<_ExternalMediaByteSample> _samples = <_ExternalMediaByteSample>[];
  int _bytesInWindow = 0;

  bool tryConsume(int bytes, DateTime now) {
    while (_samples.isNotEmpty && now.difference(_samples.first.at) >= window) {
      _bytesInWindow -= _samples.removeAt(0).bytes;
    }
    if (bytes <= 0 || _bytesInWindow + bytes > maxBytesPerWindow) {
      return false;
    }
    _samples.add(_ExternalMediaByteSample(at: now, bytes: bytes));
    _bytesInWindow += bytes;
    return true;
  }
}

final class _ExternalMediaByteSample {
  const _ExternalMediaByteSample({required this.at, required this.bytes});

  final DateTime at;
  final int bytes;
}
