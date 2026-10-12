import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_media_configuration.entity.freezed.dart';

/// Ephemeral upload contract for one externally captured conversation.
@freezed
abstract class ExternalMediaConfigurationEntity
    with _$ExternalMediaConfigurationEntity {
  /// Creates an immutable media-upload configuration.
  const factory ExternalMediaConfigurationEntity({
    required String encoding,
    required int sampleRate,
    required int channels,
    required Uri sellerWebSocketUri,
    required Uri prospectWebSocketUri,
  }) = _ExternalMediaConfigurationEntity;
}
