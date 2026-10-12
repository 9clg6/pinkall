// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_outcome.remote.model.freezed.dart';
part 'call_outcome.remote.model.g.dart';

/// JSON model for a server-confirmed call outcome.
@freezed
abstract class CallOutcomeRemoteModel with _$CallOutcomeRemoteModel {
  /// Creates a remote call outcome.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CallOutcomeRemoteModel({
    required String sessionId,
    required String type,
    required DateTime recordedAt,
    String? note,
  }) = _CallOutcomeRemoteModel;

  /// Creates a remote call outcome from JSON.
  factory CallOutcomeRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CallOutcomeRemoteModelFromJson(json);
}
