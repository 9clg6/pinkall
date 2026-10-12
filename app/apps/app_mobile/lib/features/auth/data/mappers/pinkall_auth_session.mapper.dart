import 'package:pinkall/features/auth/data/models/pinkall_auth_session.remote.model.dart';
import 'package:pinkall/features/auth/domain/entities/pinkall_auth_session.entity.dart';

/// Maps a provider session without exposing its token to presentation state.
extension PinkallAuthSessionMapper on PinkallAuthSessionRemoteModel {
  /// Converts the safe identity subset to a domain entity.
  PinkallAuthSessionEntity toEntity() =>
      PinkallAuthSessionEntity(userId: userId, email: email);
}
