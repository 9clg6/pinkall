import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/voice_contracts.dart';
import 'package:http/http.dart' as http;

/// Issues official Telnyx Voice SDK JWTs without exposing the Telnyx API key.
final class TelnyxVoiceTokenProvider implements VoiceTokenProvider {
  TelnyxVoiceTokenProvider({
    required String apiKey,
    required this.apiBaseUrl,
    required this.telephonyCredentialId,
    required this.callerName,
    required this.callerNumber,
    http.Client? httpClient,
  }) : _apiKey = apiKey,
       _httpClient = httpClient ?? http.Client();

  final String _apiKey;
  final String apiBaseUrl;
  final String telephonyCredentialId;
  final String callerName;
  final String callerNumber;
  final http.Client _httpClient;

  @override
  bool get isConfigured {
    return _apiKey.isNotEmpty &&
        telephonyCredentialId.isNotEmpty &&
        callerName.isNotEmpty &&
        callerNumber.isNotEmpty;
  }

  @override
  Future<VoiceAccessToken> issue({required String deviceId}) async {
    if (!isConfigured) {
      throw StateError('Telnyx Voice token provider is not configured.');
    }
    final String normalizedDeviceId = deviceId.trim();
    if (normalizedDeviceId.isEmpty || normalizedDeviceId.length > 128) {
      throw const FormatException(
        'device_id must contain 1 to 128 characters.',
      );
    }
    final Uri endpoint = _appendPath(
      Uri.parse(apiBaseUrl),
      '/telephony_credentials/${Uri.encodeComponent(telephonyCredentialId)}/token',
    );
    final http.Response response = await _httpClient.post(
      endpoint,
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
        HttpHeaders.acceptHeader: ContentType.json.mimeType,
      },
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Telnyx Voice token request failed (${response.statusCode}): '
        '${_safeProviderError(response.body)}',
        uri: endpoint,
      );
    }
    final String token = _readToken(response.body);
    final DateTime expiresAt = _readJwtExpiry(token);
    return VoiceAccessToken(
      token: token,
      expiresAt: expiresAt,
      callerName: callerName,
      callerNumber: callerNumber,
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

  static String _readToken(String body) {
    final String normalized = body.trim();
    if (normalized.isEmpty) {
      throw const HttpException(
        'Telnyx Voice token response did not contain a JWT.',
      );
    }

    String? token;
    try {
      final Object? decoded = jsonDecode(normalized);
      token = switch (decoded) {
        String value => value,
        Map<String, Object?> map when map['data'] is String =>
          map['data']! as String,
        _ => null,
      };
    } on FormatException {
      // Telnyx documents this endpoint as text/plain and returns the raw JWT.
      token = normalized;
    }

    if (token == null || token.trim().isEmpty) {
      throw const HttpException(
        'Telnyx Voice token response did not contain a JWT.',
      );
    }
    return token.trim();
  }

  static DateTime _readJwtExpiry(String token) {
    try {
      final List<String> parts = token.split('.');
      if (parts.length != 3) {
        throw const FormatException('not a JWT');
      }
      final Object? payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      if (payload is! Map<String, Object?> || payload['exp'] is! num) {
        throw const FormatException('JWT exp missing');
      }
      return DateTime.fromMillisecondsSinceEpoch(
        (payload['exp']! as num).toInt() * 1000,
        isUtc: true,
      );
    } on Object {
      throw const HttpException(
        'Telnyx Voice token response contained an invalid JWT expiry.',
      );
    }
  }

  static String _safeProviderError(String body) {
    final String normalized = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    return normalized.length <= 300 ? normalized : normalized.substring(0, 300);
  }
}
