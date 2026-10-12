import 'dart:async';

import 'package:core_data/clients/impl/telnyx_sdk.client.impl.dart';
import 'package:core_data/clients/telnyx_call_state_store.dart';
import 'package:core_data/model/remote/telnyx_call.remote.model.dart';
import 'package:core_data/model/remote/telnyx_configuration.remote.model.dart';
import 'package:core_data/model/remote/telnyx_connection.remote.model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telnyx_webrtc/model/audio_constraints.dart';
import 'package:telnyx_webrtc/model/connection_status.dart';
import 'package:telnyx_webrtc/telnyx_webrtc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('dev.fluttercommunity.plus/connectivity_status'),
        (MethodCall call) async => null,
      );

  group('TelnyxSdkClientImpl hardening', () {
    test('rejects a non-positive connection timeout', () {
      expect(
        () => TelnyxSdkClientImpl(connectionTimeout: Duration.zero),
        throwsArgumentError,
      );
    });

    test('reuses a ready client for an equivalent configuration', () async {
      final _FakeTelnyxClient telnyxClient = _FakeTelnyxClient();
      final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
        telnyxClient: telnyxClient,
      );

      await sdkClient.connect(_configuration());
      await sdkClient.connect(_configuration());

      expect(telnyxClient.tokenConnectionCount, 1);
      expect(telnyxClient.disconnectCount, 0);
      await sdkClient.dispose();
    });

    test('dials with an explicitly enabled unmuted microphone', () async {
      final _FakeTelnyxClient telnyxClient = _FakeTelnyxClient();
      final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
        telnyxClient: telnyxClient,
      );

      await sdkClient.connect(_configuration());
      await sdkClient.dial(
        destinationNumber: '+33600000000',
        clientState: 'test-state',
        customHeaders: const <String, String>{},
      );

      expect(telnyxClient.lastUseTrickleIce, isTrue);
      expect(telnyxClient.lastMutedMicOnStart, isFalse);
      expect(telnyxClient.lastAudioConstraints, AudioConstraints.enabled());
      await sdkClient.dispose();
    });

    test(
      'keeps an answered call connecting until WebRTC media is active',
      () async {
        final _FakeTelnyxClient telnyxClient = _FakeTelnyxClient();
        final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
          telnyxClient: telnyxClient,
        );
        await sdkClient.connect(_configuration());
        final String callId = await sdkClient.dial(
          destinationNumber: '+33600000000',
          clientState: 'test-state',
          customHeaders: const <String, String>{},
        );
        final List<String> statuses = <String>[];
        final StreamSubscription<TelnyxCallRemoteModel> subscription = sdkClient
            .watchCallState(callId)
            .listen(
              (TelnyxCallRemoteModel state) => statuses.add(state.status),
            );
        await Future<void>.delayed(Duration.zero);

        telnyxClient.onSocketMessageReceived(
          TelnyxMessage(
            socketMethod: SocketMethod.answer,
            message: ReceivedMessage(
              inviteParams: IncomingInviteParams(callID: callId),
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(statuses, <String>['newCall', 'connecting']);

        telnyxClient.lastInvitedCall!.callHandler.changeState(CallState.active);
        await Future<void>.delayed(Duration.zero);

        expect(statuses, <String>['newCall', 'connecting', 'active']);
        await subscription.cancel();
        await sdkClient.dispose();
      },
    );

    test('reports an initial media connection failure explicitly', () async {
      final _FakeTelnyxClient telnyxClient = _FakeTelnyxClient();
      final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
        telnyxClient: telnyxClient,
      );
      await sdkClient.connect(_configuration());
      final String callId = await sdkClient.dial(
        destinationNumber: '+33600000000',
        clientState: 'test-state',
        customHeaders: const <String, String>{},
      );
      final List<TelnyxCallRemoteModel> states = <TelnyxCallRemoteModel>[];
      final StreamSubscription<TelnyxCallRemoteModel> subscription = sdkClient
          .watchCallState(callId)
          .listen(states.add);
      await Future<void>.delayed(Duration.zero);

      telnyxClient.lastInvitedCall!.callHandler.changeState(CallState.error);
      await Future<void>.delayed(Duration.zero);

      expect(states.last.status, 'error');
      expect(states.last.failureReason, 'media_connection_failed');
      await subscription.cancel();
      await sdkClient.dispose();
    });

    test('times out and releases a client that never becomes ready', () async {
      final _FakeTelnyxClient telnyxClient = _FakeTelnyxClient(
        becomesReady: false,
      );
      final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
        telnyxClient: telnyxClient,
        connectionTimeout: const Duration(milliseconds: 10),
      );
      final List<TelnyxConnectionRemoteModel> states =
          <TelnyxConnectionRemoteModel>[];
      final StreamSubscription<TelnyxConnectionRemoteModel> subscription =
          sdkClient.watchConnectionStates().listen(states.add);

      await expectLater(
        sdkClient.connect(_configuration()),
        throwsA(isA<TimeoutException>()),
      );

      expect(telnyxClient.disconnectCount, 1);
      expect(
        states,
        contains(
          const TelnyxConnectionRemoteModel(
            status: 'failure',
            failureReason: 'connection_timeout',
          ),
        ),
      );
      await subscription.cancel();
      await sdkClient.dispose();
    });

    test('releases the client when the SDK connect call throws', () async {
      final _FakeTelnyxClient telnyxClient = _FakeTelnyxClient(
        connectError: StateError('SDK connect failed'),
      );
      final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
        telnyxClient: telnyxClient,
      );

      await expectLater(sdkClient.connect(_configuration()), throwsStateError);

      expect(telnyxClient.disconnectCount, 1);
      await sdkClient.dispose();
    });

    test(
      'ignores reconnecting callbacks before runtime configuration',
      () async {
        final TelnyxClient telnyxClient = TelnyxClient();
        final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
          telnyxClient: telnyxClient,
        );
        final List<String> statuses = <String>[];
        final StreamSubscription<TelnyxConnectionRemoteModel> subscription =
            sdkClient.watchConnectionStates().listen(
              (TelnyxConnectionRemoteModel state) => statuses.add(state.status),
            );

        telnyxClient.onConnectionStateChanged!(ConnectionStatus.reconnecting);

        expect(statuses, isEmpty);
        await subscription.cancel();
        await sdkClient.dispose();
      },
    );

    test(
      'releases the TelnyxClient without eagerly creating another',
      () async {
        final TelnyxClient initialClient = TelnyxClient();
        final List<TelnyxClient> replacementClients = <TelnyxClient>[];
        final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
          telnyxClient: initialClient,
          telnyxClientFactory: () {
            final TelnyxClient replacement = TelnyxClient();
            replacementClients.add(replacement);
            return replacement;
          },
        );

        await sdkClient.disconnect();

        expect(replacementClients, isEmpty);
        await sdkClient.dispose();
      },
    );

    test('disconnect makes every open snapshot terminal', () async {
      final TelnyxCallStateStore store = TelnyxCallStateStore()
        ..add(
          const TelnyxCallRemoteModel(
            callId: 'incoming-42',
            direction: 'incoming',
            status: 'ringing',
          ),
        );
      final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
        telnyxClient: TelnyxClient(),
        callStateStore: store,
      );
      final Future<void> terminalExpectation = expectLater(
        sdkClient
            .watchCallState('incoming-42')
            .map((TelnyxCallRemoteModel state) => state.status),
        emitsInOrder(<String>['ringing', 'ended']),
      );

      await sdkClient.disconnect();

      await terminalExpectation;
      await sdkClient.dispose();
    });

    test('hang up fails when the SDK does not confirm done', () async {
      final TelnyxClient telnyxClient = TelnyxClient()
        ..gatewayState = GatewayState.failed;
      final Call call = _addCall(
        telnyxClient,
        callId: 'call-42',
        state: CallState.active,
      );
      final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
        telnyxClient: telnyxClient,
      );

      await expectLater(sdkClient.hangUp('call-42'), throwsStateError);

      expect(call.callState, CallState.active);
      await sdkClient.dispose();
    });

    test('reject fails when the SDK does not confirm done', () async {
      final TelnyxClient telnyxClient = TelnyxClient()
        ..gatewayState = GatewayState.failed;
      final Call call = _addCall(
        telnyxClient,
        callId: 'call-42',
        state: CallState.ringing,
      );
      final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
        telnyxClient: telnyxClient,
      );

      await expectLater(sdkClient.reject('call-42'), throwsStateError);

      expect(call.callState, CallState.ringing);
      await sdkClient.dispose();
    });

    test('audio controls reject calls without active media', () async {
      final TelnyxClient telnyxClient = TelnyxClient();
      final Call call = _addCall(
        telnyxClient,
        callId: 'call-42',
        state: CallState.connecting,
      );
      final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
        telnyxClient: telnyxClient,
      );

      await expectLater(
        sdkClient.setMuted('call-42', isMuted: true),
        throwsStateError,
      );
      call.callState = CallState.active;
      await expectLater(
        sdkClient.setSpeakerEnabled('call-42', isEnabled: true),
        throwsStateError,
      );

      await sdkClient.dispose();
    });

    test(
      'preserves the SIP reason when a BYE makes the call terminal',
      () async {
        final _FakeTelnyxClient telnyxClient = _FakeTelnyxClient();
        final TelnyxSdkClientImpl sdkClient = TelnyxSdkClientImpl(
          telnyxClient: telnyxClient,
        );
        await sdkClient.connect(_configuration());
        final String callId = await sdkClient.dial(
          destinationNumber: '+33600000000',
          clientState: 'test-state',
          customHeaders: const <String, String>{},
        );
        final List<TelnyxCallRemoteModel> states = <TelnyxCallRemoteModel>[];
        final StreamSubscription<TelnyxCallRemoteModel> subscription = sdkClient
            .watchCallState(callId)
            .listen(states.add);

        telnyxClient.onSocketMessageReceived(
          TelnyxMessage(
            socketMethod: SocketMethod.bye,
            message: ReceivedMessage(
              byeParams: ReceiveByeParams(callID: callId),
            ),
          ),
        );
        telnyxClient.lastInvitedCall!.callHandler.changeState(
          CallState.done.withTerminationReason(
            const CallTerminationReason(
              cause: 'CALL_REJECTED',
              causeCode: 21,
              sipCode: 603,
              sipReason: 'Account disabled D17',
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(states.last.status, 'ended');
        expect(states.last.failureReason, 'SIP 603: Account disabled D17');
        expect(
          states.where(
            (TelnyxCallRemoteModel state) => state.status == 'ended',
          ),
          hasLength(1),
        );
        await subscription.cancel();
        await sdkClient.dispose();
      },
    );
  });
}

