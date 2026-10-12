import 'dart:convert';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';
import 'package:api_agent_vocal/src/domain/telnyx_call_control_contracts.dart';
import 'package:api_agent_vocal/src/infrastructure/telnyx/telnyx_webhook_verifier.dart';

/// Handles only the signed parked WebRTC → PSTN outbound topology.
final class OutboundCallService {
  OutboundCallService({
    required this.store,
    required this.gateway,
    required this.verifier,
    required this.publicBaseUrl,
    required this.webRtcConnectionId,
  });

  static const int _maxRememberedEventIds = 10000;

  final PinkallStore store;
  final TelnyxCallControlGateway gateway;
  final TelnyxWebhookVerifier verifier;
  final String? publicBaseUrl;
  final String? webRtcConnectionId;
  final Set<String> _processedEventIds = <String>{};
  final Set<String> _eventsInFlight = <String>{};

  bool get isConfigured {
    return gateway.isConfigured &&
        verifier.isConfigured &&
        publicBaseUrl != null &&
        webRtcConnectionId != null;
  }

  Future<TelnyxWebhookDisposition> handleWebhook({
    required String rawBody,
    required String? signature,
    required String? timestamp,
  }) async {
    await verifier.verify(
      rawBody: rawBody,
      signatureHeader: signature,
      timestampHeader: timestamp,
    );
    final Object? decoded = jsonDecode(rawBody);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Telnyx webhook body must be an object.');
    }
    final Map<String, Object?> data = _requiredMap(decoded, 'data');
    final String eventId = _requiredText(data, 'id');
    final String eventType = _requiredText(data, 'event_type');
    if (_processedEventIds.contains(eventId) ||
        _eventsInFlight.contains(eventId)) {
      return TelnyxWebhookDisposition(
        eventId: eventId,
        action: 'duplicate_ignored',
        duplicate: true,
        sessionId: null,
      );
    }

