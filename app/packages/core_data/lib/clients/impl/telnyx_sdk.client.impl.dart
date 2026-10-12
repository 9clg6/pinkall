import 'dart:async';
import 'dart:io';

import 'package:core_data/clients/telnyx_call_state_store.dart';
import 'package:core_data/clients/telnyx_sdk.client.dart';
import 'package:core_data/model/remote/telnyx_call.remote.model.dart';
import 'package:core_data/model/remote/telnyx_configuration.remote.model.dart';
import 'package:core_data/model/remote/telnyx_connection.remote.model.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:telnyx_webrtc/model/audio_constraints.dart';
import 'package:telnyx_webrtc/model/connection_status.dart' as telnyx;
import 'package:telnyx_webrtc/telnyx_webrtc.dart';
import 'package:telnyx_webrtc/utils/logging/log_level.dart';

/// Creates a fresh Telnyx SDK client instance.
typedef TelnyxClientFactory = TelnyxClient Function();

TelnyxClient _createTelnyxClient() => TelnyxClient();

/// Production [TelnyxSdkClient] backed by `telnyx_webrtc` 4.3.0.
final class TelnyxSdkClientImpl implements TelnyxSdkClient {
  /// Creates an SDK boundary.
  ///
  /// Supplying [telnyxClient] is intended for SDK-level integration harnesses;
  /// unit tests should fake [TelnyxSdkClient] itself.
  TelnyxSdkClientImpl({
    TelnyxClient? telnyxClient,
    TelnyxClientFactory telnyxClientFactory = _createTelnyxClient,
    TelnyxCallStateStore? callStateStore,
    Duration connectionTimeout = const Duration(seconds: 20),
  }) : _clientFactory = telnyxClientFactory,
       _client = telnyxClient,
       _callStateStore = callStateStore ?? TelnyxCallStateStore(),
       _connectionTimeout = connectionTimeout {
    if (connectionTimeout <= Duration.zero) {
      throw ArgumentError.value(
        connectionTimeout,
        'connectionTimeout',
        'The connection timeout must be positive',
      );
    }
    if (telnyxClient != null) {
      _bindClientCallbacks(telnyxClient);
    }
  }

  final TelnyxClientFactory _clientFactory;
  TelnyxClient? _client;
  final StreamController<TelnyxConnectionRemoteModel> _connectionController =
      StreamController<TelnyxConnectionRemoteModel>.broadcast(sync: true);
  final StreamController<TelnyxCallRemoteModel> _callController =
      StreamController<TelnyxCallRemoteModel>.broadcast(sync: true);
  final Map<String, IncomingInviteParams> _incomingInvites =
      <String, IncomingInviteParams>{};
  final TelnyxCallStateStore _callStateStore;
  final Duration _connectionTimeout;

  TelnyxConfigurationRemoteModel? _configuration;
  TelnyxConnectionRemoteModel? _lastConnectionState;
  Completer<void>? _readyCompleter;
  bool _disposed = false;

  @override
  Future<void> connect(TelnyxConfigurationRemoteModel configuration) async {
    _ensureAvailable();
    _validateConfiguration(configuration);

    final Completer<void>? pendingConnection = _readyCompleter;
    if (pendingConnection != null && !pendingConnection.isCompleted) {
      if (!_configurationsMatch(_configuration, configuration)) {
        throw StateError(
          'A Telnyx connection attempt is already using another '
          'configuration',
        );
      }
      await pendingConnection.future;
      return;
    }

    TelnyxClient client = _getOrCreateClient();
    if (client.getConnectionStatus() == telnyx.ConnectionStatus.clientReady) {
      if (_configurationsMatch(_configuration, configuration)) {
        _emitConnection('ready');
        return;
      }
      await disconnect();
      client = _getOrCreateClient();
    }

    final Completer<void> readyCompleter = Completer<void>();
    _readyCompleter = readyCompleter;
    _configuration = configuration;
    _emitConnection('connecting');
    final Timer timeoutTimer = Timer(_connectionTimeout, () {
      _failConnectionAttempt(
        client: client,
        completer: readyCompleter,
        error: TimeoutException(
          'Telnyx registration did not complete before the deadline',
          _connectionTimeout,
        ),
        failureReason: 'connection_timeout',
      );
    });

    try {
      switch (configuration.authenticationMode) {
        case 'token':
          client.connectWithToken(
            TokenConfig(
              sipToken: configuration.sipToken!,
              sipCallerIDName: configuration.callerName,
              sipCallerIDNumber: configuration.callerNumber,
              notificationToken: configuration.notificationToken,
              autoReconnect: false,
              logLevel: LogLevel.error,
              debug: false,
            ),
          );
        case 'credentials':
          client.connectWithCredential(
            CredentialConfig(
              sipUser: configuration.sipUser!,
              sipPassword: configuration.sipPassword!,
              sipCallerIDName: configuration.callerName,
              sipCallerIDNumber: configuration.callerNumber,
              notificationToken: configuration.notificationToken,
              autoReconnect: false,
              logLevel: LogLevel.error,
              debug: false,
            ),
          );
        default:
          throw ArgumentError.value(
            configuration.authenticationMode,
            'authenticationMode',
            'Unsupported Telnyx authentication mode',
          );
      }
    } catch (error, stackTrace) {
      _failConnectionAttempt(
        client: client,
        completer: readyCompleter,
        error: error,
        stackTrace: stackTrace,
        failureReason: 'connection_failed',
      );
    }

    try {
      await readyCompleter.future;
    } finally {
      timeoutTimer.cancel();
      if (identical(_readyCompleter, readyCompleter)) {
        _readyCompleter = null;
      }
    }
  }

