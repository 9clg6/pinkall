// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assign_recording_speaker.param.freezed.dart';
part 'assign_recording_speaker.param.g.dart';

/// Explicitly identifies which provisional diarized voice is the user.
@freezed
abstract class AssignRecordingSpeakerParam with _$AssignRecordingSpeakerParam {
  /// Creates a speaker assignment.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AssignRecordingSpeakerParam({
    required String importId,
    required String userVoice,
  }) = _AssignRecordingSpeakerParam;

  /// Decodes a speaker assignment.
  factory AssignRecordingSpeakerParam.fromJson(Map<String, dynamic> json) =>
      _$AssignRecordingSpeakerParamFromJson(json);
}
