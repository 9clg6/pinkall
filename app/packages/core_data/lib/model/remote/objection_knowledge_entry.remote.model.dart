// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'objection_knowledge_entry.remote.model.freezed.dart';
part 'objection_knowledge_entry.remote.model.g.dart';

/// User-authored response attached to a known objection.
@freezed
abstract class ObjectionResponseRemoteModel
    with _$ObjectionResponseRemoteModel {
  /// Creates a remote response.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ObjectionResponseRemoteModel({
    required String content,
    required String sourceType,
    String? sourceName,
  }) = _ObjectionResponseRemoteModel;

  /// Decodes a response.
  factory ObjectionResponseRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$ObjectionResponseRemoteModelFromJson(json);
}

/// JSON model for one objection library entry.
@freezed
abstract class ObjectionKnowledgeEntryRemoteModel
    with _$ObjectionKnowledgeEntryRemoteModel {
  /// Creates a remote entry.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ObjectionKnowledgeEntryRemoteModel({
    required String id,
    required String category,
    required String text,
    required String reviewStatus,
    required String origin,
    required int occurrenceCount,
    required DateTime firstSeenAt,
    required DateTime lastSeenAt,
    ObjectionResponseRemoteModel? response,
  }) = _ObjectionKnowledgeEntryRemoteModel;

  /// Decodes an entry.
  factory ObjectionKnowledgeEntryRemoteModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ObjectionKnowledgeEntryRemoteModelFromJson(json);
}

/// JSON envelope returned by the objection listing endpoint.
@freezed
abstract class ObjectionKnowledgeListRemoteModel
    with _$ObjectionKnowledgeListRemoteModel {
  /// Creates a remote list.
  const factory ObjectionKnowledgeListRemoteModel({
    required List<ObjectionKnowledgeEntryRemoteModel> items,
  }) = _ObjectionKnowledgeListRemoteModel;

  /// Decodes a list.
  factory ObjectionKnowledgeListRemoteModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ObjectionKnowledgeListRemoteModelFromJson(json);
}
