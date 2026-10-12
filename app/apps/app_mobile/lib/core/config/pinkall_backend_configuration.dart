import 'dart:io' show InternetAddress, Platform;

const String _macOsPocApiBaseUrl = 'http://127.0.0.1:8080';
const String _macOsPocWebSocketBaseUrl = 'ws://127.0.0.1:8080';

/// Runtime configuration required to reach the Pinkall SaaS backend.
final class PinkallBackendConfiguration {
  /// Creates a validated backend configuration.
  const PinkallBackendConfiguration({
    required this.apiBaseUri,
    required this.webSocketBaseUri,
    required this.apiToken,
  });

  /// Builds public endpoints from dart defines and reads the access token at
  /// runtime so the credential is never embedded in the application binary.
  ///
  /// Missing endpoint defines fall back to the local POC backend on macOS
  /// only. Explicit values always take precedence and remain validated.
  factory PinkallBackendConfiguration.fromEnvironment({
    Map<String, String>? runtimeEnvironment,
    String? apiBaseUrlOverride,
    String? webSocketBaseUrlOverride,
    bool? useLocalPocEndpoints,
  }) {
    const String definedApiBaseUrl = String.fromEnvironment(
      'PINKALL_API_BASE_URL',
    );
    const String definedWebSocketBaseUrl = String.fromEnvironment(
      'PINKALL_WS_BASE_URL',
    );
    final String apiToken =
        (runtimeEnvironment ?? Platform.environment)['PINKALL_API_TOKEN'] ?? '';
    final bool shouldUseLocalPocEndpoints =
        useLocalPocEndpoints ?? Platform.isMacOS;
    final String apiBaseUrl = _endpointValue(
      explicitValue: apiBaseUrlOverride ?? definedApiBaseUrl,
      localPocValue: _macOsPocApiBaseUrl,
      useLocalPocValue: shouldUseLocalPocEndpoints,
    );
    final String webSocketBaseUrl = _endpointValue(
      explicitValue: webSocketBaseUrlOverride ?? definedWebSocketBaseUrl,
      localPocValue: _macOsPocWebSocketBaseUrl,
      useLocalPocValue: shouldUseLocalPocEndpoints,
    );

    return PinkallBackendConfiguration(
      apiBaseUri: _parseUri(apiBaseUrl, const <String>{'http', 'https'}),
      webSocketBaseUri: _parseUri(webSocketBaseUrl, const <String>{
        'ws',
        'wss',
      }),
      apiToken: apiToken.trim(),
    );
  }

  /// Base URI of the authenticated HTTP API, when configured.
  final Uri? apiBaseUri;

  /// Base URI of the authenticated realtime WebSocket API, when configured.
  final Uri? webSocketBaseUri;

  /// Development-only fallback token supplied by the runtime environment.
  ///
  /// When Supabase is configured, the dynamic authenticated session always
  /// takes precedence and this value is ignored.
  final String apiToken;

  /// Whether both public backend endpoints are valid.
  bool get isConfigured => apiBaseUri != null && webSocketBaseUri != null;

  /// Human-readable configuration failure suitable for the UI.
  String? get configurationError {
    final List<String> missing = <String>[];
    if (apiBaseUri == null) {
      missing.add('PINKALL_API_BASE_URL');
    }
    if (webSocketBaseUri == null) {
      missing.add('PINKALL_WS_BASE_URL');
    }
    if (missing.isEmpty) {
      return null;
    }
    return 'Backend Pinkall non configuré : ${missing.join(', ')}.';
  }

  /// Returns the API URI or fails with an explicit configuration message.
  Uri requireApiBaseUri() {
    final Uri? value = apiBaseUri;
    if (value == null) {
      throw StateError(configurationError ?? 'API Pinkall non configurée.');
    }
    return value;
  }

  /// Returns the WebSocket URI or fails with an explicit message.
  Uri requireWebSocketBaseUri() {
    final Uri? value = webSocketBaseUri;
    if (value == null) {
      throw StateError(
        configurationError ?? 'WebSocket Pinkall non configuré.',
      );
    }
    return value;
  }

  static Uri? _parseUri(String rawValue, Set<String> allowedSchemes) {
    final String value = rawValue.trim();
    if (value.isEmpty) {
      return null;
    }
    final Uri? uri = Uri.tryParse(value);
    if (uri == null ||
        !uri.isAbsolute ||
        uri.host.isEmpty ||
        !allowedSchemes.contains(uri.scheme)) {
      return null;
    }
    final bool usesSecureTransport =
        uri.scheme == 'https' || uri.scheme == 'wss';
    final bool usesLocalDevelopmentTransport =
        (uri.scheme == 'http' || uri.scheme == 'ws') &&
        _isLoopbackHost(uri.host);
    return usesSecureTransport || usesLocalDevelopmentTransport ? uri : null;
  }

  static bool _isLoopbackHost(String host) {
    if (host.toLowerCase() == 'localhost') {
      return true;
    }
    return InternetAddress.tryParse(host)?.isLoopback ?? false;
  }

  static String _endpointValue({
    required String explicitValue,
    required String localPocValue,
    required bool useLocalPocValue,
  }) {
    if (explicitValue.trim().isNotEmpty || !useLocalPocValue) {
      return explicitValue;
    }
    return localPocValue;
  }
}
