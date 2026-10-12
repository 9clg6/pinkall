import 'package:core_domain/domain/enum/transcription_consent_method.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcription_consent.entity.freezed.dart';

/// Server-confirmed transcription notice acknowledgement for one session.
@freezed
abstract class TranscriptionConsentEntity with _$TranscriptionConsentEntity {
  /// Creates a transcription consent acknowledgement.
  const factory TranscriptionConsentEntity({
    required String sessionId,
    required bool acknowledged,
    required TranscriptionConsentMethod method,
    required DateTime acknowledgedAt,
  }) = _TranscriptionConsentEntity;
}
