import 'package:pinkall/features/auth/domain/entities/pinkall_auth_session.entity.dart';
import 'package:pinkall/features/auth/domain/params/pinkall_sign_in.param.dart';
import 'package:pinkall/features/auth/domain/pinkall_auth.exception.dart';
import 'package:pinkall/features/auth/domain/repositories/pinkall_auth.repository.dart';

/// Explicit local-development fallback for the legacy runtime API token.
final class LegacyDevelopmentAuthRepositoryImpl
    implements PinkallAuthRepository {
  /// Creates the fallback from a non-empty runtime environment value.
  LegacyDevelopmentAuthRepositoryImpl(String apiToken)
    : _apiToken = apiToken.trim();

  final String _apiToken;

  static const PinkallAuthSessionEntity _session = PinkallAuthSessionEntity(
    userId: 'legacy-development-session',
    isLegacyDevelopmentSession: true,
  );

  @override
  bool get isAvailable => _apiToken.isNotEmpty;

  @override
  String? get unavailableReason => null;

  @override
  bool get canSignOut => false;

  @override
  PinkallAuthSessionEntity? get currentSession => isAvailable ? _session : null;

  @override
  Stream<PinkallAuthSessionEntity?> get sessionChanges =>
      Stream<PinkallAuthSessionEntity?>.value(currentSession);

  @override
  Future<void> signIn(PinkallSignInParam param) async {
    throw const PinkallAuthException(PinkallAuthFailureCode.unavailable);
  }

  @override
  Future<void> signOut() async {
    throw const PinkallAuthException(PinkallAuthFailureCode.unavailable);
  }

  @override
  Future<String?> currentAccessToken() async =>
      _apiToken.isEmpty ? null : _apiToken;
}
