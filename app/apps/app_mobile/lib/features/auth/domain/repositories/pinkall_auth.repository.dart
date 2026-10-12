import 'package:pinkall/features/auth/domain/entities/pinkall_auth_session.entity.dart';
import 'package:pinkall/features/auth/domain/params/pinkall_sign_in.param.dart';

/// Stable, provider-independent authentication boundary.
abstract interface class PinkallAuthRepository {
  /// Whether this runtime has a usable Supabase or development auth source.
  bool get isAvailable;

  /// Sanitized reason shown when authentication cannot start.
  String? get unavailableReason;

  /// Whether the current session can be ended from the application.
  bool get canSignOut;

  /// Current restored session, if any.
  PinkallAuthSessionEntity? get currentSession;

  /// Session lifecycle including initial, refreshed, signed-in, and signed-out.
  Stream<PinkallAuthSessionEntity?> get sessionChanges;

  /// Signs in an existing invite-only account.
  Future<void> signIn(PinkallSignInParam param);

  /// Ends the authenticated session on this installation.
  Future<void> signOut();

  /// Returns a current access token, refreshing it when near expiration.
  Future<String?> currentAccessToken();
}
