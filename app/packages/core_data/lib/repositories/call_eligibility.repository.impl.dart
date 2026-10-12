import 'package:core_data/datasources/remote/call_eligibility.remote.data_source.dart';
import 'package:core_data/mappers/call_eligibility.mapper.dart';
import 'package:core_domain/core_domain.dart';

/// Pinkall-backend implementation of [CallEligibilityRepository].
final class CallEligibilityRepositoryImpl implements CallEligibilityRepository {
  /// Creates the repository with its [remoteDataSource].
  const CallEligibilityRepositoryImpl({
    required CallEligibilityRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final CallEligibilityRemoteDataSource _remoteDataSource;

  @override
  Future<CallEligibilityEntity> evaluate(
    EvaluateCallEligibilityParam params,
  ) async {
    return (await _remoteDataSource.evaluate(params.toJson())).toEntity();
  }
}
