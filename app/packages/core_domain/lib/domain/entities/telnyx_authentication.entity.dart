import 'package:freezed_annotation/freezed_annotation.dart';

part 'telnyx_authentication.entity.freezed.dart';

/// Authentication material supplied at runtime to the Telnyx SDK.
///
/// Secrets are intentionally redacted from [toString]. Callers must obtain them
/// from runtime configuration or a secure backend, never from source code.
@Freezed(toStringOverride: false, equal: false)
sealed class TelnyxAuthenticationEntity with _$TelnyxAuthenticationEntity {
  const TelnyxAuthenticationEntity._();

  /// Uses an ephemeral or server-issued Telnyx SIP token.
  const factory TelnyxAuthenticationEntity.token({required String sipToken}) =
      TelnyxTokenAuthenticationEntity;

  /// Uses a Telnyx SIP Connection username and password.
  const factory TelnyxAuthenticationEntity.credentials({
    required String sipUser,
    required String sipPassword,
  }) = TelnyxCredentialsAuthenticationEntity;

  @override
  String toString() => 'TelnyxAuthenticationEntity(<redacted>)';
}
