import 'package:core_domain/core_domain.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:test/test.dart';

void main() {
  group('incoming-call capability', () {
    test('is ready only when push and native UI are both verified', () {
      const IncomingCallCapabilityEntity capability =
          IncomingCallCapabilityEntity(
            status: IncomingCallCapabilityStatus.ready,
            platform: IncomingCallPlatform.ios,
            transport: IncomingCallTransport.apnsVoip,
            tokenAvailable: true,
            backgroundDeliveryReady: true,
            nativeCallUiReady: true,
            missingRequirements: <String>[],
          );

      expect(capability.isReady, isTrue);
      expect(capability.copyWith(nativeCallUiReady: false).isReady, isFalse);
    });

    test('use cases preserve explicit native capability and events', () async {
      final _FakeIncomingCallRepository repository =
          _FakeIncomingCallRepository();

      final ResultState<IncomingCallCapabilityEntity> initialized =
          await InitializeIncomingCallsUseCase(
            incomingCallRepository: repository,
          ).execute();
      final ResultState<IncomingCallCapabilityEntity> inspected =
          await InspectIncomingCallCapabilityUseCase(
            incomingCallRepository: repository,
          ).execute();
      final ResultState<IncomingCallNativeEventEntity> event =
          await WatchIncomingCallNativeEventsUseCase(
            incomingCallRepository: repository,
          ).execute().first;

      expect(
        initialized,
        ResultState<IncomingCallCapabilityEntity>.success(
          repository.capability,
        ),
      );
      expect(
        inspected,
        ResultState<IncomingCallCapabilityEntity>.success(
          repository.capability,
        ),
      );
      expect(
        event,
        const ResultState<IncomingCallNativeEventEntity>.success(
          IncomingCallNativeEventEntity(
            type: IncomingCallNativeEventType.incomingCall,
            callId: 'call-real-1',
          ),
        ),
      );
    });
  });
}

final class _FakeIncomingCallRepository implements IncomingCallRepository {
  final IncomingCallCapabilityEntity capability =
      const IncomingCallCapabilityEntity(
        status: IncomingCallCapabilityStatus.configurationRequired,
        platform: IncomingCallPlatform.android,
        transport: IncomingCallTransport.fcm,
        tokenAvailable: true,
        backgroundDeliveryReady: true,
        nativeCallUiReady: false,
        missingRequirements: <String>['android_incoming_call_notification_ui'],
      );

  @override
  Future<void> dispose() async {}

  @override
  Future<String?> getNotificationToken() async => 'opaque-token';

  @override
  Future<IncomingCallCapabilityEntity> initialize() async => capability;

  @override
  Future<IncomingCallCapabilityEntity> inspectCapability() async => capability;

  @override
  Stream<IncomingCallNativeEventEntity> watchNativeEvents() =>
      Stream<IncomingCallNativeEventEntity>.value(
        const IncomingCallNativeEventEntity(
          type: IncomingCallNativeEventType.incomingCall,
          callId: 'call-real-1',
        ),
      );
}