  @override
  Future<String> dial({
    required String destinationNumber,
    required String clientState,
    required Map<String, String> customHeaders,
  }) async {
    _ensureAvailable();
    final TelnyxConfigurationRemoteModel configuration =
        _requireConfiguration();
    _requireReady();
    if (destinationNumber.trim().isEmpty) {
      throw ArgumentError.value(
        destinationNumber,
        'destinationNumber',
        'A destination number or SIP URI is required',
      );
    }

    final Call call = _requireClient().newInvite(
      configuration.callerName,
      configuration.callerNumber,
      destinationNumber.trim(),
      clientState,
      customHeaders: customHeaders,
      debug: false,
      useTrickleIce: true,
      mutedMicOnStart: false,
      audioConstraints: AudioConstraints.enabled(),
    );
    final String? callId = call.callId;
    if (callId == null || callId.isEmpty) {
      throw StateError('Telnyx did not return an outbound call identifier');
    }

    final TelnyxCallRemoteModel snapshot = TelnyxCallRemoteModel(
      callId: callId,
      direction: 'outgoing',
      status: 'newCall',
      remoteNumber: destinationNumber.trim(),
    );
    _emitCall(snapshot);
    _attachCallStateListener(call);
    return callId;
  }

  @override
  Future<void> accept(String callId) async {
    _ensureAvailable();
    final TelnyxConfigurationRemoteModel configuration =
        _requireConfiguration();
    _requireReady();
    final IncomingInviteParams invite =
        _incomingInvites[callId] ??
        (throw StateError('No pending incoming call for $callId'));

    final Call call = _requireClient().acceptCall(
      invite,
      configuration.callerName,
      configuration.callerNumber,
      '',
      debug: false,
      useTrickleIce: true,
    );
    _attachCallStateListener(call);
    _incomingInvites.remove(callId);
    _emitCallStatus(callId, 'connecting');
  }

  @override
  Future<void> reject(String callId) async {
    _ensureAvailable();
    final Call call = _requireCall(callId);
    if (call.callState != CallState.ringing) {
      throw StateError('Only a ringing call can be rejected');
    }
    _requireClient().rejectCall(callId);
    if (call.callState != CallState.done) {
      throw StateError('Telnyx did not confirm that the call was rejected');
    }
    _incomingInvites.remove(callId);
    _emitCallStatus(callId, 'ended');
  }

  @override
  Future<void> hangUp(String callId) async {
    _ensureAvailable();
    final Call call = _requireCall(callId);
    call.endCall();
    if (call.callState != CallState.done) {
      throw StateError('Telnyx did not confirm that the call ended');
    }
    _incomingInvites.remove(callId);
    _emitCallStatus(callId, 'ended');
  }

  @override
  Future<void> setMuted(String callId, {required bool isMuted}) async {
    _ensureAvailable();
    final Call call = _requireControllableCall(callId);
    call.setMuteState(isMuted);
    final TelnyxCallRemoteModel snapshot = _requireSnapshot(callId);
    _emitCall(snapshot.copyWith(isMuted: isMuted));
  }

