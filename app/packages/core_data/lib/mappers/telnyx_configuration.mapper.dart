import 'package:core_data/model/remote/telnyx_configuration.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Maps a domain Telnyx configuration to the SDK boundary.
extension TelnyxConfigurationMapper on TelnyxConfigurationEntity {
  /// Converts this configuration to a remote SDK model.
  TelnyxConfigurationRemoteModel toRemoteModel() {
    final TelnyxAuthenticationEntity currentAuthentication = authentication;
    return switch (currentAuthentication) {
      TelnyxTokenAuthenticationEntity(:final String sipToken) =>
        TelnyxConfigurationRemoteModel(
          authenticationMode: 'token',
          sipToken: sipToken,
          callerName: callerName,
          callerNumber: callerNumber,
          notificationToken: notificationToken,
        ),
      TelnyxCredentialsAuthenticationEntity(
        :final String sipUser,
        :final String sipPassword,
      ) =>
        TelnyxConfigurationRemoteModel(
          authenticationMode: 'credentials',
          sipUser: sipUser,
          sipPassword: sipPassword,
          callerName: callerName,
          callerNumber: callerNumber,
          notificationToken: notificationToken,
        ),
    };
  }
}
