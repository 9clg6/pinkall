import 'package:core_data/model/remote/voice_access_token.remote.model.dart';

/// Remote source for short-lived, server-issued Telnyx credentials.
abstract interface class VoiceAccessRemoteDataSource {
  /// Requests a new credential for the authenticated device.
  Future<VoiceAccessTokenRemoteModel> requestToken(Map<String, dynamic> body);
}
