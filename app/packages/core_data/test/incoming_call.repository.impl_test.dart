import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:test/test.dart';

void main() {
  test(
    'repository maps native capability and actions into the domain',
    () async {
      final _FakeIncomingCallPlatformClient client =
          _FakeIncomingCallPlatformClient();
      final IncomingCallRepository repository = IncomingCallRepositoryImpl(
        client: client,
      );

      final IncomingCallCapabilityEntity capability = await repository
          .initialize();
      final IncomingCallNativeEventEntity event = await repository
          .watchNativeEvents()
          .single;

      expect(capability.platform, IncomingCallPlatform.ios);
      expect(capability.transport, IncomingCallTransport.apnsVoip);
      expect(capability.isReady, isTrue);
      expect(event.type, IncomingCallNativeEventType.answerRequested);
      expect(event.callId, 'call-1');
      expect(await repository.getNotificationToken(), 'opaque-token');
    },
  );
}

final class _FakeIncomingCallPlatformClient
    implements IncomingCallPlatformClient {
  static const IncomingCallCapabilityRemoteModel capability =
      IncomingCallCapabilityRemoteModel(
        status: 'ready',
        platform: 'ios',
        transport: 'apnsVoip',
        tokenAvailable: true,
        backgroundDeliveryReady: true,
        nativeCallUiReady: true,
        missingRequirements: <String>[],
      );

  @override
  Future<void> dispose() async {}

  @override
  Future<String?> getNotificationToken() async => 'opaque-token';

  @override
  Future<IncomingCallCapabilityRemoteModel> initialize() async => capability;

  @override
  Future<IncomingCallCapabilityRemoteModel> inspectCapability() async =>
      capability;

  @override
  Stream<IncomingCallNativeEventRemoteModel> watchEvents() =>
      Stream<IncomingCallNativeEventRemoteModel>.value(
        const IncomingCallNativeEventRemoteModel(
          type: 'answerRequested',
          callId: 'call-1',
        ),
      );
}
