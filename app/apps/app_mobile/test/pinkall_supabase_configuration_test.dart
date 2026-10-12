import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/config/pinkall_supabase_bootstrap.dart';
import 'package:pinkall/core/config/pinkall_supabase_configuration.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('PinkallSupabaseConfiguration', () {
    test('stays disabled when no public dart define is supplied', () async {
      final PinkallSupabaseConfiguration configuration =
          PinkallSupabaseConfiguration.fromEnvironment(
            urlOverride: '',
            publishableKeyOverride: '',
          );
      bool initializerCalled = false;

      final SupabaseClient? client = await initializePinkallSupabase(
        configuration,
        initializer:
            ({required Uri url, required String publishableKey}) async {
              initializerCalled = true;
              return SupabaseClient(url.toString(), publishableKey);
            },
      );

      expect(configuration.hasAnyValue, isFalse);
      expect(configuration.isConfigured, isFalse);
      expect(configuration.configurationError, isNull);
      expect(initializerCalled, isFalse);
      expect(client, isNull);
    });

    test('reports partial configuration without exposing the key', () {
      const String publicKey = 'sb_publishable_do-not-print-this-value';
      final PinkallSupabaseConfiguration configuration =
          PinkallSupabaseConfiguration.fromEnvironment(
            urlOverride: 'not-an-absolute-url',
            publishableKeyOverride: publicKey,
          );

      expect(configuration.hasAnyValue, isTrue);
      expect(configuration.isConfigured, isFalse);
      expect(
        configuration.configurationError,
        contains('PINKALL_SUPABASE_URL'),
      );
      expect(configuration.configurationError, isNot(contains(publicKey)));
    });

    test('rejects an insecure remote Supabase URL', () {
      final PinkallSupabaseConfiguration configuration =
          PinkallSupabaseConfiguration.fromEnvironment(
            urlOverride: 'http://project.supabase.co',
            publishableKeyOverride: 'sb_publishable_test',
          );

      expect(configuration.isConfigured, isFalse);
      expect(
        configuration.configurationError,
        contains('PINKALL_SUPABASE_URL'),
      );
    });

    test('does not mistake a hostname starting with 127 for loopback', () {
      final PinkallSupabaseConfiguration configuration =
          PinkallSupabaseConfiguration.fromEnvironment(
            urlOverride: 'http://127.attacker.example',
            publishableKeyOverride: 'sb_publishable_test',
          );

      expect(configuration.isConfigured, isFalse);
    });

    for (final String loopbackUrl in <String>[
      'http://localhost:54321',
      'http://127.0.0.1:54321',
      'http://[::1]:54321',
    ]) {
      test('allows insecure HTTP only on loopback: $loopbackUrl', () {
        final PinkallSupabaseConfiguration configuration =
            PinkallSupabaseConfiguration.fromEnvironment(
              urlOverride: loopbackUrl,
              publishableKeyOverride: 'sb_publishable_test',
            );

        expect(configuration.isConfigured, isTrue);
      });
    }

    test('rejects an sb_secret key before the initializer is called', () async {
      const String secretKey = 'sb_secret_do-not-print-this-value';
      final PinkallSupabaseConfiguration configuration =
          PinkallSupabaseConfiguration.fromEnvironment(
            urlOverride: 'https://project.supabase.co',
            publishableKeyOverride: secretKey,
          );
      bool initializerCalled = false;

      final SupabaseClient? client = await initializePinkallSupabase(
        configuration,
        initializer:
            ({required Uri url, required String publishableKey}) async {
              initializerCalled = true;
              return SupabaseClient(url.toString(), publishableKey);
            },
      );

      expect(configuration.isConfigured, isFalse);
      expect(configuration.configurationError, contains('clé secrète refusée'));
      expect(configuration.configurationError, isNot(contains(secretKey)));
      expect(initializerCalled, isFalse);
      expect(client, isNull);
    });

    test('rejects a detectable service-role JWT without exposing it', () {
      final String serviceRoleJwt = _fakeJwt(<String, Object?>{
        'role': 'service_role',
      });
      final PinkallSupabaseConfiguration configuration =
          PinkallSupabaseConfiguration.fromEnvironment(
            urlOverride: 'https://project.supabase.co',
            publishableKeyOverride: serviceRoleJwt,
          );

      expect(configuration.isConfigured, isFalse);
      expect(configuration.configurationError, contains('clé secrète refusée'));
      expect(configuration.configurationError, isNot(contains(serviceRoleJwt)));
    });

    test('rejects a literal service_role credential', () {
      final PinkallSupabaseConfiguration configuration =
          PinkallSupabaseConfiguration.fromEnvironment(
            urlOverride: 'https://project.supabase.co',
            publishableKeyOverride: 'service_role',
          );

      expect(configuration.isConfigured, isFalse);
      expect(configuration.configurationError, contains('clé secrète refusée'));
    });

    test('still accepts a legacy public anon JWT', () {
      final PinkallSupabaseConfiguration configuration =
          PinkallSupabaseConfiguration.fromEnvironment(
            urlOverride: 'https://project.supabase.co',
            publishableKeyOverride: _fakeJwt(<String, Object?>{'role': 'anon'}),
          );

      expect(configuration.isConfigured, isTrue);
      expect(configuration.configurationError, isNull);
    });

    test(
      'initializes the official boundary only when fully configured',
      () async {
        final PinkallSupabaseConfiguration configuration =
            PinkallSupabaseConfiguration.fromEnvironment(
              urlOverride: 'https://project.supabase.co',
              publishableKeyOverride: 'sb_publishable_test',
            );
        Uri? initializedUrl;
        String? initializedKey;

        final SupabaseClient? client = await initializePinkallSupabase(
          configuration,
          initializer:
              ({required Uri url, required String publishableKey}) async {
                initializedUrl = url;
                initializedKey = publishableKey;
                return SupabaseClient(url.toString(), publishableKey);
              },
        );

        expect(client, isNotNull);
        expect(initializedUrl, Uri.parse('https://project.supabase.co'));
        expect(initializedKey, 'sb_publishable_test');
      },
    );

    test('reduces initialization failure to an unavailable client', () async {
      final PinkallSupabaseConfiguration configuration =
          PinkallSupabaseConfiguration.fromEnvironment(
            urlOverride: 'https://project.supabase.co',
            publishableKeyOverride: 'sb_publishable_test',
          );

      final SupabaseClient? client = await initializePinkallSupabase(
        configuration,
        initializer:
            ({required Uri url, required String publishableKey}) async {
              throw StateError('provider-secret-error');
            },
      );

      expect(client, isNull);
    });
  });
}

String _fakeJwt(Map<String, Object?> payload) {
  String encode(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${encode(<String, Object?>{'alg': 'HS256'})}.'
      '${encode(payload)}.test-signature';
}
