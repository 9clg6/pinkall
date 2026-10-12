// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_preference.remote.model.freezed.dart';
part 'coach_preference.remote.model.g.dart';

/// JSON model for the authenticated user's coach preference.
@freezed
abstract class CoachPreferenceRemoteModel with _$CoachPreferenceRemoteModel {
  /// Creates a remote coaching preference.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CoachPreferenceRemoteModel({
    required String defaultMode,
    required DateTime updatedAt,
  }) = _CoachPreferenceRemoteModel;

  /// Creates a remote coaching preference from JSON.
  factory CoachPreferenceRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CoachPreferenceRemoteModelFromJson(json);
}
