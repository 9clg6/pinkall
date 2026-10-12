// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_media_configuration.remote.model.freezed.dart';
part 'external_media_configuration.remote.model.g.dart';

/// Backend media-upload details for an external conversation.
@freezed
abstract class ExternalMediaConfigurationRemoteModel
    with _$ExternalMediaConfigurationRemoteModel {
  /// Creates a remote media configuration.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ExternalMediaConfigurationRemoteModel({
    required String encoding,
    required int sampleRate,
    required int channels,
    required String sellerWebsocketUrl,
    required String prospectWebsocketUrl,
  }) = _ExternalMediaConfigurationRemoteModel;

  /// Decodes a remote media configuration.
  factory ExternalMediaConfigurationRemoteModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ExternalMediaConfigurationRemoteModelFromJson(json);
}
