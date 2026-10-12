import 'package:pinkall/features/auth/data/models/pinkall_auth_session.remote.model.dart';
import 'package:pinkall/features/auth/domain/params/pinkall_sign_in.param.dart';

/// Remote authentication orchestration and proactive token refresh boundary.
abstract interface class PinkallAuthRemoteDataSource {
  /// Current provider session.
  PinkallAuthSessionRemoteModel? get currentSession;

  /// Sanitized provider session lifecycle.
  Stream<PinkallAuthSessionRemoteModel?> get sessionChanges;

  /// Signs in an existing invite-only account.
  Future<void> signIn(PinkallSignInParam param);

  /// Ends the provider session.
  Future<void> signOut();

  /// Returns a current token, proactively refreshing near expiration.
  Future<String?> currentAccessToken();
}
