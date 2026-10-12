// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_import_result.remote.model.freezed.dart';
part 'contact_import_result.remote.model.g.dart';

/// JSON model for a backend-confirmed CRM contact import.
@freezed
abstract class ContactImportResultRemoteModel
    with _$ContactImportResultRemoteModel {
  /// Creates a remote contact import result.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ContactImportResultRemoteModel({
    required String importId,
    required int importedCount,
    required int skippedCount,
    @Default(<String>[]) List<String> errors,
  }) = _ContactImportResultRemoteModel;

  /// Creates a remote contact import result from JSON.
  factory ContactImportResultRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$ContactImportResultRemoteModelFromJson(json);
}
