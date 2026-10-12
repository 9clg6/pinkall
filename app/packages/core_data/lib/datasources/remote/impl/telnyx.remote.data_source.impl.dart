import 'package:core_data/clients/impl/webrtc_microphone_access_probe.impl.dart';
import 'package:core_data/clients/microphone_access_probe.dart';
import 'package:core_data/clients/telnyx_sdk.client.dart';
import 'package:core_data/datasources/remote/telnyx.remote.data_source.dart';
import 'package:core_data/model/remote/telnyx_call.remote.model.dart';
import 'package:core_data/model/remote/telnyx_configuration.remote.model.dart';
import 'package:core_data/model/remote/telnyx_connection.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Telnyx remote source backed by a testable SDK boundary.
final class TelnyxRemoteDataSourceImpl implements TelnyxRemoteDataSource {
  /// Creates the source with its [telnyxSdkClient].
  TelnyxRemoteDataSourceImpl({
    required TelnyxSdkClient telnyxSdkClient,
    MicrophoneAccessProbe? microphoneAccessProbe,
  }) : _telnyxSdkClient = telnyxSdkClient,
       _microphoneAccessProbe =
           microphoneAccessProbe ?? const WebRtcMicrophoneAccessProbe();

  final TelnyxSdkClient _telnyxSdkClient;
  final MicrophoneAccessProbe _microphoneAccessProbe;

  @override
  Future<void> accept(String callId) => _telnyxSdkClient.accept(callId);

  @override
  Future<void> connect(TelnyxConfigurationRemoteModel configuration) {
    return _telnyxSdkClient.connect(configuration);
  }

  @override
  Future<String> dial({
    required String destinationNumber,
    required String clientState,
    required Map<String, String> customHeaders,
  }) {
    return _telnyxSdkClient.dial(
      destinationNumber: destinationNumber,
      clientState: clientState,
      customHeaders: customHeaders,
    );
  }

  @override
  Future<void> disconnect() => _telnyxSdkClient.disconnect();

  @override
  Future<void> dispose() => _telnyxSdkClient.dispose();

  @override
  Future<void> ensureMicrophoneAccess() async {
    try {
      await _microphoneAccessProbe.ensureAccess();
    } on CallOperationException catch (exception) {
      throw exception;
    } catch (_) {
      throw const CallOperationException(
        code: CallFailureCode.microphoneAccessDenied,
      );
    }
  }

  @override
  Future<void> hangUp(String callId) => _telnyxSdkClient.hangUp(callId);

  @override
  Future<void> reject(String callId) => _telnyxSdkClient.reject(callId);

  @override
  Future<void> setMuted(String callId, {required bool isMuted}) {
    return _telnyxSdkClient.setMuted(callId, isMuted: isMuted);
  }

  @override
  Future<void> setSpeakerEnabled(String callId, {required bool isEnabled}) {
    return _telnyxSdkClient.setSpeakerEnabled(callId, isEnabled: isEnabled);
  }

  @override
  Stream<TelnyxCallRemoteModel> watchCallStates() {
    return _telnyxSdkClient.watchCallStates();
  }

  @override
  Stream<TelnyxCallRemoteModel> watchCallState(String callId) {
    return _telnyxSdkClient.watchCallState(callId);
  }

  @override
  Stream<TelnyxConnectionRemoteModel> watchConnectionStates() {
    return _telnyxSdkClient.watchConnectionStates();
  }
}
