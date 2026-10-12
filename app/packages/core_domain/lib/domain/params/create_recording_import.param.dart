// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_recording_import.param.freezed.dart';
part 'create_recording_import.param.g.dart';

/// Metadata declared before Pinkall accepts an imported audio body.
@freezed
abstract class CreateRecordingImportParam with _$CreateRecordingImportParam {
  /// Creates validated recording metadata for the backend.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CreateRecordingImportParam({
    @Default('recording_import') String source,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    String? title,
    @Default('fr-FR') String locale,
    String? preparationMarkdown,
  }) = _CreateRecordingImportParam;

  /// Decodes recording metadata.
  factory CreateRecordingImportParam.fromJson(Map<String, dynamic> json) =>
      _$CreateRecordingImportParamFromJson(json);
}
