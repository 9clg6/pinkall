import 'package:core_data/clients/incoming_call_platform.client.dart';
import 'package:core_data/mappers/incoming_call.mapper.dart';
import 'package:core_data/model/remote/incoming_call_native_event.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Native-backed implementation of background incoming-call readiness.
final class IncomingCallRepositoryImpl implements IncomingCallRepository {
  /// Creates the repository.
  const IncomingCallRepositoryImpl({required IncomingCallPlatformClient client})
    : _client = client;

  final IncomingCallPlatformClient _client;

  @override
  Future<IncomingCallCapabilityEntity> initialize() async =>
      (await _client.initialize()).toDomain();

  @override
  Future<IncomingCallCapabilityEntity> inspectCapability() async =>
      (await _client.inspectCapability()).toDomain();

  @override
  Future<String?> getNotificationToken() => _client.getNotificationToken();

  @override
  Stream<IncomingCallNativeEventEntity> watchNativeEvents() => _client
      .watchEvents()
      .map((IncomingCallNativeEventRemoteModel event) => event.toDomain());

  @override
  Future<void> dispose() => _client.dispose();
}
