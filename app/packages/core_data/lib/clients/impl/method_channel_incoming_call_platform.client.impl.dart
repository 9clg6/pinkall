import 'dart:async';

import 'package:core_data/clients/incoming_call_platform.client.dart';
import 'package:core_data/model/remote/incoming_call_capability.remote.model.dart';
import 'package:core_data/model/remote/incoming_call_native_event.remote.model.dart';
import 'package:flutter/services.dart';

/// Stable Flutter bridge for native background incoming-call adapters.
final class MethodChannelIncomingCallPlatformClientImpl
    implements IncomingCallPlatformClient {
  /// Creates the production bridge or injects channels for tests.
  const MethodChannelIncomingCallPlatformClientImpl({
    MethodChannel methodChannel = const MethodChannel(_methodChannelName),
    Stream<Object?> Function()? eventStreamFactory,
  }) : _methodChannel = methodChannel,
       _eventStreamFactory = eventStreamFactory;

  static const String _methodChannelName = 'com.pinkall.incoming_calls/methods';
  static const String _eventChannelName = 'com.pinkall.incoming_calls/events';

  final MethodChannel _methodChannel;
  final Stream<Object?> Function()? _eventStreamFactory;

  @override
  Future<IncomingCallCapabilityRemoteModel> initialize() =>
      _readCapability('initialize');

  @override
  Future<IncomingCallCapabilityRemoteModel> inspectCapability() =>
      _readCapability('getCapability');

  @override
  Future<String?> getNotificationToken() async {
    try {
      final String? raw = await _methodChannel.invokeMethod<String>(
        'getNotificationToken',
      );
      if (raw == null || raw.trim().isEmpty) return null;
      final String token = raw.trim();
      if (token.length > 8192) {
        throw const FormatException('Native notification token is too long.');
      }
      return token;
    } on MissingPluginException {
      return null;
    }
  }

  @override
  Stream<IncomingCallNativeEventRemoteModel> watchEvents() async* {
    final IncomingCallCapabilityRemoteModel capability =
        await inspectCapability();
    if (capability.status == 'unsupported') return;
    final Stream<Object?> source =
        _eventStreamFactory?.call() ??
        const EventChannel(_eventChannelName).receiveBroadcastStream();
    await for (final Object? raw in source) {
      yield _decodeEvent(_stringMap(raw, context: 'event'));
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _methodChannel.invokeMethod<void>('dispose');
    } on MissingPluginException {
      // Desktop/web builds intentionally have no background-call adapter.
    }
  }

  Future<IncomingCallCapabilityRemoteModel> _readCapability(
    String method,
  ) async {
    try {
      final Object? raw = await _methodChannel.invokeMethod<Object?>(method);
      return _decodeCapability(_stringMap(raw, context: 'capability'));
    } on MissingPluginException {
      return const IncomingCallCapabilityRemoteModel(
        status: 'unsupported',
        platform: 'other',
        transport: 'none',
        tokenAvailable: false,
        backgroundDeliveryReady: false,
        nativeCallUiReady: false,
        missingRequirements: <String>['native_adapter_unavailable'],
      );
    }
  }
}

IncomingCallCapabilityRemoteModel _decodeCapability(
  Map<String, Object?> values,
) {
  final String status = _requiredString(values, 'status');
  const Set<String> statuses = <String>{
    'unsupported',
    'disabled',
    'registering',
    'configurationRequired',
    'ready',
    'error',
  };
  if (!statuses.contains(status)) {
    throw FormatException('Unknown native incoming-call status: $status');
  }
  final String platform = _requiredString(values, 'platform');
  if (!const <String>{'ios', 'android', 'macos', 'other'}.contains(platform)) {
    throw FormatException('Unknown native incoming-call platform: $platform');
  }
  final String transport = _requiredString(values, 'transport');
  if (!const <String>{'apnsVoip', 'fcm', 'none'}.contains(transport)) {
    throw FormatException('Unknown native incoming-call transport: $transport');
  }
  final Object? rawMissing = values['missing_requirements'];
  if (rawMissing is! List<Object?>) {
    throw const FormatException(
      'Native capability is missing requirement metadata.',
    );
  }
  final List<String> missing = rawMissing
      .map<String>((Object? value) => value?.toString().trim() ?? '')
      .where((String value) => value.isNotEmpty)
      .toList(growable: false);
  return IncomingCallCapabilityRemoteModel(
    status: status,
    platform: platform,
    transport: transport,
    tokenAvailable: _requiredBool(values, 'token_available'),
    backgroundDeliveryReady: _requiredBool(values, 'background_delivery_ready'),
    nativeCallUiReady: _requiredBool(values, 'native_call_ui_ready'),
    missingRequirements: missing,
    detail: _optionalString(values['detail']),
  );
}

IncomingCallNativeEventRemoteModel _decodeEvent(Map<String, Object?> values) {
  final String type = _requiredString(values, 'type');
  if (!const <String>{
    'tokenUpdated',
    'incomingCall',
    'answerRequested',
    'declineRequested',
    'tokenInvalidated',
  }.contains(type)) {
    throw FormatException('Unknown native incoming-call event: $type');
  }
  return IncomingCallNativeEventRemoteModel(
    type: type,
    callId: _boundedOptionalString(values['call_id'], 256),
    callerName: _boundedOptionalString(values['caller_name'], 256),
    callerNumber: _boundedOptionalString(values['caller_number'], 64),
    voiceSdkId: _boundedOptionalString(values['voice_sdk_id'], 256),
  );
}

Map<String, Object?> _stringMap(Object? raw, {required String context}) {
  if (raw is! Map<Object?, Object?>) {
    throw FormatException('Native incoming-call $context is not a map.');
  }
  return raw.map<String, Object?>(
    (Object? key, Object? value) =>
        MapEntry<String, Object?>(key?.toString() ?? '', value),
  );
}

String _requiredString(Map<String, Object?> values, String key) {
  final String? value = _optionalString(values[key]);
  if (value == null) {
    throw FormatException('Native incoming-call payload is missing $key.');
  }
  return value;
}

bool _requiredBool(Map<String, Object?> values, String key) {
  final Object? value = values[key];
  if (value is! bool) {
    throw FormatException('Native incoming-call payload is missing $key.');
  }
  return value;
}

String? _optionalString(Object? raw) {
  if (raw is! String || raw.trim().isEmpty) return null;
  return raw.trim();
}

String? _boundedOptionalString(Object? raw, int maximumLength) {
  final String? value = _optionalString(raw);
  if (value == null) return null;
  if (value.length > maximumLength) {
    throw const FormatException('Native incoming-call metadata is too long.');
  }
  return value;
}
