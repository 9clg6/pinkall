// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_media_configuration.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExternalMediaConfigurationRemoteModel
_$ExternalMediaConfigurationRemoteModelFromJson(Map<String, dynamic> json) =>
    _ExternalMediaConfigurationRemoteModel(
      encoding: json['encoding'] as String,
      sampleRate: (json['sample_rate'] as num).toInt(),
      channels: (json['channels'] as num).toInt(),
      sellerWebsocketUrl: json['seller_websocket_url'] as String,
      prospectWebsocketUrl: json['prospect_websocket_url'] as String,
    );

Map<String, dynamic> _$ExternalMediaConfigurationRemoteModelToJson(
  _ExternalMediaConfigurationRemoteModel instance,
) => <String, dynamic>{
  'encoding': instance.encoding,
  'sample_rate': instance.sampleRate,
  'channels': instance.channels,
  'seller_websocket_url': instance.sellerWebsocketUrl,
  'prospect_websocket_url': instance.prospectWebsocketUrl,
};
