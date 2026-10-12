import 'dart:convert';
import 'dart:io' show InternetAddress;

/// Public Supabase client configuration supplied at compile time.
final class PinkallSupabaseConfiguration {
  /// Creates an immutable Supabase configuration.
  const PinkallSupabaseConfiguration({
    required this.url,
    required this.publishableKey,
    required this.hasAnyValue,
  });

  /// Reads the public project URL and publishable key from dart defines.
  factory PinkallSupabaseConfiguration.fromEnvironment({
    String? urlOverride,
    String? publishableKeyOverride,
  }) {
    const String definedUrl = String.fromEnvironment('PINKALL_SUPABASE_URL');
    const String definedPublishableKey = String.fromEnvironment(
      'PINKALL_SUPABASE_PUBLISHABLE_KEY',
    );
    final String rawUrl = (urlOverride ?? definedUrl).trim();
    final String publishableKey =
        (publishableKeyOverride ?? definedPublishableKey).trim();
    return PinkallSupabaseConfiguration(
      url: _parseUrl(rawUrl),
      publishableKey: publishableKey,
      hasAnyValue: rawUrl.isNotEmpty || publishableKey.isNotEmpty,
    );
  }

  /// Absolute Supabase HTTP(S) project URL.
  final Uri? url;

  /// Public client key. It must never be a secret or service-role key.
  final String publishableKey;

  /// Whether at least one Supabase define was supplied.
  final bool hasAnyValue;

  /// Whether both public values are present and valid.
  bool get isConfigured =>
      url != null &&
      publishableKey.isNotEmpty &&
      !_isForbiddenClientKey(publishableKey);

  /// Sanitized configuration error that never includes the key value.
  String? get configurationError {
    if (isConfigured || !hasAnyValue) {
      return null;
    }
    final List<String> invalid = <String>[];
    if (url == null) {
      invalid.add('PINKALL_SUPABASE_URL');
    }
    if (publishableKey.isEmpty) {
      invalid.add('PINKALL_SUPABASE_PUBLISHABLE_KEY');
    }
    if (_isForbiddenClientKey(publishableKey)) {
      invalid.add('PINKALL_SUPABASE_PUBLISHABLE_KEY (clé secrète refusée)');
    }
    return 'Configuration Supabase invalide : ${invalid.join(', ')}. '
        'Utilisez uniquement une clé publique publishable ou anon.';
  }

  static Uri? _parseUrl(String value) {
    if (value.isEmpty) {
      return null;
    }
    final Uri? uri = Uri.tryParse(value);
    if (uri == null ||
        !uri.isAbsolute ||
        !const <String>{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty) {
      return null;
    }
    if (uri.scheme == 'http' && !_isLoopbackHost(uri.host)) {
      return null;
    }
    return uri;
  }

  static bool _isLoopbackHost(String host) {
    final String normalized = host.toLowerCase();
    if (normalized == 'localhost') {
      return true;
    }
    return InternetAddress.tryParse(normalized)?.isLoopback ?? false;
  }

  static bool _isForbiddenClientKey(String value) {
    final String normalized = value.trim().toLowerCase();
    if (normalized.startsWith('sb_secret_') ||
        normalized == 'service_role' ||
        normalized.startsWith('service_role_')) {
      return true;
    }

    final List<String> segments = value.split('.');
    if (segments.length != 3) {
      return false;
    }
    try {
      final Object? payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(segments[1]))),
      );
      if (payload is! Map<String, dynamic>) {
        return false;
      }
      final Object? appMetadata = payload['app_metadata'];
      return _isServiceRole(payload['role']) ||
          (appMetadata is Map<String, dynamic> &&
              _isServiceRole(appMetadata['role']));
    } on Object {
      // A malformed value is not assumed to be a service-role JWT. Supabase
      // will still reject it without ever receiving privileged credentials.
      return false;
    }
  }

  static bool _isServiceRole(Object? value) =>
      value is String && value.trim().toLowerCase() == 'service_role';
}
