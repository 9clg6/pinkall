// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_eligibility.remote.model.freezed.dart';
part 'call_eligibility.remote.model.g.dart';

/// JSON model for a versioned outbound-call policy decision.
@freezed
abstract class CallEligibilityRemoteModel with _$CallEligibilityRemoteModel {
  /// Creates a remote call-eligibility decision.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CallEligibilityRemoteModel({
    required String status,
    required List<String> reasons,
    required DateTime checkedAt,
    required String policyVersion,
    String? contactId,
  }) = _CallEligibilityRemoteModel;

  /// Creates a remote call-eligibility decision from JSON.
  factory CallEligibilityRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CallEligibilityRemoteModelFromJson(json);
}
