import 'package:core_foundation/core_foundation.dart';
import 'package:pinkall/features/auth/domain/params/pinkall_sign_in.param.dart';
import 'package:pinkall/features/auth/domain/repositories/pinkall_auth.repository.dart';

/// Signs in an existing Pinkall invite with email and password.
final class SignInPinkallUseCase
    extends FutureUseCaseWithParams<void, PinkallSignInParam> {
  /// Creates the use case.
  const SignInPinkallUseCase(this._repository);

  final PinkallAuthRepository _repository;

  @override
  Future<void> invoke(PinkallSignInParam params) => _repository.signIn(params);
}
