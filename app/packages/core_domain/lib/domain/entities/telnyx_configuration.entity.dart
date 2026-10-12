import 'package:core_domain/domain/entities/telnyx_authentication.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'telnyx_configuration.entity.freezed.dart';

/// Runtime configuration required to register a Telnyx WebRTC client.
@Freezed(toStringOverride: false, equal: false)
abstract class TelnyxConfigurationEntity with _$TelnyxConfigurationEntity {
  const TelnyxConfigurationEntity._();

  /// Creates a Telnyx client configuration.
  const factory TelnyxConfigurationEntity({
    required TelnyxAuthenticationEntity authentication,
    required String callerName,
    required String callerNumber,
    String? notificationToken,
  }) = _TelnyxConfigurationEntity;

  @override
  String toString() => 'TelnyxConfigurationEntity(<redacted>)';
}
