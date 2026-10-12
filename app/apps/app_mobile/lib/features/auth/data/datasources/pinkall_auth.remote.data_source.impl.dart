import 'dart:async';

import 'package:pinkall/features/auth/data/clients/pinkall_auth.remote.client.dart';
import 'package:pinkall/features/auth/data/datasources/pinkall_auth.remote.data_source.dart';
import 'package:pinkall/features/auth/data/models/pinkall_auth_session.remote.model.dart';
import 'package:pinkall/features/auth/domain/params/pinkall_sign_in.param.dart';
import 'package:pinkall/features/auth/domain/pinkall_auth.exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Duration _proactiveRefreshWindow = Duration(seconds: 60);

/// Supabase-backed auth data source with de-duplicated proactive refresh.
final class PinkallAuthRemoteDataSourceImpl
    implements PinkallAuthRemoteDataSource {
  /// Creates the source with an injectable clock for deterministic tests.
  PinkallAuthRemoteDataSourceImpl({
    required PinkallAuthRemoteClient client,
    DateTime Function()? now,
  }) : _client = client,
       _now = now ?? DateTime.now;

  final PinkallAuthRemoteClient _client;
  final DateTime Function() _now;
  Future<PinkallAuthSessionRemoteModel?>? _refreshInFlight;

  @override
  PinkallAuthSessionRemoteModel? get currentSession => _client.currentSession;

  @override
  Stream<PinkallAuthSessionRemoteModel?> get sessionChanges =>
      _client.sessionChanges.transform(
        StreamTransformer<
          PinkallAuthSessionRemoteModel?,
          PinkallAuthSessionRemoteModel?
        >.fromHandlers(
          handleData:
              (
                PinkallAuthSessionRemoteModel? session,
                EventSink<PinkallAuthSessionRemoteModel?> sink,
              ) => sink.add(session),
          handleError:
              (
                Object error,
                StackTrace stackTrace,
                EventSink<PinkallAuthSessionRemoteModel?> sink,
              ) {
                sink.addError(_sanitize(error), stackTrace);
              },
        ),
      );

  @override
  Future<void> signIn(PinkallSignInParam param) async {
    try {
      final PinkallAuthSessionRemoteModel? session = await _client
          .signInWithPassword(email: param.email, password: param.password);
      if (session == null || session.accessToken.isEmpty) {
        throw const PinkallAuthException(PinkallAuthFailureCode.unknown);
      }
    } on PinkallAuthException {
      rethrow;
    } on Object catch (error) {
      throw _sanitize(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.signOut();
    } on Object catch (error) {
      throw _sanitize(error);
    }
  }

  @override
  Future<String?> currentAccessToken() async {
    PinkallAuthSessionRemoteModel? session = _client.currentSession;
    if (session == null) {
      return null;
    }
    if (_mustRefresh(session)) {
      try {
        session = await (_refreshInFlight ??= _refresh());
      } on PinkallAuthException {
        rethrow;
      } on Object catch (error) {
        throw _sanitize(error);
      }
    }
    final String token = session?.accessToken.trim() ?? '';
    return token.isEmpty ? null : token;
  }

  bool _mustRefresh(PinkallAuthSessionRemoteModel session) {
    final DateTime? expiresAt = session.expiresAt;
    return expiresAt != null &&
        !expiresAt.isAfter(_now().toUtc().add(_proactiveRefreshWindow));
  }

  Future<PinkallAuthSessionRemoteModel?> _refresh() async {
    try {
      return await _client.refreshSession();
    } finally {
      _refreshInFlight = null;
    }
  }

  static PinkallAuthException _sanitize(Object error) {
    if (error is PinkallAuthException) {
      return error;
    }
    if (error is AuthRetryableFetchException) {
      return const PinkallAuthException(
        PinkallAuthFailureCode.networkUnavailable,
      );
    }
    if (error is AuthException) {
      const Set<String> credentialCodes = <String>{
        'invalid_credentials',
        'email_not_confirmed',
        'user_not_found',
      };
      if (credentialCodes.contains(error.code) || error.statusCode == '400') {
        return const PinkallAuthException(
          PinkallAuthFailureCode.invalidCredentials,
        );
      }
    }
    return const PinkallAuthException(PinkallAuthFailureCode.unknown);
  }
}
