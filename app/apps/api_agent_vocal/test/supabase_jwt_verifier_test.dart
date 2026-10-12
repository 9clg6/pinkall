import 'package:api_agent_vocal/src/domain/auth_contracts.dart';
import 'package:api_agent_vocal/src/infrastructure/auth/supabase_jwt_verifier.dart';
import 'package:jose/jose.dart';
import 'package:test/test.dart';

void main() {
  final DateTime now = DateTime.utc(2026, 7, 14, 12);
  final Uri issuer = Uri.parse('https://project.supabase.co/auth/v1');
  const String audience = 'authenticated';
  const String userId = '11111111-1111-4111-8111-111111111111';
  const String sessionId = '22222222-2222-4222-8222-222222222222';
  late JsonWebKey signingKey;
  late SupabaseJwtVerifier verifier;

  setUp(() {
    signingKey = JsonWebKey.generate('RS256');
    final JsonWebKey publicKey = JsonWebKey.fromCryptoKeys(
      publicKey: signingKey.cryptoKeyPair.publicKey,
    );
    verifier = SupabaseJwtVerifier(
      issuer: issuer,
      jwksUrl: Uri.parse('$issuer/.well-known/jwks.json'),
      audience: audience,
      now: () => now,
      keyStore: JsonWebKeyStore()..addKey(publicKey),
    );
  });

  test(
    'verifies signature and required Supabase access-token claims',
    () async {
      final String token = _signedToken(signingKey, <String, Object?>{
        'iss': issuer.toString(),
        'aud': audience,
        'sub': userId,
        'role': 'authenticated',
        'session_id': sessionId,
        'iat': now.millisecondsSinceEpoch ~/ 1000,
        'exp': now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      });

      final VerifiedSupabaseAccessToken verified = await verifier.verify(token);

      expect(verified.userId, userId);
      expect(verified.sessionId, sessionId);
    },
  );

  test('rejects wrong issuer, audience and authenticated role', () async {
    for (final Map<String, Object?> override in <Map<String, Object?>>[
      <String, Object?>{'iss': 'https://attacker.example/auth/v1'},
      <String, Object?>{'aud': 'another-audience'},
      <String, Object?>{'role': 'service_role'},
    ]) {
      final String token = _signedToken(signingKey, <String, Object?>{
        'iss': issuer.toString(),
        'aud': audience,
        'sub': userId,
        'role': 'authenticated',
        'iat': now.millisecondsSinceEpoch ~/ 1000,
        'exp': now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
        ...override,
      });

      await expectLater(
        verifier.verify(token),
        throwsA(_invalidAccessToken),
        reason: override.toString(),
      );
    }
  });

  test('rejects expired and future access tokens', () async {
    final List<Map<String, Object?>> claims = <Map<String, Object?>>[
      <String, Object?>{
        'iat':
            now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch ~/
            1000,
        'exp':
            now.subtract(const Duration(minutes: 2)).millisecondsSinceEpoch ~/
            1000,
      },
      <String, Object?>{
        'iat':
            now.add(const Duration(minutes: 2)).millisecondsSinceEpoch ~/ 1000,
        'exp': now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      },
      <String, Object?>{
        'iat': now.millisecondsSinceEpoch ~/ 1000,
        'nbf':
            now.add(const Duration(minutes: 2)).millisecondsSinceEpoch ~/ 1000,
        'exp': now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      },
    ];

    for (final Map<String, Object?> temporal in claims) {
      final String token = _signedToken(signingKey, <String, Object?>{
        'iss': issuer.toString(),
        'aud': audience,
        'sub': userId,
        'role': 'authenticated',
        ...temporal,
      });
      await expectLater(verifier.verify(token), throwsA(_invalidAccessToken));
    }
  });

  test('rejects an untrusted key and legacy HS256 algorithms', () async {
    final JsonWebKey otherKey = JsonWebKey.generate('RS256');
    final String untrusted = _signedToken(otherKey, <String, Object?>{
      'iss': issuer.toString(),
      'aud': audience,
      'sub': userId,
      'role': 'authenticated',
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
    });
    final JsonWebKey hmacKey = JsonWebKey.generate('HS256');
    final String legacyHs256 = _signedToken(hmacKey, <String, Object?>{
      'iss': issuer.toString(),
      'aud': audience,
      'sub': userId,
      'role': 'authenticated',
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
    }, algorithm: 'HS256');

    await expectLater(verifier.verify(untrusted), throwsA(_invalidAccessToken));
    await expectLater(
      verifier.verify(legacyHs256),
      throwsA(_invalidAccessToken),
    );
  });
}

final Matcher _invalidAccessToken = isA<AuthenticationException>().having(
  (AuthenticationException error) => error.code,
  'code',
  'invalid_access_token',
);

String _signedToken(
  JsonWebKey key,
  Map<String, Object?> claims, {
  String algorithm = 'RS256',
}) {
  final JsonWebSignatureBuilder builder = JsonWebSignatureBuilder()
    ..jsonContent = claims
    ..setProtectedHeader('typ', 'JWT')
    ..addRecipient(key, algorithm: algorithm);
  return builder.build().toCompactSerialization();
}
