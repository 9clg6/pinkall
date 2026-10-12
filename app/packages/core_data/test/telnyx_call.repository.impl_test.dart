import 'dart:io';

import 'package:core_data/clients/microphone_access_probe.dart';
import 'package:core_data/clients/telnyx_sdk.client.dart';
import 'package:core_data/datasources/remote/impl/telnyx.remote.data_source.impl.dart';
import 'package:core_data/model/remote/telnyx_call.remote.model.dart';
import 'package:core_data/model/remote/telnyx_configuration.remote.model.dart';
import 'package:core_data/model/remote/telnyx_connection.remote.model.dart';
import 'package:core_data/repositories/call.repository.impl.dart';
import 'package:core_domain/core_domain.dart';
import 'package:test/test.dart';

void main() {
  group('CallRepositoryImpl with Telnyx', () {
    test('maps token runtime configuration into the SDK boundary', () async {
      final _FakeTelnyxSdkClient sdkClient = _FakeTelnyxSdkClient();
      final CallRepository repository = _repositoryFor(sdkClient);

      await repository.connect(
        const TelnyxConfigurationEntity(
          authentication: TelnyxAuthenticationEntity.token(
            sipToken: 'test-token',
          ),
          callerName: 'Pinkall test',
          callerNumber: '+33100000000',
          notificationToken: 'test-device-token',
        ),
      );

      expect(sdkClient.configuration?.authenticationMode, 'token');
      expect(sdkClient.configuration?.sipToken, 'test-token');
      expect(sdkClient.configuration?.sipPassword, isNull);
      expect(sdkClient.configuration?.callerNumber, '+33100000000');
      expect(sdkClient.configuration?.notificationToken, 'test-device-token');
    });

    test(
      'maps credential runtime configuration into the SDK boundary',
      () async {
        final _FakeTelnyxSdkClient sdkClient = _FakeTelnyxSdkClient();
        final CallRepository repository = _repositoryFor(sdkClient);

        await repository.connect(
          const TelnyxConfigurationEntity(
            authentication: TelnyxAuthenticationEntity.credentials(
              sipUser: 'test-user',
              sipPassword: 'test-password',
            ),
            callerName: 'Pinkall test',
            callerNumber: '+33100000000',
          ),
        );

        expect(sdkClient.configuration?.authenticationMode, 'credentials');
        expect(sdkClient.configuration?.sipUser, 'test-user');
        expect(sdkClient.configuration?.sipPassword, 'test-password');
        expect(sdkClient.configuration?.sipToken, isNull);
      },
    );

    test('maps real SDK call events to domain snapshots', () async {
      const TelnyxCallRemoteModel remoteCall = TelnyxCallRemoteModel(
        callId: 'telnyx-call-42',
        direction: 'incoming',
        status: 'ringing',
        remoteName: 'Prospect test',
        remoteNumber: '+33600000000',
      );
      final _FakeTelnyxSdkClient sdkClient = _FakeTelnyxSdkClient(
        callStates: Stream<TelnyxCallRemoteModel>.value(remoteCall),
      );
      final CallRepository repository = _repositoryFor(sdkClient);

      await expectLater(
        repository.watchCallStates(),
        emits(
          const CallStateEntity(
            callId: 'telnyx-call-42',
            direction: CallDirection.incoming,
            status: CallLifecycleStatus.ringing,
            remoteName: 'Prospect test',
            remoteNumber: '+33600000000',
          ),
        ),
      );
    });

    test('maps the replaying stream for one call', () async {
      const TelnyxCallRemoteModel remoteCall = TelnyxCallRemoteModel(
        callId: 'telnyx-call-42',
        direction: 'outgoing',
        status: 'active',
      );
      final _FakeTelnyxSdkClient sdkClient = _FakeTelnyxSdkClient(
        callStatesById: <String, Stream<TelnyxCallRemoteModel>>{
          'telnyx-call-42': Stream<TelnyxCallRemoteModel>.value(remoteCall),
        },
      );
      final CallRepository repository = _repositoryFor(sdkClient);

      await expectLater(
        repository.watchCallState('telnyx-call-42'),
        emits(
          const CallStateEntity(
            callId: 'telnyx-call-42',
            direction: CallDirection.outgoing,
            status: CallLifecycleStatus.active,
          ),
        ),
      );
      expect(sdkClient.watchedCallId, 'telnyx-call-42');
    });

    test('maps SDK connection events to domain snapshots', () async {
      const TelnyxConnectionRemoteModel remoteConnection =
          TelnyxConnectionRemoteModel(status: 'ready');
      final _FakeTelnyxSdkClient sdkClient = _FakeTelnyxSdkClient(
        connectionStates: Stream<TelnyxConnectionRemoteModel>.value(
          remoteConnection,
        ),
      );
      final CallRepository repository = _repositoryFor(sdkClient);

      await expectLater(
        repository.watchConnectionStates(),
        emits(
          const TelnyxConnectionStateEntity(
            status: TelnyxConnectionStatus.ready,
          ),
        ),
      );
    });

    test('places an outbound call through the SDK boundary', () async {
      final _FakeTelnyxSdkClient sdkClient = _FakeTelnyxSdkClient();
      final CallRepository repository = _repositoryFor(sdkClient);
      const DialCallParam params = DialCallParam(
        destinationNumber: '+33102030405',
        clientState: 'prospect-42',
        customHeaders: <String, String>{'X-Pinkall-Prospect': '42'},
      );

      final String callId = await repository.dial(
        destinationNumber: params.destinationNumber,
        clientState: params.clientState,
        customHeaders: params.customHeaders,
      );

      expect(callId, 'real-sdk-call-id');
      expect(sdkClient.destinationNumber, params.destinationNumber);
      expect(sdkClient.clientState, params.clientState);
      expect(sdkClient.customHeaders, params.customHeaders);
    });

    test('delegates incoming and active call controls', () async {
      final _FakeTelnyxSdkClient sdkClient = _FakeTelnyxSdkClient();
      final CallRepository repository = _repositoryFor(sdkClient);

      await repository.accept('call-42');
      await repository.reject('call-43');
      await repository.hangUp('call-44');
      await repository.setMuted('call-44', isMuted: true);
      await repository.setSpeakerEnabled('call-44', isEnabled: true);
      await repository.disconnect();
      await repository.dispose();

      expect(sdkClient.acceptedCallId, 'call-42');
      expect(sdkClient.rejectedCallId, 'call-43');
      expect(sdkClient.hungUpCallId, 'call-44');
      expect(sdkClient.mutedCallId, 'call-44');
      expect(sdkClient.isMuted, isTrue);
      expect(sdkClient.speakerCallId, 'call-44');
      expect(sdkClient.isSpeakerEnabled, isTrue);
      expect(sdkClient.didDisconnect, isTrue);
      expect(sdkClient.didDispose, isTrue);
    });

    test('maps a native microphone failure to a safe domain error', () async {
      final _FakeTelnyxSdkClient sdkClient = _FakeTelnyxSdkClient();
      final CallRepository repository = _repositoryFor(
        sdkClient,
        microphoneAccessProbe: _ThrowingMicrophoneAccessProbe(),
      );

      await expectLater(
        repository.ensureMicrophoneAccess(),
        throwsA(
          isA<CallOperationException>()
              .having(
                (CallOperationException exception) => exception.code,
                'code',
                CallFailureCode.microphoneAccessDenied,
              )
              .having(
                (CallOperationException exception) => exception.toString(),
                'safe text',
                isNot(contains('native-permission-details')),
              ),
        ),
      );
    });

    test('runtime SDK configuration has no JSON serializer', () {
      const TelnyxConfigurationRemoteModel configuration =
          TelnyxConfigurationRemoteModel(
            authenticationMode: 'token',
            sipToken: 'test-token',
            callerName: 'Pinkall test',
            callerNumber: '+33100000000',
          );

      expect(
        () => (configuration as dynamic).toJson(),
        throwsNoSuchMethodError,
      );
      expect(configuration.toString(), isNot(contains('test-token')));
    });

    test('runtime SDK configuration uses identity equality', () {
      final TelnyxConfigurationRemoteModel first =
          TelnyxConfigurationRemoteModel(
            authenticationMode: 'credentials',
            sipUser: 'same-user',
            sipPassword: 'same-password',
            callerName: 'Pinkall test',
            callerNumber: '+33100000000',
          );
      final TelnyxConfigurationRemoteModel second =
          TelnyxConfigurationRemoteModel(
            authenticationMode: 'credentials',
            sipUser: 'same-user',
            sipPassword: 'same-password',
            callerName: 'Pinkall test',
            callerNumber: '+33100000000',
          );

      expect(first == second, isFalse);
    });

    test('generated SDK configuration has no JSON or equality code', () {
      final String source = _dataGeneratedFile(
        'model/remote/telnyx_configuration.remote.model.freezed.dart',
      ).readAsStringSync();

      expect(source, isNot(contains('toJson(')));
      expect(source, isNot(contains('operator ==')));
      expect(source, isNot(contains('hashCode')));
    });

    test('remote models support JSON without runtime fixtures', () {
      const TelnyxCallRemoteModel call = TelnyxCallRemoteModel(
        callId: 'call-42',
        direction: 'outgoing',
        status: 'active',
      );
      const TelnyxConnectionRemoteModel connection =
          TelnyxConnectionRemoteModel(status: 'connected');

      expect(TelnyxCallRemoteModel.fromJson(call.toJson()), call);
      expect(
        TelnyxConnectionRemoteModel.fromJson(connection.toJson()),
        connection,
      );
    });
  });
}

