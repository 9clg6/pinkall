import 'package:pinkall/features/auth/data/models/pinkall_auth_session.remote.model.dart';

/// Minimal provider client used by the authentication data source.
abstract interface class PinkallAuthRemoteClient {
  /// Current session restored or created by the provider.
  PinkallAuthSessionRemoteModel? get currentSession;

  /// Provider session lifecycle, including refresh and sign-out events.
  Stream<PinkallAuthSessionRemoteModel?> get sessionChanges;

  /// Signs in an existing account and returns its session.
  Future<PinkallAuthSessionRemoteModel?> signInWithPassword({
    required String email,
    required String password,
  });

  /// Forces a token refresh and returns the replacement session.
  Future<PinkallAuthSessionRemoteModel?> refreshSession();

  /// Ends the provider session.
  Future<void> signOut();
}