    _eventsInFlight.add(eventId);
    try {
      final TelnyxWebhookDisposition disposition = eventType == 'call.initiated'
          ? await _handleCallInitiated(eventId, data)
          : TelnyxWebhookDisposition(
              eventId: eventId,
              action: 'event_ignored',
              duplicate: false,
              sessionId: null,
            );
      _rememberProcessed(eventId);
      return disposition;
    } finally {
      _eventsInFlight.remove(eventId);
    }
  }

  void dispose() => gateway.dispose();

  Future<TelnyxWebhookDisposition> _handleCallInitiated(
    String eventId,
    Map<String, Object?> data,
  ) async {
    final Map<String, Object?> payload = _requiredMap(data, 'payload');
    final String direction = _requiredText(payload, 'direction');
    final String state = _requiredText(payload, 'state');
    if (direction != 'outgoing' || state != 'parked') {
      return TelnyxWebhookDisposition(
        eventId: eventId,
        action: direction == 'incoming'
            ? 'incoming_out_of_scope'
            : 'non_parked_event_ignored',
        duplicate: false,
        sessionId: null,
      );
    }
    final String connectionId = _requiredText(payload, 'connection_id');
    if (connectionId != webRtcConnectionId) {
      return TelnyxWebhookDisposition(
        eventId: eventId,
        action: 'non_webrtc_connection_ignored',
        duplicate: false,
        sessionId: null,
      );
    }

    final Map<String, Object?> clientState = _decodeClientState(
      _requiredText(payload, 'client_state'),
    );
    if (clientState['pinkall_leg'] == 'pstn') {
      return TelnyxWebhookDisposition(
        eventId: eventId,
        action: 'pstn_leg_event_ignored',
        duplicate: false,
        sessionId: _optionalText(clientState['pinkall_session_id']),
      );
    }
    final String sessionId = _requiredText(clientState, 'pinkall_session_id');
    final CallSessionSnapshot? session = store.session(sessionId);
    if (session == null) {
      throw StateError('Session not found: $sessionId');
    }
    if (session.status != SessionStatus.awaitingMedia) {
      throw StateError(
        'Session $sessionId is not waiting for an outbound call.',
      );
    }
    final String correlationId = _requiredText(clientState, 'correlation_id');
    if (correlationId != session.callId) {
      throw const FormatException(
        'Telnyx client_state correlation_id does not match the session.',
      );
    }
    final String destination = _requiredText(payload, 'to');
    if (destination != session.destinationNumber) {
      store.failSession(sessionId, 'provider_destination_mismatch');
      await store.flush();
      throw const FormatException(
        'Telnyx destination does not match the Pinkall session.',
      );
    }
    final String agentCallControlId = _requiredText(payload, 'call_control_id');
    final String agentCallSessionId = _requiredText(payload, 'call_session_id');
    final String outboundClientState = base64Encode(
      utf8.encode(
        jsonEncode(<String, Object?>{
          'pinkall_session_id': sessionId,
          'correlation_id': correlationId,
          'pinkall_leg': 'pstn',
        }),
      ),
    );
    store.reserveOutboundCall(
      sessionId: sessionId,
      agentCallControlId: agentCallControlId,
      agentCallSessionId: agentCallSessionId,
    );
    await store.flush();
    try {
      final TelnyxDialResult pstn = await gateway.dial(
        TelnyxDialCommand(
          to: destination,
          clientState: outboundClientState,
          commandId: eventId,
          linkTo: agentCallControlId,
          streamUrl: _mediaStreamUrl(session),
          webhookUrl: _webhookUrl(),
        ),
      );
      store.attachOutboundCall(
        sessionId: sessionId,
        agentCallControlId: agentCallControlId,
        agentCallSessionId: agentCallSessionId,
        pstnCallControlId: pstn.callControlId,
        pstnCallSessionId: pstn.callSessionId,
      );
      await store.flush();
    } on Object {
      store.releaseOutboundCallReservation(
        sessionId: sessionId,
        agentCallControlId: agentCallControlId,
      );
      await store.flush();
      rethrow;
    }
    return TelnyxWebhookDisposition(
      eventId: eventId,
      action: 'pstn_dial_started',
      duplicate: false,
      sessionId: sessionId,
    );
  }

  String _mediaStreamUrl(CallSessionSnapshot session) {
    final Uri base = Uri.parse(publicBaseUrl!);
    final String scheme = switch (base.scheme) {
      'https' => 'wss',
      'http' => 'ws',
      _ => throw const FormatException(
        'PUBLIC_BASE_URL must use http or https.',
      ),
    };
    return base
        .replace(
          scheme: scheme,
          path: '/v1/telnyx/media/${session.id}',
          queryParameters: <String, String>{'token': session.mediaToken},
          fragment: null,
        )
        .toString();
  }

  String _webhookUrl() {
    final Uri base = Uri.parse(publicBaseUrl!);
    return base
        .replace(path: '/v1/telnyx/webhooks', query: null, fragment: null)
        .toString();
  }

  void _rememberProcessed(String eventId) {
    _processedEventIds.add(eventId);
    if (_processedEventIds.length > _maxRememberedEventIds) {
      _processedEventIds.remove(_processedEventIds.first);
    }
  }

  static Map<String, Object?> _decodeClientState(String encoded) {
    try {
      late final List<int> bytes;
      try {
        bytes = base64Decode(encoded);
      } on FormatException {
        bytes = base64Url.decode(base64Url.normalize(encoded));
      }
      final Object? decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is Map<String, Object?>) {
        return decoded;
      }
    } on Object {
      // Converted into the stable API error below.
    }
    throw const FormatException(
      'Telnyx client_state must be Base64-encoded Pinkall JSON.',
    );
  }

  static Map<String, Object?> _requiredMap(
    Map<String, Object?> source,
    String key,
  ) {
    final Object? value = source[key];
    if (value is Map<String, Object?>) {
      return value;
    }
    throw FormatException('Missing Telnyx object field: $key');
  }

  static String _requiredText(Map<String, Object?> source, String key) {
    final String? value = _optionalText(source[key]);
    if (value == null) {
      throw FormatException('Missing Telnyx string field: $key');
    }
    return value;
  }

  static String? _optionalText(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }
}
