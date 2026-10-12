import 'package:core_domain/domain/entities/telnyx_configuration.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connect_telnyx.param.freezed.dart';

/// Parameters used to connect and register the Telnyx WebRTC client.
@Freezed(toStringOverride: false, equal: false)
abstract class ConnectTelnyxParam with _$ConnectTelnyxParam {
  const ConnectTelnyxParam._();

  /// Creates connection parameters.
  const factory ConnectTelnyxParam({
    required TelnyxConfigurationEntity configuration,
  }) = _ConnectTelnyxParam;

  @override
  String toString() => 'ConnectTelnyxParam(<redacted>)';
}