  @override
  Future<void> setSpeakerEnabled(
    String callId, {
    required bool isEnabled,
  }) async {
    _ensureAvailable();
    final Call call = _requireControllableCall(callId);
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw UnsupportedError(
        'Speakerphone switching is only supported on Android and iOS',
      );
    }
    await Helper.setSpeakerphoneOn(isEnabled);
    call.speakerPhone = isEnabled;
    final TelnyxCallRemoteModel snapshot = _requireSnapshot(callId);
    _emitCall(snapshot.copyWith(isSpeakerEnabled: isEnabled));
  }

  @override
  Future<void> disconnect() async {
    _ensureAvailable();
    _endOpenCallsForDisconnect();
    _configuration = null;
    _disconnectAndReleaseClient();
    _incomingInvites.clear();
    _completePendingConnectionWithError(
      StateError('Telnyx connection was cancelled'),
    );
    _emitConnection('disconnected');
  }

  @override
  Stream<TelnyxCallRemoteModel> watchCallStates() {
    _ensureAvailable();
    return _callController.stream;
  }

  @override
  Stream<TelnyxCallRemoteModel> watchCallState(String callId) {
    _ensureAvailable();
    return _callStateStore.watch(callId);
  }

  @override
  Stream<TelnyxConnectionRemoteModel> watchConnectionStates() {
    _ensureAvailable();
    return _connectionController.stream;
  }

  @override
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _endOpenCallsForDisconnect();
    _emitConnection('disconnected');
    _completePendingConnectionWithError(
      StateError('Telnyx client was disposed'),
    );
    _disposed = true;
    _disconnectAndReleaseClient();
    _incomingInvites.clear();
    _configuration = null;
    await Future.wait<void>(<Future<void>>[
      _callStateStore.dispose(),
      _connectionController.close(),
      _callController.close(),
    ]);
  }

  void _onConnectionStateChanged(telnyx.ConnectionStatus status) {
    if (_disposed) {
      return;
    }
    if (_configuration == null &&
        status != telnyx.ConnectionStatus.disconnected) {
      return;
    }
    switch (status) {
      case telnyx.ConnectionStatus.disconnected:
        _emitConnection('disconnected');
        final TelnyxClient? client = _client;
        final Completer<void>? completer = _readyCompleter;
        if (client != null && completer != null && !completer.isCompleted) {
          _configuration = null;
          _disconnectAndReleaseClient();
        }
        _completePendingConnectionWithError(
          StateError('Telnyx disconnected before registration completed'),
        );
      case telnyx.ConnectionStatus.connected:
        _emitConnection('connected');
      case telnyx.ConnectionStatus.reconnecting:
        _emitConnection('reconnecting');
      case telnyx.ConnectionStatus.clientReady:
        _markClientReady();
    }
  }

  void _onSocketMessageReceived(TelnyxMessage message) {
    if (_disposed || _configuration == null) {
      return;
    }
    switch (message.socketMethod) {
      case SocketMethod.clientReady:
        _markClientReady();
      case SocketMethod.invite:
        _handleIncomingInvite(message);
      case SocketMethod.ringing:
        _emitMessageCallStatus(message, 'ringing');
      case SocketMethod.answer:
        // A SIP answer only means that signaling succeeded. Media is usable
        // once WebRTC reports ICE/DTLS connected through CallState.active.
        _emitMessageCallStatus(message, 'connecting');
      case SocketMethod.bye:
        _handleByeMessage(message);
      case SocketMethod.attach:
        _handleAttachedCall(message);
    }
  }

  void _onSocketErrorReceived(TelnyxSocketError _) {
    if (_disposed || _configuration == null) {
      return;
    }
    final StateError exception = StateError('Telnyx socket error');
    final TelnyxClient? client = _client;
    final Completer<void>? completer = _readyCompleter;
    if (client != null && completer != null && !completer.isCompleted) {
      _failConnectionAttempt(
        client: client,
        completer: completer,
        error: exception,
        failureReason: 'socket_error',
      );
      return;
    }
    _emitConnection('failure', failureReason: 'socket_error');
  }

  void _handleIncomingInvite(TelnyxMessage message) {
    final IncomingInviteParams? invite = message.message.inviteParams;
    final String? callId = invite?.callID;
    if (invite == null || callId == null || callId.isEmpty) {
      _emitConnection(
        'failure',
        failureReason: 'Telnyx sent an incoming call without an identifier',
      );
      return;
    }

    _incomingInvites[callId] = invite;
    final TelnyxCallRemoteModel snapshot = TelnyxCallRemoteModel(
      callId: callId,
      direction: 'incoming',
      status: 'ringing',
      remoteName: _nullIfBlank(invite.callerIdName),
      remoteNumber: _nullIfBlank(invite.callerIdNumber),
    );
    _emitCall(snapshot);
    final Call? call = _client?.calls[callId];
    if (call != null) {
      _attachCallStateListener(call);
    }
  }

  void _handleAttachedCall(TelnyxMessage message) {
    final String? callId = _callIdFromMessage(message);
    if (callId == null) {
      return;
    }
    final Call? call = _client?.calls[callId];
    if (call != null) {
      _attachCallStateListener(call);
    }
    if (_callStateStore.contains(callId)) {
      _emitCallStatus(callId, 'connecting');
    }
  }

  void _attachCallStateListener(Call call) {
    final String? callId = call.callId;
    if (callId == null || callId.isEmpty) {
      return;
    }
    call.callHandler.onCallStateChanged = (CallState state) {
      _onSdkCallStateChanged(call, state);
    };
  }

  void _onSdkCallStateChanged(Call call, CallState state) {
    final String? callId = call.callId;
    if (callId == null || callId.isEmpty) {
      return;
    }
    if (_disposed || !_callStateStore.contains(callId)) {
      return;
    }
    if (state == CallState.active && !_requireSnapshot(callId).isMuted) {
      // Re-assert the requested local audio state once the media transport is
      // connected. This protects macOS against a disabled sender track left by
      // an SDK or device transition without overriding an explicit user mute.
      call.setMuteState(false);
    }
    final String status = switch (state) {
      CallState.newCall => 'newCall',
      CallState.connecting => 'connecting',
      CallState.ringing => 'ringing',
      CallState.active => 'active',
      CallState.held => 'held',
      CallState.reconnecting => 'reconnecting',
      CallState.renegotiation => 'renegotiating',
      CallState.dropped => 'dropped',
      CallState.done => 'ended',
      CallState.error => 'error',
    };
    final String? reason = switch (state) {
      CallState.done => state.terminationReason?.toString(),
      CallState.reconnecting ||
      CallState.dropped => state.networkReason?.message,
      CallState.error => 'media_connection_failed',
      _ => null,
    };
    _emitCallStatus(callId, status, failureReason: reason);
  }

  void _handleByeMessage(TelnyxMessage message) {
    final String? callId = _callIdFromMessage(message);
    if (callId == null) {
      return;
    }
    _incomingInvites.remove(callId);

    // The SDK invokes this socket callback before it emits CallState.done.
    // Waiting for that state is important: it carries the SIP termination
    // reason. Emitting a generic terminal snapshot here would make the store
    // reject the richer state as a post-terminal update.
  }

  void _emitMessageCallStatus(TelnyxMessage message, String status) {
    final String? callId = _callIdFromMessage(message);
    if (callId == null || !_callStateStore.contains(callId)) {
      return;
    }
    _emitCallStatus(callId, status);
    if (status == 'ended') {
      _incomingInvites.remove(callId);
    }
  }

  String? _callIdFromMessage(TelnyxMessage message) {
    return message.message.inviteParams?.callID ??
        message.message.byeParams?.callID ??
        message.message.dialogParams?.callID;
  }

  void _emitCallStatus(String callId, String status, {String? failureReason}) {
    final TelnyxCallRemoteModel snapshot = _requireSnapshot(callId);
    _emitCall(snapshot.copyWith(status: status, failureReason: failureReason));
  }

  void _emitCall(TelnyxCallRemoteModel snapshot) {
    if (_disposed || _callController.isClosed) {
      return;
    }
    if (_callStateStore.add(snapshot)) {
      _callController.add(snapshot);
    }
  }

  void _markClientReady() {
    _emitConnection('ready');
    final Completer<void>? completer = _readyCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  void _emitConnection(String status, {String? failureReason}) {
    if (_disposed || _connectionController.isClosed) {
      return;
    }
    final TelnyxConnectionRemoteModel state = TelnyxConnectionRemoteModel(
      status: status,
      failureReason: failureReason,
    );
    if (_lastConnectionState == state) {
      return;
    }
    _lastConnectionState = state;
    _connectionController.add(state);
  }

  void _completePendingConnectionWithError(Object error) {
    final Completer<void>? completer = _readyCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.completeError(error);
    }
  }

  void _failConnectionAttempt({
    required TelnyxClient client,
    required Completer<void> completer,
    required Object error,
    required String failureReason,
    StackTrace? stackTrace,
  }) {
    if (_disposed ||
        !identical(_readyCompleter, completer) ||
        completer.isCompleted) {
      return;
    }
    _configuration = null;
    _incomingInvites.clear();
    if (identical(_client, client)) {
      _disconnectAndReleaseClient();
    }
    _emitConnection('failure', failureReason: failureReason);
    if (stackTrace == null) {
      completer.completeError(error);
    } else {
      completer.completeError(error, stackTrace);
    }
  }

  void _validateConfiguration(TelnyxConfigurationRemoteModel configuration) {
    if (configuration.callerName.trim().isEmpty) {
      throw ArgumentError.value(
        configuration.callerName,
        'callerName',
        'A caller name is required',
      );
    }
    if (configuration.callerNumber.trim().isEmpty) {
      throw ArgumentError.value(
        configuration.callerNumber,
        'callerNumber',
        'A caller number is required',
      );
    }
    switch (configuration.authenticationMode) {
      case 'token':
        if (configuration.sipToken?.trim().isEmpty ?? true) {
          throw ArgumentError('A Telnyx SIP token is required');
        }
      case 'credentials':
        if (configuration.sipUser?.trim().isEmpty ?? true) {
          throw ArgumentError('A Telnyx SIP user is required');
        }
        if (configuration.sipPassword?.isEmpty ?? true) {
          throw ArgumentError('A Telnyx SIP password is required');
        }
      default:
        throw ArgumentError.value(
          configuration.authenticationMode,
          'authenticationMode',
          'Unsupported Telnyx authentication mode',
        );
    }
  }

  bool _configurationsMatch(
    TelnyxConfigurationRemoteModel? current,
    TelnyxConfigurationRemoteModel candidate,
  ) {
    return current != null &&
        current.authenticationMode == candidate.authenticationMode &&
        current.sipToken == candidate.sipToken &&
        current.sipUser == candidate.sipUser &&
        current.sipPassword == candidate.sipPassword &&
        current.callerName == candidate.callerName &&
        current.callerNumber == candidate.callerNumber &&
        current.notificationToken == candidate.notificationToken;
  }

  void _requireReady() {
    if (_client?.getConnectionStatus() != telnyx.ConnectionStatus.clientReady) {
      throw StateError('The Telnyx client is not registered');
    }
  }

  TelnyxConfigurationRemoteModel _requireConfiguration() {
    return _configuration ??
        (throw StateError('The Telnyx client has not been configured'));
  }

  Call _requireCall(String callId) {
    return _client?.calls[callId] ??
        (throw StateError('No Telnyx call found for $callId'));
  }

  Call _requireControllableCall(String callId) {
    final Call call = _requireCall(callId);
    if (call.callState != CallState.active &&
        call.callState != CallState.held) {
      throw StateError('Audio controls require an active or held call');
    }
    if (call.peerConnection == null) {
      throw StateError('The call media connection is not available');
    }
    return call;
  }

  TelnyxCallRemoteModel _requireSnapshot(String callId) {
    return _callStateStore.requireSnapshot(callId);
  }

  void _ensureAvailable() {
    if (_disposed) {
      throw StateError('The Telnyx SDK client has been disposed');
    }
  }

  void _bindClientCallbacks(TelnyxClient client) {
    client
      ..onConnectionStateChanged = (telnyx.ConnectionStatus status) {
        if (identical(client, _client)) {
          _onConnectionStateChanged(status);
        }
      }
      ..onSocketMessageReceived = (TelnyxMessage message) {
        if (identical(client, _client)) {
          _onSocketMessageReceived(message);
        }
      }
      ..onSocketErrorReceived = (TelnyxSocketError error) {
        if (identical(client, _client)) {
          _onSocketErrorReceived(error);
        }
      };
  }

  void _disconnectAndReleaseClient() {
    final TelnyxClient? previousClient = _client;
    _client = null;
    if (previousClient == null) {
      return;
    }
    previousClient
      ..onConnectionStateChanged = null
      ..onSocketMessageReceived = (TelnyxMessage _) {}
      ..onSocketErrorReceived = (TelnyxSocketError _) {}
      ..disconnect();
  }

  void _endOpenCallsForDisconnect() {
    final TelnyxClient? client = _client;
    for (final TelnyxCallRemoteModel snapshot in _callStateStore.snapshots) {
      if (snapshot.status == 'ended' || snapshot.status == 'error') {
        continue;
      }
      try {
        client?.calls[snapshot.callId]?.endCall();
      } catch (_) {
        // Disconnect remains best-effort: releasing the transport is terminal.
      }
      _emitCallStatus(snapshot.callId, 'ended');
    }
  }

  TelnyxClient _getOrCreateClient() {
    final TelnyxClient? existingClient = _client;
    if (existingClient != null) {
      return existingClient;
    }
    final TelnyxClient client = _clientFactory();
    _client = client;
    _bindClientCallbacks(client);
    return client;
  }

  TelnyxClient _requireClient() {
    return _client ??
        (throw StateError('The Telnyx client has not been initialized'));
  }

  String? _nullIfBlank(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }
}
