// ignore_for_file: invalid_annotation_target

import 'package:core_data/model/remote/coaching_source.remote.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coaching_suggestion.remote.model.freezed.dart';
part 'coaching_suggestion.remote.model.g.dart';

/// JSON model for an expiring source-backed coaching suggestion.
@freezed
abstract class CoachingSuggestionRemoteModel
    with _$CoachingSuggestionRemoteModel {
  /// Creates a remote coaching suggestion.
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CoachingSuggestionRemoteModel({
    required String id,
    required String sessionId,
    required String kind,
    required String text,
    required String rationale,
    required List<CoachingSourceRemoteModel> sources,
    required double confidence,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _CoachingSuggestionRemoteModel;

  /// Creates a remote coaching suggestion from JSON.
  factory CoachingSuggestionRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CoachingSuggestionRemoteModelFromJson(json);
}
