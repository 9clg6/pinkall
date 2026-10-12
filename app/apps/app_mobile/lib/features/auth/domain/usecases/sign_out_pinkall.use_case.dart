import 'package:core_foundation/core_foundation.dart';
import 'package:pinkall/features/auth/domain/repositories/pinkall_auth.repository.dart';

/// Ends the authenticated Pinkall session.
final class SignOutPinkallUseCase extends FutureUseCase<void> {
  /// Creates the use case.
  const SignOutPinkallUseCase(this._repository);

  final PinkallAuthRepository _repository;

  @override
  Future<void> invoke() => _repository.signOut();
}
