import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_import_result.entity.freezed.dart';

/// Server-confirmed result of a CRM contact import.
@freezed
abstract class ContactImportResultEntity with _$ContactImportResultEntity {
  /// Creates a contact import result.
  const factory ContactImportResultEntity({
    required String importId,
    required int importedCount,
    required int skippedCount,
    @Default(<String>[]) List<String> errors,
  }) = _ContactImportResultEntity;
}
