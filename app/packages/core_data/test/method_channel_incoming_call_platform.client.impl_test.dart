import 'package:core_data/core_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('test.incoming_calls');

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('decodes truthful capability flags without a token value', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          expect(call.method, 'initialize');
          return <String, Object?>{
            'status': 'configurationRequired',
            'platform': 'android',
            'transport': 'fcm',
            'token_available': true,
            'background_delivery_ready': true,
            'native_call_ui_ready': false,
            'missing_requirements': <String>[
              'android_incoming_call_notification_ui',
            ],
          };
        });
    const MethodChannelIncomingCallPlatformClientImpl client =
        MethodChannelIncomingCallPlatformClientImpl(methodChannel: channel);

    final IncomingCallCapabilityRemoteModel capability = await client
        .initialize();

    expect(capability.status, 'configurationRequired');
    expect(capability.tokenAvailable, isTrue);
    expect(capability.nativeCallUiReady, isFalse);
    expect(capability.missingRequirements, <String>[
      'android_incoming_call_notification_ui',
    ]);
  });

  test('reads the opaque token separately from capability state', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (MethodCall call) async =>
              call.method == 'getNotificationToken' ? ' opaque-token ' : null,
        );
    const MethodChannelIncomingCallPlatformClientImpl client =
        MethodChannelIncomingCallPlatformClientImpl(methodChannel: channel);

    expect(await client.getNotificationToken(), 'opaque-token');
  });

  test('decodes only bounded Telnyx routing metadata from events', () async {
    final MethodChannelIncomingCallPlatformClientImpl client =
        MethodChannelIncomingCallPlatformClientImpl(
          methodChannel: channel,
          eventStreamFactory: () => Stream<Object?>.value(<String, Object?>{
            'type': 'incomingCall',
            'call_id': 'call-123',
            'caller_name': 'Maya',
            'caller_number': '+33611223344',
            'voice_sdk_id': 'voice-sdk-1',
          }),
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (_) async => <String, Object?>{
            'status': 'registering',
            'platform': 'ios',
            'transport': 'apnsVoip',
            'token_available': false,
            'background_delivery_ready': false,
            'native_call_ui_ready': true,
            'missing_requirements': <String>['apns_voip_token_pending'],
          },
        );

    final IncomingCallNativeEventRemoteModel event = await client
        .watchEvents()
        .single;

    expect(event.type, 'incomingCall');
    expect(event.callId, 'call-123');
    expect(event.voiceSdkId, 'voice-sdk-1');
  });

  test('rejects a native ready claim with malformed booleans', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (_) async => <String, Object?>{
            'status': 'ready',
            'platform': 'ios',
            'transport': 'apnsVoip',
            'token_available': 'yes',
            'background_delivery_ready': true,
            'native_call_ui_ready': true,
            'missing_requirements': <String>[],
          },
        );
    const MethodChannelIncomingCallPlatformClientImpl client =
        MethodChannelIncomingCallPlatformClientImpl(methodChannel: channel);

    await expectLater(client.inspectCapability(), throwsFormatException);
  });
}
