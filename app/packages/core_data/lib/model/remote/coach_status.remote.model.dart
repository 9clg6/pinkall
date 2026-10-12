// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_status.remote.model.freezed.dart';
part 'coach_status.remote.model.g.dart';

/// JSON payload emitted while the optional live coach runs.
@freezed
abstract class CoachStatusRemoteModel with _$CoachStatusRemoteModel {
  /// Creates one remote coach status payload.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CoachStatusRemoteModel({
    required String status,
    String? outcome,
  }) = _CoachStatusRemoteModel;

  /// Creates a remote coach status payload from JSON.
  factory CoachStatusRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CoachStatusRemoteModelFromJson(json);
}
