import 'dart:async';

import 'package:core_foundation/core_foundation.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/auth/domain/entities/pinkall_auth_session.entity.dart';
import 'package:pinkall/features/auth/domain/params/pinkall_sign_in.param.dart';
import 'package:pinkall/features/auth/domain/pinkall_auth.exception.dart';
import 'package:pinkall/features/auth/domain/repositories/pinkall_auth.repository.dart';
import 'package:pinkall/features/auth/domain/usecases/sign_in_pinkall.use_case.dart';
import 'package:pinkall/features/auth/domain/usecases/sign_out_pinkall.use_case.dart';
import 'package:pinkall/features/auth/presentation/pinkall_auth.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pinkall_auth.view_model.g.dart';

/// Coordinates restored sessions, invite-only sign-in, refresh, and logout.
@riverpod
class PinkallAuthViewModel extends _$PinkallAuthViewModel {
  StreamSubscription<PinkallAuthSessionEntity?>? _subscription;
  late PinkallAuthRepository _repository;
  late SignInPinkallUseCase _signInUseCase;
  late SignOutPinkallUseCase _signOutUseCase;
  bool _disposed = false;

  @override
  PinkallAuthState build() {
    _repository = ref.watch(pinkallAuthRepositoryProvider);
    _signInUseCase = SignInPinkallUseCase(_repository);
    _signOutUseCase = SignOutPinkallUseCase(_repository);
    ref.onDispose(() {
      _disposed = true;
      unawaited(_subscription?.cancel());
    });
    if (_repository.canSignOut) {
      scheduleMicrotask(_listenForSessionChanges);
    }
    return PinkallAuthState(
      isAvailable: _repository.isAvailable,
      canSignOut: _repository.canSignOut,
      isSubmitting: false,
      session: _repository.currentSession,
    );
  }

  /// Signs in an existing account without retaining either credential.
  Future<bool> signIn({required String email, required String password}) async {
    if (!state.isAvailable || state.isSubmitting) {
      return false;
    }
    state = state.copyWith(isSubmitting: true, failureCode: null);
    final ResultState<void> result = await _signInUseCase.execute(
      PinkallSignInParam(email: email, password: password),
    );
    if (_disposed) {
      return false;
    }
    return result.when<bool>(
      success: (_) {
        state = state.copyWith(
          isSubmitting: false,
          session: _repository.currentSession,
          failureCode: null,
        );
        return true;
      },
      failure: (Exception exception) {
        state = state.copyWith(
          isSubmitting: false,
          failureCode: _failureCode(exception),
        );
        return false;
      },
    );
  }

  /// Ends the current session and returns to the invite-only gate.
  Future<void> signOut() async {
    if (!state.canSignOut || state.isSubmitting) {
      return;
    }
    state = state.copyWith(isSubmitting: true, failureCode: null);
    final ResultState<void> result = await _signOutUseCase.execute();
    if (_disposed) {
      return;
    }
    result.when<void>(
      success: (_) {
        state = state.copyWith(
          isSubmitting: false,
          session: null,
          failureCode: null,
        );
      },
      failure: (Exception exception) {
        state = state.copyWith(
          isSubmitting: false,
          failureCode: _failureCode(exception),
        );
      },
    );
  }

  void _listenForSessionChanges() {
    if (_disposed) {
      return;
    }
    _subscription = _repository.sessionChanges.listen(
      (PinkallAuthSessionEntity? session) {
        if (!_disposed) {
          state = state.copyWith(session: session, failureCode: null);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!_disposed) {
          state = state.copyWith(
            failureCode: error is PinkallAuthException
                ? error.code
                : PinkallAuthFailureCode.networkUnavailable,
          );
        }
      },
      cancelOnError: false,
    );
  }

  static PinkallAuthFailureCode _failureCode(Exception exception) =>
      exception is PinkallAuthException
      ? exception.code
      : PinkallAuthFailureCode.unknown;
}
