// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coaching_source.remote.model.freezed.dart';
part 'coaching_source.remote.model.g.dart';

/// JSON model for one coaching source attribution.
@freezed
abstract class CoachingSourceRemoteModel with _$CoachingSourceRemoteModel {
  /// Creates a remote coaching source.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CoachingSourceRemoteModel({
    required String id,
    required String title,
    required String evidenceLevel,
    String? author,
    String? url,
    String? locator,
  }) = _CoachingSourceRemoteModel;

  /// Creates a remote coaching source from JSON.
  factory CoachingSourceRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CoachingSourceRemoteModelFromJson(json);
}
