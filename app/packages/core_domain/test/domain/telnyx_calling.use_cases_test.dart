import 'dart:io';

import 'package:core_domain/core_domain.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:test/test.dart';

void main() {
  group('Telnyx configuration', () {
    test('redacts every runtime secret from diagnostic strings', () {
      const TelnyxAuthenticationEntity authentication =
          TelnyxAuthenticationEntity.credentials(
            sipUser: 'test-user',
            sipPassword: 'test-password',
          );
      const TelnyxConfigurationEntity configuration = TelnyxConfigurationEntity(
        authentication: authentication,
        callerName: 'Pinkall test',
        callerNumber: '+33100000000',
        notificationToken: 'test-notification-token',
      );
      const ConnectTelnyxParam params = ConnectTelnyxParam(
        configuration: configuration,
      );

      expect(authentication.toString(), isNot(contains('test-user')));
      expect(authentication.toString(), isNot(contains('test-password')));
      expect(configuration.toString(), isNot(contains('test-password')));
      expect(
        configuration.toString(),
        isNot(contains('test-notification-token')),
      );
      expect(params.toString(), isNot(contains('test-password')));
    });

    test('does not expose JSON serialization for authentication material', () {
      const TelnyxAuthenticationEntity authentication =
          TelnyxAuthenticationEntity.token(sipToken: 'test-token');
      final TelnyxConfigurationEntity configuration = _configuration();
      final ConnectTelnyxParam params = ConnectTelnyxParam(
        configuration: configuration,
      );

      expect(
        () => (authentication as dynamic).toJson(),
        throwsNoSuchMethodError,
      );
      expect(
        () => (configuration as dynamic).toJson(),
        throwsNoSuchMethodError,
      );
      expect(() => (params as dynamic).toJson(), throwsNoSuchMethodError);
    });

    test('uses identity equality for every secret-bearing domain object', () {
      final TelnyxAuthenticationEntity firstAuthentication =
          TelnyxAuthenticationEntity.token(sipToken: 'same-token');
      final TelnyxAuthenticationEntity secondAuthentication =
          TelnyxAuthenticationEntity.token(sipToken: 'same-token');
      final TelnyxConfigurationEntity firstConfiguration =
          TelnyxConfigurationEntity(
            authentication: firstAuthentication,
            callerName: 'Pinkall test',
            callerNumber: '+33100000000',
          );
      final TelnyxConfigurationEntity secondConfiguration =
          TelnyxConfigurationEntity(
            authentication: firstAuthentication,
            callerName: 'Pinkall test',
            callerNumber: '+33100000000',
          );

      expect(firstAuthentication == secondAuthentication, isFalse);
      expect(firstConfiguration == secondConfiguration, isFalse);
      expect(
        ConnectTelnyxParam(configuration: firstConfiguration) ==
            ConnectTelnyxParam(configuration: firstConfiguration),
        isFalse,
      );
    });

    test('generated secret types contain no JSON or equality code', () {
      const List<String> relativePaths = <String>[
        'domain/entities/telnyx_authentication.entity.freezed.dart',
        'domain/entities/telnyx_configuration.entity.freezed.dart',
        'domain/params/connect_telnyx.param.freezed.dart',
      ];

      for (final String relativePath in relativePaths) {
        final String source = _domainGeneratedFile(
          relativePath,
        ).readAsStringSync();
        expect(source, isNot(contains('toJson(')), reason: relativePath);
        expect(source, isNot(contains('operator ==')), reason: relativePath);
        expect(source, isNot(contains('hashCode')), reason: relativePath);
      }
    });
  });

  group('Telnyx use cases', () {
    test('connect passes runtime configuration to the repository', () async {
      final _FakeCallRepository repository = _FakeCallRepository();
      final ConnectTelnyxUseCase useCase = ConnectTelnyxUseCase(
        callRepository: repository,
      );
      final TelnyxConfigurationEntity configuration = _configuration();

      final ResultState<void> result = await useCase.execute(
        ConnectTelnyxParam(configuration: configuration),
      );

      expect(result, isA<ResultSuccess<void>>());
      expect(repository.connectedConfiguration, configuration);
    });

    test('connect surfaces repository exceptions', () async {
      final Exception exception = Exception('registration failed');
      final _FakeCallRepository repository = _FakeCallRepository(
        exception: exception,
      );
      final ConnectTelnyxUseCase useCase = ConnectTelnyxUseCase(
        callRepository: repository,
      );

      final ResultState<void> result = await useCase.execute(
        ConnectTelnyxParam(configuration: _configuration()),
      );

      expect(result, isA<ResultFailure<void>>());
      expect((result as ResultFailure<void>).exception, same(exception));
    });

    test('dial returns the real repository call identifier', () async {
      final _FakeCallRepository repository = _FakeCallRepository();
      final DialCallUseCase useCase = DialCallUseCase(
        callRepository: repository,
      );
      const DialCallParam params = DialCallParam(
        destinationNumber: '+33102030405',
        clientState: 'prospect-42',
      );

      final ResultState<String> result = await useCase.execute(params);

      expect(result, const ResultState<String>.success('telnyx-call-id'));
      expect(repository.dialedDestinationNumber, params.destinationNumber);
      expect(repository.dialedClientState, params.clientState);
      expect(repository.dialedCustomHeaders, params.customHeaders);
    });

    test('call actions target the requested call', () async {
      final _FakeCallRepository repository = _FakeCallRepository();
      const CallActionParam params = CallActionParam(callId: 'call-42');

      await AcceptCallUseCase(callRepository: repository).execute(params);
      await RejectCallUseCase(callRepository: repository).execute(params);
      await HangUpCallUseCase(callRepository: repository).execute(params);

      expect(repository.acceptedCallId, 'call-42');
      expect(repository.rejectedCallId, 'call-42');
      expect(repository.hungUpCallId, 'call-42');
    });

    test('audio controls pass explicit target states', () async {
      final _FakeCallRepository repository = _FakeCallRepository();

      await SetCallMutedUseCase(
        callRepository: repository,
      ).execute(const SetCallMutedParam(callId: 'call-42', isMuted: true));
      await SetSpeakerEnabledUseCase(callRepository: repository).execute(
        const SetSpeakerEnabledParam(callId: 'call-42', isEnabled: true),
      );

      expect(repository.mutedCallId, 'call-42');
      expect(repository.isMuted, isTrue);
      expect(repository.speakerCallId, 'call-42');
      expect(repository.isSpeakerEnabled, isTrue);
    });

    test('connection stream is wrapped in ResultState', () async {
      const TelnyxConnectionStateEntity state = TelnyxConnectionStateEntity(
        status: TelnyxConnectionStatus.ready,
      );
      final _FakeCallRepository repository = _FakeCallRepository(
        connectionStates: Stream<TelnyxConnectionStateEntity>.value(state),
      );

      await expectLater(
        WatchTelnyxConnectionStatesUseCase(
          callRepository: repository,
        ).execute(),
        emits(const ResultState<TelnyxConnectionStateEntity>.success(state)),
      );
    });

    test('call stream is wrapped in ResultState', () async {
      const CallStateEntity state = CallStateEntity(
        callId: 'call-42',
        direction: CallDirection.incoming,
        status: CallLifecycleStatus.ringing,
      );
      final _FakeCallRepository repository = _FakeCallRepository(
        callStates: Stream<CallStateEntity>.value(state),
      );

      await expectLater(
        WatchCallStatesUseCase(callRepository: repository).execute(),
        emits(const ResultState<CallStateEntity>.success(state)),
      );
    });

    test('one-call stream is selected with CallActionParam', () async {
      const CallStateEntity state = CallStateEntity(
        callId: 'call-42',
        direction: CallDirection.outgoing,
        status: CallLifecycleStatus.active,
      );
      final _FakeCallRepository repository = _FakeCallRepository(
        callStatesById: <String, Stream<CallStateEntity>>{
          'call-42': Stream<CallStateEntity>.value(state),
        },
      );

      await expectLater(
        WatchCallStateUseCase(
          callRepository: repository,
        ).execute(const CallActionParam(callId: 'call-42')),
        emits(const ResultState<CallStateEntity>.success(state)),
      );
      expect(repository.watchedCallId, 'call-42');
    });

    test('microphone denial keeps its structured domain failure', () async {
      const CallOperationException exception = CallOperationException(
        code: CallFailureCode.microphoneAccessDenied,
      );
      final _FakeCallRepository repository = _FakeCallRepository(
        microphoneException: exception,
      );

      final ResultState<void> result = await EnsureMicrophoneAccessUseCase(
        callRepository: repository,
      ).execute();

      expect(result, isA<ResultFailure<void>>());
      expect((result as ResultFailure<void>).exception, same(exception));
      expect(
        (result.exception as CallOperationException).code,
        CallFailureCode.microphoneAccessDenied,
      );
    });

    test('disconnect and dispose release repository resources', () async {
      final _FakeCallRepository repository = _FakeCallRepository();

      await DisconnectTelnyxUseCase(callRepository: repository).execute();
      await DisposeCallRepositoryUseCase(callRepository: repository).execute();

      expect(repository.didDisconnect, isTrue);
      expect(repository.didDispose, isTrue);
    });
  });

  group('Calling params', () {
    test('all control params support JSON round trips', () {
      const CallActionParam action = CallActionParam(callId: 'call-42');
      const DialCallParam dial = DialCallParam(
        destinationNumber: '+33102030405',
        customHeaders: <String, String>{'X-Pinkall-Prospect': '42'},
      );
      const SetCallMutedParam muted = SetCallMutedParam(
        callId: 'call-42',
        isMuted: true,
      );
      const SetSpeakerEnabledParam speaker = SetSpeakerEnabledParam(
        callId: 'call-42',
        isEnabled: true,
      );

      expect(CallActionParam.fromJson(action.toJson()), action);
      expect(DialCallParam.fromJson(dial.toJson()), dial);
      expect(SetCallMutedParam.fromJson(muted.toJson()), muted);
      expect(SetSpeakerEnabledParam.fromJson(speaker.toJson()), speaker);
    });
  });
}

