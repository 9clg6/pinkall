import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'external session endpoint maps its two ephemeral media tracks',
    () async {
      final _ExternalSessionHttpClient http = _ExternalSessionHttpClient();
      final ConversationSessionRepository repository =
          ConversationSessionRepositoryImpl(
            remoteDataSource: ConversationSessionRemoteDataSourceImpl(
              httpClient: http,
              realtimeClient: _UnusedRealtimeClient(),
            ),
          );

      final ExternalConversationSessionEntity launch = await repository
          .createExternalSession(
            const CreateExternalConversationSessionParam(
              title: 'Discovery Acme',
              preparationMarkdown: '# Objectif',
              coachModeOverride: CoachMode.off,
            ),
          );

      expect(http.path, '/v1/sessions/external');
      expect(http.body?['source'], 'macos_meeting');
      expect(http.body?['coach_mode_override'], 'off');
      expect(launch.session.id, 'session-external');
      expect(launch.source, ExternalConversationSource.macosMeeting);
      expect(launch.consentRequired, isTrue);
      expect(launch.media.encoding, 'pcm_s16le');
      expect(launch.media.sampleRate, 16000);
      expect(launch.media.channels, 1);
      expect(
        launch.media.sellerWebSocketUri.queryParameters['track'],
        'seller',
      );
      expect(
        launch.media.prospectWebSocketUri.queryParameters['track'],
        'prospect',
      );
    },
  );

  test('binary audio rejects unencrypted non-local media URLs', () async {
    const PinkallBinaryRealtimeClient client =
        WebSocketPinkallBinaryRealtimeClientImpl();

    await expectLater(
      client.connect(Uri.parse('ws://public.example/media')),
      throwsArgumentError,
    );
  });
}

final class _ExternalSessionHttpClient implements PinkallHttpClient {
  String? path;
  Map<String, dynamic>? body;

  @override
  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    this.path = path;
    this.body = body;
    return <String, dynamic>{
      'id': 'session-external',
      'call_id': 'external-call',
      'status': 'created',
      'coach_mode': 'off',
      'created_at': '2026-07-14T08:00:00.000Z',
      'transcription_consent_acknowledged': false,
      'source': 'macos_meeting',
      'title': 'Discovery Acme',
      'locale': 'fr-FR',
      'media_token': 'ephemeral-only',
      'media': <String, dynamic>{
        'encoding': 'pcm_s16le',
        'sample_rate': 16000,
        'channels': 1,
        'seller_websocket_url':
            'wss://api.example/v1/sessions/session-external/media/client?track=seller&token=ephemeral-only',
        'prospect_websocket_url':
            'wss://api.example/v1/sessions/session-external/media/client?track=prospect&token=ephemeral-only',
      },
      'consent_required': true,
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _UnusedRealtimeClient implements PinkallRealtimeClient {
  @override
  Stream<Map<String, dynamic>> watchJson(String path) =>
      const Stream<Map<String, dynamic>>.empty();
}
