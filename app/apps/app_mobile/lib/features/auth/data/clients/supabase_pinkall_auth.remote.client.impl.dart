import 'package:pinkall/features/auth/data/clients/pinkall_auth.remote.client.dart';
import 'package:pinkall/features/auth/data/models/pinkall_auth_session.remote.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Official Supabase Flutter adapter kept behind a provider-neutral boundary.
final class SupabasePinkallAuthRemoteClientImpl
    implements PinkallAuthRemoteClient {
  /// Creates the adapter around the initialized public Supabase client.
  const SupabasePinkallAuthRemoteClientImpl(this._client);

  final SupabaseClient _client;

  @override
  PinkallAuthSessionRemoteModel? get currentSession =>
      _mapSession(_client.auth.currentSession);

  @override
  Stream<PinkallAuthSessionRemoteModel?> get sessionChanges => _client
      .auth
      .onAuthStateChange
      .map((AuthState state) => _mapSession(state.session));

  @override
  Future<PinkallAuthSessionRemoteModel?> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final AuthResponse response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return _mapSession(response.session);
  }

  @override
  Future<PinkallAuthSessionRemoteModel?> refreshSession() async {
    final AuthResponse response = await _client.auth.refreshSession();
    return _mapSession(response.session);
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  static PinkallAuthSessionRemoteModel? _mapSession(Session? session) {
    if (session == null) {
      return null;
    }
    final int? expiresAt = session.expiresAt;
    return PinkallAuthSessionRemoteModel(
      userId: session.user.id,
      accessToken: session.accessToken,
      expiresAt: expiresAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              expiresAt * Duration.millisecondsPerSecond,
              isUtc: true,
            ),
      email: session.user.email,
    );
  }
}
