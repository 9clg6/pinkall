import 'package:pinkall/features/auth/domain/entities/pinkall_auth_session.entity.dart';
import 'package:pinkall/features/auth/domain/params/pinkall_sign_in.param.dart';
import 'package:pinkall/features/auth/domain/pinkall_auth.exception.dart';
import 'package:pinkall/features/auth/domain/repositories/pinkall_auth.repository.dart';

/// Safe unavailable state used for missing or failed public auth setup.
final class UnavailableAuthRepositoryImpl implements PinkallAuthRepository {
  /// Creates an unavailable repository with a sanitized UI reason.
  const UnavailableAuthRepositoryImpl(this.unavailableReason);

  @override
  final String unavailableReason;

  @override
  bool get isAvailable => false;

  @override
  bool get canSignOut => false;

  @override
  PinkallAuthSessionEntity? get currentSession => null;

  @override
  Stream<PinkallAuthSessionEntity?> get sessionChanges =>
      Stream<PinkallAuthSessionEntity?>.value(null);

  @override
  Future<void> signIn(PinkallSignInParam param) async {
    throw const PinkallAuthException(PinkallAuthFailureCode.unavailable);
  }

  @override
  Future<void> signOut() async {
    throw const PinkallAuthException(PinkallAuthFailureCode.unavailable);
  }

  @override
  Future<String?> currentAccessToken() async => null;
}
