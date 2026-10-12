import 'package:api_agent_vocal/src/domain/auth_contracts.dart';
import 'package:jose/jose.dart';

/// Verifies asymmetric Supabase access tokens against the project's JWKS.
///
/// The verifier deliberately accepts only `ES256` and `RS256`. Supabase's
/// legacy shared-secret `HS256` tokens must be migrated to asymmetric signing
/// keys before enabling this runtime path.
final class SupabaseJwtVerifier implements SupabaseAccessTokenVerifier {
  SupabaseJwtVerifier({
    required Uri issuer,
    required Uri jwksUrl,
    required String audience,
    Duration clockTolerance = const Duration(seconds: 30),
    DateTime Function()? now,
    JsonWebKeyStore? keyStore,
  }) : _issuer = issuer,
       _audience = audience,
       _clockTolerance = clockTolerance,
       _now = now ?? DateTime.now,
       _keyStore = keyStore ?? (JsonWebKeyStore()..addKeySetUrl(jwksUrl));

  final Uri _issuer;
  final String _audience;
  final Duration _clockTolerance;
  final DateTime Function() _now;
  final JsonWebKeyStore _keyStore;

  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  @override
  Future<VerifiedSupabaseAccessToken> verify(String token) async {
    try {
      if (token.isEmpty || token.length > 16 * 1024) {
        throw const AuthenticationException(
          'invalid_access_token',
          'The Supabase access token has an invalid size.',
        );
      }
      final JsonWebToken jwt = await JsonWebToken.decodeAndVerify(
        token,
        _keyStore,
        allowedArguments: const <String>['ES256', 'RS256'],
      );
      final Map<String, dynamic> claims = jwt.claims.toJson();
      _validateIssuer(claims['iss']);
      _validateAudience(claims['aud']);
      _validateTemporalClaims(claims);

      final String userId = _requiredUuid(claims['sub'], 'sub');
      if (claims['role'] != 'authenticated') {
        throw const AuthenticationException(
          'invalid_access_token',
          'The Supabase access token role is not authenticated.',
        );
      }
      final Object? rawSessionId = claims['session_id'];
      final String? sessionId = rawSessionId == null
          ? null
          : _requiredUuid(rawSessionId, 'session_id');
      return VerifiedSupabaseAccessToken(userId: userId, sessionId: sessionId);
    } on AuthenticationException {
      rethrow;
    } on Object {
      throw const AuthenticationException(
        'invalid_access_token',
        'The Supabase access token could not be verified.',
      );
    }
  }

  void _validateIssuer(Object? rawIssuer) {
    if (rawIssuer is! String || rawIssuer != _issuer.toString()) {
      throw const AuthenticationException(
        'invalid_access_token',
        'The Supabase access token issuer does not match.',
      );
    }
  }

  void _validateAudience(Object? rawAudience) {
    final List<String> audiences = switch (rawAudience) {
      String value => <String>[value],
      List<Object?> values => values.whereType<String>().toList(
        growable: false,
      ),
      _ => const <String>[],
    };
    if (!audiences.contains(_audience)) {
      throw const AuthenticationException(
        'invalid_access_token',
        'The Supabase access token audience does not match.',
      );
    }
  }

  void _validateTemporalClaims(Map<String, dynamic> claims) {
    final int nowSeconds = _now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final int toleranceSeconds = _clockTolerance.inSeconds;
    final int expiry = _requiredEpochSeconds(claims['exp'], 'exp');
    if (expiry <= nowSeconds - toleranceSeconds) {
      throw const AuthenticationException(
        'invalid_access_token',
        'The Supabase access token is expired.',
      );
    }
    final Object? rawNotBefore = claims['nbf'];
    if (rawNotBefore != null &&
        _requiredEpochSeconds(rawNotBefore, 'nbf') >
            nowSeconds + toleranceSeconds) {
      throw const AuthenticationException(
        'invalid_access_token',
        'The Supabase access token is not active yet.',
      );
    }
    final Object? rawIssuedAt = claims['iat'];
    if (rawIssuedAt != null &&
        _requiredEpochSeconds(rawIssuedAt, 'iat') >
            nowSeconds + toleranceSeconds) {
      throw const AuthenticationException(
        'invalid_access_token',
        'The Supabase access token was issued in the future.',
      );
    }
  }

  static int _requiredEpochSeconds(Object? raw, String claim) {
    if (raw is int) {
      return raw;
    }
    if (raw is num && raw.isFinite && raw == raw.roundToDouble()) {
      return raw.toInt();
    }
    throw AuthenticationException(
      'invalid_access_token',
      'The Supabase access token $claim claim is invalid.',
    );
  }

  static String _requiredUuid(Object? raw, String claim) {
    if (raw is! String || !_uuidPattern.hasMatch(raw)) {
      throw AuthenticationException(
        'invalid_access_token',
        'The Supabase access token $claim claim is invalid.',
      );
    }
    return raw.toLowerCase();
  }
}