CallRepository _repositoryFor(
  _FakeTelnyxSdkClient sdkClient, {
  MicrophoneAccessProbe? microphoneAccessProbe,
}) {
  return CallRepositoryImpl(
    telnyxRemoteDataSource: TelnyxRemoteDataSourceImpl(
      telnyxSdkClient: sdkClient,
      microphoneAccessProbe: microphoneAccessProbe,
    ),
  );
}

final class _FakeTelnyxSdkClient implements TelnyxSdkClient {
  _FakeTelnyxSdkClient({
    this.connectionStates = const Stream<TelnyxConnectionRemoteModel>.empty(),
    this.callStates = const Stream<TelnyxCallRemoteModel>.empty(),
    this.callStatesById = const <String, Stream<TelnyxCallRemoteModel>>{},
  });

  final Stream<TelnyxConnectionRemoteModel> connectionStates;
  final Stream<TelnyxCallRemoteModel> callStates;
  final Map<String, Stream<TelnyxCallRemoteModel>> callStatesById;

  TelnyxConfigurationRemoteModel? configuration;
  String? destinationNumber;
  String? clientState;
  Map<String, String>? customHeaders;
  String? acceptedCallId;
  String? rejectedCallId;
  String? hungUpCallId;
  String? mutedCallId;
  bool? isMuted;
  String? speakerCallId;
  bool? isSpeakerEnabled;
  bool didDisconnect = false;
  bool didDispose = false;
  String? watchedCallId;

