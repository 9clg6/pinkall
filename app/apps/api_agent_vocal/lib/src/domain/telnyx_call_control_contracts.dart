/// Safe outbound Dial command built only after a signed webhook is verified.
final class TelnyxDialCommand {
  const TelnyxDialCommand({
    required this.to,
    required this.clientState,
    required this.commandId,
    required this.linkTo,
    required this.streamUrl,
    required this.webhookUrl,
  });

  final String to;
  final String clientState;
  final String commandId;
  final String linkTo;
  final String streamUrl;
  final String webhookUrl;
}

/// Identifiers returned by Telnyx for the newly created PSTN leg.
final class TelnyxDialResult {
  const TelnyxDialResult({
    required this.callControlId,
    required this.callSessionId,
  });

  final String callControlId;
  final String callSessionId;
}

/// Replaceable Call Control boundary.
abstract interface class TelnyxCallControlGateway {
  bool get isConfigured;

  Future<TelnyxDialResult> dial(TelnyxDialCommand command);

  void dispose();
}

/// Explicit unavailable adapter; it never pretends to dial.
final class UnavailableTelnyxCallControlGateway
    implements TelnyxCallControlGateway {
  const UnavailableTelnyxCallControlGateway(this.reason);

  final String reason;

  @override
  bool get isConfigured => false;

  @override
  Future<TelnyxDialResult> dial(TelnyxDialCommand command) {
    throw StateError(reason);
  }

  @override
  void dispose() {}
}

/// Public acknowledgement returned to Telnyx after processing a webhook.
final class TelnyxWebhookDisposition {
  const TelnyxWebhookDisposition({
    required this.eventId,
    required this.action,
    required this.duplicate,
    required this.sessionId,
  });

  final String eventId;
  final String action;
  final bool duplicate;
  final String? sessionId;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'received': true,
      'event_id': eventId,
      'action': action,
      'duplicate': duplicate,
      'session_id': sessionId,
    };
  }
}