TelnyxConfigurationRemoteModel _configuration() {
  return const TelnyxConfigurationRemoteModel(
    authenticationMode: 'token',
    sipToken: 'test-token',
    callerName: 'Pinkall test',
    callerNumber: '+33100000000',
  );
}

final class _FakeTelnyxClient extends TelnyxClient {
  _FakeTelnyxClient({this.becomesReady = true, this.connectError});

  final bool becomesReady;
  final Object? connectError;
  ConnectionStatus _status = ConnectionStatus.disconnected;
  int tokenConnectionCount = 0;
  int disconnectCount = 0;
  Call? lastInvitedCall;
  bool? lastUseTrickleIce;
  bool? lastMutedMicOnStart;
  AudioConstraints? lastAudioConstraints;

  @override
  ConnectionStatus getConnectionStatus() => _status;

  @override
  void connectWithToken(TokenConfig tokenConfig) {
    tokenConnectionCount++;
    final Object? currentError = connectError;
    if (currentError != null) {
      throw currentError;
    }
    _status = ConnectionStatus.connected;
    onConnectionStateChanged?.call(_status);
    if (becomesReady) {
      _status = ConnectionStatus.clientReady;
      onConnectionStateChanged?.call(_status);
    }
  }

  @override
  void disconnect() {
    disconnectCount++;
    _status = ConnectionStatus.disconnected;
    onConnectionStateChanged?.call(_status);
  }

  @override
  Call newInvite(
    String callerName,
    String callerNumber,
    String destinationNumber,
    String clientState, {
    Map<String, String> customHeaders = const <String, String>{},
    List<AudioCodec>? preferredCodecs,
    bool debug = false,
    bool useTrickleIce = false,
    bool mutedMicOnStart = false,
    AudioConstraints? audioConstraints,
  }) {
    lastUseTrickleIce = useTrickleIce;
    lastMutedMicOnStart = mutedMicOnStart;
    lastAudioConstraints = audioConstraints;
    final Call call = _addCall(
      this,
      callId: 'outbound-test-call',
      state: CallState.newCall,
    );
    lastInvitedCall = call;
    return call;
  }
}

Call _addCall(
  TelnyxClient client, {
  required String callId,
  required CallState state,
}) {
  final CallHandler handler = CallHandler((CallState _) {}, null);
  final Call call =
      Call(
          client.txSocket,
          client,
          'test-session',
          '',
          '',
          handler,
          () {},
          false,
        )
        ..callId = callId
        ..callState = state;
  handler.call = call;
  client.calls[callId] = call;
  return call;
}
