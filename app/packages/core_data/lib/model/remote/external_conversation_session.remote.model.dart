import 'package:core_data/model/remote/conversation_session.remote.model.dart';
import 'package:core_data/model/remote/external_media_configuration.remote.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_conversation_session.remote.model.freezed.dart';

/// Flattened backend response for an externally captured conversation.
@freezed
abstract class ExternalConversationSessionRemoteModel
    with _$ExternalConversationSessionRemoteModel {
  /// Creates the decoded launch response.
  const factory ExternalConversationSessionRemoteModel({
    required ConversationSessionRemoteModel session,
    required String source,
    required String locale,
    required String mediaToken,
    required ExternalMediaConfigurationRemoteModel media,
    @Default(true) bool consentRequired,
    String? title,
  }) = _ExternalConversationSessionRemoteModel;

  /// Decodes the session fields and external-media fields from one object.
  factory ExternalConversationSessionRemoteModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final Object? rawMedia = json['media'];
    if (rawMedia is! Map<dynamic, dynamic>) {
      throw const FormatException(
        'External session response must contain a media object.',
      );
    }
    return ExternalConversationSessionRemoteModel(
      session: ConversationSessionRemoteModel.fromJson(json),
      source: _requiredString(json, 'source'),
      locale: _requiredString(json, 'locale'),
      mediaToken: _requiredString(json, 'media_token'),
      media: ExternalMediaConfigurationRemoteModel.fromJson(
        rawMedia.map<String, dynamic>(
          (dynamic key, dynamic value) =>
              MapEntry<String, dynamic>(key.toString(), value),
        ),
      ),
      consentRequired: json['consent_required'] as bool? ?? true,
      title: json['title'] as String?,
    );
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final Object? value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('External session response requires $key.');
  }
  return value;
}