  @override
  Future<void> accept(String callId) async {
    acceptedCallId = callId;
  }

  @override
  Future<void> connect(TelnyxConfigurationRemoteModel configuration) async {
    this.configuration = configuration;
  }

  @override
  Future<String> dial({
    required String destinationNumber,
    required String clientState,
    required Map<String, String> customHeaders,
  }) async {
    this.destinationNumber = destinationNumber;
    this.clientState = clientState;
    this.customHeaders = customHeaders;
    return 'real-sdk-call-id';
  }

  @override
  Future<void> disconnect() async {
    didDisconnect = true;
  }

  @override
  Future<void> dispose() async {
    didDispose = true;
  }

  @override
  Future<void> hangUp(String callId) async {
    hungUpCallId = callId;
  }

  @override
  Future<void> reject(String callId) async {
    rejectedCallId = callId;
  }

  @override
  Future<void> setMuted(String callId, {required bool isMuted}) async {
    mutedCallId = callId;
    this.isMuted = isMuted;
  }

  @override
  Future<void> setSpeakerEnabled(
    String callId, {
    required bool isEnabled,
  }) async {
    speakerCallId = callId;
    isSpeakerEnabled = isEnabled;
  }

  @override
  Stream<TelnyxCallRemoteModel> watchCallStates() => callStates;

  @override
  Stream<TelnyxCallRemoteModel> watchCallState(String callId) {
    watchedCallId = callId;
    return callStatesById[callId] ??
        const Stream<TelnyxCallRemoteModel>.empty();
  }

  @override
  Stream<TelnyxConnectionRemoteModel> watchConnectionStates() {
    return connectionStates;
  }
}

final class _ThrowingMicrophoneAccessProbe implements MicrophoneAccessProbe {
  @override
  Future<void> ensureAccess() {
    throw StateError('native-permission-details');
  }
}

File _dataGeneratedFile(String relativePath) {
  final List<File> candidates = <File>[
    File('lib/$relativePath'),
    File('packages/core_data/lib/$relativePath'),
  ];
  return candidates.firstWhere((File file) => file.existsSync());
}
