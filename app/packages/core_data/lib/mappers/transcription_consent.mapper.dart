import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/transcription_consent.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Mapping extensions for [TranscriptionConsentRemoteModel].
extension TranscriptionConsentRemoteModelX on TranscriptionConsentRemoteModel {
  /// Converts the remote acknowledgement to a domain entity.
  TranscriptionConsentEntity toEntity() => TranscriptionConsentEntity(
    sessionId: sessionId,
    acknowledged: acknowledged,
    method: enumFromWireName<TranscriptionConsentMethod>(
      TranscriptionConsentMethod.values,
      method,
    ),
    acknowledgedAt: acknowledgedAt,
  );
}
