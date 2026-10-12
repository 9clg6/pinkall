import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/coach_status.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Mapping extensions for [CoachStatusRemoteModel].
extension CoachStatusRemoteModelX on CoachStatusRemoteModel {
  /// Converts the backend payload to a provider-independent coach status.
  CoachStatusEntity toEntity() => CoachStatusEntity(
    status: enumFromWireName<CoachAnalysisStatus>(
      CoachAnalysisStatus.values,
      status,
    ),
    outcome: outcome == null
        ? null
        : enumFromWireName<CoachAnalysisOutcome>(
            CoachAnalysisOutcome.values,
            outcome!,
          ),
  );
}
