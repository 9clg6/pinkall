// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_session.remote.model.freezed.dart';
part 'conversation_session.remote.model.g.dart';

/// JSON model for a Pinkall backend conversation session.
@freezed
abstract class ConversationSessionRemoteModel
    with _$ConversationSessionRemoteModel {
  /// Creates a remote conversation session.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ConversationSessionRemoteModel({
    required String id,
    required String callId,
    required String status,
    required String coachMode,
    required DateTime createdAt,
    @Default(false) bool transcriptionConsentAcknowledged,
    String? destinationNumber,
    String? contactId,
    String? preparationMarkdown,
    DateTime? startedAt,
    DateTime? endedAt,
    String? failureReason,
  }) = _ConversationSessionRemoteModel;

  /// Creates a remote conversation session from JSON.
  factory ConversationSessionRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationSessionRemoteModelFromJson(json);
}
