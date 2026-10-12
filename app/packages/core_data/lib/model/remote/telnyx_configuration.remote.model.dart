import 'package:freezed_annotation/freezed_annotation.dart';

part 'telnyx_configuration.remote.model.freezed.dart';

/// Internal configuration passed to the Telnyx SDK adapter.
@Freezed(toStringOverride: false, equal: false)
abstract class TelnyxConfigurationRemoteModel
    with _$TelnyxConfigurationRemoteModel {
  const TelnyxConfigurationRemoteModel._();

  /// Creates an SDK configuration model.
  const factory TelnyxConfigurationRemoteModel({
    required String authenticationMode,
    String? sipToken,
    String? sipUser,
    String? sipPassword,
    required String callerName,
    required String callerNumber,
    String? notificationToken,
  }) = _TelnyxConfigurationRemoteModel;

  @override
  String toString() => 'TelnyxConfigurationRemoteModel(<redacted>)';
}
