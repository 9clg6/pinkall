// ignore_for_file: invalid_annotation_target

import 'package:core_domain/domain/enum/coach_mode.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_conversation_session.param.freezed.dart';
part 'create_conversation_session.param.g.dart';

/// Parameters used to create the backend session attached to a voice call.
@freezed
abstract class CreateConversationSessionParam
    with _$CreateConversationSessionParam {
  /// Creates backend session parameters.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CreateConversationSessionParam({
    required String callId,
    required String destinationNumber,
    String? contactId,
    CoachMode? coachModeOverride,
    String? locale,
    String? preparationMarkdown,
    @Default(<String, String>{}) Map<String, String> context,
  }) = _CreateConversationSessionParam;

  /// Creates backend session parameters from JSON.
  factory CreateConversationSessionParam.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationSessionParamFromJson(json);
}
