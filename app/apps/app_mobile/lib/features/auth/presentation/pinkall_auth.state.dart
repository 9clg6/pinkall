import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pinkall/features/auth/domain/entities/pinkall_auth_session.entity.dart';
import 'package:pinkall/features/auth/domain/pinkall_auth.exception.dart';

part 'pinkall_auth.state.freezed.dart';

/// Immutable UI-safe authentication state.
///
/// It contains identity metadata and stable error codes only. Credentials,
/// bearer tokens, and provider error messages never cross into this state.
@freezed
abstract class PinkallAuthState with _$PinkallAuthState {
  /// Creates the authentication gate state.
  const factory PinkallAuthState({
    required bool isAvailable,
    required bool canSignOut,
    required bool isSubmitting,
    required PinkallAuthSessionEntity? session,
    PinkallAuthFailureCode? failureCode,
  }) = _PinkallAuthState;
}
