import 'package:freezed_annotation/freezed_annotation.dart';

part 'pinkall_auth_session.entity.freezed.dart';

/// Minimal authenticated identity exposed to the presentation layer.
@freezed
abstract class PinkallAuthSessionEntity with _$PinkallAuthSessionEntity {
  /// Creates an authenticated Pinkall session identity.
  const factory PinkallAuthSessionEntity({
    required String userId,
    String? email,
    @Default(false) bool isLegacyDevelopmentSession,
  }) = _PinkallAuthSessionEntity;
}
