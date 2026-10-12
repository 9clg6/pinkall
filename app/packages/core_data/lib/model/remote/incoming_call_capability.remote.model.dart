import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_call_capability.remote.model.freezed.dart';

/// Native capability payload before it is mapped into the domain.
@freezed
abstract class IncomingCallCapabilityRemoteModel
    with _$IncomingCallCapabilityRemoteModel {
  /// Creates a decoded native capability snapshot.
  const factory IncomingCallCapabilityRemoteModel({
    required String status,
    required String platform,
    required String transport,
    required bool tokenAvailable,
    required bool backgroundDeliveryReady,
    required bool nativeCallUiReady,
    required List<String> missingRequirements,
    String? detail,
  }) = _IncomingCallCapabilityRemoteModel;
}
