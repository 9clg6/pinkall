import 'package:core_domain/core_domain.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:test/test.dart';

void main() {
  group('VoiceAccessTokenEntity', () {
    test('redacts the secret and keeps identity equality', () {
      final DateTime expiresAt = DateTime.utc(2026, 7, 11, 11);
      final VoiceAccessTokenEntity first = VoiceAccessTokenEntity(
        token: 'first-sensitive-token',
        expiresAt: expiresAt,
        callerName: 'Pinkall',
        callerNumber: '+33102030405',
      );
      final VoiceAccessTokenEntity second = VoiceAccessTokenEntity(
        token: 'second-sensitive-token',
        expiresAt: expiresAt,
        callerName: 'Pinkall',
        callerNumber: '+33102030405',
      );

      expect(first, isNot(second));
      expect(first.toString(), contains('<redacted>'));
      expect(first.toString(), isNot(contains(first.token)));
      expect(first.isExpiredAt(expiresAt), isTrue);
    });

    test('request parameters expose only the device identifier', () {
      const RequestVoiceAccessTokenParam params = RequestVoiceAccessTokenParam(
        deviceId: 'device-macos-1',
      );

      expect(params.toJson(), <String, dynamic>{'device_id': 'device-macos-1'});
    });

    test('request use case delegates without persisting the token', () async {
      final _FakeVoiceAccessRepository repository =
          _FakeVoiceAccessRepository();
      final RequestVoiceAccessTokenUseCase useCase =
          RequestVoiceAccessTokenUseCase(voiceAccessRepository: repository);
      const RequestVoiceAccessTokenParam params = RequestVoiceAccessTokenParam(
        deviceId: 'device-ios-1',
      );

      final ResultState<VoiceAccessTokenEntity> result = await useCase.execute(
        params,
      );

      expect(result, isA<ResultSuccess<VoiceAccessTokenEntity>>());
      expect(repository.lastParams, params);
      expect(
        (result as ResultSuccess<VoiceAccessTokenEntity>).data.token,
        'runtime-only-token',
      );
    });
  });
}

final class _FakeVoiceAccessRepository implements VoiceAccessRepository {
  RequestVoiceAccessTokenParam? lastParams;

  @override
  Future<VoiceAccessTokenEntity> requestToken(
    RequestVoiceAccessTokenParam params,
  ) async {
    lastParams = params;
    return VoiceAccessTokenEntity(
      token: 'runtime-only-token',
      expiresAt: DateTime.utc(2026, 7, 11, 11),
      callerName: 'Pinkall',
      callerNumber: '+33102030405',
    );
  }
}
