import 'package:freezed_annotation/freezed_annotation.dart';

/// Supported sources for conversations captured outside Pinkall VoIP.
enum ExternalConversationSource {
  /// A meeting or browser call captured from a macOS desktop.
  @JsonValue('macos_meeting')
  macosMeeting,
}
