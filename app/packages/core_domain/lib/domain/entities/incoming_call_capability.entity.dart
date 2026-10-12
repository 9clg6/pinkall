import 'package:core_domain/domain/enum/incoming_call_capability_status.enum.dart';
import 'package:core_domain/domain/enum/incoming_call_platform.enum.dart';
import 'package:core_domain/domain/enum/incoming_call_transport.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_call_capability.entity.freezed.dart';

/// Truthful snapshot of native background incoming-call readiness.
@Freezed(toStringOverride: false)
abstract class IncomingCallCapabilityEntity
    with _$IncomingCallCapabilityEntity {
  const IncomingCallCapabilityEntity._();

  /// Creates a capability snapshot without exposing the push token itself.
  const factory IncomingCallCapabilityEntity({
    required IncomingCallCapabilityStatus status,
    required IncomingCallPlatform platform,
    required IncomingCallTransport transport,
    required bool tokenAvailable,
    required bool backgroundDeliveryReady,
    required bool nativeCallUiReady,
    required List<String> missingRequirements,
    String? detail,
  }) = _IncomingCallCapabilityEntity;

  /// Safe default used until the native adapter has been inspected.
  factory IncomingCallCapabilityEntity.unchecked() =>
      const IncomingCallCapabilityEntity(
        status: IncomingCallCapabilityStatus.registering,
        platform: IncomingCallPlatform.other,
        transport: IncomingCallTransport.none,
        tokenAvailable: false,
        backgroundDeliveryReady: false,
        nativeCallUiReady: false,
        missingRequirements: <String>['native_capability_not_checked'],
      );

  /// Only true when every background and native UI prerequisite is verified.
  bool get isReady =>
      status == IncomingCallCapabilityStatus.ready &&
      tokenAvailable &&
      backgroundDeliveryReady &&
      nativeCallUiReady;

  @override
  String toString() =>
      'IncomingCallCapabilityEntity(status: $status, platform: $platform, '
      'transport: $transport, tokenAvailable: $tokenAvailable, '
      'backgroundDeliveryReady: $backgroundDeliveryReady, '
      'nativeCallUiReady: $nativeCallUiReady, '
      'missingRequirements: $missingRequirements, detail: $detail)';
}
