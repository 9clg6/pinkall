// ignore_for_file: invalid_annotation_target

import 'package:core_domain/domain/enum/coach_mode.enum.dart';
import 'package:core_domain/domain/enum/external_conversation_source.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_external_conversation_session.param.freezed.dart';
part 'create_external_conversation_session.param.g.dart';

/// Parameters for a conversation captured outside the Pinkall phone.
@freezed
abstract class CreateExternalConversationSessionParam
    with _$CreateExternalConversationSessionParam {
  /// Creates external-session parameters.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CreateExternalConversationSessionParam({
    @Default(ExternalConversationSource.macosMeeting)
    ExternalConversationSource source,
    String? title,
    String? preparationMarkdown,
    CoachMode? coachModeOverride,
    @Default('fr-FR') String locale,
  }) = _CreateExternalConversationSessionParam;

  /// Creates external-session parameters from JSON.
  factory CreateExternalConversationSessionParam.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateExternalConversationSessionParamFromJson(json);
}