final class _FakeCallRepository implements CallRepository {
  _FakeCallRepository({
    this.exception,
    this.microphoneException,
    this.connectionStates = const Stream<TelnyxConnectionStateEntity>.empty(),
    this.callStates = const Stream<CallStateEntity>.empty(),
    this.callStatesById = const <String, Stream<CallStateEntity>>{},
  });

  final Exception? exception;
  final Exception? microphoneException;
  final Stream<TelnyxConnectionStateEntity> connectionStates;
  final Stream<CallStateEntity> callStates;
  final Map<String, Stream<CallStateEntity>> callStatesById;

  TelnyxConfigurationEntity? connectedConfiguration;
  String? dialedDestinationNumber;
  String? dialedClientState;
  Map<String, String>? dialedCustomHeaders;
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
  Future<void> connect(TelnyxConfigurationEntity configuration) async {
    final Exception? currentException = exception;
    if (currentException != null) {
      throw currentException;
    }
    connectedConfiguration = configuration;
  }

  @override
  Future<String> dial({
    required String destinationNumber,
    required String clientState,
    required Map<String, String> customHeaders,
  }) async {
    dialedDestinationNumber = destinationNumber;
    dialedClientState = clientState;
    dialedCustomHeaders = customHeaders;
    return 'telnyx-call-id';
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
  Future<void> ensureMicrophoneAccess() async {
    final Exception? currentException = microphoneException;
    if (currentException != null) {
      throw currentException;
    }
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
  Stream<CallStateEntity> watchCallStates() => callStates;

  @override
  Stream<CallStateEntity> watchCallState(String callId) {
    watchedCallId = callId;
    return callStatesById[callId] ?? const Stream<CallStateEntity>.empty();
  }

  @override
  Stream<TelnyxConnectionStateEntity> watchConnectionStates() {
    return connectionStates;
  }
}

TelnyxConfigurationEntity _configuration() {
  return const TelnyxConfigurationEntity(
    authentication: TelnyxAuthenticationEntity.token(sipToken: 'test-token'),
    callerName: 'Pinkall test',
    callerNumber: '+33100000000',
  );
}

File _domainGeneratedFile(String relativePath) {
  final List<File> candidates = <File>[
    File('lib/$relativePath'),
    File('packages/core_domain/lib/$relativePath'),
  ];
  return candidates.firstWhere((File file) => file.existsSync());
}
