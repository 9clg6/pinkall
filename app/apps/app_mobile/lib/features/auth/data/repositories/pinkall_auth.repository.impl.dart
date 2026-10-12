import 'package:pinkall/features/auth/data/datasources/pinkall_auth.remote.data_source.dart';
import 'package:pinkall/features/auth/data/mappers/pinkall_auth_session.mapper.dart';
import 'package:pinkall/features/auth/data/models/pinkall_auth_session.remote.model.dart';
import 'package:pinkall/features/auth/domain/entities/pinkall_auth_session.entity.dart';
import 'package:pinkall/features/auth/domain/params/pinkall_sign_in.param.dart';
import 'package:pinkall/features/auth/domain/repositories/pinkall_auth.repository.dart';

/// Repository exposing only safe identity data outside the auth data layer.
final class PinkallAuthRepositoryImpl implements PinkallAuthRepository {
  /// Creates the repository.
  const PinkallAuthRepositoryImpl(this._remoteDataSource);

  final PinkallAuthRemoteDataSource _remoteDataSource;

  @override
  bool get isAvailable => true;

  @override
  String? get unavailableReason => null;

  @override
  bool get canSignOut => true;

  @override
  PinkallAuthSessionEntity? get currentSession =>
      _remoteDataSource.currentSession?.toEntity();

  @override
  Stream<PinkallAuthSessionEntity?> get sessionChanges => _remoteDataSource
      .sessionChanges
      .map((PinkallAuthSessionRemoteModel? session) => session?.toEntity());

  @override
  Future<void> signIn(PinkallSignInParam param) =>
      _remoteDataSource.signIn(param);

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  @override
  Future<String?> currentAccessToken() =>
      _remoteDataSource.currentAccessToken();
}
