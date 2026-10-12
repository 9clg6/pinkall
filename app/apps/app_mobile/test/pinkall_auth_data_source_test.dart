import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/config/pinkall_backend_configuration.dart';
import 'package:pinkall/core/config/pinkall_supabase_configuration.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/auth/data/clients/pinkall_auth.remote.client.dart';
import 'package:pinkall/features/auth/data/datasources/pinkall_auth.remote.data_source.impl.dart';
import 'package:pinkall/features/auth/data/models/pinkall_auth_session.remote.model.dart';
import 'package:pinkall/features/auth/domain/entities/pinkall_auth_session.entity.dart';
import 'package:pinkall/features/auth/domain/params/pinkall_sign_in.param.dart';
import 'package:pinkall/features/auth/domain/pinkall_auth.exception.dart';
import 'package:pinkall/features/auth/domain/repositories/pinkall_auth.repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final DateTime now = DateTime.utc(2026, 7, 14, 10);

  test('sensitive session toString never exposes the bearer token', () {
    const String token = 'secret-access-token-that-must-never-appear';
    final PinkallAuthSessionRemoteModel session = PinkallAuthSessionRemoteModel(
      userId: 'user-1',
      accessToken: token,
      expiresAt: now,
      email: 'founder@example.com',
    );

    expect(session.toString(), isNot(contains(token)));
    expect(session.toString(), contains('[REDACTED]'));
  });

  test('sign-in params never expose the password through toString', () {
    const String password = 'password-that-must-never-appear';
    final PinkallSignInParam param = PinkallSignInParam(
      email: 'Founder@Example.com',
      password: password,
    );

    expect(param.toString(), isNot(contains(password)));
  });

  test(
    'returns the current token without refresh when it remains valid',
    () async {
      final _FakeAuthRemoteClient client = _FakeAuthRemoteClient(
        current: _session('token-1', now.add(const Duration(minutes: 5))),
      );
      final PinkallAuthRemoteDataSourceImpl source =
          PinkallAuthRemoteDataSourceImpl(client: client, now: () => now);

      expect(await source.currentAccessToken(), 'token-1');
      expect(client.refreshCount, 0);
    },
  );

  test('refreshes near expiry and returns the replacement token', () async {
    final _FakeAuthRemoteClient client = _FakeAuthRemoteClient(
      current: _session('token-old', now.add(const Duration(seconds: 30))),
      refreshed: _session('token-new', now.add(const Duration(hours: 1))),
    );
    final PinkallAuthRemoteDataSourceImpl source =
        PinkallAuthRemoteDataSourceImpl(client: client, now: () => now);

    expect(await source.currentAccessToken(), 'token-new');
    expect(client.refreshCount, 1);
    expect(await source.currentAccessToken(), 'token-new');
    expect(client.refreshCount, 1);
  });

  test('de-duplicates simultaneous proactive refreshes', () async {
    final Completer<PinkallAuthSessionRemoteModel?> refresh =
        Completer<PinkallAuthSessionRemoteModel?>();
    final _FakeAuthRemoteClient client = _FakeAuthRemoteClient(
      current: _session('token-old', now),
      refreshCompleter: refresh,
    );
    final PinkallAuthRemoteDataSourceImpl source =
        PinkallAuthRemoteDataSourceImpl(client: client, now: () => now);

    final Future<String?> first = source.currentAccessToken();
    final Future<String?> second = source.currentAccessToken();
    await Future<void>.delayed(Duration.zero);
    expect(client.refreshCount, 1);

    refresh.complete(_session('token-new', now.add(const Duration(hours: 1))));
    expect(await first, 'token-new');
    expect(await second, 'token-new');
  });

  test(
    'maps provider credential errors without retaining their message',
    () async {
      const String providerSecret = 'raw-provider-message-with-secret';
      final _FakeAuthRemoteClient client = _FakeAuthRemoteClient(
        signInError: const AuthException(
          providerSecret,
          statusCode: '400',
          code: 'invalid_credentials',
        ),
      );
      final PinkallAuthRemoteDataSourceImpl source =
          PinkallAuthRemoteDataSourceImpl(client: client, now: () => now);

      Object? thrown;
      try {
        await source.signIn(
          PinkallSignInParam(
            email: 'founder@example.com',
            password: 'never-log-password',
          ),
        );
      } on Object catch (error) {
        thrown = error;
      }

      expect(thrown, isA<PinkallAuthException>());
      expect(
        (thrown! as PinkallAuthException).code,
        PinkallAuthFailureCode.invalidCredentials,
      );
      expect(thrown.toString(), isNot(contains(providerSecret)));
      expect(thrown.toString(), isNot(contains('never-log-password')));
    },
  );

  test(
    'dynamic access-token provider resolves the repository every call',
    () async {
      final _RotatingAuthRepository repository = _RotatingAuthRepository(
        <String?>['first-token', 'refreshed-token'],
      );
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          pinkallAuthRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final Future<String?> Function() accessTokenProvider = container.read(
        pinkallAccessTokenProvider,
      );
      expect(await accessTokenProvider(), 'first-token');
      expect(await accessTokenProvider(), 'refreshed-token');
    },
  );

  test(
    'partial Supabase configuration never falls back to legacy token',
    () async {
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          pinkallSupabaseConfigurationProvider.overrideWithValue(
            PinkallSupabaseConfiguration.fromEnvironment(
              urlOverride: 'https://project.supabase.co',
              publishableKeyOverride: '',
            ),
          ),
          pinkallBackendConfigurationProvider.overrideWithValue(
            PinkallBackendConfiguration(
              apiBaseUri: Uri.parse('https://api.pinkall.test'),
              webSocketBaseUri: Uri.parse('wss://api.pinkall.test'),
              apiToken: 'legacy-token-must-not-be-used',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final PinkallAuthRepository repository = container.read(
        pinkallAuthRepositoryProvider,
      );
      final Future<String?> Function() accessTokenProvider = container.read(
        pinkallAccessTokenProvider,
      );
      expect(repository.isAvailable, isFalse);
      expect(await accessTokenProvider(), isNull);
    },
  );
}

PinkallAuthSessionRemoteModel _session(String token, DateTime expiresAt) =>
    PinkallAuthSessionRemoteModel(
      userId: 'user-1',
      accessToken: token,
      expiresAt: expiresAt,
      email: 'founder@example.com',
    );

final class _FakeAuthRemoteClient implements PinkallAuthRemoteClient {
  _FakeAuthRemoteClient({
    this.current,
    this.refreshed,
    this.refreshCompleter,
    this.signInError,
  });

  PinkallAuthSessionRemoteModel? current;
  final PinkallAuthSessionRemoteModel? refreshed;
  final Completer<PinkallAuthSessionRemoteModel?>? refreshCompleter;
  final Object? signInError;
  final StreamController<PinkallAuthSessionRemoteModel?> controller =
      StreamController<PinkallAuthSessionRemoteModel?>.broadcast();
  int refreshCount = 0;

  @override
  PinkallAuthSessionRemoteModel? get currentSession => current;

  @override
  Stream<PinkallAuthSessionRemoteModel?> get sessionChanges =>
      controller.stream;

  @override
  Future<PinkallAuthSessionRemoteModel?> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final Object? error = signInError;
    if (error != null) {
      throw error;
    }
    return current;
  }

  @override
  Future<PinkallAuthSessionRemoteModel?> refreshSession() async {
    refreshCount += 1;
    final PinkallAuthSessionRemoteModel? next = refreshCompleter == null
        ? refreshed
        : await refreshCompleter!.future;
    current = next;
    return next;
  }

  @override
  Future<void> signOut() async {
    current = null;
    controller.add(null);
  }
}

final class _RotatingAuthRepository implements PinkallAuthRepository {
  _RotatingAuthRepository(this._tokens);

  final List<String?> _tokens;
  int _index = 0;

  @override
  bool get isAvailable => true;

  @override
  String? get unavailableReason => null;

  @override
  bool get canSignOut => true;

  @override
  PinkallAuthSessionEntity? get currentSession =>
      const PinkallAuthSessionEntity(userId: 'user-1');

  @override
  Stream<PinkallAuthSessionEntity?> get sessionChanges =>
      const Stream<PinkallAuthSessionEntity?>.empty();

  @override
  Future<String?> currentAccessToken() async => _tokens[_index++];

  @override
  Future<void> signIn(PinkallSignInParam param) async {}

  @override
  Future<void> signOut() async {}
}
