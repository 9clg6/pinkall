// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.remote.model.freezed.dart';
part 'contact.remote.model.g.dart';

/// JSON model for a minimal Pinkall CRM contact.
@freezed
abstract class ContactRemoteModel with _$ContactRemoteModel {
  /// Creates a remote contact.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ContactRemoteModel({
    required String id,
    required String phoneNumber,
    required String market,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? firstName,
    String? lastName,
    String? company,
    String? jobTitle,
    String? email,
    bool? hasPriorConsent,
    bool? hasOptedOut,
    bool? professionalRelevanceConfirmed,
    @Default(<String, String>{}) Map<String, String> customFields,
  }) = _ContactRemoteModel;

  /// Creates a remote contact from JSON.
  factory ContactRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$ContactRemoteModelFromJson(json);
}
