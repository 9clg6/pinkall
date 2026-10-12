import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/telnyx_call_control_contracts.dart';
import 'package:http/http.dart' as http;

/// Real Telnyx Call Control adapter for the outbound WebRTC → PSTN B-leg.
final class HttpTelnyxCallControlGateway implements TelnyxCallControlGateway {
  HttpTelnyxCallControlGateway({
    required String apiKey,
    required this.apiBaseUrl,
    required this.connectionId,
    required this.fromNumber,
    required this.fromDisplayName,
    this.requestTimeout = const Duration(milliseconds: 1800),
    http.Client? httpClient,
  }) : _apiKey = apiKey,
       _httpClient = httpClient ?? http.Client();

  final String _apiKey;
  final String apiBaseUrl;
  final String connectionId;
  final String fromNumber;
  final String fromDisplayName;
  final Duration requestTimeout;
  final http.Client _httpClient;

  @override
  bool get isConfigured {
    return _apiKey.isNotEmpty &&
        connectionId.isNotEmpty &&
        fromNumber.isNotEmpty;
  }

  @override
  Future<TelnyxDialResult> dial(TelnyxDialCommand command) async {
    if (!isConfigured) {
      throw StateError('Telnyx Call Control is not configured.');
    }
    final Uri endpoint = _appendPath(Uri.parse(apiBaseUrl), '/calls');
    late final http.Response response;
    try {
      response = await _httpClient
          .post(
            endpoint,
            headers: <String, String>{
              HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              HttpHeaders.acceptHeader: ContentType.json.mimeType,
            },
            body: jsonEncode(<String, Object?>{
              'connection_id': connectionId,
              'to': command.to,
              'from': fromNumber,
              'from_display_name': fromDisplayName,
              'client_state': command.clientState,
              'command_id': command.commandId,
              'link_to': command.linkTo,
              'bridge_intent': true,
              'bridge_on_answer': true,
              'stream_url': command.streamUrl,
              'stream_track': 'both_tracks',
              'stream_establish_before_call_originate': true,
              'webhook_url': command.webhookUrl,
              'webhook_url_method': 'POST',
            }),
          )
          .timeout(requestTimeout);
    } on TimeoutException {
      throw HttpException(
        'Telnyx Dial timed out before the webhook acknowledgement deadline.',
        uri: endpoint,
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Telnyx Dial failed (${response.statusCode}).',
        uri: endpoint,
      );
    }
    final Object? decoded = jsonDecode(response.body);
    if (decoded is! Map<String, Object?> ||
        decoded['data'] is! Map<String, Object?>) {
      throw HttpException('Telnyx Dial response was not a call object.');
    }
    final Map<String, Object?> data = decoded['data']! as Map<String, Object?>;
    final String? callControlId = _text(data['call_control_id']);
    final String? callSessionId = _text(data['call_session_id']);
    if (callControlId == null || callSessionId == null) {
      throw HttpException(
        'Telnyx Dial response omitted call correlation identifiers.',
      );
    }
    return TelnyxDialResult(
      callControlId: callControlId,
      callSessionId: callSessionId,
    );
  }

  @override
  void dispose() => _httpClient.close();

  static Uri _appendPath(Uri base, String suffix) {
    final String path = base.path.endsWith('/')
        ? base.path.substring(0, base.path.length - 1)
        : base.path;
    return base.replace(path: '$path$suffix', query: null, fragment: null);
  }

  static String? _text(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }
}
