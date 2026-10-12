import 'package:core_data/datasources/remote/telnyx.remote.data_source.dart';
import 'package:core_data/mappers/telnyx_call.mapper.dart';
import 'package:core_data/mappers/telnyx_configuration.mapper.dart';
import 'package:core_data/mappers/telnyx_connection.mapper.dart';
import 'package:core_data/model/remote/telnyx_call.remote.model.dart';
import 'package:core_data/model/remote/telnyx_connection.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Telnyx-backed implementation of the calling repository.
final class CallRepositoryImpl implements CallRepository {
  /// Creates the repository with its [telnyxRemoteDataSource].
  const CallRepositoryImpl({
    required TelnyxRemoteDataSource telnyxRemoteDataSource,
  }) : _remoteDataSource = telnyxRemoteDataSource;

  final TelnyxRemoteDataSource _remoteDataSource;

  @override
  Future<void> accept(String callId) => _remoteDataSource.accept(callId);

  @override
  Future<void> connect(TelnyxConfigurationEntity configuration) {
    return _remoteDataSource.connect(configuration.toRemoteModel());
  }

  @override
  Future<String> dial({
    required String destinationNumber,
    required String clientState,
    required Map<String, String> customHeaders,
  }) {
    return _remoteDataSource.dial(
      destinationNumber: destinationNumber,
      clientState: clientState,
      customHeaders: customHeaders,
    );
  }

  @override
  Future<void> disconnect() => _remoteDataSource.disconnect();

  @override
  Future<void> dispose() => _remoteDataSource.dispose();

  @override
  Future<void> ensureMicrophoneAccess() {
    return _remoteDataSource.ensureMicrophoneAccess();
  }

  @override
  Future<void> hangUp(String callId) => _remoteDataSource.hangUp(callId);

  @override
  Future<void> reject(String callId) => _remoteDataSource.reject(callId);

  @override
  Future<void> setMuted(String callId, {required bool isMuted}) {
    return _remoteDataSource.setMuted(callId, isMuted: isMuted);
  }

  @override
  Future<void> setSpeakerEnabled(String callId, {required bool isEnabled}) {
    return _remoteDataSource.setSpeakerEnabled(callId, isEnabled: isEnabled);
  }

  @override
  Stream<CallStateEntity> watchCallStates() {
    return _remoteDataSource.watchCallStates().map(
      (TelnyxCallRemoteModel model) => model.toEntity(),
    );
  }

  @override
  Stream<CallStateEntity> watchCallState(String callId) {
    return _remoteDataSource
        .watchCallState(callId)
        .map((TelnyxCallRemoteModel model) => model.toEntity());
  }

  @override
  Stream<TelnyxConnectionStateEntity> watchConnectionStates() {
    return _remoteDataSource.watchConnectionStates().map(
      (TelnyxConnectionRemoteModel model) => model.toEntity(),
    );
  }
}
